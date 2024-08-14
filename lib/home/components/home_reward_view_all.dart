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
          MaterialPageRoute(builder: (context) => const ProductScreen()),
        );
      },
      child: Text(
        'viewAll'.tr + '\u2192',
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
