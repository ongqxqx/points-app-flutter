import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AccountSettingReferrerCode extends StatelessWidget {
  final TextEditingController referrerCodeController;

  const AccountSettingReferrerCode({
    Key? key,
    required this.referrerCodeController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (referrerCodeController.text.isNotEmpty) {
      return TextFormField(
        controller: referrerCodeController,
        readOnly: true,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'referrerCode'.tr,
        ),
      );
    } else {
      return TextFormField(
        controller: referrerCodeController,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'referrerCode'.tr,
        ),
      );
    }
  }
}
