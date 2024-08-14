import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../navigation/bottom_navigation_screen.dart';
import '../../profile/components/account_setting_screen/account_setting_screen.dart';

Future<bool> SignInUpWithGoogle(BuildContext context) async {
  try {
    if (await GoogleSignIn().isSignedIn()) {
      await GoogleSignIn().disconnect();
    }
  } catch (e) {
    //print('Error disconnecting: $e');
  }

  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
  if (googleUser == null) {
    return false; // 用户取消了登录
  }

  final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
  final AuthCredential credential = GoogleAuthProvider.credential(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  );

  User? currentUser = FirebaseAuth.instance.currentUser;

  try {
    if (currentUser != null && currentUser.isAnonymous) {
      // 尝试将 Google 账户链接到匿名账户
      final UserCredential userCredential =
          await currentUser.linkWithCredential(credential);
      await handleUserSignIn(context, userCredential.user);
      await saveUserToFirestore(userCredential.user);
      Fluttertoast.showToast(
        msg: 'Anonymous account linked with Google account',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return true;
    } else {
      // 正常登录
      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      await handleUserSignIn(context, userCredential.user);
      await saveUserToFirestore(userCredential.user);
      Fluttertoast.showToast(
        msg: 'Sign in successful',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return true;
    }
  } catch (e) {
    if (e is FirebaseAuthException && e.code == 'credential-already-in-use') {
      // 处理 Google 账户已被占用的情况
      bool? result = await showConflictDialog(context, credential);
      return result ?? false;
    } else {
      // 处理其他错误
      Fluttertoast.showToast(
        msg: 'Error: ${e.toString()}',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return false;
    }
  }
}

Future<bool?> showConflictDialog(
    BuildContext context, AuthCredential credential) async {
  return showDialog<bool?>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Account Conflict'),
        content: Text(
            'This Google account is already in use. Do you want to delete the anonymous account and continue with the Google account, or use another Google account?'),
        actions: <Widget>[
          TextButton(
            onPressed: () async {
              // 删除匿名账户并继续登录
              await FirebaseAuth.instance.currentUser?.delete();
              final UserCredential userCredential =
                  await FirebaseAuth.instance.signInWithCredential(credential);
              await handleUserSignIn(context, userCredential.user);
              await saveUserToFirestore(userCredential.user);
              Fluttertoast.showToast(
                msg: 'Sign in successful',
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.TOP,
                backgroundColor: Colors.green,
                textColor: Colors.white,
                fontSize: 16.0,
              );
              Navigator.of(context).pop(true); // 返回 true 表示用户选择删除匿名账户
            },
            child: Text('Delete Anonymous Account'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false); // 返回 false 表示用户选择使用其他 Google 账户
              SignInUpWithGoogle(context);
            },
            child: Text('Use Another Google Account'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(null);
            },
            child: Text('Back'),
          ),
        ],
      );
    },
  );
}

Future<void> saveUserToFirestore(User? user) async {
  if (user != null) {
    await user.reload();
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    final userList = firestore.collection('user_list').doc(user.uid);
    final docSnapshot = await userList.get();
    if (!docSnapshot.exists) {
      await userList.set({
        'uid': user.uid,
        'name': user.displayName,
        'email': user.email,
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

Future<bool> handleUserSignIn(BuildContext context, User? user) async {
  if (user != null) {
    // 处理用户登录逻辑
    // 如果登录成功返回 true
    Get.offAll(() => MainPage());
    return true;
  }
  // 如果用户为 null 则返回 false
  return false;
}
