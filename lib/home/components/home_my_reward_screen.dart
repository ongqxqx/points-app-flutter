import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeMyRewardScreen extends StatelessWidget {
  const HomeMyRewardScreen({Key? key}) : super(key: key);

  Future<Map<String, int>> _fetchUserRewards() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return {};

    try {
      final userRewardsDoc = await FirebaseFirestore.instance
          .collection('user_reward')
          .doc(user.uid)
          .get();

      if (userRewardsDoc.exists) {
        final data = userRewardsDoc.data() as Map<String, dynamic>;
        return data.map((key, value) => MapEntry(key, value as int));
      }
    } catch (e) {
      print('Error fetching user rewards: $e');
    }
    return {};
  }

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
          };
        }
      }
    } catch (e) {
      print('Error fetching product details: $e');
    }

    return productDetails;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('myRewards'.tr),
      ),
      body: FutureBuilder<Map<String, int>>(
        future: _fetchUserRewards(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final userRewards = snapshot.data ?? {};

          if (userRewards.isEmpty) {
            return Center(child: Text('noRewardFound'.tr));
          }

          return FutureBuilder<Map<String, Map<String, String>>>(
            future: _fetchProductDetails(userRewards.keys.toList()),
            builder: (context, productSnapshot) {
              if (productSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (productSnapshot.hasError) {
                return Center(child: Text('Error: ${productSnapshot.error}'));
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
                    padding: const EdgeInsets.only(left: 10.0,top: 2.0,right: 10.0,bottom: 2.0), // 每个列表项之间的垂直间距
                    child: Material(
                      elevation: 5, // 设置elevation值来控制阴影高度
                      borderRadius: BorderRadius.circular(10), // 可选：设置边缘框圆角
                      child: Container(
                        padding: EdgeInsets.only(
                            left: 20.0, top: 10.0, right: 20.0, bottom: 10.0),
                        height: 100,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            productImageURL != null
                                ? Image.network(productImageURL,
                                    width: 60, height: 60, fit: BoxFit.cover)
                                : Container(
                                    width: 60,
                                    height: 60,
                                    color: Colors.grey,
                                    child: Icon(Icons.image, size: 50),
                                  ),
                            SizedBox(width: 16), // 图像和文本之间的间距
                            Expanded(
                              child: Text(
                                productName,
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Text(
                                '${('qty'.tr)}:$quantity',
                                style: TextStyle(fontSize: 16),
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
