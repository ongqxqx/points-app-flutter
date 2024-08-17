import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AccountSettingReferrerCode extends StatefulWidget {
  final TextEditingController referrerCodeController; // Controller for managing referrer code input

  const AccountSettingReferrerCode({
    Key? key,
    required this.referrerCodeController, // Initialize the controller via constructor
  }) : super(key: key);

  @override
  _AccountSettingReferrerCodeState createState() => _AccountSettingReferrerCodeState();
}

class _AccountSettingReferrerCodeState extends State<AccountSettingReferrerCode> {
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
      controller: widget.referrerCodeController,
      focusNode: _focusNode,
      readOnly: widget.referrerCodeController.text.isNotEmpty, // Make the text field read-only if referrer code is provided
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey, // Default border color
            width: 2.0, // Border thickness
          ),
        ),
        // enabledBorder: OutlineInputBorder(
        //   borderSide: BorderSide(
        //     color: Colors.grey, // Border color when the field is enabled (no focus)
        //     width: 2.0, // Border thickness
        //   ),
        // ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xFFF26101), // Border color when the field is focused
            width: 2.0, // Border thickness
          ),
        ),
        labelText: 'referrerCode'.tr, // Sets the label text, translated
        labelStyle: TextStyle(
          color: _hasFocus ? Color(0xFFF26101) : Colors.blueGrey, // Change label color based on focus
        ),
      ),
    );
  }
}
