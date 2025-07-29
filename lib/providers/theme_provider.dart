import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/preferences_service.dart';

enum AppThemeMode { light, dark, system }

class ThemeState {
  final AppThemeMode mode;
  final bool isDark;

  const ThemeState({
    required this.mode,
    required this.isDark,
  });

  ThemeState copyWith({
    AppThemeMode? mode,
    bool? isDark,
  }) {
    return ThemeState(
      mode: mode ?? this.mode,
      isDark: isDark ?? this.isDark,
    );
  }
}

class ThemeNotifier extends StateNotifier<ThemeState> {
  ThemeNotifier() : super(ThemeState(
    mode: PreferencesService.themeMode,
    isDark: _calculateIsDark(PreferencesService.themeMode),
  ));

  static bool _calculateIsDark(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.light:
        return false;
      case AppThemeMode.dark:
        return true;
      case AppThemeMode.system:
        // This will be updated when system brightness changes
        return WidgetsBinding.instance.platformDispatcher.platformBrightness == Brightness.dark;
    }
  }

  void updateSystemBrightness(Brightness brightness) {
    if (state.mode == AppThemeMode.system) {
      state = state.copyWith(isDark: brightness == Brightness.dark);
    }
  }

  Future<void> toggleTheme() async {
    final newMode = state.isDark ? AppThemeMode.light : AppThemeMode.dark;
    await setThemeMode(newMode);
  }

  Future<void> setThemeMode(AppThemeMode mode) async {
    state = ThemeState(
      mode: mode,
      isDark: _calculateIsDark(mode),
    );
    await PreferencesService.setThemeMode(mode);
  }

  Future<void> setLightTheme() async {
    await setThemeMode(AppThemeMode.light);
  }

  Future<void> setDarkTheme() async {
    await setThemeMode(AppThemeMode.dark);
  }

  Future<void> setSystemTheme() async {
    await setThemeMode(AppThemeMode.system);
  }
}

final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeState>((ref) {
  return ThemeNotifier();
});