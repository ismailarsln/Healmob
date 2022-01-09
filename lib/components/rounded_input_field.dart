import 'package:flutter/material.dart';
import 'package:healmob/components/text_field_container.dart';
import 'package:healmob/constants.dart';

class RoundedInputField extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final ValueChanged<String> onChanged;
  final Color backColor;

  const RoundedInputField({
    Key? key,
    required this.hintText,
    required this.icon,
    required this.onChanged,
    this.backColor = appPrimaryColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextField(
        onChanged: onChanged,
        decoration: InputDecoration(
            icon: Icon(
              icon,
              color: backColor,
            ),
            hintText: hintText,
            border: InputBorder.none),
      ),
    );
  }
}
