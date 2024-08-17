import 'package:flutter/material.dart';

class AccountSettingUid extends StatefulWidget {
  final TextEditingController uidController;

  const AccountSettingUid({
    Key? key,
    required this.uidController,
  }) : super(key: key);

  @override
  _AccountSettingUidState createState() => _AccountSettingUidState();
}

class _AccountSettingUidState extends State<AccountSettingUid> {
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
      controller: widget.uidController,
      focusNode: _focusNode,
      readOnly: true, // Makes the text field read-only
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
        labelText: 'UID', // Label for the text field
        labelStyle: TextStyle(
          color: _hasFocus ? Color(0xFFF26101) : Colors.blueGrey, // Change label color based on focus
        ),
      ),
    );
  }
}
