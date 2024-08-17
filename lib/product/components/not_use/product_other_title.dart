import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'product_other_all.dart';

class ProductOtherTitle extends StatelessWidget {
  const ProductOtherTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Row(children: [
        Text('otherProduct'.tr,
            style: GoogleFonts.ubuntu(fontSize: 26, fontWeight: FontWeight.bold)),
        Spacer(),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProductOtherAll()),
            );
          },
          child: Text('viewAll'.tr), // Ensure the translation key is correct
        ),
      ]),
    );
  }
}
