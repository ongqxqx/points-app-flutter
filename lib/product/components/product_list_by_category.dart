import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:points/product/components/product_detail.dart';
import 'product_controller.dart';

class ProductListByCategory extends StatelessWidget {
  const ProductListByCategory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ProductController controller = Get.find(); // Finds the ProductController using GetX

    return Obx(() { // Reactive UI update using Obx
      if (controller.isLoading.value) {
        // return Center(child: CircularProgressIndicator()); // Shows a loading indicator when data is being fetched
      }

      if (controller.products.isEmpty) {
        // Displays a message when no products are available
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 10),
              Text('No products available'), // Placeholder text for no products
            ],
          ),
        );
      }

      return Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0), // Adds padding around the grid
        child: GridView.builder(
          shrinkWrap: true, // Ensures the GridView doesn't take up more space than necessary
          physics: NeverScrollableScrollPhysics(), // Prevents the grid from being scrollable
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Two items per row
            childAspectRatio: 0.7, // Aspect ratio of each grid item
            mainAxisSpacing: 15, // Vertical spacing between grid items
            crossAxisSpacing: 15, // Horizontal spacing between grid items
          ),
          itemCount: controller.products.length, // Number of items in the grid
          itemBuilder: (context, index) {
            var product = controller.products[index]; // Fetches each product

            return GestureDetector(
              onTap: () {
                ProductDetail.showProductDetailDialog(context, product); // Shows product detail dialog on tap
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), // Rounds the corners of the container
                  // Optionally, add shadow effects to the container
                  // boxShadow: [
                  //   BoxShadow(
                  //     color: Colors.white.withOpacity(0.5),
                  //     spreadRadius: -4,
                  //     blurRadius: 3,
                  //     offset: Offset(0, 1),
                  //   ),
                  // ],
                ),
                child: Card(
                  elevation: 5, // Adds elevation to the card for a shadow effect
                  color: Color(0xFFD9E8F5), // Background color of the card
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // Rounds the corners of the card
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start, // Aligns child elements to the start of the column
                    children: [
                      Expanded(
                        flex: 2, // Flex factor to control the space taken by the image
                        child: Padding(
                          padding: const EdgeInsets.only(top: 25.0), // Adds padding to the top of the image
                          child: Center(
                            child: AspectRatio(
                              aspectRatio: 1.0, // Maintains a 1:1 aspect ratio for the image
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10), // Rounds the corners of the image
                                child: Image.network(
                                  product['imageURL'], // Loads the product image from the URL
                                  fit: BoxFit.cover, // Fills the image container
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2, // Flex factor to control the space taken by the text and quantity
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 10.0, left: 10.0, right: 10.0), // Adds padding around the text content
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start, // Aligns text to the start
                            mainAxisAlignment: MainAxisAlignment.center, // Centers the text vertically
                            children: [
                              Text(
                                '${product['name']}', // Displays the product name
                                style: TextStyle(
                                    color: Color(0xFF003354), // Text color
                                    // fontWeight: FontWeight.bold, // Optionally bolds the text
                                    fontSize: 16),
                              ),
                              // SizedBox(height: 8), // Optional spacing
                              Text(
                                '${product['pointToClaim']} ${'pts'.tr}', // Displays the points required to claim the product
                                style: TextStyle(
                                  color: Color(0xFF003354), // Text color
                                  fontSize: 16, // Font size for the points text
                                ),
                              ),
                              SizedBox(height: 8), // Adds spacing between points and quantity text
                              Align(
                                alignment: Alignment.centerRight, // Aligns the quantity text to the right
                                child: Text(
                                  '${product['quantity']} ${'lefts'.tr}', // Displays the remaining quantity of the product
                                  style: TextStyle(
                                    fontSize: 12, // Font size for the quantity text
                                    color: Color(0xFF91BED4), // Text color
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      );
    });
  }
}
