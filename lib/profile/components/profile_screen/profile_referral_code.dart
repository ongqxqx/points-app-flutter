import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileReferralCode extends StatefulWidget {
  final TextEditingController referralCodeController; // Controller to manage the referral code input field

  const ProfileReferralCode({
    Key? key,
    required this.referralCodeController,
  }) : super(key: key);

  @override
  _ProfileReferralCodeState createState() => _ProfileReferralCodeState();
}

class _ProfileReferralCodeState extends State<ProfileReferralCode> {
  final FocusNode _focusNode = FocusNode();
  bool _hasFocus = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _hasFocus = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.referralCodeController,
      focusNode: _focusNode,
      readOnly: true, // Make the text field read-only
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey, // Default border color
            width: 2.0, // Border thickness
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey, // Border color when the field is enabled (no focus)
            width: 2.0, // Border thickness
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xFFF26101), // Border color when the field is focused
            width: 2.0, // Border thickness
          ),
        ),
        labelText: 'referralCode'.tr, // Label text, translated
        labelStyle: TextStyle(
          color: _hasFocus ? Color(0xFFF26101) : Colors.blueGrey, // Change label color based on focus
        ),
      ),
    );
  }
}
