import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AccountSettingEmail extends StatelessWidget {
  final TextEditingController emailController;
  final bool isBindingEmail;
  final Function() onPressed;

  const AccountSettingEmail({
    Key? key,
    required this.emailController,
    required this.isBindingEmail,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (emailController.text.isNotEmpty) {
      return TextFormField(
        controller: emailController,
        readOnly: true,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'email'.tr,
        ),
      );
    } else {
      return ElevatedButton(
        onPressed: onPressed,
        child: Text('bindEmail'.tr),
      );
    }
  }
}
