import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:points/onboard/onboarding_sign_in_up_screen.dart';

import '../../navigation/bottom_navigation_screen.dart';

class FirstTimeUserDialog {
  static void show(BuildContext context, {required Function(bool) onComplete}) {
    showDialog(
      context: context,
      barrierDismissible: true, // Allow dialog to be dismissed by tapping outside
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async {
            // Handle back button press and dismiss dialog
            onComplete(false);
            return true;
          },
          child: AlertDialog(
            title: Text('wouldYouLikeToCreateAnAccount'.tr),
            content: Text(
              'byCreatingAnAccount'
                  .tr,
            ),
            actions: [
              Row(children: [
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Get.to(() => OnboardingSignInUpScreen()); // Navigate to sign up screen
                      //onComplete(true); // Uncomment if needed
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white, // Button text color
                      backgroundColor: Color(0xFFF26101), // Button background color
                    ),
                    child: Text(
                      'createAnAccount'.tr,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ]),
              Row(children: [
                Expanded(
                  child: TextButton(
                    onPressed: () async {
                      Navigator.pop(context);
                      try {
                        await FirebaseAuth.instance.signInAnonymously(); // Sign in anonymously
                        onComplete(false); // Notify that anonymous login was chosen
                        Fluttertoast.showToast(
                          msg: 'anAnonymousAccountHasBeenCreated'.tr,
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.CENTER,
                          backgroundColor: Colors.green,
                          textColor: Colors.white,
                          fontSize: 16.0,
                        );
                        Get.off(() => MainPage()); // Navigate to MainPage
                      } catch (e) {
                        print('Failed to sign in anonymously: $e');
                        // Add error handling logic here if needed
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Color(0xFFF26101), // Button text color
                      side: BorderSide(
                        color: Color(0xFFF26101), // Border color
                        width: 2, // Border width
                      ),
                    ),
                    child: Text('UseAnAnonymousAccount'.tr),
                  ),
                ),
              ]),
              SizedBox(height: 20),
              Align(
                alignment: Alignment.bottomLeft, // Align button to bottom left
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    onComplete(false); // Notify that user chose to go back
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Color(0xFFF26101),
                  ),
                  child: Text('back'.tr),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
