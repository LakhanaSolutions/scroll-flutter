import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/preferences_service.dart';

class ThemeNotifier extends StateNotifier<bool> {
  ThemeNotifier() : super(PreferencesService.isDarkMode);

  Future<void> toggleTheme() async {
    final newValue = !state;
    state = newValue;
    await PreferencesService.setDarkMode(newValue);
  }

  Future<void> setTheme(bool isDark) async {
    state = isDark;
    await PreferencesService.setDarkMode(isDark);
  }
}

final themeProvider = StateNotifierProvider<ThemeNotifier, bool>((ref) {
  return ThemeNotifier();
});