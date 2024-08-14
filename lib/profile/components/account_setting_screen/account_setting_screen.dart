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
  final bool isFirstTimeSignIn;
  const AccountSettingScreen({Key? key, this.isFirstTimeSignIn = false})
      : super(key: key);

  @override
  _AccountSettingScreenState createState() => _AccountSettingScreenState();
}

class _AccountSettingScreenState extends State<AccountSettingScreen> {
  final user = FirebaseAuth.instance.currentUser;
  final userUID = FirebaseAuth.instance.currentUser?.uid;
  final TextEditingController _uidController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _referrerCodeController = TextEditingController();
  String? _gender;
  String? _avatarID;
  bool _isBindingPhoneNumber = false;
  bool _isBindingEmail = false;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
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
      final referralCode = user.uid.substring(0, 5);
      final referralDoc = await FirebaseFirestore.instance
          .collection('referral_list')
          .doc(referralCode)
          .get();
      if (referralDoc.exists) {
        final data = referralDoc.data()!;
        if (data.containsKey('referrerUid') && data['referrerUid'] is String) {
          setState(() {
            _referrerCodeController.text = data['referrerUid'].substring(0, 5);
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
        _isBindingPhoneNumber = true;
      }

      if (_emailController.text.isNotEmpty) {
        _isBindingEmail = true;
      }

      if (!_isBindingPhoneNumber || !_isBindingEmail) {
        Fluttertoast.showToast(
          msg:
              'Please bind your phone number and email to your account for enhanced security.',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.orange,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        return; // 停止执行
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
          final referralCode = userUID?.substring(0, 5);
          // 检查推荐码是否存在
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
              Get.back();
            } else {
              // 跳转到首页或其他页面
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
            Get.back();
          } else {
            Get.offAll(() => MainPage());
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
        title: Text('accountSetting'.tr),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(left: 30.0,right: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              AccountSettingAvatar(
                avatarID: _avatarID,
                onAvatarSelected: (newAvatarID) {
                  setState(() {
                    _avatarID = newAvatarID;
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
                    _gender = newGender;
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
                      _isBindingPhoneNumber = true;
                    });
                    await _reloadUserInfo();
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
                      _isBindingEmail = true;
                    });
                    await _reloadUserInfo();
                  }
                },
              ),
              SizedBox(height: 20),
              AccountSettingReferrerCode(
                referrerCodeController: _referrerCodeController,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveUserInfo,
                child: Text('save'.tr),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
