import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:healmob/components/rounded_button.dart';
import 'package:healmob/components/rounded_form_input_field.dart';
import 'package:healmob/components/rounded_form_password_field.dart';
import 'package:healmob/constants.dart';
import 'package:healmob/data/doktor_api.dart';
import 'package:healmob/data/file_api.dart';
import 'package:healmob/environment.dart';
import 'package:healmob/models/api_response/api_post_response.dart';
import 'package:healmob/models/api_response/api_upload_post_response.dart';
import 'package:healmob/models/doktor.dart';
import 'package:healmob/validation/user_validator.dart';
import 'package:http/http.dart';
import 'package:restart_app/restart_app.dart';

class ProfilePage extends StatefulWidget {
  Doktor doktor;
  ProfilePage({Key? key, required this.doktor}) : super(key: key);

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
              widget.doktor.aktifDurum = false;
              DoktorApi.update(widget.doktor).then((response) {
                Restart.restartApp();
              });
            },
            child: const Text(
              "Güvenli çıkış",
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
                      child: widget.doktor.resimYolu == "" ||
                              widget.doktor.resimYolu == null
                          ? ClipOval(
                              child: SvgPicture.asset(
                                widget.doktor.cinsiyet
                                    ? "assets/images/person-girl-flat.svg"
                                    : "assets/images/person-flat.svg",
                                height: MediaQuery.of(context).size.width / 2.2,
                                width: MediaQuery.of(context).size.width / 2.2,
                              ),
                            )
                          : ClipOval(
                              child: CachedNetworkImage(
                                imageUrl:
                                    "${Environment.APIURL}/${widget.doktor.resimYolu}",
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
                        child: const Text("Resmi değiştir"),
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
                                    widget.doktor.resimYolu =
                                        apiUploadResponse.data.path;
                                    widget.doktor.aktifDurum = false;
                                    DoktorApi.update(widget.doktor)
                                        .then((doktorUpdateApiResponse) {
                                      var doktorUpdateResponse =
                                          ApiPostResponse.fromJson(json.decode(
                                              doktorUpdateApiResponse.body));
                                      if (doktorUpdateResponse.success) {
                                        _showRegisterAlertAndRestartApp(
                                            context,
                                            "Resim yüklendi",
                                            "Resim başarıyla yüklendi. Uygulama yeniden başlatılıyor");
                                      } else {
                                        _showAlert(context, "Dosya yüklenemedi",
                                            "Dosya yüklenirken bir şeyler ters gitti\n\n${doktorUpdateResponse.message}");
                                        widget.doktor.aktifDurum = true;
                                        return;
                                      }
                                    });
                                  } else {
                                    _showAlert(context, "Dosya yüklenemedi",
                                        "Dosya yüklenirken bir şeyler ters gitti\n\n${apiUploadResponse.message}");
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
                        initialValue: widget.doktor.email,
                        icon: Icons.mail,
                        onChanged: (value) {},
                        validator: validateEmail,
                        onSaved: (value) {
                          txtNewEmail.text = value.toString();
                        },
                      ),
                      RoundedFormInputField(
                        hintText: "Adınız",
                        initialValue: widget.doktor.ad,
                        icon: Icons.person,
                        onChanged: (value) {},
                        validator: validateFirstName,
                        onSaved: (value) {
                          txtNewAd.text = value.toString();
                        },
                      ),
                      RoundedFormInputField(
                        hintText: "Soyadınız",
                        initialValue: widget.doktor.soyad,
                        icon: Icons.person,
                        onChanged: (value) {},
                        validator: validateLastName,
                        onSaved: (value) {
                          txtNewSoyad.text = value.toString();
                        },
                      ),
                      RoundedFormInputField(
                        hintText: "Telefon numaranız",
                        initialValue: widget.doktor.telefon,
                        icon: Icons.phone,
                        onChanged: (value) {},
                        validator: validatePhone,
                        onSaved: (value) {
                          txtNewPhone.text = value.toString();
                        },
                      ),
                      RoundedButton(
                        buttonText: "Profilimi güncelle",
                        onPress: () {
                          if (_profileFormKey.currentState!.validate()) {
                            _profileFormKey.currentState!.save();
                            if (widget.doktor.email == txtNewEmail.text &&
                                widget.doktor.ad == txtNewAd.text &&
                                widget.doktor.soyad == txtNewSoyad.text &&
                                widget.doktor.telefon == txtNewPhone.text) {
                              _showAlert(context, "Hiçbir şey değiştirmediniz",
                                  "Güncelleme yapmak için önce bazı bilgilerinizi değiştirin");
                              return;
                            }
                            var newDoktor = Doktor(
                                widget.doktor.doktorNo,
                                widget.doktor.anabilimDaliNo,
                                txtNewEmail.text,
                                widget.doktor.sifre,
                                txtNewAd.text,
                                txtNewSoyad.text,
                                txtNewPhone.text,
                                widget.doktor.cinsiyet,
                                true,
                                "");
                            DoktorApi.update(newDoktor).then((response) {
                              var apiResponse = ApiPostResponse.fromJson(
                                  json.decode(response.body));
                              if (apiResponse.success) {
                                if (apiResponse.data.affectedRows == 0) {
                                  _showAlert(context, "Güncelleme başarısız",
                                      "Güncelleme yapılırken bir şeyler ters gitti");
                                  return;
                                }
                                _showRegisterAlertAndRestartApp(
                                  context,
                                  "Güncelleme başarılı",
                                  "Profiliniz başarıyla güncellendi. Lütfen tekrar giriş yapınız",
                                );
                              } else {
                                _showAlert(context, "Güncelleme başarısız",
                                    "Güncelleme yapılırken bir şeyler ters gitti\n\n${apiResponse.message}");
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
                        hintText: "Şuanki şifreniz",
                        validator: validatePassword,
                        onSaved: (value) {
                          txtOldPassword.text = value.toString();
                        },
                      ),
                      RoundedFormPasswordField(
                        onChanged: (value) {},
                        hintText: "Yeni şifreniz",
                        validator: validatePassword,
                        onSaved: (value) {
                          txtNewPassword.text = value.toString();
                        },
                      ),
                      RoundedFormPasswordField(
                        onChanged: (value) {},
                        hintText: "Yeni şifreniz tekrar",
                        validator: validatePassword,
                        onSaved: (value) {
                          txtReNewPassword.text = value.toString();
                        },
                      ),
                      RoundedButton(
                        buttonText: "Şifremi güncelle",
                        onPress: () {
                          if (_passwordFormKey.currentState!.validate()) {
                            _passwordFormKey.currentState!.save();
                            if (txtOldPassword.text != widget.doktor.sifre) {
                              _showAlert(context, "Eski şifreniz hatalı",
                                  "Girdiğiniz şifre, eski şifrenizle eşleşmiyor");
                              return;
                            }
                            if (txtNewPassword.text != txtReNewPassword.text) {
                              _showAlert(context, "Yeni şifreler eşleşmiyor",
                                  "Girdiğiniz yeni şifreler eşleşmiyor");
                              return;
                            }
                            var newDoktor = Doktor(
                                widget.doktor.doktorNo,
                                widget.doktor.anabilimDaliNo,
                                widget.doktor.email,
                                txtNewPassword.text,
                                widget.doktor.ad,
                                widget.doktor.soyad,
                                widget.doktor.telefon,
                                widget.doktor.cinsiyet,
                                true,
                                "");
                            DoktorApi.update(newDoktor).then((response) {
                              var apiResponse = ApiPostResponse.fromJson(
                                  json.decode(response.body));
                              if (apiResponse.success) {
                                if (apiResponse.data.affectedRows == 0) {
                                  _showAlert(context, "Güncelleme başarısız",
                                      "Güncelleme yapılırken bir şeyler ters gitti");
                                  return;
                                }
                                _showRegisterAlertAndRestartApp(
                                  context,
                                  "Güncelleme başarılı",
                                  "Şifreniz başarıyla değiştirildi. Lütfen yeni şifrenizle tekrar giriş yapınız",
                                );
                              } else {
                                _showAlert(context, "Güncelleme başarısız",
                                    "Şifreniz değiştirilirken bir şeyler ters gitti\n\n${apiResponse.message}");
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
