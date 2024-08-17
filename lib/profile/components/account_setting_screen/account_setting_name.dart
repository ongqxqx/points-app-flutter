import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AccountSettingName extends StatefulWidget {
  final TextEditingController nameController; // Controller for managing the text input

  const AccountSettingName({
    Key? key,
    required this.nameController, // Initialize the controller via constructor
  }) : super(key: key);

  @override
  _AccountSettingNameState createState() => _AccountSettingNameState();
}

class _AccountSettingNameState extends State<AccountSettingName> {
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
      controller: widget.nameController, // Binds the text field to the provided controller
      focusNode: _focusNode, // Set the focus node to manage focus state
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey, // Default border color
            width: 2.0, // Border thickness
          ),
        ),
        // enabledBorder: OutlineInputBorder(
        //   borderSide: BorderSide(
        //     color: _hasFocus ? Color(0xFFF26101) : Colors.grey, // Border color when enabled and not focused
        //     width: 2.0, // Border thickness
        //   ),
        // ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xFFF26101), // Border color when focused
            width: 2.0, // Border thickness
          ),
        ),
        labelText: 'name'.tr, // Sets the label text, translated
        labelStyle: TextStyle(
          color: _hasFocus ? Color(0xFFF26101) : Colors.blueGrey, // Change label color based on focus
        ),
      ),
    );
  }
}
