import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:points/onboard/onboarding_sign_in_up_screen.dart';

class ProductDetail {
  // Method to show the product detail dialog
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
                    // Row with points display and close button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        FutureBuilder<String>(
                          future: _getUserPoint(), // Fetches user's points
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator(); // Shows loading indicator
                            }
                            if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            }
                            return Text(snapshot.data ?? 'loading'.tr,
                                style: TextStyle(fontSize: 26)); // Displays points or loading text
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.close, size: 30.0),
                          onPressed: () => Navigator.of(context).pop(), // Closes the dialog
                        ),
                      ],
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                    // Displays the product image
                    Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.5, // Controls image width
                        constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height * 0.3, // Sets max height
                        ),
                        child: AspectRatio(
                          aspectRatio: 1, // Maintains 1:1 aspect ratio
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10), // Adds rounded corners
                            child: Image.network(
                              product['imageURL'],
                              fit: BoxFit.cover, // Fills the container
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                    // Displays the product name
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
                    // Displays points and redeem button
                    Row(children: [
                      Text(
                        '${product['pointToClaim']} ${'pts'.tr}',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      Spacer(),
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Closes the product detail dialog
                            _showRedemptionDialog(context, product); // Opens the redemption dialog
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFF26101), // Button background color
                            foregroundColor: Color(0xFFFFFFFF), // Button text color
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10), // Button padding
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10), // Button border radius
                            ),
                          ),
                          child: Text(
                            'confirmRedeem'.tr,
                            style: TextStyle(
                              fontSize: 16, // Button text size
                              fontWeight: FontWeight.bold, // Button text weight
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

  // Method to get user points from Firestore
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

  // Method to show the redemption dialog
  static void _showRedemptionDialog(
      BuildContext context, DocumentSnapshot product) {
    final user = FirebaseAuth.instance.currentUser;

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        if (user == null || user.isAnonymous) {
          // If user is not logged in or is anonymous
          return AlertDialog(
            title: Text('signInRequired'.tr),
            content: Text('pleaseSignInToContinue'.tr),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(), // Closes the dialog
                child: Text('cancel'.tr),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFF26101),
                  foregroundColor: Color(0xFFFFFFFF),
                ),
                onPressed: () {
                  Get.back(); // Close the dialog
                  Get.to(() => OnboardingSignInUpScreen()); // Navigate to sign in/up screen
                },
                child: Text('pleaseSignIn'.tr),
              ),
            ],
          );
        } else {
          // If user is logged in
          return FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance
                .collection('user_list')
                .doc(user.uid)
                .get(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return AlertDialog(
                  content: Center(child: CircularProgressIndicator()), // Shows loading indicator
                );
              }
              if (snapshot.hasError) {
                return AlertDialog(
                  title: Text('error'.tr),
                  content: Text('failedToObtainUserPoints,PleaseTryAgainLater'.tr), // Error message
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(dialogContext).pop(), // Closes the dialog
                      child: Text('confirm'.tr),
                    ),
                  ],
                );
              }
              if (snapshot.hasData && snapshot.data != null) {
                final userData = snapshot.data!.data() as Map<String, dynamic>?;
                int currentPoint = 0;
                int pointToClaim = 0;

                // Parse user's current points
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

                // Parse product's points required for redemption
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
                      : Text('${'insufficientPtsToRedeemThisItem'.tr}'), // Insufficient points message
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(dialogContext).pop(), // Closes the dialog
                      child: Text('cancel'.tr),
                    ),
                    if (remainingPoint >= 0)
                      ElevatedButton(
                        onPressed: () {
                          _performRedemption(dialogContext, user.uid,
                              pointToClaim, remainingPoint); // Perform the redemption
                        },
                        child: Text('confirm'.tr),
                      ),
                  ],
                );
              }
              // Default dialog if data is not available
              return AlertDialog(
                title: Text('error'.tr),
                content: Text('unableToRetrieveUserData'.tr),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(dialogContext).pop(), // Closes the dialog
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

  // Method to perform the redemption and update user points in Firestore
  static void _performRedemption(BuildContext context, String userId,
      int productPoint, int remainingPoint) {
    if (remainingPoint < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Redemption failed: Insufficient Pts'.tr)),
      );
      return;
    }

    FirebaseFirestore.instance.collection('user_list').doc(userId).update({
      'point': remainingPoint, // Update user's points
    }).then((_) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${'redeemSuccessful'.tr} ${'deducted'.tr} $productPoint ${'pts'.tr}, ${'remaining'.tr} $remainingPoint ${'pts'.tr}.')), // Success message
      );
    }).catchError((error) {
      print('Error updating user point: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('redemptionFailed,PleaseTryAgainLater'.tr)), // Failure message
      );
    });
  }
}
