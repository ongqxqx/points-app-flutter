import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:points/authentication/binding/binding_google_account.dart';
import 'package:points/authentication/binding/binding_phone_number.dart';
import 'package:points/navigation/bottom_navigation_screen.dart';
import 'account_setting_avatar.dart';
import 'account_setting_uid.dart';
import 'account_setting_name.dart';
import 'account_setting_gender.dart';
import 'account_setting_phone_number.dart';
import 'account_setting_email.dart';
import 'account_setting_referrer_code.dart';

class AccountSettingScreen extends StatefulWidget {
  final bool isFirstTimeSignIn; // Flag to determine if it's the user's first sign-in

  const AccountSettingScreen({Key? key, this.isFirstTimeSignIn = false}) : super(key: key);

  @override
  _AccountSettingScreenState createState() => _AccountSettingScreenState();
}

class _AccountSettingScreenState extends State<AccountSettingScreen> {
  final user = FirebaseAuth.instance.currentUser; // Current authenticated user
  final userUID = FirebaseAuth.instance.currentUser?.uid; // User UID for identification
  final TextEditingController _uidController = TextEditingController(); // Controller for UID field
  final TextEditingController _nameController = TextEditingController(); // Controller for name field
  final TextEditingController _phoneNumberController = TextEditingController(); // Controller for phone number field
  final TextEditingController _emailController = TextEditingController(); // Controller for email field
  final TextEditingController _referrerCodeController = TextEditingController(); // Controller for referrer code field
  String? _gender; // Selected gender
  String? _avatarID; // Selected avatar ID
  bool _isBindingPhoneNumber = false; // Flag to check if phone number is bound
  bool _isBindingEmail = false; // Flag to check if email is bound

  @override
  void initState() {
    super.initState();
    _loadUserInfo(); // Load user info on initialization
  }

  Future<void> _loadUserInfo() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userDoc = await FirebaseFirestore.instance
          .collection('user_list')
          .doc(user.uid)
          .get();
      if (userDoc.exists) {
        final data = userDoc.data()!;
        setState(() {
          _avatarID = data['avatarID'];
          _uidController.text = data['uid'] ?? '';
          _nameController.text = data['name'] ?? '';
          _gender = data['gender'];
          _phoneNumberController.text = data['phoneNumber'] ?? '';
          _emailController.text = data['email'] ?? '';
          _referrerCodeController.text = data['referralCode'] ?? '';
        });
      }
      final referralCode = user.uid.substring(0, 5); // Generate referral code from user UID
      final referralDoc = await FirebaseFirestore.instance
          .collection('referral_list')
          .doc(referralCode)
          .get();
      if (referralDoc.exists) {
        final data = referralDoc.data()!;
        if (data.containsKey('referrerUid') && data['referrerUid'] is String) {
          setState(() {
            _referrerCodeController.text = data['referrerUid'].substring(0, 5); // Set referrer code
          });
        }
      }
    }
  }

  Future<void> _reloadUserInfo() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance
          .collection('user_list')
          .doc(user.uid)
          .get();
      if (doc.exists) {
        final data = doc.data()!;
        setState(() {
          _phoneNumberController.text = data['phoneNumber'] ?? '';
          _emailController.text = data['email'] ?? '';
        });
      }
    }
  }

  Future<void> _saveUserInfo() async {
    if (userUID != null) {
      if (_phoneNumberController.text.isNotEmpty) {
        _isBindingPhoneNumber = true; // Update binding status
      }

      if (_emailController.text.isNotEmpty) {
        _isBindingEmail = true; // Update binding status
      }

      if (!_isBindingPhoneNumber || !_isBindingEmail) {
        Fluttertoast.showToast(
          msg: 'Please bind your phone number and email to your account for enhanced security.',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.orange,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        return; // Stop execution if not all required fields are bound
      }
      try {
        await FirebaseFirestore.instance
            .collection('user_list')
            .doc(userUID)
            .update({
          'name': _nameController.text,
          'gender': _gender,
          'avatarID': _avatarID,
        });
        if (_referrerCodeController.text.isNotEmpty) {
          final referrerDoc = FirebaseFirestore.instance
              .collection('referral_list')
              .doc(_referrerCodeController.text);
          final referrerSnapshot = await referrerDoc.get();
          final referralCode = userUID?.substring(0, 5); // Generate referral code from user UID
          // Check if referral code exists
          if (referrerSnapshot.exists) {
            final data = referrerSnapshot.data()!;
            await FirebaseFirestore.instance
                .collection('referral_list')
                .doc(referralCode)
                .update({
              'referrerUid': data['userUid'],
              'referralCodeTimestamp': FieldValue.serverTimestamp(),
            });
            Fluttertoast.showToast(
              msg: 'User Detail Updated :)',
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.TOP,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 16.0,
            );
            if (!widget.isFirstTimeSignIn) {
              Get.back(); // Navigate back if not first time sign-in
            } else {
              // Redirect to the main page or home screen
              Get.offAll(() => BottomNavigationScreen());
              //Get.offAll(() => MainPage(title: 'Points'));
            }
          } else {
            Fluttertoast.showToast(
              msg: 'Referral Code Invalid!',
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.TOP,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0,
            );
          }
        } else {
          Fluttertoast.showToast(
            msg: 'User Detail Updated :)',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.TOP,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0,
          );
          if (!widget.isFirstTimeSignIn) {
            Get.back(); // Navigate back if not first time sign-in
          } else {
            Get.offAll(() => MainPage()); // Redirect to the main page if first time sign-in
          }
        }
      } catch (error) {
        Fluttertoast.showToast(
          msg: 'Failed to update user info: $error',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('accountSetting'.tr), // Title of the app bar
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(left: 30.0, right: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              AccountSettingAvatar(
                avatarID: _avatarID,
                onAvatarSelected: (newAvatarID) {
                  setState(() {
                    _avatarID = newAvatarID; // Update avatar ID when a new avatar is selected
                  });
                },
              ),
              SizedBox(height: 20),
              AccountSettingUid(
                uidController: _uidController,
              ),
              SizedBox(height: 20),
              AccountSettingName(
                nameController: _nameController,
              ),
              SizedBox(height: 20),
              AccountSettingGender(
                gender: _gender,
                onChanged: (newGender) {
                  setState(() {
                    _gender = newGender; // Update gender when a new gender is selected
                  });
                },
              ),
              SizedBox(height: 20),
              AccountSettingPhoneNumber(
                phoneNumberController: _phoneNumberController,
                isBindingPhoneNumber: _isBindingPhoneNumber,
                onPressed: () async {
                  bool result = await Get.to(() => BindingPhoneNumber());
                  if (result == true) {
                    setState(() {
                      _isBindingPhoneNumber = true; // Update phone number binding status
                    });
                    await _reloadUserInfo(); // Reload user info after binding
                  }
                },
              ),
              SizedBox(height: 20),
              AccountSettingEmail(
                emailController: _emailController,
                isBindingEmail: _isBindingEmail,
                onPressed: () async {
                  bool result = await Get.to(() => BindingGoogleAccount());
                  if (result == true) {
                    setState(() {
                      _isBindingEmail = true; // Update email binding status
                    });
                    await _reloadUserInfo(); // Reload user info after binding
                  }
                },
              ),
              SizedBox(height: 20),
              AccountSettingReferrerCode(
                referrerCodeController: _referrerCodeController,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16), // Set vertical padding for the button
                  backgroundColor: Color(0xFFF26101), // Button background color
                  foregroundColor: Color(0xFFFFFFFF), // Button text color
                ),
                onPressed: _saveUserInfo, // Save user info when the button is pressed
                child: Text('save'.tr, style: TextStyle(fontSize: 16),), // Save button text
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
