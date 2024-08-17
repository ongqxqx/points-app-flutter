import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AccountSettingEmail extends StatefulWidget {
  final TextEditingController emailController; // Controller to manage email input
  final bool isBindingEmail; // State indicating if email binding is in progress
  final Function() onPressed; // Callback function when the button is pressed

  const AccountSettingEmail({
    Key? key,
    required this.emailController,
    required this.isBindingEmail,
    required this.onPressed,
  }) : super(key: key);

  @override
  _AccountSettingEmailState createState() => _AccountSettingEmailState();
}

class _AccountSettingEmailState extends State<AccountSettingEmail> {
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
    // Check if the email field is not empty
    if (widget.emailController.text.isNotEmpty) {
      // Display a read-only text field with the current email
      return TextFormField(
        focusNode: _focusNode,
        controller: widget.emailController,
        readOnly: true, // Make the text field read-only
        decoration: InputDecoration(
          border: OutlineInputBorder(), // Border style for the text field
          // enabledBorder: OutlineInputBorder(
          //   borderSide: BorderSide(color: Colors.grey), // Border color when the field is enabled
          // ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFF26101), width: 2.0), // Border color when the field is focused
          ),
          labelText: 'email'.tr, // Label text, translated
          labelStyle: TextStyle(
            color: _hasFocus ? Color(0xFFF26101) : Colors.grey, // Change label color based on focus
          ),
        ),
      );
    } else {
      // Display a button to bind email if the email field is empty
      return ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 16), // Set vertical padding for the button
          backgroundColor: Color(0xFFF26101), // Button background color
          foregroundColor: Color(0xFFFFFFFF), // Button text color
        ),
        onPressed: widget.onPressed, // Trigger the callback function when pressed
        child: Text('bindEmail'.tr, style: TextStyle(fontSize: 16)), // Button text, translated
      );
    }
  }
}
