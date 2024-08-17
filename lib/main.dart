import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:points/product/components/product_controller.dart';
import 'package:points/profile/components/account_setting_screen/account_setting_screen.dart';
import 'navigation/bottom_navigation_screen.dart';
import 'onboard/onboarding_screen.dart';
import 'onboard/onboarding_sign_in_up_screen.dart';
import 'translation_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // Check if there's a current user and if they are anonymous
  final User? currentUser = FirebaseAuth.instance.currentUser;
  if (currentUser != null && currentUser.isAnonymous) {
    try {
      // Delete the anonymous user
      await currentUser.delete();
      print('Anonymous user deleted');
    } catch (e) {
      // Handle any errors that occur during user deletion
      print('Error deleting anonymous user: $e');
    }
  }
  //Get.put(ProductController());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Your App Title',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      translations: TranslationService(),
      locale: TranslationService.locale,
      fallbackLocale: TranslationService.fallbackLocale,
      home: InitialRouter(),
    );
  }
}

class InitialRouter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: _determineInitialRoute(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        } else if (snapshot.hasError) {
          return Scaffold(
              body: Center(child: Text('Error: ${snapshot.error}')));
        } else {
          return snapshot.data!;
        }
      },
    );
  }

  Future<Widget> _determineInitialRoute() async {
    await Future.delayed(Duration(seconds: 2));

    final User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null || currentUser.isAnonymous) {
      return OnboardingScreen(onCompleted: _handleOnboardingCompleted);
    }

    bool isOnboardingCompleted = await _checkIfOnboardingCompleted();
    if (!isOnboardingCompleted) {
      return OnboardingScreen(onCompleted: _handleOnboardingCompleted);
    } else {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final userDoc = await FirebaseFirestore.instance
            .collection('user_list')
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          final data = userDoc.data();
          if (data != null) {
            final name = data['name'];
            final phoneNumber = data['phoneNumber'];
            final email = data['email'];

            if (name == null || phoneNumber == null || email == null) {
              return AccountSettingScreen();
            }
          }
        }
        Get.put(ProductController());
        return MainPage();
      }
    }
    Get.put(ProductController());
    return MainPage();
  }

  void _handleOnboardingCompleted(bool createAccount) {
    if (createAccount) {
      Get.to(() => OnboardingSignInUpScreen());
    } else {
      Get.off(() => OnboardingScreen(onCompleted: (bool) => false));
    }
  }

  Future<bool> _checkIfOnboardingCompleted() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      //
      return true;
    }
    return false;
  }
}
