import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductHotAll extends StatefulWidget {
  const ProductHotAll({Key? key}) : super(key: key);

  @override
  _ProductHotAllState createState() => _ProductHotAllState();
}

class _ProductHotAllState extends State<ProductHotAll> {
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
        .where('status', isEqualTo: 'hot')
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
        title: Text('hotProduct'.tr),
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
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                  ),
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: products.length + 1,
                  itemBuilder: (context, index) {
                    if (index == products.length) {
                      if (hasMore) {
                        return Center(child: CircularProgressIndicator());
                      } else {
                         return null;//Center(child: Text(''));
                      }
                    }
                    var product = products[index];
                    return Card(
                      color: Color(0xFFE6D2BD),
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 3,
                            child: Padding(
                              padding: const EdgeInsets.only(left:10.0,top:20.0,right:10.0),
                              child: Center(
                                child: AspectRatio(
                                  aspectRatio: 1.0,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
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
                            flex: 3,
                            child: Padding(
                              padding: const EdgeInsets.only(left:10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: double.infinity, // 使容器占满整个宽度
                                    child: Text(
                                      '${product['name']}',
                                      style: GoogleFonts.ubuntu(fontSize: 14),
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Container(
                                    width: double.infinity, // 使容器占满整个宽度
                                    child: Text(
                                      '${product['pointToClaim']} Points',
                                      style: GoogleFonts.ebGaramond(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                      //textAlign: TextAlign.right,
                                    ),
                                  ),
                                  SizedBox(height: 0),
                                  Container(
                                    width: double.infinity, // 使容器占满整个宽度
                                    child: Text(
                                      '${product['quantity']} lefts',
                                      style: GoogleFonts.workSans(fontSize: 10),
                                      //textAlign: TextAlign.right,
                                    ),
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
                  SizedBox(height: 20.0),
                  Center(child: Text('No more products available')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
