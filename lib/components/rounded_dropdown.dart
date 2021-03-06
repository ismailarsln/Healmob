import 'package:flutter/material.dart';
import 'package:healmob/components/text_field_container.dart';
import 'package:healmob/constants.dart';

class RoundedDropdown<T> extends StatelessWidget {
  final ValueChanged<T?> onChanged;
  final List<DropdownMenuItem<T>> items;
  final T? selectedValue;
  final IconData icon;
  final Color backColor;
  final Color inputFieldColor;

  const RoundedDropdown({
    Key? key,
    required this.onChanged,
    required this.items,
    required this.selectedValue,
    required this.icon,
    this.backColor = appPrimaryColor,
    this.inputFieldColor = appPrimaryLightColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      backColor: inputFieldColor,
      child: Row(children: [
        Icon(
          icon,
          color: backColor,
        ),
        const SizedBox(
          width: 20.0,
        ),
        Expanded(
          child: DropdownButton(
            isExpanded: true,
            items: items,
            onChanged: onChanged,
            value: selectedValue,
          ),
        ),
      ]),
    );
  }
}
