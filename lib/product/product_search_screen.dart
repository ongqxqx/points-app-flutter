import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class ProductSearchScreen extends SearchDelegate {
  List<DocumentSnapshot> products = []; // List to store the fetched products
  bool hasMore = true; // Flag to check if there are more products to load
  bool isLoading = false; // Flag to prevent concurrent fetches
  int documentLimit = 10; // Limit of documents to fetch per request
  DocumentSnapshot? lastDocument; // Keeps track of the last fetched document for pagination

  Future<void> fetchProducts() async {
    if (isLoading) return; // Prevent concurrent fetches
    isLoading = true;

    Query query = FirebaseFirestore.instance
        .collection('product_list')
        .orderBy('name') // Order products by name
        .limit(documentLimit); // Limit the number of documents fetched

    if (lastDocument != null) {
      query = query.startAfterDocument(lastDocument!); // Start after the last fetched document for pagination
    }

    QuerySnapshot querySnapshot = await query.get();
    if (querySnapshot.docs.isEmpty) {
      hasMore = false; // No more products to load
    } else {
      lastDocument = querySnapshot.docs.last; // Update lastDocument to the latest fetched document
      products.addAll(querySnapshot.docs); // Add fetched documents to the products list
    }

    isLoading = false;
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear), // Clear icon to reset the search query
        onPressed: () {
          query = ''; // Clear the search query
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back), // Back icon to close the search screen
      onPressed: () {
        close(context, null); // Close the search screen
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.isEmpty) {
      return Center(child: Text('Enter a search term')); // Prompt user to enter a search term
    }

    return FutureBuilder(
      future: fetchProducts(), // Fetch products based on the query
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting && products.isEmpty) {
          return Center(child: CircularProgressIndicator()); // Show loading indicator while fetching
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}')); // Show error message if there's an error
        }

        var filteredProducts = products.where((product) {
          var name = product['name'].toString().toLowerCase();
          return name.contains(query.toLowerCase()); // Filter products based on the query
        }).toList();

        if (filteredProducts.isEmpty) {
          return Center(child: Text('noProductsFound'.tr)); // Show message if no products found
        }

        return NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollInfo) {
            if (!isLoading && hasMore && scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
              fetchProducts(); // Load more products when reaching the end of the list
            }
            return false;
          },
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Number of columns in the grid
              childAspectRatio: 0.6, // Aspect ratio of each grid item
              mainAxisSpacing: 10, // Spacing between rows
              crossAxisSpacing: 10, // Spacing between columns
            ),
            itemCount: filteredProducts.length, // Number of items in the grid
            itemBuilder: (context, index) {
              var product = filteredProducts[index];
              return Card(
                elevation: 3, // Shadow elevation for the card
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // Rounded corners for the card
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Center(
                          child: AspectRatio(
                            aspectRatio: 1.0, // Aspect ratio for the product image
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10), // Rounded corners for the image
                              child: Image.network(
                                product['imageURL'], // Product image URL
                                fit: BoxFit.cover, // Fit the image inside the container
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${product['name']}', // Product name
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                            SizedBox(height: 4),
                            Text(
                              '${product['pointToClaim']} ${'pts'.tr}', // Points required to claim the product
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                            SizedBox(height: 4),
                            Text(
                              '${product['quantity']} ${'letfs'.tr}', // Quantity left
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return buildResults(context); // Use the same widget to display search suggestions
  }
}
