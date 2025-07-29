import 'package:shared_preferences/shared_preferences.dart';
import '../providers/theme_provider.dart';

class PreferencesService {
  static const String _themeKey = 'theme_mode';
  static const String _languageKey = 'language_code';
  static const String _textDirectionKey = 'text_direction';

  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Legacy support for existing installations
  static bool get isDarkMode => _prefs.getBool(_themeKey) ?? false;

  static Future<bool> setDarkMode(bool isDark) async {
    return await _prefs.setBool(_themeKey, isDark);
  }

  // New theme mode support
  static AppThemeMode get themeMode {
    final savedMode = _prefs.getString('theme_mode_v2');
    if (savedMode == null) {
      // Migrate from old boolean system
      final legacyDarkMode = _prefs.getBool(_themeKey);
      if (legacyDarkMode == null) {
        return AppThemeMode.system; // Default to system for new users
      }
      return legacyDarkMode ? AppThemeMode.dark : AppThemeMode.light;
    }
    
    switch (savedMode) {
      case 'light':
        return AppThemeMode.light;
      case 'dark':
        return AppThemeMode.dark;
      case 'system':
        return AppThemeMode.system;
      default:
        return AppThemeMode.system;
    }
  }

  static Future<bool> setThemeMode(AppThemeMode mode) async {
    final modeString = switch (mode) {
      AppThemeMode.light => 'light',
      AppThemeMode.dark => 'dark',
      AppThemeMode.system => 'system',
    };
    return await _prefs.setString('theme_mode_v2', modeString);
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