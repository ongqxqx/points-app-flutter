import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeMyRewardScreen extends StatelessWidget {
  const HomeMyRewardScreen({Key? key}) : super(key: key);

  // Fetch the rewards for the current user
  Future<Map<String, int>> _fetchUserRewards() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return {}; // Return empty map if no user is logged in

    try {
      final userRewardsDoc = await FirebaseFirestore.instance
          .collection('user_reward')
          .doc(user.uid)
          .get();

      if (userRewardsDoc.exists) {
        final data = userRewardsDoc.data() as Map<String, dynamic>;
        return data.map((key, value) => MapEntry(key, value as int)); // Map document data to reward map
      }
    } catch (e) {
      print('Error fetching user rewards: $e'); // Log errors
    }
    return {}; // Return empty map if no data or error occurred
  }

  // Fetch details of products given a list of product IDs
  Future<Map<String, Map<String, String>>> _fetchProductDetails(
      List<String> productIds) async {
    final productDetails = <String, Map<String, String>>{};

    try {
      for (final productId in productIds) {
        final productDoc = await FirebaseFirestore.instance
            .collection('product_list')
            .doc(productId)
            .get();

        if (productDoc.exists) {
          final data = productDoc.data() as Map<String, dynamic>;
          productDetails[productId] = {
            'name': data['name'] as String,
            'imageURL': data['imageURL'] as String,
          }; // Map product data to productDetails
        }
      }
    } catch (e) {
      print('Error fetching product details: $e'); // Log errors
    }

    return productDetails; // Return the product details map
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('myRewards'.tr), // Display the translated 'myRewards' text
      ),
      body: FutureBuilder<Map<String, int>>(
        future: _fetchUserRewards(), // Fetch user rewards
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator()); // Show loading indicator while fetching data
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}')); // Show error message if any
          }

          final userRewards = snapshot.data ?? {};

          if (userRewards.isEmpty) {
            return Center(child: Text('noRewardFound'.tr)); // Show message if no rewards are found
          }

          return FutureBuilder<Map<String, Map<String, String>>>(
            future: _fetchProductDetails(userRewards.keys.toList()), // Fetch product details for rewards
            builder: (context, productSnapshot) {
              if (productSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator()); // Show loading indicator while fetching data
              }

              if (productSnapshot.hasError) {
                return Center(child: Text('Error: ${productSnapshot.error}')); // Show error message if any
              }

              final productDetails = productSnapshot.data ?? {};

              return ListView.builder(
                itemCount: userRewards.length,
                itemBuilder: (context, index) {
                  final productId = userRewards.keys.elementAt(index);
                  final quantity = userRewards[productId];
                  final productInfo = productDetails[productId] ?? {};
                  final productName = productInfo['name'] ?? 'Unknown';
                  final productImageURL = productInfo['imageURL'];

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 10.0), // Padding for list items
                    child: Material(
                      elevation: 5, // Shadow for elevation effect
                      borderRadius: BorderRadius.circular(10), // Rounded corners
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0), // Padding inside container
                        height: 100,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            productImageURL != null
                                ? Image.network(productImageURL,
                                width: 60, height: 60, fit: BoxFit.cover) // Product image
                                : Container(
                              width: 60,
                              height: 60,
                              color: Colors.grey,
                              child: Icon(Icons.image, size: 50), // Placeholder image
                            ),
                            SizedBox(width: 16), // Space between image and text
                            Expanded(
                              child: Text(
                                productName,
                                style: TextStyle(fontSize: 18), // Product name
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Text(
                                '${('qty'.tr)}: $quantity',
                                style: TextStyle(fontSize: 16), // Quantity text
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
