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
        SystemNavigator.pop(); // Exit the app on back button press
        return false; // Prevent default back button action
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
                      onCompleted(createAccount); // Pass the result to onCompleted
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Color(0xFFF26101), // Button background color
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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
                  Get.to(() => OnboardingSignInUpScreen()); // Navigate to sign-in/up screen
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Color(0xFFF26101), // Button background color
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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
                  value: Get.locale?.languageCode ?? 'en', // Current language code
                  icon: SizedBox.shrink(), // Hide the default dropdown icon
                  style: TextStyle(color: Color(0xFFF26101), fontSize: 16),
                  items: TranslationService.langs.map((String lang) {
                    return DropdownMenuItem<String>(
                      value: TranslationService
                          .locales[TranslationService.langs.indexOf(lang)]
                          .languageCode,
                      child: Row(
                        children: [
                          Icon(Icons.language, color: Color(0xFFF26101)), // Language icon
                          SizedBox(width: 8),
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
                      ); // Change app language
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
