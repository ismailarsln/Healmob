import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:healmob/components/already_have_an_account.dart';
import 'package:healmob/components/rounded_button.dart';
import 'package:healmob/components/rounded_dropdown.dart';
import 'package:healmob/components/rounded_input_field.dart';
import 'package:healmob/components/rounded_password_field.dart';
import 'package:healmob/components/swap_doctor_patient_screen.dart';
import 'package:healmob/constants.dart';

var _isPatient = true;
String anabilimDali = "Anabilim dalınızı seçiniz";
String gender = "Cinsiyetiniz";

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
                    "HASTA KAYIT",
                    key: UniqueKey(),
                  )
                : Text("DOKTOR KAYIT", key: UniqueKey())),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: size.height * 0.03,
              ),
              AnimatedSwitcher(
                duration: defaultDuration,
                child: _isPatient
                    ? SvgPicture.asset(
                        "assets/images/patient_register.svg",
                        height: size.height * 0.35,
                        key: UniqueKey(),
                      )
                    : SvgPicture.asset("assets/images/doctor_register.svg",
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
                isLoginScreen: false,
              ),
              SizedBox(
                height: size.height * 0.03,
              ),
              RoundedInputField(
                hintText: "Adınız",
                icon: Icons.person,
                onChanged: (value) {},
              ),
              RoundedInputField(
                hintText: "Soyadınız",
                icon: Icons.person,
                onChanged: (value) {},
              ),
              RoundedInputField(
                hintText: "E-posta adresiniz",
                icon: Icons.email,
                onChanged: (value) {},
              ),
              RoundedPasswordField(
                onChanged: (value) {},
              ),
              RoundedInputField(
                hintText: "Telefon numaranız",
                icon: Icons.phone,
                onChanged: (value) {},
              ),
              if (!_isPatient)
                RoundedDropdown<String>(
                  icon: Icons.assignment_ind_rounded,
                  onChanged: (value) {
                    setState(() {
                      anabilimDali = value!;
                    });
                  },
                  items: ["Anabilim dalınızı seçiniz", "Test1", "Test2"],
                  selectedValue: anabilimDali,
                ),
              RoundedDropdown<String>(
                icon: Icons.wc,
                onChanged: (value) {
                  setState(() {
                    gender = value!;
                  });
                },
                items: const ["Cinsiyetiniz", "Erkek", "Kadın"],
                selectedValue: gender,
              ),
              RoundedButton(
                buttonText:
                    (_isPatient ? "Hasta" : "Doktor ") + " kaydını oluştur",
                onPress: () {},
              ),
              AlreadyHaveAnAccountCheck(
                onPress: () {
                  Navigator.pushNamed(context, "/login");
                },
                login: false,
              ),
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
