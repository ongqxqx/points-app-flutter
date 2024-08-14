import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class ProductSearchScreen extends SearchDelegate {
  List<DocumentSnapshot> products = [];
  bool hasMore = true;
  bool isLoading = false;
  int documentLimit = 10;
  DocumentSnapshot? lastDocument;

  Future<void> fetchProducts() async {
    if (isLoading) return;
    isLoading = true;

    Query query = FirebaseFirestore.instance
        .collection('product_list')
        .orderBy('name')
        .limit(documentLimit);

    if (lastDocument != null) {
      query = query.startAfterDocument(lastDocument!);
    }

    QuerySnapshot querySnapshot = await query.get();
    if (querySnapshot.docs.isEmpty) {
      hasMore = false;
    } else {
      lastDocument = querySnapshot.docs.last;
      products.addAll(querySnapshot.docs);
    }

    isLoading = false;
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.isEmpty) {
      return Center(child: Text('Enter a search term'));
    }

    return FutureBuilder(
      future: fetchProducts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting && products.isEmpty) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        var filteredProducts = products.where((product) {
          var name = product['name'].toString().toLowerCase();
          return name.contains(query.toLowerCase());
        }).toList();

        if (filteredProducts.isEmpty) {
          return Center(child: Text('noProductsFound'.tr));
        }

        return NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollInfo) {
            if (!isLoading && hasMore && scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
              fetchProducts();
            }
            return false;
          },
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.6,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
            ),
            itemCount: filteredProducts.length,
            itemBuilder: (context, index) {
              var product = filteredProducts[index];
              return Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
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
                            aspectRatio: 1.0,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                product['imageURL'],
                                fit: BoxFit.cover,
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
                              '${product['name']}',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                            SizedBox(height: 4),
                            Text(
                              '${product['pointToClaim']} ${'pts'.tr}',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                            SizedBox(height: 4),
                            Text(
                              '${product['quantity']} ${'letfs'.tr}',
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
    return buildResults(context);
  }
}
