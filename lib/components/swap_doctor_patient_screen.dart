import 'package:flutter/material.dart';
import 'package:healmob/constants.dart';

class SwapDoctorPatientScreen extends StatelessWidget {
  final bool isPatient;
  final bool isLoginScreen;
  final void Function() onPress;

  const SwapDoctorPatientScreen({
    Key? key,
    this.isPatient = true,
    required this.onPress,
    required this.isLoginScreen,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          isPatient
              ? "DOKTOR " + (isLoginScreen ? "GİRİŞİ" : "KAYDI") + " İÇİN "
              : "HASTA " + (isLoginScreen ? "GİRİŞİ" : "KAYDI") + " İÇİN ",
          style: const TextStyle(color: appPrimaryColor),
        ),
        GestureDetector(
          onTap: onPress,
          child: const Text(
            "TIKLAYINIZ",
            style:
                TextStyle(color: appPrimaryColor, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }
}
