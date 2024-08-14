import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:points/account/components/account_history.dart';

class HomeAccountHistory extends StatelessWidget {
  const HomeAccountHistory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AccountHistory()),
        );
      },
      child: Text(
        'history'.tr + '\u2192',
        style: TextStyle(
          fontFamily: 'Roboto',
          fontSize: 14,
          color: Color(0xFFF26101),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
