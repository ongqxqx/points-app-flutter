import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AccountSettingName extends StatelessWidget {
  final TextEditingController nameController;

  const AccountSettingName({
    Key? key,
    required this.nameController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: nameController,
      decoration: InputDecoration(border: OutlineInputBorder(),labelText: 'name'.tr),
    );
  }
}
