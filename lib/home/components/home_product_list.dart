import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../../product/components/product_detail.dart';

class HomeProductList extends StatelessWidget {
  const HomeProductList({Key? key}) : super(key: key);

  Future<List<QueryDocumentSnapshot>> _fetchProducts() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('product_list')
        .where('status', whereIn: ['hot', 'other'])
        .limit(8)
        .get();
    return querySnapshot.docs;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<QueryDocumentSnapshot>>(
      future: _fetchProducts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox(
            height: 300,
            child: Center(child: CircularProgressIndicator()), // Loading indicator while fetching data
          );
        }

        if (snapshot.hasError) {
          return SizedBox(
            height: 300,
            child: Center(child: Text('Error: ${snapshot.error}')), // Error message if fetching fails
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return SizedBox(
            height: 300,
            child: Center(child: Text('noProductsAvailable'.tr)), // Message when no products are available
          );
        }

        var products = snapshot.data!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            GridView.count(
              crossAxisCount: 2, // Number of columns in grid
              childAspectRatio: 0.7, // Aspect ratio for each grid item
              physics: NeverScrollableScrollPhysics(), // Disable scrolling within the GridView
              shrinkWrap: true, // Adjust height of GridView based on its content
              mainAxisSpacing: 10, // Spacing between rows
              crossAxisSpacing: 8, // Spacing between columns
              children: List.generate(products.length, (index) {
                var product = products[index];
                return GestureDetector(
                  onTap: () => ProductDetail.showProductDetailDialog(
                      context, product), // Navigate to product detail dialog
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10), // Rounded corners for container
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withOpacity(0.5), // Shadow color
                          spreadRadius: -4, // Spread radius of shadow
                          blurRadius: 3, // Blur radius of shadow
                          offset: Offset(0, 1), // Offset of shadow
                        ),
                      ],
                    ),
                    child: Card(
                      color: Color(0xFFD9E8F5), // Card background color
                      elevation: 5, // Elevation of card
                      shadowColor: Colors.white, // Shadow color of card
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10), // Rounded corners for card
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 2,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 16.0),
                              child: Center(
                                child: AspectRatio(
                                  aspectRatio: 1, // Aspect ratio for image
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10), // Rounded corners for image
                                    child: Image.network(
                                      product['imageURL'], // Product image
                                      fit: BoxFit.cover, // Fit mode for image
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 10.0, left: 10.0, right: 10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '${product['name']}', // Product name
                                    style: TextStyle(
                                        color: Color(0xFF003354),
                                        fontSize: 16),
                                  ),
                                  Text(
                                    '${product['pointToClaim']} ${('pts'.tr)}', // Points required to claim
                                    style: TextStyle(
                                      color: Color(0xFF003354),
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(height: 8), // Space between text widgets
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      '${product['quantity']} ${('lefts'.tr)}', // Quantity left
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF91BED4),
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
              }),
            ),
          ],
        );
      },
    );
  }
}
