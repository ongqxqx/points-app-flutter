import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:points/navigation/bottom_navigation_screen.dart';
import 'package:points/translation_service.dart';
import '../authentication/sign_in_up/sign_in_up_with_google.dart';
import '../authentication/sign_in_up/sign_in_up_with_phone_number.dart';
import '../main.dart';
import '../profile/components/account_setting_screen/account_setting_screen.dart';

class SignInUpScreen extends StatefulWidget {
  const SignInUpScreen({Key? key}) : super(key: key);

  @override
  _SignInUpScreenState createState() => _SignInUpScreenState();
}

class _SignInUpScreenState extends State<SignInUpScreen> {
  @override
  void initState() {
    super.initState();
    // Initialize Firebase when the screen is first built
    initializeFirebase();
  }

  // Method to initialize Firebase
  Future<void> initializeFirebase() async {
    await Firebase.initializeApp();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
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
                    // Widget for signing in/up with phone number
                    SignInUpWithPhoneNumber(),
                    SizedBox(height: 20),
                    Spacer(),
                    // Button for signing in/up with Google
                    ElevatedButton(
                      onPressed: () async {
                        // Trigger Google sign-in/up process
                        await SignInUpWithGoogle(context);
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Color(0xFFF26101),
                      ),
                      child: Text('signInWithGoogleAccount'.tr),
                    ),
                    Center(
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          // Current selected language
                          value: Get.locale?.languageCode ?? 'en',
                          icon: SizedBox
                              .shrink(), // Hide default icon
                          style:
                          TextStyle(color: Color(0xFFF26101), fontSize: 16),
                          items: TranslationService.langs.map((String lang) {
                            return DropdownMenuItem<String>(
                              value: TranslationService
                                  .locales[
                              TranslationService.langs.indexOf(lang)]
                                  .languageCode,
                              child: Row(
                                children: [
                                  Icon(Icons.language,
                                      color: Color(0xFFF26101)),
                                  SizedBox(width: 8),
                                  Text('$lang'),
                                ],
                              ),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              // Change locale when a new language is selected
                              TranslationService().changeLocale(
                                TranslationService.langs[TranslationService
                                    .locales
                                    .indexWhere((locale) =>
                                locale.languageCode == newValue)],
                              );
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
    );
  }
}
