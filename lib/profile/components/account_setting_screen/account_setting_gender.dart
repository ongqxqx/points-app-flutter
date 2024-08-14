import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AccountSettingGender extends StatelessWidget {
  final String? gender;
  final Function(String?) onChanged;

  const AccountSettingGender({
    Key? key,
    required this.gender,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: gender,
      decoration: InputDecoration(border: OutlineInputBorder(),labelText: 'gender'.tr),
      onChanged: onChanged,
      items: <String>['Male', 'Female', 'Other']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
