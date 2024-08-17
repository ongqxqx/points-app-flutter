import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'product_controller.dart';

class ProductCategory extends GetView<ProductController> {
  const ProductCategory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Using GetX to manage the state of the ProductController
    return GetX<ProductController>(
      init: ProductController(), // Initializing the ProductController
      builder: (controller) {
        // Checking if data is still loading
        if (controller.isLoading.value) {
          // Show a loading indicator while data is being fetched
          // return Center(child: CircularProgressIndicator());
        }

        // Display a message if there are no categories available
        if (controller.categories.isEmpty) {
          return Center(child: Text('noCategoriesAvailable'.tr));
        }

        // Sorting categories to prioritize the "hot" category
        var sortedCategories = controller.categories;
        sortedCategories.sort((a, b) {
          if (a.id == 'hot') return -1;
          if (b.id == 'hot') return 1;
          return 0;
        });

        // Displaying categories in a horizontal scroll view
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: EdgeInsets.only(left: 20.0, right: 20.0),
            child: Row(
              children: sortedCategories.map((type) {
                // Check if the current category is selected
                bool isSelected = type.id == controller.selectedCategory.value;

                return GestureDetector(
                  onTap: () => controller.setCategory(type.id), // Set the selected category on tap
                  child: Padding(
                    padding: const EdgeInsets.only(left: 0.0, right: 20.0, bottom: 20.0),
                    // Building the UI for each category item
                    child: _buildProductItem(type.id, type['imageURL'], isSelected),
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  // Widget to build each product category item
  Widget _buildProductItem(String name, String imageURL, bool isSelected) {
    return Material(
      elevation: 5, // Adding shadow to the item
      borderRadius: BorderRadius.circular(20), // Rounding the corners of the item
      color: Color(0xFF91BED4), // Setting background color
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Centering content vertically
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15.0, top: 10, right: 15, bottom: 10),
              child: Column(
                children: [
                  // Displaying the category image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(5), // Rounding the image corners
                    child: SizedBox(
                      width: 50, // Setting image width
                      height: 50, // Setting image height
                      child: Image.network(
                        imageURL,
                        fit: BoxFit.cover, // Covering the container with the image
                      ),
                    ),
                  ),
                  SizedBox(height: 8), // Adding space between image and text
                  // Displaying the category name
                  Text(
                    name.tr,
                    style: TextStyle(
                      fontSize: isSelected ? 30 : 20, // Adjusting font size based on selection
                      color: Colors.white, // Text color
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal, // Adjusting font weight based on selection
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
