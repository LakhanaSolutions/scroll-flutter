import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static const String _themeKey = 'theme_mode';
  static const String _languageKey = 'language_code';
  static const String _textDirectionKey = 'text_direction';

  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static bool get isDarkMode => _prefs.getBool(_themeKey) ?? false;

  static Future<bool> setDarkMode(bool isDark) async {
    return await _prefs.setBool(_themeKey, isDark);
  }

  static String get languageCode => _prefs.getString(_languageKey) ?? 'en';

  static Future<bool> setLanguageCode(String code) async {
    return await _prefs.setString(_languageKey, code);
  }

  static bool get isRTL => _prefs.getBool(_textDirectionKey) ?? false;

  static Future<bool> setTextDirection(bool isRTL) async {
    return await _prefs.setBool(_textDirectionKey, isRTL);
  }

  static Future<bool> clearAll() async {
    return await _prefs.clear();
  }
}