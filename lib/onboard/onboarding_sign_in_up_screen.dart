import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
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
    initializeFirebase();
  }

  Future<void> initializeFirebase() async {
    await Firebase.initializeApp();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('signIn/signUp'.tr),
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
                      SignInUpWithPhoneNumber(),
                      SizedBox(height: 20),
                      Spacer(),
                      ElevatedButton(
                        onPressed: () async {
                          bool signInSuccess = await SignInUpWithGoogle(context);
                          if (signInSuccess) {
                            Fluttertoast.showToast(
                              msg: 'signInSuccessful'.tr,
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.TOP,
                              backgroundColor: Colors.green,
                              textColor: Colors.white,
                              fontSize: 16.0,
                            );
                            Get.offAll(() => MainPage());
                          }
                          // 如果 signInSuccess 为 false，不执行任何操作，即停留在当前页面
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white, // 设置按钮文本颜色
                          backgroundColor: Color(0xFFF26101), // 设置按钮背景颜色
                        ),
                        child: Text('Sign in with Google Account'),
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
