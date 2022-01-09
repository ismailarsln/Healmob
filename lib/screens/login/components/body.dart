import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:healmob/components/already_have_an_account.dart';
import 'package:healmob/components/rounded_button.dart';
import 'package:healmob/components/rounded_input_field.dart';
import 'package:healmob/components/rounded_password_field.dart';
import 'package:healmob/components/swap_doctor_patient_screen.dart';
import 'package:healmob/constants.dart';

var _isPatient = true;

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
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
                  });
                },
                isPatient: _isPatient,
                isLoginScreen: true,
              ),
              SizedBox(
                height: size.height * 0.03,
              ),
              RoundedInputField(
                hintText: "E-posta adresiniz",
                icon: Icons.email,
                onChanged: (value) {},
              ),
              RoundedPasswordField(
                onChanged: (value) {},
              ),
              RoundedButton(
                buttonText: "Giriş yap",
                onPress: () {},
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
}
