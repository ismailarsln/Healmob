import 'package:flutter/material.dart';
import 'package:healmob/constants.dart';

class RoundedButton extends StatelessWidget {
  final String buttonText;
  final void Function() onPress;
  final Color backColor, textColor;

  const RoundedButton({
    Key? key,
    required this.buttonText,
    required this.onPress,
    this.backColor = appPrimaryColor,
    this.textColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      width: size.width * 0.8,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(29),
        child: TextButton(
            style: TextButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                backgroundColor: backColor),
            onPressed: onPress,
            child: Text(
              buttonText,
              style: TextStyle(color: textColor),
            )),
      ),
    );
  }
}
