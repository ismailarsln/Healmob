import 'package:flutter/material.dart';
import 'package:healmob/components/text_field_container.dart';
import 'package:healmob/constants.dart';

var _obscureText = true;

class RoundedFormPasswordField extends StatefulWidget {
  final ValueChanged<String> onChanged;
  final String? Function(String?) validator;
  final Function(String?) onSaved;
  final String hintText;
  final Color backColor;
  final Color inputFieldColor;

  const RoundedFormPasswordField({
    Key? key,
    required this.onChanged,
    required this.validator,
    required this.onSaved,
    this.hintText = "Şifreniz",
    this.backColor = appPrimaryColor,
    this.inputFieldColor = appPrimaryLightColor,
  }) : super(key: key);

  @override
  State<RoundedFormPasswordField> createState() =>
      _RoundedFormPasswordFieldState(validator, onSaved);
}

class _RoundedFormPasswordFieldState extends State<RoundedFormPasswordField> {
  final String? Function(String?) validator;
  final Function(String?) onSaved;

  _RoundedFormPasswordFieldState(this.validator, this.onSaved);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      backColor: widget.inputFieldColor,
      child: TextFormField(
        obscureText: _obscureText,
        onChanged: widget.onChanged,
        decoration: InputDecoration(
            hintText: widget.hintText,
            icon: Icon(
              Icons.lock,
              color: widget.backColor,
            ),
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
              icon: Icon(_obscureText ? Icons.visibility : Icons.visibility_off,
                  color: widget.backColor),
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              hoverColor: Colors.transparent,
            ),
            border: InputBorder.none),
        validator: validator,
        onSaved: onSaved,
      ),
    );
  }
}
