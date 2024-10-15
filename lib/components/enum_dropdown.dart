import 'package:flutter/material.dart';

class EnumDropdownFormField<T extends Enum> extends StatelessWidget {
  final List<T> optionsList;
  final void Function(T) onChange;
  String get name => T.toString();
  const EnumDropdownFormField(
      {super.key, required this.optionsList, required this.onChange});

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      value: optionsList.first,
      decoration: InputDecoration(labelText: name),
      items: optionsList.map((T value) {
        return DropdownMenuItem<T>(
          value: value,
          child: Text(value.name),
        );
      }).toList(),
      onChanged: (T? newValue) {
        if (newValue != null) {
          onChange(newValue);
        }
      },
      validator: (value) {
        if (value == null) {
          return "$name is required";
        }
        return null;
      },
    );
  }
}
