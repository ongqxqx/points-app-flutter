import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:points/main.dart';

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
          // Automatically sign in the user.
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
      final UserCredential userCredential = await _firebaseAuth.signInWithCredential(credential);
      final User? user = userCredential.user;
      if (user != null) {
        // Check if the user is newly created or existing
        //if (userCredential.additionalUserInfo?.isNewUser ?? false) {
        //Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpWithPhoneNumberDart()),);
        // "New User";
        //} else {
        Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => MyApp()),);

        return "Success";
        //}
      } else {
        return "Error in OTP login!";
      }
    } on FirebaseAuthException catch (e) {
      return e.message.toString();
    } catch (e) {
      return e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up with Phone Number'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16.0),
            Row(
              children: [
                Container(
                  width: 100, height: 70,
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Country Code',
                    ),
                    child: DropdownButton<String>(
                      value: _selectedCountryCode,
                      onChanged: (String? newValue) {
                        setState(() {_selectedCountryCode = newValue!;});
                      },
                      items: <String>['+60'].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value, style: TextStyle(fontSize: 22),),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),
                Flexible(
                  child: TextFormField(
                    controller: _phoneNumberController,
                    decoration: const InputDecoration(labelText: 'Phone Number'),
                    style: const TextStyle(fontSize: 24),
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly, // 只允许输入数字
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  final phone = _selectedCountryCode + _phoneNumberController.text.trim();
                  sendVerificationCode(
                    phone: phone,
                    errorStep: (errorMessage) {print(errorMessage);},
                    nextStep: () {print('Verification code sent');},
                  );
                },
                child: const Text('Send Verification Code'),
              ),
            ),
            const SizedBox(height: 50),
            TextFormField(
              controller: _smsCodeController,
              decoration: const InputDecoration(labelText: 'SMS Code',),
              style: const TextStyle(fontSize: 24),
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly,] // 只允许输入数字
            ),
            const SizedBox(height: 16.0),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  final result = await verifySmsCode(otp: _smsCodeController.text.trim());
                  print(result);
                },
                child: const Text('Verify & Create Account'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
