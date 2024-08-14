import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AccountSettingPhoneNumber extends StatelessWidget {
  final TextEditingController phoneNumberController;
  final bool isBindingPhoneNumber;
  final Function() onPressed;

  const AccountSettingPhoneNumber({
    Key? key,
    required this.phoneNumberController,
    required this.isBindingPhoneNumber,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (phoneNumberController.text.isNotEmpty) {
      return TextFormField(
        controller: phoneNumberController,
        readOnly: true,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'phoneNumber'.tr,
        ),
      );
    } else {
      return ElevatedButton(
        onPressed: onPressed,
        child: const Text(
          'Please proceed with binding your phone number to your account.',
        ),
      );
    }
  }
}
