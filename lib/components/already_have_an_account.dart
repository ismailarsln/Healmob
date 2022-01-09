import 'package:flutter/material.dart';
import 'package:healmob/constants.dart';

class AlreadyHaveAnAccountCheck extends StatelessWidget {
  final bool login;
  final void Function() onPress;

  const AlreadyHaveAnAccountCheck({
    Key? key,
    this.login = true,
    required this.onPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          login ? "Hesabın yok mu? " : "Zaten bir hesabın var mı? ",
          style: const TextStyle(color: appPrimaryColor),
        ),
        GestureDetector(
          onTap: onPress,
          child: Text(
            login ? "Hemen kayıt ol" : "Hemen giriş yap",
            style: const TextStyle(
                color: appPrimaryColor, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }
}
