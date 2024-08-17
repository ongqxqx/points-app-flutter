import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../navigation/bottom_navigation_screen.dart';
import '../../profile/components/account_setting_screen/account_setting_screen.dart';

// Handles Google Sign-In and linking to Firebase accounts.
Future<bool> SignInUpWithGoogle(BuildContext context) async {
  try {
    // Check if the user is already signed in and disconnect if so.
    if (await GoogleSignIn().isSignedIn()) {
      await GoogleSignIn().disconnect();
    }
  } catch (e) {
    // Handle error during disconnection (e.g., logging).
  }

  // Trigger Google Sign-In flow.
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
  if (googleUser == null) {
    return false; // User canceled the sign-in process.
  }

  final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
  final AuthCredential credential = GoogleAuthProvider.credential(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  );

  User? currentUser = FirebaseAuth.instance.currentUser;

  try {
    if (currentUser != null && currentUser.isAnonymous) {
      // Link Google account to the existing anonymous user.
      final UserCredential userCredential =
          await currentUser.linkWithCredential(credential);
      await handleUserSignIn(context, userCredential.user);
      await saveUserToFirestore(userCredential.user);
      Fluttertoast.showToast(
        msg: 'anonymousAccountLinkedWithGoogleAccount'.tr,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return true;
    } else {
      // Sign in with Google account.
      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      await handleUserSignIn(context, userCredential.user);
      await saveUserToFirestore(userCredential.user);
      Fluttertoast.showToast(
        msg: 'Sign in successful',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return true;
    }
  } catch (e) {
    if (e is FirebaseAuthException && e.code == 'credential-already-in-use') {
      // Handle case where Google account is already in use.
      bool? result = await showConflictDialog(context, credential);
      return result ?? false;
    } else {
      // Handle other errors.
      Fluttertoast.showToast(
        msg: 'Error: ${e.toString()}',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return false;
    }
  }
}

// Shows a dialog to resolve Google account conflict (e.g., existing anonymous account).
Future<bool?> showConflictDialog(
    BuildContext context, AuthCredential credential) async {
  return showDialog<bool?>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('accountConflict'.tr),
        content: Text('googleAccountAlreadyInUse'.tr),
        actions: <Widget>[
          TextButton(
            onPressed: () async {
              // Delete anonymous account and proceed with Google sign-in.
              await FirebaseAuth.instance.currentUser?.delete();
              final UserCredential userCredential =
                  await FirebaseAuth.instance.signInWithCredential(credential);
              await handleUserSignIn(context, userCredential.user);
              await saveUserToFirestore(userCredential.user);
              Fluttertoast.showToast(
                msg: 'signInSuccessful'.tr,
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.TOP,
                backgroundColor: Colors.green,
                textColor: Colors.white,
                fontSize: 16.0,
              );
              Navigator.of(context)
                  .pop(true); // Return true to indicate account deletion.
            },
            child: Text('deleteAnonymousAccount'.tr),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(
                  false); // Return false to use a different Google account.
              SignInUpWithGoogle(context);
            },
            child: Text('useAnotherGoogleAccount'.tr),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(null); // Return null to cancel.
            },
            child: Text('back'.tr),
          ),
        ],
      );
    },
  );
}

// Saves user information to Firestore.
Future<void> saveUserToFirestore(User? user) async {
  if (user != null) {
    await user.reload(); // Reload user to get updated information.
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    final userList = firestore.collection('user_list').doc(user.uid);
    final docSnapshot = await userList.get();
    if (!docSnapshot.exists) {
      // Create a new document for the user if it does not exist.
      await userList.set({
        'uid': user.uid,
        'name': user.displayName,
        'email': user.email,
        'point': 20,
        'registrationTimestamp': FieldValue.serverTimestamp(),
      });
      Get.offAll(() => AccountSettingScreen(
          isFirstTimeSignIn:
              true)); // Navigate to AccountSettingScreen for first-time sign-in.
    } else {
      Get.offAll(
          () => MainPage()); // Navigate to MainPage if user already exists.
    }
  }
}

// Handles user sign-in logic and navigation.
Future<bool> handleUserSignIn(BuildContext context, User? user) async {
  if (user != null) {
    // Handle user login success.
    Get.offAll(() => MainPage()); // Navigate to MainPage on successful sign-in.
    return true;
  }
  // Return false if user is null.
  return false;
}
