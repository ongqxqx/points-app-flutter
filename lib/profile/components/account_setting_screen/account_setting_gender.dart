import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AccountSettingGender extends StatefulWidget {
  final String? gender; // Currently selected gender
  final Function(String?) onChanged; // Callback function when the gender is changed

  const AccountSettingGender({
    Key? key,
    required this.gender,
    required this.onChanged,
  }) : super(key: key);

  @override
  _AccountSettingGenderState createState() => _AccountSettingGenderState();
}

class _AccountSettingGenderState extends State<AccountSettingGender> {
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
    return DropdownButtonFormField<String>(
      value: widget.gender, // Access the widget's gender property
      focusNode: _focusNode,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          // borderSide: BorderSide(
          //   color: Colors.grey, // Default border color
          //   width: 2.0, // Border thickness
          // ),
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
        labelText: 'gender'.tr, // Label text, translated
        labelStyle: TextStyle(
          color: _hasFocus ? Color(0xFFF26101) : Colors.blueGrey, // Change label color based on focus
        ),
      ),
      onChanged: widget.onChanged, // Access the widget's onChanged callback
      items: <String>['Male', 'Female', 'Other'] // List of gender options
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value, // Value of the dropdown item
          child: Text(
            value,
            style: TextStyle(
              color: Colors.black, // Text color in dropdown menu
              fontWeight: FontWeight.normal, // Ensure text is not bold
            ),
          ), // Displayed text of the dropdown item
        );
      }).toList(), // Converts the list of options to a list of DropdownMenuItems
    );
  }
}
