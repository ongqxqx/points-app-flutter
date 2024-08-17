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
    Get.put(ProductController()); // Initializes the ProductController and makes it available for dependency injection

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'allReward'.tr, // Displays the title with localized string
          style: TextStyle(), // Default text style for the title
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.search, // Search icon
              color: Colors.white, // Icon color
            ),
            onPressed: () {
              // Opens the search screen when the search icon is pressed
              showSearch(
                context: context,
                delegate: ProductSearchScreen(), // Delegates the search functionality to ProductSearchScreen
              );
            },
          ),
        ],
      ),
      body: Container(
        width: double.infinity, // Takes up the full width of the screen
        height: double.infinity, // Takes up the full height of the screen
        decoration: BoxDecoration(color: Color(0xFFFFFF)), // Sets the background color of the container
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(left: 0.0, right: 0.0), // Adds padding on the left and right of the content
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // Aligns children to the start of the column
              children: const [
                SizedBox(height: 20.0), // Adds spacing above the content
                ProductCategory(), // Displays the product category widget
                ProductListByCategory(), // Displays the list of products by category
              ],
            ),
          ),
        ),
      ),
    );
  }
}
