import 'package:flutter/material.dart';
import 'package:healmob/components/text_field_container.dart';
import 'package:healmob/constants.dart';

var _obscureText = true;

class RoundedPasswordField extends StatefulWidget {
  final ValueChanged<String> onChanged;

  const RoundedPasswordField({
    Key? key,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<RoundedPasswordField> createState() => _RoundedPasswordFieldState();
}

class _RoundedPasswordFieldState extends State<RoundedPasswordField> {
  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextField(
        obscureText: _obscureText,
        onChanged: widget.onChanged,
        decoration: InputDecoration(
            hintText: "Şifreniz",
            icon: const Icon(
              Icons.lock,
              color: appPrimaryColor,
            ),
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
              icon: Icon(_obscureText ? Icons.visibility : Icons.visibility_off,
                  color: appPrimaryColor),
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              hoverColor: Colors.transparent,
            ),
            border: InputBorder.none),
      ),
    );
  }
}
