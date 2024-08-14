import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class BindingPhoneNumber extends StatefulWidget {
  BindingPhoneNumber({Key? key}) : super(key: key);

  @override
  BindingPhoneNumberState createState() => BindingPhoneNumberState();
}

class BindingPhoneNumberState extends State<BindingPhoneNumber> {
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _smsCodeController = TextEditingController();
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  String _selectedCountryCode = '+60'; // Default country code
  static String verifyId = "";
  bool _isButtonDisabled = false;
  int _countdown = 30;
  Timer? _timer;
  bool _showTextFieldSMS_And_ButtonSignIn = false; // 控制文本字段和按钮的显示状态
  final user = FirebaseAuth.instance.currentUser;
  final userUID = FirebaseAuth.instance.currentUser?.uid;
  final TextEditingController _phoneNumber = TextEditingController();
  final TextEditingController _email = TextEditingController();

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
    _smsCodeController.dispose();
    super.dispose();
  }

  static Future<void> sendVerificationCode({
    required String phone,
    required Function errorStep,
    required Function nextStep,
  }) async {
    try {
      await _firebaseAuth.verifyPhoneNumber(
        timeout: Duration(seconds: 30),
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

  Future<void> linkPhoneNumberWithGoogleAuth(User user, String smsCode) async {
    try {
      final PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verifyId,
        smsCode: smsCode,
      );
      await user.linkWithCredential(credential);
      Fluttertoast.showToast(
        msg: 'phoneNumberLinkedSuccessfully'.tr,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      await FirebaseFirestore.instance
          .collection('user_list')
          .doc(user.uid)
          .update({
        'phoneNumber':
            _selectedCountryCode + _phoneNumberController.text.trim(),
      });
      Get.back(result: true);
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(
        msg: e.message.toString(),
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      Get.back(result: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('bindingPhoneNumber'.tr),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16.0),
              Row(
                children: [
                  Container(
                    width: 100,
                    height: 70,
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'countryCode'.tr,
                      ),
                      child: DropdownButton<String>(
                        value: _selectedCountryCode,
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedCountryCode = newValue!;
                          });
                        },
                        items: <String>['+60']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: TextStyle(fontSize: 22),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  SizedBox(width: 8.0),
                  Flexible(
                    child: TextFormField(
                      controller: _phoneNumberController,
                      decoration: InputDecoration(labelText: 'phoneNumber'.tr),
                      style: TextStyle(fontSize: 25),
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly, // 只允许输入数字
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
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
                              //print('Verification code sent');
                              setState(() {
                                _showTextFieldSMS_And_ButtonSignIn =
                                    true; // 显示文本字段和按钮
                              });
                              Fluttertoast.showToast(
                                msg: 'verificationCodeSent'.tr,
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
                  child: _isButtonDisabled
                      ? Text('$_countdown' + 's')
                      : Text('sendVerificationCode'.tr),
                ),
              ),
              SizedBox(height: 16.0),
              if (_showTextFieldSMS_And_ButtonSignIn) ...[
                TextFormField(
                  controller: _smsCodeController,
                  decoration: InputDecoration(
                    labelText: 'smsCode'.tr,
                  ),
                  style: TextStyle(fontSize: 25),
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                  ], // 只允许输入数字
                ),
                SizedBox(height: 16.0),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      final user = FirebaseAuth.instance.currentUser;
                      if (user != null) {
                        await linkPhoneNumberWithGoogleAuth(
                          user,
                          _smsCodeController.text.trim(),
                        );
                      }
                      Get.back();
                    },
                    child: Text('verify'.tr),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
