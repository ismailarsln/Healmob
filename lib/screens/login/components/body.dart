import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:healmob/components/already_have_an_account.dart';
import 'package:healmob/components/rounded_button.dart';
import 'package:healmob/components/rounded_form_input_field.dart';
import 'package:healmob/components/rounded_form_password_field.dart';
import 'package:healmob/components/swap_doctor_patient_screen.dart';
import 'package:healmob/constants.dart';
import 'package:healmob/data/doktor_api.dart';
import 'package:healmob/data/hasta_api.dart';
import 'package:healmob/models/api_response/api_get_response.dart';
import 'package:healmob/models/api_response/api_post_response.dart';
import 'package:healmob/models/doktor.dart';
import 'package:healmob/models/hasta.dart';
import 'package:healmob/validation/user_validator.dart';

var _isPatient = true;
var _loginInfo = {"email": "", "password": ""};

class Body extends StatefulWidget with UserValidationMixin {
  const Body({Key? key}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> with UserValidationMixin {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: AnimatedSwitcher(
            duration: defaultDuration,
            child: _isPatient
                ? Text(
                    "HASTA GİRİŞ",
                    key: UniqueKey(),
                  )
                : Text("DOKTOR GİRİŞ", key: UniqueKey())),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              AnimatedSwitcher(
                duration: defaultDuration,
                child: _isPatient
                    ? SvgPicture.asset(
                        "assets/images/patient_login.svg",
                        height: size.height * 0.35,
                        key: UniqueKey(),
                      )
                    : SvgPicture.asset("assets/images/doctor_login.svg",
                        height: size.height * 0.35, key: UniqueKey()),
              ),
              SizedBox(
                height: size.height * 0.03,
              ),
              SwapDoctorPatientScreen(
                onPress: () {
                  setState(() {
                    _isPatient = !_isPatient;
                    _formKey.currentState!.reset();
                  });
                },
                isPatient: _isPatient,
                isLoginScreen: true,
              ),
              SizedBox(
                height: size.height * 0.03,
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    RoundedFormInputField(
                      hintText: "E-posta adresiniz",
                      icon: Icons.email,
                      onChanged: (value) {},
                      validator: validateEmail,
                      onSaved: (value) {
                        _loginInfo["email"] = value.toString();
                      },
                    ),
                    RoundedFormPasswordField(
                      onChanged: (value) {},
                      validator: validatePassword,
                      onSaved: (value) {
                        _loginInfo["password"] = value.toString();
                      },
                    ),
                  ],
                ),
              ),
              RoundedButton(
                buttonText: "Giriş yap",
                onPress: () {
                  login();
                },
              ),
              AlreadyHaveAnAccountCheck(onPress: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, "/register", ModalRoute.withName('/'));
              }),
              SizedBox(
                height: size.height * 0.03,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAlert(BuildContext context, String title, String message) {
    var alert = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (BuildContext context) => alert);
  }

  void login() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (_isPatient) {
        HastaApi.getAllByEmail(_loginInfo["email"].toString()).then((response) {
          ApiGetResponse apiResponse =
              ApiGetResponse.fromJson(json.decode(response.body));
          if (apiResponse.success) {
            if (apiResponse.data.isNotEmpty) {
              if (apiResponse.data.length == 1) {
                var hasta = Hasta.fromJson(apiResponse.data[0]);
                if (hasta.email == _loginInfo["email"] &&
                    hasta.sifre == _loginInfo["password"]) {
                  hasta.aktifDurum = true;
                  HastaApi.update(hasta).then((updateResponse) {
                    ApiPostResponse apiPostResponse = ApiPostResponse.fromJson(
                        json.decode(updateResponse.body));
                    if (apiPostResponse.success) {
                      Navigator.pushNamedAndRemoveUntil(
                          context, "/patientHome", ModalRoute.withName('/'),
                          arguments: hasta);
                    } else {
                      _showAlert(context, "Bağlantı sorunu",
                          "Giriş yapılırken bir sorun oluştu");
                    }
                  });
                } else {
                  _showAlert(context, "Giriş başarısız",
                      "E-posta adresiniz veya şifreniz hatalı");
                }
              } else {
                _showAlert(context, "Bir sorun var",
                    "Bu e-posta adresi birden çok hesaba kayıtlı");
              }
            } else {
              _showAlert(
                  context, "Giriş başarısız", "E-posta adresiniz bulunamadı");
            }
          }
        });
      } else {
        DoktorApi.getAllByEmail(_loginInfo["email"].toString())
            .then((response) {
          ApiGetResponse apiResponse =
              ApiGetResponse.fromJson(json.decode(response.body));
          if (apiResponse.success) {
            if (apiResponse.data.isNotEmpty) {
              if (apiResponse.data.length == 1) {
                var doktor = Doktor.fromJson(apiResponse.data[0]);
                if (doktor.email == _loginInfo["email"] &&
                    doktor.sifre == _loginInfo["password"]) {
                  doktor.aktifDurum = true;
                  DoktorApi.update(doktor).then((updateResponse) {
                    ApiPostResponse apiPostResponse = ApiPostResponse.fromJson(
                        json.decode(updateResponse.body));
                    if (apiPostResponse.success) {
                      print("GİRDİ");
                    } else {
                      _showAlert(context, "Bağlantı sorunu",
                          "Giriş yapılırken bir sorun oluştu");
                    }
                  });
                } else {
                  _showAlert(context, "Giriş başarısız",
                      "E-posta adresiniz veya şifreniz hatalı");
                }
              } else {
                _showAlert(context, "Bir sorun var",
                    "Bu e-posta adresi birden çok hesaba kayıtlı");
              }
            } else {
              _showAlert(
                  context, "Giriş başarısız", "E-posta adresiniz bulunamadı");
            }
          }
        });
      }
    }
  }
}
