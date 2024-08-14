import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:points/onboard/onboarding_sign_in_up_screen.dart';

class ProductDetail {
  static void showProductDetailDialog(
      BuildContext context, DocumentSnapshot product) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 20.0, top: 10.0, right: 20.0, bottom: 20.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        FutureBuilder<String>(
                          future: _getUserPoint(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            }
                            if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            }
                            return Text(snapshot.data ?? 'loading'.tr,
                                style: TextStyle(fontSize: 26));
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.close, size: 30.0),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                    Center(
                      child: Container(
                        width:
                            MediaQuery.of(context).size.width * 0.5, // 控制图片的宽度
                        constraints: BoxConstraints(
                          maxHeight:
                              MediaQuery.of(context).size.height * 0.3, // 最大高度
                        ),
                        child: AspectRatio(
                          aspectRatio: 1, // 1:1的宽高比
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10), // 圆角半径
                            child: Image.network(
                              product['imageURL'],
                              fit: BoxFit.cover, // 填充方式
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            product['name'],
                            style: TextStyle(fontSize: 26),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(children: [
                      Text(
                        '${product['pointToClaim']} ${'pts'.tr}',                        style: TextStyle(
                          fontSize: 20,
                          //fontWeight: FontWeight.bold,
                        ),
                      ),
                      Spacer(),
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            _showRedemptionDialog(context, product);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFF26101), // 设置背景颜色
                            foregroundColor: Color(0xFFFFFFFF), // 设置文本颜色
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10), // 可选：设置内边距
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(10), // 可选：设置圆角
                            ),
                          ),
                          child: Text(
                            'confirmRedeem'.tr,
                            style: TextStyle(
                              fontSize: 16, // 可选：设置字体大小
                              fontWeight: FontWeight.bold, // 可选：设置字体粗细
                            ),
                          ),
                        ),
                      ),
                    ]),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  static Future<String> _getUserPoint() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || user.isAnonymous) {
      return 'anonymous'.tr;
    }
    try {
      final doc = await FirebaseFirestore.instance
          .collection('user_list')
          .doc(user.uid)
          .get();
      final userData = doc.data();
      final point = int.tryParse(userData?['point']?.toString() ?? '') ?? 0;
      return '${'yourPts'.tr}: $point';
    } catch (e) {
      print('Error fetching user point: $e');
      return 'error fetching data';
    }
  }

  static void _showRedemptionDialog(
      BuildContext context, DocumentSnapshot product) {
    final user = FirebaseAuth.instance.currentUser;

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        if (user == null || user.isAnonymous) {
          // 用户未登录或是匿名用户
          return AlertDialog(
            title: Text('signInRequired'.tr),
            content: Text('pleaseSignInToContinue'.tr),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: Text('cancel'.tr),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFF26101),
                  foregroundColor: Color(0xFFFFFFFF),
                ),
                onPressed: () {
                  Get.back(); // Close the dialog
                  Get.to(() => OnboardingSignInUpScreen());
                },
                child: Text('pleaseSignIn'.tr),
              ),
            ],
          );
        } else {
          // 用户已登录
          return FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance
                .collection('user_list')
                .doc(user.uid)
                .get(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return AlertDialog(
                  content: Center(child: CircularProgressIndicator()),
                );
              }
              if (snapshot.hasError) {
                return AlertDialog(
                  title: Text('error'.tr),
                  content: Text('failedToObtainUserPoints,PleaseTryAgainLater'.tr),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(dialogContext).pop(),
                      child: Text('confirm'.tr),
                    ),
                  ],
                );
              }
              if (snapshot.hasData && snapshot.data != null) {
                final userData = snapshot.data!.data() as Map<String, dynamic>?;
                int currentPoint = 0;
                int pointToClaim = 0;

                try {
                  currentPoint =
                      int.parse(userData?['point']?.toString() ?? '0');
                } catch (e) {
                  print('Error parsing currentPoint: $e');
                  return AlertDialog(
                    title: Text('error'.tr),
                    content: Text('failedToObtainUserPoints,PleaseTryAgainLater'.tr),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(dialogContext).pop(),
                        child: Text('confirm'),
                      ),
                    ],
                  );
                }

                try {
                  pointToClaim =
                      int.parse(product['pointToClaim']?.toString() ?? '0');
                } catch (e) {
                  print('Error parsing pointToClaim: $e');
                  return AlertDialog(
                    title: Text('error'.tr),
                    content: Text('failedToObtainProductPoints,PleaseTryAgainLater'.tr),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(dialogContext).pop(),
                        child: Text('confirm'.tr),
                      ),
                    ],
                  );
                }
                final int remainingPoint = currentPoint - pointToClaim;

                return AlertDialog(
                  title: Text('confirmRedeem'.tr),
                  content: remainingPoint >= 0
                      ? Text('${'willDeduct'.tr} $pointToClaim ${'pts'.tr}, ${'remainingPtsAfterRedeem'.tr}: $remainingPoint ${'pts'.tr}')
                      : Text('${'insufficientPtsToRedeemThisItem'.tr}'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(dialogContext).pop(),
                      child: Text('cancel'.tr),
                    ),
                    if (remainingPoint >= 0)
                      ElevatedButton(
                        onPressed: () {
                          _performRedemption(dialogContext, user.uid,
                              pointToClaim, remainingPoint);
                        },
                        child: Text('confirm'.tr),
                      ),
                  ],
                );
              }
              // 返回默认的对话框
              return AlertDialog(
                title: Text('error'.tr),
                content: Text('unableToRetrieveUserData'.tr),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(dialogContext).pop(),
                    child: Text('confirm'.tr),
                  ),
                ],
              );
            },
          );
        }
      },
    );
  }

  static void _performRedemption(BuildContext context, String userId,
      int productPoint, int remainingPoint) {
    if (remainingPoint < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Redemption failed: Insufficient Pts'.tr)),
      );
      return;
    }

    FirebaseFirestore.instance.collection('user_list').doc(userId).update({
      'point': remainingPoint, // 直接使用 int 类型
    }).then((_) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${'redeemSuccessful'.tr} ${'deducted'.tr} $productPoint ${'pts'.tr}, ${'remaining'.tr} $remainingPoint ${'pts'.tr}.')),
      );
    }).catchError((error) {
      print('Error updating user point: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('redemptionFailed,PleaseTryAgainLater'.tr)),
      );
    });
  }
}
