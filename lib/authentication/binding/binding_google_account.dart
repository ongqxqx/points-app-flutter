// binding_google_account.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BindAccount {
  // Function to link the current Firebase user with a Google account.
  static Future<bool> linkWithGoogleAccount() async {
    try {
      // Disconnect any previous Google sign-in.
      await GoogleSignIn().disconnect();

      // Trigger the Google sign-in process.
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        return false; // User canceled the login.
      }

      // Get the authentication details from the Google account.
      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;

      // Create an AuthCredential using the Google authentication details.
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Link the Google credentials to the current Firebase user.
      final User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.linkWithCredential(credential);

        // Reload the user to get updated information.
        await user.reload();
        final User? updatedUser = FirebaseAuth.instance.currentUser;

        // Update the user's information in Firestore.
        if (updatedUser != null) {
          await FirebaseFirestore.instance
              .collection('user_list')
              .doc(updatedUser.uid)
              .update({
            'email': updatedUser.email,
          });

          // Show a success message using FlutterToast.
          Fluttertoast.showToast(
            msg: 'linkedWithGoogleAccountSuccessfully'.tr,
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0,
          );
          return true;
        } else {
          return false; // Failed to reload the user.
        }
      } else {
        return false; // No user found.
      }
    } catch (e) {
      // Show an error message using FlutterToast in case of an exception.
      Fluttertoast.showToast(
        msg: e.toString(),
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return false;
    }
  }
}

class BindingGoogleAccount extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Builds the UI that attempts to link the Google account and provides feedback to the user.
    return FutureBuilder<bool>(
      future: BindAccount.linkWithGoogleAccount(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              // Display the title for the binding process.
              title: Text('bindingGoogleAccount'.tr),
            ),
            body: Center(
              // Show a loading indicator while the Google account is being linked.
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          // Close the current screen and return the result of the linking process.
          if (snapshot.hasData && snapshot.data == true) {
            Get.back(result: true);
          } else {
            Get.back(result: false);
          }
          return SizedBox.shrink(); // Return an empty widget after navigation.
        }
      },
    );
  }
}
