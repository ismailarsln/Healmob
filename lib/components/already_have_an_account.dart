import 'package:flutter/material.dart';
import 'package:healmob/constants.dart';

class AlreadyHaveAnAccountCheck extends StatelessWidget {
  final bool login;
  final void Function() onPress;
  final Color color;

  const AlreadyHaveAnAccountCheck({
    Key? key,
    this.login = true,
    required this.onPress,
    this.color = appPrimaryColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          login ? "Hesabın yok mu? " : "Zaten bir hesabın var mı? ",
          style: TextStyle(color: color),
        ),
        GestureDetector(
          onTap: onPress,
          child: Text(
            login ? "Hemen kayıt ol" : "Hemen giriş yap",
            style: TextStyle(color: color, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }
}
