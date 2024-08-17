import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductOtherAll extends StatefulWidget {
  const ProductOtherAll({Key? key}) : super(key: key);

  @override
  _ProductOtherAllState createState() => _ProductOtherAllState();
}

class _ProductOtherAllState extends State<ProductOtherAll> {
  List<DocumentSnapshot> products = [];
  bool hasMore = true;
  bool isLoading = false;
  int documentLimit = 10;
  DocumentSnapshot? lastDocument;

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    if (isLoading) return;
    setState(() {
      isLoading = true;
    });

    Query query = FirebaseFirestore.instance
        .collection('product_list')
        .where('status', isEqualTo: 'other')
        .orderBy('name')
        .limit(documentLimit);

    if (lastDocument != null) {
      query = query.startAfterDocument(lastDocument!);
    }

    QuerySnapshot querySnapshot = await query.get();
    if (querySnapshot.docs.length < documentLimit) {
      setState(() {
        hasMore = false;
      });
    }

    if (querySnapshot.docs.isNotEmpty) {
      setState(() {
        lastDocument = querySnapshot.docs.last;
        products.addAll(querySnapshot.docs);
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('otherProduct'.tr),
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (!isLoading &&
              hasMore &&
              scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
            fetchProducts();
          }
          return false;
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(left: 20.0, right: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.6,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                  ),
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: products.length + 1,
                  itemBuilder: (context, index) {
                    if (index == products.length) {
                      if (hasMore) {
                        return Center(child: CircularProgressIndicator());
                      } else {
                        return null;
                      }
                    }
                    var product = products[index];
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
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    '${product['pointToClaim']} point(s)',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    '${product['quantity']} left(s)',
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
                if (isLoading) Center(child: CircularProgressIndicator()),
                if (!hasMore && !isLoading)
                  SizedBox(height: 10.0),
                Center(child: Text('No more products available')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
