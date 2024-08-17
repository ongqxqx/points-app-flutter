import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AccountSettingPhoneNumber extends StatefulWidget {
  final TextEditingController phoneNumberController; // Controller for managing phone number input
  final bool isBindingPhoneNumber; // Boolean to determine if phone number is bound
  final Function() onPressed; // Callback function to execute when the button is pressed

  const AccountSettingPhoneNumber({
    Key? key,
    required this.phoneNumberController, // Initialize the controller via constructor
    required this.isBindingPhoneNumber, // Initialize the binding status
    required this.onPressed, // Initialize the button press callback
  }) : super(key: key);

  @override
  _AccountSettingPhoneNumberState createState() => _AccountSettingPhoneNumberState();
}

class _AccountSettingPhoneNumberState extends State<AccountSettingPhoneNumber> {
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
    if (widget.phoneNumberController.text.isNotEmpty) {
      return TextFormField(
        controller: widget.phoneNumberController, // Bind the text field to the provided controller
        readOnly: true, // Make the text field read-only
        focusNode: _focusNode, // Attach the FocusNode to the text field
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey, // Default border color
              width: 2.0, // Border thickness
            ),
          ),
          // enabledBorder: OutlineInputBorder(
          //   borderSide: BorderSide(
          //     color: Colors.grey, // Border color when enabled (no focus)
          //     width: 2.0, // Border thickness
          //   ),
          // ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color(0xFFF26101), // Border color when focused
              width: 2.0, // Border thickness
            ),
          ),
          labelText: 'phoneNumber'.tr, // Sets the label text, translated
          labelStyle: TextStyle(
            color: _hasFocus ? Color(0xFFF26101) : Colors.blueGrey, // Change label color based on focus
          ),
        ),
      );
    } else {
      return ElevatedButton(
        onPressed: widget.onPressed, // Callback function when the button is pressed
        child: const Text(
          'Please proceed with binding your phone number to your account.',
          // Prompt for the user to bind their phone number
        ),
      );
    }
  }
}
