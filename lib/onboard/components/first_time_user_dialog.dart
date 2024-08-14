import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:points/onboard/onboarding_sign_in_up_screen.dart';

import '../../navigation/bottom_navigation_screen.dart';

class FirstTimeUserDialog {
  static void show(BuildContext context, {required Function(bool) onComplete}) {
    showDialog(
      context: context,
      barrierDismissible: true, // 允许点击空白处关闭对话框
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async {
            // 当用户点击返回按钮或空白处时，调用 onComplete(false)
            onComplete(false);
            return true;
          },
          child: AlertDialog(
            title: Text('wouldYouLikeToCreateAnAccount'.tr),
            content: Text(
              'byCreatingAnAccount,YourDataWillBeSecurelySaved,AllowingYouToAccessItFromMultipleDevices'
                  .tr,
            ),
            actions: [
              Row(children: [
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Get.to(() => OnboardingSignInUpScreen());
                      //onComplete(true); // 用户选择创建账户
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white, // 设置按钮文本颜色
                      backgroundColor: Color(0xFFF26101), // 设置按钮背景颜色
                    ),
                    child: Text(
                      'createAnAccount'.tr,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ]),
              //SizedBox(height: 20),
              Row(children: [
                Expanded(
                  child: TextButton(
                    onPressed: () async {
                      Navigator.pop(context);
                      try {
                        await FirebaseAuth.instance.signInAnonymously();
                        onComplete(false); // 用户选择匿名登录
                        Fluttertoast.showToast(
                          msg: 'anAnonymousAccountHasBeenCreated'.tr,
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.CENTER,
                          backgroundColor: Colors.green,
                          textColor: Colors.white,
                          fontSize: 16.0,
                        );
                        Get.off(() => MainPage()); // 直接导航到 MainPage
                      } catch (e) {
                        print('Failed to sign in anonymously: $e');
                        // 可以在这里添加错误处理逻辑
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Color(
                          0xFFF26101), //backgroundColor: Color(0xFFF26101),    // 设置按钮前景色（文本颜色）
                      side: BorderSide(
                        color: Color(0xFFF26101), // 设置边框颜色
                        width: 2, // 设置边框宽度
                      ),
                    ),
                    child: Text('UseAnAnonymousAccount'.tr),
                  ),
                ),
              ]),
              SizedBox(height: 20),
              Align(
                alignment: Alignment.bottomLeft, // 将按钮水平居中
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    onComplete(false); // 用户选择返回
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Color(0xFFF26101),
                  ),
                  child: Text('back'.tr),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
