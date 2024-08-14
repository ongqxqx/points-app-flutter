import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileReferralCode extends StatelessWidget {
  final TextEditingController referralCodeController;

  const ProfileReferralCode({
    Key? key,
    required this.referralCodeController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: referralCodeController,
      readOnly: true,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'referralCode'.tr,
      ),
    );
  }
}
