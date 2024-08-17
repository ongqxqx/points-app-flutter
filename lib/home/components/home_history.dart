import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:points/account/components/account_history.dart';

class HomeAccountHistory extends StatelessWidget {
  const HomeAccountHistory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        // Navigate to the AccountHistory screen when the button is pressed
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AccountHistory()),
        );
      },
      child: Text(
        // Display the translated 'history' text with an arrow
        'history'.tr + '\u2192',
        style: TextStyle(
          fontFamily: 'Roboto', // Use the 'Roboto' font
          fontSize: 14, // Set the font size
          color: Color(0xFFF26101), // Set the text color
          fontWeight: FontWeight.bold, // Set the font weight to bold
        ),
      ),
    );
  }
}
