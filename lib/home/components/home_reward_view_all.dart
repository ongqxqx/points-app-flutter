import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:points/product/product_screen.dart';

class HomeRewardViewAll extends StatelessWidget {
  const HomeRewardViewAll({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ProductScreen()), // Navigate to ProductScreen
        );
      },
      child: Text(
        'viewAll'.tr + '\u2192', // Translated 'viewAll' text with arrow
        style: TextStyle(
          fontFamily: 'Roboto', // Font family for text
          fontSize: 14, // Font size for text
          color: Color(0xFFF26101), // Text color
          fontWeight: FontWeight.bold, // Text weight
        ),
      ),
    );
  }
}
