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
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return SizedBox(
            height: 300,
            child: Center(child: Text('Error: ${snapshot.error}')),
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return SizedBox(
            height: 300,
            child: Center(child: Text('noProductsAvailable'.tr)),
          );
        }

        var products = snapshot.data!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            GridView.count(
              crossAxisCount: 2,
              childAspectRatio: 0.7,
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              children: List.generate(products.length, (index) {
                var product = products[index];
                return GestureDetector(
                  onTap: () => ProductDetail.showProductDetailDialog(
                      context, product),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withOpacity(0.5),
                          spreadRadius: -4,
                          blurRadius: 3,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Card(
                      color: Color(0xFFD9E8F5),
                      elevation: 5,
                      shadowColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
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
                                  aspectRatio: 1,
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
                              padding: const EdgeInsets.only(
                                  top: 10.0, left: 10.0, right: 10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '${product['name']}',
                                    style: TextStyle(
                                        color: Color(0xFF003354),
                                        fontSize: 16),
                                  ),
                                  Text(
                                    '${product['pointToClaim']} ${('pts'.tr)}',
                                    style: TextStyle(
                                      color: Color(0xFF003354),
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      '${product['quantity']} ${('lefts'.tr)}',
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
