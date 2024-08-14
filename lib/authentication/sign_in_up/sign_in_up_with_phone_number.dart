import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:points/main.dart';
import 'package:points/profile/components/account_setting_screen/account_setting_screen.dart';

import '../../navigation/bottom_navigation_screen.dart';

class SignInUpWithPhoneNumber extends StatefulWidget {
  const SignInUpWithPhoneNumber({Key? key}) : super(key: key);

  @override
  SignInUpWithPhoneNumberState createState() => SignInUpWithPhoneNumberState();
}

class SignInUpWithPhoneNumberState extends State<SignInUpWithPhoneNumber> {
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _smsCodeController = TextEditingController();
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  String _selectedCountryCode = '+60'; // Default country code
  static String verifyId = "";
  bool _isButtonDisabled = false;
  int _countdown = 30;
  Timer? _timer;
  bool _showTextFieldSMS_And_ButtonSignIn = false; // 控制文本字段和按钮的显示状态

  void _startCountdown() {
    setState(() {
      _isButtonDisabled = true;
      _countdown = 30;
    });

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_countdown == 0) {
        timer.cancel();
        setState(() {
          _isButtonDisabled = false;
        });
      } else {
        setState(() {
          _countdown--;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _phoneNumberController.dispose();
    super.dispose();
  }

  static Future<void> sendVerificationCode({
    required String phone,
    required Function errorStep,
    required Function nextStep,
  }) async {
    try {
      await _firebaseAuth.verifyPhoneNumber(
        timeout: const Duration(seconds: 30),
        phoneNumber: phone,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _firebaseAuth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          errorStep(e.message);
        },
        codeSent: (String verificationId, int? resendToken) {
          verifyId = verificationId;
          nextStep();
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          verifyId = verificationId;
        },
      );
    } catch (e) {
      errorStep(e.toString());
    }
  }

  Future<String> verifySmsCode({required String otp}) async {
    try {
      final PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verifyId,
        smsCode: otp,
      );
      final UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(credential);
      final User? user = userCredential.user;
      if (user != null) {
        await saveUserToFirestore(user);
        Fluttertoast.showToast(
          msg: "Sign in success",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.teal,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        return "Success";
      } else {
        Fluttertoast.showToast(
          msg: "Error in OTP login!",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red, // 设置为红色以表示错误
          textColor: Colors.white,
          fontSize: 16.0,
        );
        return "Error in OTP login!";
      }
    } on FirebaseAuthException catch (e) {
      return e.message.toString();
    } catch (e) {
      return e.toString();
    }
  }

  Future<void> saveUserToFirestore(User? user) async {
    if (user != null) {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      final userList = firestore.collection('user_list').doc(user.uid);
      final docSnapshot = await userList.get();
      if (!docSnapshot.exists) {
        await userList.set({
          'uid': user.uid,
          'phoneNumber': user.phoneNumber,
          'point': 20,
          'registrationTimestamp': FieldValue.serverTimestamp(),
        });
        Get.offAll(() => AccountSettingScreen(
            isFirstTimeSignIn: true)); // 跳转到 AccountSettingScreen
      } else {
        Get.offAll(() => MainPage());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16.0),
          Row(
            children: [
              Container(
                width: 100,
                height: 70,
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Country Code',
                  ),
                  child: DropdownButton<String>(
                    value: _selectedCountryCode,
                    icon: SizedBox.shrink(),
                    isExpanded: true,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedCountryCode = newValue!;
                      });
                    },
                    items: <String>['+60']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Center(
                        child: Text(
                          value,
                          style:
                              TextStyle(fontSize: 22, color: Color(0xFFF26101)),
                        ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(width: 8.0),
              Flexible(
                child: TextFormField(
                  controller: _phoneNumberController,
                  decoration: InputDecoration(labelText: 'phoneNumber'.tr),
                  style:
                      const TextStyle(fontSize: 25, color: Color(0xFFF26101)),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly, // 只允许输入数字
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          Center(
            child: ElevatedButton(
              onPressed: _isButtonDisabled
                  ? null
                  : () {
                      final phone = _selectedCountryCode +
                          _phoneNumberController.text.trim();
                      sendVerificationCode(
                        phone: phone,
                        errorStep: (errorMessage) {
                          print(errorMessage);
                          Fluttertoast.showToast(
                            msg: errorMessage,
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.CENTER,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0,
                          );
                        },
                        nextStep: () {
                          print('Verification code sent');
                          setState(() {
                            _showTextFieldSMS_And_ButtonSignIn =
                                true; // 显示文本字段和按钮
                          });
                          Fluttertoast.showToast(
                            msg: 'Verification code sent',
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.CENTER,
                            backgroundColor: Colors.green,
                            textColor: Colors.white,
                            fontSize: 16.0,
                          );
                        },
                      );
                      _startCountdown();
                    },
              style: TextButton.styleFrom(
                foregroundColor: Colors.white, // 设置按钮文本颜色
                backgroundColor: Color(0xFFF26101), // 设置按钮背景颜色
              ),
              child: _isButtonDisabled
                  ? Text('$_countdown' + 's')
                  : const Text('Send Verification Code'),
            ),
          ),
          const SizedBox(height: 16.0),
          if (_showTextFieldSMS_And_ButtonSignIn) ...[
            TextFormField(
                controller: _smsCodeController,
                decoration: const InputDecoration(
                  labelText: 'SMS Code',
                ),
                style: const TextStyle(fontSize: 25),
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                ] // 只允许输入数字
                ),
            const SizedBox(height: 16.0),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  final result =
                      await verifySmsCode(otp: _smsCodeController.text.trim());
                  print(result);
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white, // 设置按钮文本颜色
                  backgroundColor: Color(0xFFF26101), // 设置按钮背景颜色
                ),
                child: const Text('Sign In'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
