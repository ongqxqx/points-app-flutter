import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:points/translation_service.dart';
import 'components/first_time_user_dialog.dart';
import 'onboarding_sign_in_up_screen.dart';

class OnboardingScreen extends StatelessWidget {
  final Function(bool) onCompleted;

  OnboardingScreen({required this.onCompleted});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // 直接退出应用程序
        SystemNavigator.pop();
        return false;
      },
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(),
              ElevatedButton(
                onPressed: () {
                  FirstTimeUserDialog.show(
                    context,
                    onComplete: (bool createAccount) {
                      onCompleted(createAccount);
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Color(0xFFF26101),    // 设置按钮前景色（文本颜色）
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12), // 按钮的内边距
                ),
                child: Text(
                  'getStarted'.tr,
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Get.to(() => OnboardingSignInUpScreen());
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Color(0xFFF26101),    // 设置按钮前景色（文本颜色）
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12), // 按钮的内边距
                ),
                child: Text(
                  'signIn'.tr,
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
              Spacer(),
              DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: Get.locale?.languageCode ?? 'en',
                  icon: SizedBox.shrink(), //Icon(Icons.language, color: Color(0xFFF26101)),
                  style: TextStyle(color: Color(0xFFF26101), fontSize: 16),
                  items: TranslationService.langs.map((String lang) {
                    return DropdownMenuItem<String>(
                      value: TranslationService
                          .locales[TranslationService.langs.indexOf(lang)]
                          .languageCode,
                      child: Row(
                        children: [
                          Icon(Icons.language, color: Color(0xFFF26101)), // 可选：添加图标
                          SizedBox(width: 8), // 在文本和图标之间添加8像素的间距
                          Text('$lang'),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      TranslationService().changeLocale(
                        TranslationService.langs[TranslationService.locales
                            .indexWhere((locale) => locale.languageCode == newValue)],
                      );
                    }
                  },
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
