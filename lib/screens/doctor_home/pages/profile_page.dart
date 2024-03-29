import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:healmob/components/rounded_button.dart';
import 'package:healmob/components/rounded_form_input_field.dart';
import 'package:healmob/components/rounded_form_password_field.dart';
import 'package:healmob/components/text_field_container.dart';
import 'package:healmob/constants.dart';
import 'package:healmob/data/doktor_api.dart';
import 'package:healmob/data/doktor_uzmanlik_alani_api.dart';
import 'package:healmob/data/file_api.dart';
import 'package:healmob/data/uzmanlik_alani_api.dart';
import 'package:healmob/environment.dart';
import 'package:healmob/models/api_response/api_get_response.dart';
import 'package:healmob/models/api_response/api_post_response.dart';
import 'package:healmob/models/api_response/api_upload_post_response.dart';
import 'package:healmob/models/doktor.dart';
import 'package:healmob/models/doktor_uzmanlik_alani.dart';
import 'package:healmob/models/uzmanlik_alani.dart';
import 'package:healmob/validation/user_validator.dart';
import 'package:http/http.dart';
import 'package:restart_app/restart_app.dart';
import 'package:collection/collection.dart';

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
  Map<UzmanlikAlani, bool> uzmanlikAlaniList = <UzmanlikAlani, bool>{};

  @override
  void initState() {
    getAllUzmanlikAlaniFromApi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text("Profilim"),
            centerTitle: true,
            backgroundColor: appSecondColor,
            actions: [
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
                      color: Colors.yellowAccent,
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
                        backColor: appSecondColor,
                        inputFieldBackColor: appSecondLightColor,
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
                        backColor: appSecondColor,
                        inputFieldBackColor: appSecondLightColor,
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
                        backColor: appSecondColor,
                        inputFieldBackColor: appSecondLightColor,
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
                        backColor: appSecondColor,
                        inputFieldBackColor: appSecondLightColor,
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
                        backColor: appSecondColor,
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
                      const SizedBox(
                        height: 10,
                      ),
                      const Divider(
                        color: appPrimaryDarkColor,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFieldContainer(
                        backColor: appSecondLightColor,
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height / 3,
                          width: MediaQuery.of(context).size.width / 1.5,
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              const Text(
                                "Uzmanlık alanlarınızı seçiniz",
                                style: TextStyle(
                                    fontSize: 15,
                                    decoration: TextDecoration.underline),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Expanded(
                                child: ListView.builder(
                                  itemCount: uzmanlikAlaniList.length,
                                  itemBuilder: (context, index) {
                                    var tempUzmanlikAlaniList =
                                        uzmanlikAlaniList.keys.toList();
                                    var tempSelectedList =
                                        uzmanlikAlaniList.values.toList();
                                    return CheckboxListTile(
                                      title: Text(tempUzmanlikAlaniList[index]
                                          .uzmanlikAlaniAdi),
                                      selected: tempSelectedList[index],
                                      value: tempSelectedList[index],
                                      onChanged: (value) {
                                        setState(
                                          () {
                                            uzmanlikAlaniList[
                                                tempUzmanlikAlaniList[
                                                    index]] = value!;
                                          },
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      RoundedButton(
                        backColor: appSecondColor,
                        buttonText: "Uzmanlık alanlarımı güncelle",
                        onPress: () {
                          DoktorUzmanlikAlaniApi.getAllByDoktorNo(
                                  widget.doktor.doktorNo)
                              .then((response) async {
                            ApiGetResponse apiResponse =
                                ApiGetResponse.fromJson(
                                    json.decode(response.body));
                            if (apiResponse.success) {
                              var doktorUzmanlikAlaniList = apiResponse.data
                                  .map((d) => DoktorUzmanlikAlani.fromJson(d))
                                  .toList();

                              for (int i = 0;
                                  i < uzmanlikAlaniList.length;
                                  i++) {
                                var selectedUzmanlikAlani =
                                    uzmanlikAlaniList.keys.toList()[i];
                                bool isSelected =
                                    uzmanlikAlaniList[selectedUzmanlikAlani]!;

                                var existDoktorUzmanlikAlani =
                                    doktorUzmanlikAlaniList.firstWhereOrNull(
                                        (u) =>
                                            u.uzmanlikAlaniId ==
                                            selectedUzmanlikAlani
                                                .uzmanlikAlaniId);

                                if (existDoktorUzmanlikAlani != null &&
                                    !isSelected) {
                                  await DoktorUzmanlikAlaniApi.delete(
                                      existDoktorUzmanlikAlani);
                                  continue;
                                }

                                if (existDoktorUzmanlikAlani == null &&
                                    isSelected) {
                                  await DoktorUzmanlikAlaniApi.add(
                                      DoktorUzmanlikAlani(
                                          1,
                                          widget.doktor.doktorNo,
                                          selectedUzmanlikAlani
                                              .uzmanlikAlaniId));
                                }
                              }
                              _showRegisterAlertAndRestartApp(
                                context,
                                "Güncelleme başarılı",
                                "Uzmanlık alanlarınız başarıyla güncellendi. Lütfen tekrar giriş yapınız",
                              );
                            }
                          });
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
                        backColor: appSecondColor,
                        inputFieldColor: appSecondLightColor,
                        onChanged: (value) {},
                        hintText: "Şuanki şifreniz",
                        validator: validatePassword,
                        onSaved: (value) {
                          txtOldPassword.text = value.toString();
                        },
                      ),
                      RoundedFormPasswordField(
                        backColor: appSecondColor,
                        inputFieldColor: appSecondLightColor,
                        onChanged: (value) {},
                        hintText: "Yeni şifreniz",
                        validator: validatePassword,
                        onSaved: (value) {
                          txtNewPassword.text = value.toString();
                        },
                      ),
                      RoundedFormPasswordField(
                        backColor: appSecondColor,
                        inputFieldColor: appSecondLightColor,
                        onChanged: (value) {},
                        hintText: "Yeni şifreniz tekrar",
                        validator: validatePassword,
                        onSaved: (value) {
                          txtReNewPassword.text = value.toString();
                        },
                      ),
                      RoundedButton(
                        backColor: appSecondColor,
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

  getAllUzmanlikAlaniFromApi() {
    uzmanlikAlaniList.clear();
    UzmanlikAlaniApi.getAll().then((response) {
      ApiGetResponse apiResponse =
          ApiGetResponse.fromJson(json.decode(response.body));
      if (apiResponse.success) {
        DoktorUzmanlikAlaniApi.getAllByDoktorNo(widget.doktor.doktorNo)
            .then((response2) {
          ApiGetResponse apiResponse2 =
              ApiGetResponse.fromJson(json.decode(response2.body));
          if (apiResponse2.success) {
            var doktorUzmanlikAlaniList = apiResponse2.data
                .map((d) => DoktorUzmanlikAlani.fromJson(d))
                .toList();
            for (var uzmanlikAlaniInstance in apiResponse.data) {
              var uzmanlikAlani = UzmanlikAlani.fromJson(uzmanlikAlaniInstance);
              setState(() {
                uzmanlikAlaniList[uzmanlikAlani] = doktorUzmanlikAlaniList.any(
                    (d) => d.uzmanlikAlaniId == uzmanlikAlani.uzmanlikAlaniId);
              });
            }
          }
        });
      }
    });
  }
}
