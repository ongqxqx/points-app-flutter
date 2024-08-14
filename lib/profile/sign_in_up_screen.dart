import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:points/navigation/bottom_navigation_screen.dart';
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
    initializeFirebase();
  }

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
                    SignInUpWithPhoneNumber(),
                    SizedBox(height: 20),
                    Spacer(),
                    ElevatedButton(
                      onPressed: () async {
                        await SignInUpWithGoogle(context);
                      },
                      child: Text('signInWithGoogleAccount'.tr),
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
