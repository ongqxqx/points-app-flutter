import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shimmer/shimmer.dart';
import 'package:google_fonts/google_fonts.dart';

import 'product_detail.dart';

class ProductHot extends StatelessWidget {
  const ProductHot({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('product_list')
          .where('status', isEqualTo: 'hot')
          .limit(4)
          .snapshots(),
      builder: (context, snapshot) {
        return FutureBuilder(
          future: Future.delayed(Duration(milliseconds: 500)),
          builder: (context, delaySnapshot) {
            if (snapshot.connectionState == ConnectionState.waiting ||
                delaySnapshot.connectionState != ConnectionState.done) {
              // Shimmer loading effect
              return SizedBox(
                child: Center(
                  child: Shimmer.fromColors(
                    baseColor: Color(0xFFF4DAE2),//Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: GridView.count(
                      crossAxisCount: 2,
                      childAspectRatio: 0.6,
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      padding: EdgeInsets.only(left: 10.0, right: 10.0),
                      children: List.generate(4, (index) {
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
                                      child: Container(
                                        color: Colors.grey,
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
                                      Container(
                                        height: 10,
                                        color: Colors.grey,
                                      ),
                                      SizedBox(height: 4),
                                      Container(
                                        height: 10,
                                        color: Colors.grey,
                                      ),
                                      SizedBox(height: 4),
                                      Container(
                                        height: 10,
                                        color: Colors.grey,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              );
            }

            if (snapshot.hasError) {
              return SizedBox(
                height: 300,
                child: Center(child: Text('Error: ${snapshot.error}')),
              );
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return SizedBox(
                height: 300,
                child: Center(child: Text('No hot products available')),
              );
            }

            var products = snapshot.data!.docs;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GridView.count(
                  crossAxisCount: 2,
                  childAspectRatio: 0.6, // 调整这个值以更好地匹配卡片的实际比例
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  padding: EdgeInsets.only(left: 10.0, right: 10.0),
                  children: List.generate(products.length, (index) {
                    var product = products[index];
                    return GestureDetector(
                      onTap: () => ProductDetail.showProductDetailDialog(context, product),
                      child: Card(
                        elevation: 10,
                        color: Color(0xFFF4DAE2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 3,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10.0,top: 20.0,right: 10.0),
                                child: Center(
                                  child: AspectRatio(
                                    aspectRatio: 1.0, // 使用更常见的宽高比
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
                                padding: const EdgeInsets.only(left: 20.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '${product['name']}',
                                      style: GoogleFonts.ubuntu(fontSize: 18),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      '${product['pointToClaim']} Points',
                                      style: GoogleFonts.ebGaramond(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      '${product['quantity']} lefts',
                                      style: GoogleFonts.workSans(fontSize: 10),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
