import 'package:shared_preferences/shared_preferences.dart';

class LanguageSaved {
  static const String _languageCodeKey = 'languageCode';

  Future<void> saveLanguageCode(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageCodeKey, languageCode);
  }

  Future<String?> getLanguageCode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_languageCodeKey);
  }
}
