import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:points/translation_service.dart';
import '../authentication/sign_in_up/sign_in_up_with_google.dart';
import '../authentication/sign_in_up/sign_in_up_with_phone_number.dart';
import '../navigation/bottom_navigation_screen.dart';

class OnboardingSignInUpScreen extends StatefulWidget {
  const OnboardingSignInUpScreen({Key? key}) : super(key: key);

  @override
  _OnboardingSignInUpScreenState createState() =>
      _OnboardingSignInUpScreenState();
}

class _OnboardingSignInUpScreenState extends State<OnboardingSignInUpScreen> {
  @override
  void initState() {
    super.initState();
    initializeFirebase(); // Initialize Firebase when the screen is loaded
  }

  Future<void> initializeFirebase() async {
    await Firebase.initializeApp(); // Initialize Firebase app
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('signIn/signUp'.tr), // AppBar title with translation
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: constraints.copyWith(
                minHeight: constraints.maxHeight,
                maxHeight: double.infinity,
              ),
              child: IntrinsicHeight(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SignInUpWithPhoneNumber(), // Phone number sign-in widget
                      SizedBox(height: 20),
                      Spacer(), // Add space between elements
                      ElevatedButton(
                        onPressed: () async {
                          bool signInSuccess =
                          await SignInUpWithGoogle(context); // Google sign-in
                          if (signInSuccess) {
                            Fluttertoast.showToast(
                              msg: 'signInSuccessful'.tr,
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.TOP,
                              backgroundColor: Colors.green,
                              textColor: Colors.white,
                              fontSize: 16.0,
                            );
                            Get.offAll(() => MainPage()); // Navigate to the main page after successful sign-in
                          }
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Color(0xFFF26101), // Set button background color
                        ),
                        child: Text('signInWithGoogleAccount'.tr),
                      ),
                      Center(
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: Get.locale?.languageCode ?? 'en', // Get the current language code
                            icon: SizedBox.shrink(), // Hide the default dropdown icon
                            style: TextStyle(
                                color: Color(0xFFF26101), fontSize: 16),
                            items: TranslationService.langs.map((String lang) {
                              return DropdownMenuItem<String>(
                                value: TranslationService
                                    .locales[
                                TranslationService.langs.indexOf(lang)]
                                    .languageCode,
                                child: Row(
                                  children: [
                                    Icon(Icons.language,
                                        color: Color(0xFFF26101)), // Optional: add an icon
                                    SizedBox(width: 8), // Add an 8-pixel gap between text and icon
                                    Text('$lang'),
                                  ],
                                ),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                TranslationService().changeLocale(
                                  TranslationService.langs[TranslationService
                                      .locales
                                      .indexWhere((locale) =>
                                  locale.languageCode == newValue)],
                                ); // Change app language based on selection
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
