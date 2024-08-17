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
                  padding: EdgeInsets.symmetric(vertical: 16), // Set vertical padding for the button
                  backgroundColor: Color(0xFFF26101), // Button background color
                  foregroundColor: Color(0xFFFFFFFF), // Button text color
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AccountSettingScreen()),
                  );
                },
                child: Text('accountSetting'.tr), // Translated text for account settings
              ),
            ),
          ],
        ),
        const SizedBox(height: 10), // Add space between buttons
        Row(
          children: [
            // Button for app settings (currently not functional)
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16), // Set vertical padding for the button
                  backgroundColor: Color(0xFFF26101), // Button background color
                  foregroundColor: Color(0xFFFFFFFF), // Button text color
                ),
                onPressed: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => SettingScreen()),
                  // );
                },
                child: Text('appSetting'.tr), // Translated text for app settings
              ),
            ),
          ],
        ),
        const SizedBox(height: 10), // Add space between buttons
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 1),
                height: 50,
                decoration: BoxDecoration(
                  color: Color(0xFFF26101), // Background color for the dropdown when not expanded
                  border: Border.all(color: Color(0xFFF26101)), // Border color for the dropdown
                  borderRadius: BorderRadius.circular(24), // Border radius for the dropdown
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: Get.locale?.languageCode ?? 'en', // Current locale language code
                    //icon: Icon(Icons.arrow_drop_down, color: Colors.white),
                    icon: SizedBox.shrink(), // Hide the default dropdown icon
                    //iconSize: 0,
                    style: TextStyle(color: Color(0xFFF26101), fontSize: 16),
                    dropdownColor: Color(0xFFF26101), // Background color of the dropdown menu
                    // Items for the dropdown menu, populated from TranslationService
                    items: TranslationService.langs.map((String lang) {
                      return DropdownMenuItem<String>(
                        value: TranslationService
                            .locales[TranslationService.langs.indexOf(lang)]
                            .languageCode,
                        //child: Center(child: Text(lang)), // Display language in dropdown
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center, // Center align items horizontally
                          children: [
                            Icon(Icons.language, color: Colors.white), // Language icon
                            SizedBox(width: 8),
                            //Text('$lang'),
                            Text('$lang', style: TextStyle(color: Colors.white)), // Text color in dropdown
                          ],
                        ),
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
        const SizedBox(height: 10), // Add space between buttons
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16), // Set vertical padding for the button
                  backgroundColor: Color(0xFFF26101), // Button background color
                  foregroundColor: Color(0xFFFFFFFF), // Button text color
                ),
                onPressed: () async {
                  await FirebaseAuth.instance.signOut(); // Sign out from Firebase
                  await GoogleSignIn().signOut(); // Sign out from Google
                  Get.offAll(() => MainPage()); // Navigate to the main page
                  Fluttertoast.showToast(
                    msg: 'signOutSuccessful'.tr, // Translated sign out success message
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.CENTER,
                    backgroundColor: Colors.green,
                    textColor: Colors.white,
                    fontSize: 16.0,
                  );
                },
                child: Text('signOut'.tr), // Translated text for sign out button
              ),
            ),
          ],
        ),
      ],
    );
  }
}
