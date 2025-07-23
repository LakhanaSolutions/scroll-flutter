import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/preferences_service.dart';

class LocaleState {
  final String languageCode;
  final bool isRTL;

  const LocaleState({
    required this.languageCode,
    required this.isRTL,
  });

  Locale get locale => Locale(languageCode);
  TextDirection get textDirection => isRTL ? TextDirection.rtl : TextDirection.ltr;

  LocaleState copyWith({
    String? languageCode,
    bool? isRTL,
  }) {
    return LocaleState(
      languageCode: languageCode ?? this.languageCode,
      isRTL: isRTL ?? this.isRTL,
    );
  }
}

class LocaleNotifier extends StateNotifier<LocaleState> {
  LocaleNotifier()
      : super(LocaleState(
          languageCode: PreferencesService.languageCode,
          isRTL: PreferencesService.isRTL,
        ));

  Future<void> setLanguage(String languageCode) async {
    await PreferencesService.setLanguageCode(languageCode);
    
    final isRTL = _isRTLLanguage(languageCode);
    await PreferencesService.setTextDirection(isRTL);
    
    state = state.copyWith(
      languageCode: languageCode,
      isRTL: isRTL,
    );
  }

  Future<void> toggleTextDirection() async {
    final newDirection = !state.isRTL;
    await PreferencesService.setTextDirection(newDirection);
    state = state.copyWith(isRTL: newDirection);
  }

  bool _isRTLLanguage(String languageCode) {
    const rtlLanguages = ['ar', 'he', 'fa', 'ur', 'ku', 'ps'];
    return rtlLanguages.contains(languageCode);
  }
}

final localeProvider = StateNotifierProvider<LocaleNotifier, LocaleState>((ref) {
  return LocaleNotifier();
});