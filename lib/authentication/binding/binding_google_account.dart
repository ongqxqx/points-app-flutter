// binding_google_account.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BindAccount {
  static Future<bool> linkWithGoogleAccount() async {
    try {
      // 断开之前的Google登录连接
      await GoogleSignIn().disconnect();

      // 触发 Google 登录流程
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        return false; // 用户取消了登录
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // 使用 Google 凭据创建 AuthCredential
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // 将 Google 凭据链接到现有用户
      final User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.linkWithCredential(credential);

        // 重新获取用户信息
        await user.reload();
        final User? updatedUser = FirebaseAuth.instance.currentUser;

        // 更新 Firestore 中的用户信息
        if (updatedUser != null) {
          await FirebaseFirestore.instance
              .collection('user_list')
              .doc(updatedUser.uid)
              .update({
            'email': updatedUser.email,
          });

          Fluttertoast.showToast(
            msg: 'linkedWithGoogleAccountSuccessfully'.tr,
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0,
          );
          return true;
        } else {
          return false; // 重新获取用户信息失败
        }
      } else {
        return false; // 没有找到用户
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: e.toString(),
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return false;
    }
  }
}

class BindingGoogleAccount extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: BindAccount.linkWithGoogleAccount(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              title: Text('bindingGoogleAccount'.tr),
            ),
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          if (snapshot.hasData && snapshot.data == true) {
            Get.back(result: true);
          } else {
            Get.back(result: false);
          }
          return SizedBox.shrink();
        }
      },
    );
  }
}
