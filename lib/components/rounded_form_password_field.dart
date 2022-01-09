import 'package:flutter/material.dart';
import 'package:healmob/components/text_field_container.dart';
import 'package:healmob/constants.dart';

var _obscureText = true;

class RoundedFormPasswordField extends StatefulWidget {
  final ValueChanged<String> onChanged;
  final String? Function(String?) validator;
  final Function(String?) onSaved;

  const RoundedFormPasswordField({
    Key? key,
    required this.onChanged,
    required this.validator,
    required this.onSaved,
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
      child: TextFormField(
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
        validator: validator,
        onSaved: onSaved,
      ),
    );
  }
}
