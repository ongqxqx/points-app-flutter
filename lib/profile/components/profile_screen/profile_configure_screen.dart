import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:points/translation_service.dart';
import '../../../navigation/bottom_navigation_screen.dart';
import '../account_setting_screen/account_setting_screen.dart';

class ProfileConfigureScreen extends StatelessWidget {
  const ProfileConfigureScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16), // 设置按钮内部的垂直填充
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AccountSettingScreen()),
                  );
                },
                child: Text('accountSetting'.tr),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            // 用来在两个按钮之间添加间距
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16), // 设置按钮内部的垂直填充
                ),
                onPressed: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => SettingScreen()),
                  // );
                },
                child: Text('appSetting'.tr),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10), // 添加上下间距
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 1),
                height: 50,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: Get.locale?.languageCode ?? 'en',
                    icon: Icon(Icons.arrow_drop_down, color: Colors.white),
                    iconSize: 0,
                    style: TextStyle(color: Colors.deepPurple, fontSize: 16),
                    //dropdownColor: Colors.white,
                    items: TranslationService.langs.map((String lang) {
                      return DropdownMenuItem<String>(
                        value: TranslationService
                            .locales[TranslationService.langs.indexOf(lang)]
                            .languageCode,
                        child: Center(child: Text(lang)),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        TranslationService().changeLocale(
                          TranslationService.langs[TranslationService.locales
                              .indexWhere(
                                  (locale) => locale.languageCode == newValue)],
                        );
                      }
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10), // 添加上下间距
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16), // 设置按钮内部的垂直填充
                ),
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  await GoogleSignIn().signOut();
                  Get.offAll(() => MainPage()); // 跳转到主页
                  Fluttertoast.showToast(
                    msg: 'signOutSuccessful'.tr,
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.CENTER,
                    backgroundColor: Colors.green,
                    textColor: Colors.white,
                    fontSize: 16.0,
                  );
                },
                child: Text('signOut'.tr),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
