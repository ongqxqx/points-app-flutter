import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:points/product/components/product_list_by_category.dart';
import 'components/product_category.dart';
import 'components/product_controller.dart';
import 'product_search_screen.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(ProductController());
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'allReward'.tr,
          style: TextStyle(),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.search,
              color: Colors.white,
            ),
            onPressed: () {
              showSearch(
                context: context,
                delegate: ProductSearchScreen(),
              );
            },
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(color: Color(0xFFFFFF)),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(left: 0.0, right: 0.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                SizedBox(height: 20.0),
                ProductCategory(),
                ProductListByCategory(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
