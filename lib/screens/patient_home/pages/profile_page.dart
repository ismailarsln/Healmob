import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:healmob/components/rounded_button.dart';
import 'package:healmob/components/rounded_form_input_field.dart';
import 'package:healmob/components/rounded_form_password_field.dart';
import 'package:healmob/constants.dart';
import 'package:healmob/data/file_api.dart';
import 'package:healmob/data/hasta_api.dart';
import 'package:healmob/environment.dart';
import 'package:healmob/models/api_response/api_post_response.dart';
import 'package:healmob/models/api_response/api_upload_post_response.dart';
import 'package:healmob/models/hasta.dart';
import 'package:healmob/validation/user_validator.dart';
import 'package:http/http.dart';
import 'package:restart_app/restart_app.dart';

class ProfilePage extends StatefulWidget {
  Hasta hasta;
  ProfilePage({Key? key, required this.hasta}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with UserValidationMixin {
  final _profileFormKey = GlobalKey<FormState>();
  final _passwordFormKey = GlobalKey<FormState>();
  var txtNewEmail = TextEditingController();
  var txtNewAd = TextEditingController();
  var txtNewSoyad = TextEditingController();
  var txtNewPhone = TextEditingController();
  var txtOldPassword = TextEditingController();
  var txtNewPassword = TextEditingController();
  var txtReNewPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:
            AppBar(title: const Text("Profilim"), centerTitle: true, actions: [
          TextButton(
            onPressed: () {
              widget.hasta.aktifDurum = false;
              HastaApi.update(widget.hasta).then((response) {
                Restart.restartApp();
              });
            },
            child: const Text(
              "G??venli ????k????",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ]),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    CircleAvatar(
                      radius: MediaQuery.of(context).size.width / 4.5,
                      backgroundColor: Colors.transparent,
                      child: widget.hasta.resimYolu == "" ||
                              widget.hasta.resimYolu == null
                          ? ClipOval(
                              child: SvgPicture.asset(
                                widget.hasta.cinsiyet
                                    ? "assets/images/person-girl-flat.svg"
                                    : "assets/images/person-flat.svg",
                                height: MediaQuery.of(context).size.width / 2.2,
                                width: MediaQuery.of(context).size.width / 2.2,
                              ),
                            )
                          : ClipOval(
                              child: CachedNetworkImage(
                                imageUrl:
                                    "${Environment.APIURL}/${widget.hasta.resimYolu}",
                                placeholder: (context, url) =>
                                    const CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    const Icon(
                                  Icons.error,
                                  size: 160,
                                ),
                              ),
                            ),
                    ),
                    TextButton(
                        child: const Text("Resmi de??i??tir"),
                        onPressed: () {
                          FilePicker.platform
                              .pickFiles(withReadStream: true)
                              .then((value) {
                            if (value != null && value.paths.isNotEmpty) {
                              FileApi.uploadImage(value.files.single)
                                  .then((imageUploadApiResponse) {
                                var x =
                                    imageUploadApiResponse as StreamedResponse;
                                x.stream.bytesToString().then((finalResponse) {
                                  var apiUploadResponse =
                                      ApiUploadPostResponse.fromJson(
                                          json.decode(finalResponse));
                                  if (apiUploadResponse.success) {
                                    widget.hasta.resimYolu =
                                        apiUploadResponse.data.path;
                                    widget.hasta.aktifDurum = false;
                                    HastaApi.update(widget.hasta)
                                        .then((hastaUpdateApiResponse) {
                                      var hastaUpdateResponse =
                                          ApiPostResponse.fromJson(json.decode(
                                              hastaUpdateApiResponse.body));
                                      if (hastaUpdateResponse.success) {
                                        _showRegisterAlertAndRestartApp(
                                            context,
                                            "Resim y??klendi",
                                            "Resim ba??ar??yla y??klendi. Uygulama yeniden ba??lat??l??yor");
                                      } else {
                                        _showAlert(context, "Dosya y??klenemedi",
                                            "Dosya y??klenirken bir ??eyler ters gitti\n\n${hastaUpdateResponse.message}");
                                        widget.hasta.aktifDurum = true;
                                        return;
                                      }
                                    });
                                  } else {
                                    _showAlert(context, "Dosya y??klenemedi",
                                        "Dosya y??klenirken bir ??eyler ters gitti\n\n${apiUploadResponse.message}");
                                    return;
                                  }
                                });
                              });
                              //print(value.paths[0]);
                            }
                          });
                        }),
                  ],
                ),
                Form(
                  key: _profileFormKey,
                  child: Column(
                    children: [
                      RoundedFormInputField(
                        hintText: "E-posta adresiniz",
                        initialValue: widget.hasta.email,
                        icon: Icons.mail,
                        onChanged: (value) {},
                        validator: validateEmail,
                        onSaved: (value) {
                          txtNewEmail.text = value.toString();
                        },
                      ),
                      RoundedFormInputField(
                        hintText: "Ad??n??z",
                        initialValue: widget.hasta.ad,
                        icon: Icons.person,
                        onChanged: (value) {},
                        validator: validateFirstName,
                        onSaved: (value) {
                          txtNewAd.text = value.toString();
                        },
                      ),
                      RoundedFormInputField(
                        hintText: "Soyad??n??z",
                        initialValue: widget.hasta.soyad,
                        icon: Icons.person,
                        onChanged: (value) {},
                        validator: validateLastName,
                        onSaved: (value) {
                          txtNewSoyad.text = value.toString();
                        },
                      ),
                      RoundedFormInputField(
                        hintText: "Telefon numaran??z",
                        initialValue: widget.hasta.telefon,
                        icon: Icons.phone,
                        onChanged: (value) {},
                        validator: validatePhone,
                        onSaved: (value) {
                          txtNewPhone.text = value.toString();
                        },
                      ),
                      RoundedButton(
                        buttonText: "Profilimi g??ncelle",
                        onPress: () {
                          if (_profileFormKey.currentState!.validate()) {
                            _profileFormKey.currentState!.save();
                            if (widget.hasta.email == txtNewEmail.text &&
                                widget.hasta.ad == txtNewAd.text &&
                                widget.hasta.soyad == txtNewSoyad.text &&
                                widget.hasta.telefon == txtNewPhone.text) {
                              _showAlert(context, "Hi??bir ??ey de??i??tirmediniz",
                                  "G??ncelleme yapmak i??in ??nce baz?? bilgilerinizi de??i??tirin");
                              return;
                            }
                            var newHasta = Hasta(
                                widget.hasta.hastaNo,
                                txtNewEmail.text,
                                widget.hasta.sifre,
                                txtNewAd.text,
                                txtNewSoyad.text,
                                txtNewPhone.text,
                                widget.hasta.cinsiyet,
                                true,
                                "");
                            HastaApi.update(newHasta).then((response) {
                              var apiResponse = ApiPostResponse.fromJson(
                                  json.decode(response.body));
                              if (apiResponse.success) {
                                if (apiResponse.data.affectedRows == 0) {
                                  _showAlert(context, "G??ncelleme ba??ar??s??z",
                                      "G??ncelleme yap??l??rken bir ??eyler ters gitti");
                                  return;
                                }
                                _showRegisterAlertAndRestartApp(
                                  context,
                                  "G??ncelleme ba??ar??l??",
                                  "Profiliniz ba??ar??yla g??ncellendi. L??tfen tekrar giri?? yap??n??z",
                                );
                              } else {
                                _showAlert(context, "G??ncelleme ba??ar??s??z",
                                    "G??ncelleme yap??l??rken bir ??eyler ters gitti\n\n${apiResponse.message}");
                              }
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Divider(
                  color: appPrimaryDarkColor,
                ),
                const SizedBox(
                  height: 10,
                ),
                Form(
                  key: _passwordFormKey,
                  child: Column(
                    children: [
                      RoundedFormPasswordField(
                        onChanged: (value) {},
                        hintText: "??uanki ??ifreniz",
                        validator: validatePassword,
                        onSaved: (value) {
                          txtOldPassword.text = value.toString();
                        },
                      ),
                      RoundedFormPasswordField(
                        onChanged: (value) {},
                        hintText: "Yeni ??ifreniz",
                        validator: validatePassword,
                        onSaved: (value) {
                          txtNewPassword.text = value.toString();
                        },
                      ),
                      RoundedFormPasswordField(
                        onChanged: (value) {},
                        hintText: "Yeni ??ifreniz tekrar",
                        validator: validatePassword,
                        onSaved: (value) {
                          txtReNewPassword.text = value.toString();
                        },
                      ),
                      RoundedButton(
                        buttonText: "??ifremi g??ncelle",
                        onPress: () {
                          if (_passwordFormKey.currentState!.validate()) {
                            _passwordFormKey.currentState!.save();
                            if (txtOldPassword.text != widget.hasta.sifre) {
                              _showAlert(context, "Eski ??ifreniz hatal??",
                                  "Girdi??iniz ??ifre, eski ??ifrenizle e??le??miyor");
                              return;
                            }
                            if (txtNewPassword.text != txtReNewPassword.text) {
                              _showAlert(context, "Yeni ??ifreler e??le??miyor",
                                  "Girdi??iniz yeni ??ifreler e??le??miyor");
                              return;
                            }
                            var newHasta = Hasta(
                                widget.hasta.hastaNo,
                                widget.hasta.email,
                                txtNewPassword.text,
                                widget.hasta.ad,
                                widget.hasta.soyad,
                                widget.hasta.telefon,
                                widget.hasta.cinsiyet,
                                true,
                                "");
                            HastaApi.update(newHasta).then((response) {
                              var apiResponse = ApiPostResponse.fromJson(
                                  json.decode(response.body));
                              if (apiResponse.success) {
                                if (apiResponse.data.affectedRows == 0) {
                                  _showAlert(context, "G??ncelleme ba??ar??s??z",
                                      "G??ncelleme yap??l??rken bir ??eyler ters gitti");
                                  return;
                                }
                                _showRegisterAlertAndRestartApp(
                                  context,
                                  "G??ncelleme ba??ar??l??",
                                  "??ifreniz ba??ar??yla de??i??tirildi. L??tfen yeni ??ifrenizle tekrar giri?? yap??n??z",
                                );
                              } else {
                                _showAlert(context, "G??ncelleme ba??ar??s??z",
                                    "??ifreniz de??i??tirilirken bir ??eyler ters gitti\n\n${apiResponse.message}");
                              }
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 80,
                ),
              ],
            ),
          ),
        ));
  }

  void _showAlert(BuildContext context, String title, String message) {
    var alert = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (BuildContext context) => alert);
  }

  void _showRegisterAlertAndRestartApp(
      BuildContext context, String title, String message) {
    var alert = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (BuildContext context) => alert)
        .then((value) {
      Restart.restartApp();
    });
  }
}
