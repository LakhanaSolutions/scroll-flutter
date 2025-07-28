import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

/// Comprehensive color system for the Siraaj app
/// Implements Material You 3 color tokens and iOS system colors
class AppColors {
  // Prevent instantiation
  AppColors._();

  // ====== Material You 3 Color Schemes ======
  
  /// Light color scheme following Material You 3 design tokens
  static const ColorScheme lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    
    // Primary colors
    primary: Color(0xFF6750A4),
    onPrimary: Color(0xFFFFFFFF),
    primaryContainer: Color(0xFFE9DDFF),
    onPrimaryContainer: Color(0xFF22005D),
    
    // Secondary colors
    secondary: Color(0xFF625B71),
    onSecondary: Color(0xFFFFFFFF),
    secondaryContainer: Color(0xFFE8DEF8),
    onSecondaryContainer: Color(0xFF1E192B),
    
    // Tertiary colors
    tertiary: Color(0xFF7E5260),
    onTertiary: Color(0xFFFFFFFF),
    tertiaryContainer: Color(0xFFFFD9E3),
    onTertiaryContainer: Color(0xFF31101D),
    
    // Error colors
    error: Color(0xFFBA1A1A),
    onError: Color(0xFFFFFFFF),
    errorContainer: Color(0xFFFFDAD6),
    onErrorContainer: Color(0xFF410002),
    
    // Background colors
    surface: Color(0xFFFFFBFF),
    onSurface: Color(0xFF1C1B1E),
    surfaceContainerLowest: Color(0xFFFFFFFF),
    surfaceContainerLow: Color(0xFFF7F2FA),
    surfaceContainer: Color(0xFFF1ECF4),
    surfaceContainerHigh: Color(0xFFECE6F0),
    surfaceContainerHighest: Color(0xFFE6E0E9),
    onSurfaceVariant: Color(0xFF49454E),
    
    // Outline colors
    outline: Color(0xFF7A757F),
    outlineVariant: Color(0xFFCAC4CF),
    
    // Other colors
    shadow: Color(0xFF000000),
    scrim: Color(0xFF000000),
    inverseSurface: Color(0xFF313033),
    onInverseSurface: Color(0xFFF4EFF4),
    inversePrimary: Color(0xFFCFBCFF),
    surfaceTint: Color(0xFF6750A4),
  );

  /// Dark color scheme following Material You 3 design tokens
  static const ColorScheme darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    
    // Primary colors
    primary: Color(0xFF9A8CBF),
    onPrimary: Color(0xFF381E72),
    primaryContainer: Color(0xFF4F378A),
    onPrimaryContainer: Color(0xFFE9DDFF),
    
    // Secondary colors
    secondary: Color(0xFFCBC2DB),
    onSecondary: Color(0xFF332D41),
    secondaryContainer: Color(0xFF4A4458),
    onSecondaryContainer: Color(0xFFE8DEF8),
    
    // Tertiary colors
    tertiary: Color(0xFFF2B7C4),
    onTertiary: Color(0xFF4B2532),
    tertiaryContainer: Color(0xFF643B48),
    onTertiaryContainer: Color(0xFFFFD9E3),
    
    // Error colors
    error: Color(0xFFFFB4AB),
    onError: Color(0xFF690005),
    errorContainer: Color(0xFF93000A),
    onErrorContainer: Color(0xFFFFDAD6),
    
    // Background colors
    surface: Color(0xFF141218),
    onSurface: Color(0xFFE6E0E9),
    surfaceContainerLowest: Color(0xFF0F0D13),
    surfaceContainerLow: Color(0xFF1C1B1E),
    surfaceContainer: Color(0xFF201F22),
    surfaceContainerHigh: Color(0xFF2B2930),
    surfaceContainerHighest: Color(0xFF36343B),
    onSurfaceVariant: Color(0xFFCAC4CF),
    
    // Outline colors
    outline: Color(0xFF948F99),
    outlineVariant: Color(0xFF49454E),
    
    // Other colors
    shadow: Color(0xFF000000),
    scrim: Color(0xFF000000),
    inverseSurface: Color(0xFFE6E0E9),
    onInverseSurface: Color(0xFF313033),
    inversePrimary: Color(0xFF6750A4),
    surfaceTint: Color(0xFFCFBCFF),
  );

  // ====== iOS System Colors ======
  
  /// iOS system colors for light mode
  static const Color iosPrimary = Color(0xFF007AFF);
  static const Color iosOnPrimary = Color(0xFFFFFFFF);
  static const Color iosBackground = Color(0xFFFFFFFF);
  static const Color iosSystemBackground = Color(0xFFF2F2F7);
  static const Color iosLabel = Color(0xFF000000);
  static const Color iosSecondaryLabel = Color(0xFF3C3C43);
  static const Color iosTertiaryLabel = Color(0xFF3C3C43);
  static const Color iosQuaternaryLabel = Color(0xFF3C3C43);
  static const Color iosSeparator = Color(0xFF3C3C43);
  static const Color iosOpaqueSeparator = Color(0xFFC6C6C8);
  
  /// iOS-inspired background colors for light mode
  static const Color iosLightBackground = Color(0xFFF8F9FB);
  static const Color iosLightSystemBackground = Color(0xFFF2F2F7);
  
  /// iOS system colors for dark mode
  static const Color iosBackgroundDark = Color(0xFF000000);
  static const Color iosSystemBackgroundDark = Color(0xFF1C1C1E);
  static const Color iosLabelDark = Color(0xFFFFFFFF);
  static const Color iosSecondaryLabelDark = Color(0xFF99999D);
  static const Color iosTertiaryLabelDark = Color(0xFF62626A);
  static const Color iosQuaternaryLabelDark = Color(0xFF484850);
  static const Color iosSeparatorDark = Color(0xFF545458);
  static const Color iosOpaqueSeparatorDark = Color(0xFF38383A);
  
  /// iOS-inspired background colors for dark mode
  static const Color iosDarkBackground = Color(0xFF000000);
  static const Color iosDarkSystemBackground = Color(0xFF1C1C1E);

  // ====== Semantic Color Tokens ======
  
  /// Success colors
  static const Color successLight = Color(0xFF4CAF50);
  static const Color onSuccessLight = Color(0xFFFFFFFF);
  static const Color successContainerLight = Color(0xFFE8F5E8);
  static const Color onSuccessContainerLight = Color(0xFF1B5E20);
  
  static const Color successDark = Color(0xFF81C784);
  static const Color onSuccessDark = Color(0xFF1B5E20);
  static const Color successContainerDark = Color(0xFF2E7D32);
  static const Color onSuccessContainerDark = Color(0xFFE8F5E8);
  
  /// Warning colors
  static const Color warningLight = Color(0xFFFF9800);
  static const Color onWarningLight = Color(0xFFFFFFFF);
  static const Color warningContainerLight = Color(0xFFFFF3E0);
  static const Color onWarningContainerLight = Color(0xFFE65100);
  
  static const Color warningDark = Color(0xFFFFB74D);
  static const Color onWarningDark = Color(0xFFE65100);
  static const Color warningContainerDark = Color(0xFFEF6C00);
  static const Color onWarningContainerDark = Color(0xFFFFF3E0);
  
  /// Info colors
  static const Color infoLight = Color(0xFF2196F3);
  static const Color onInfoLight = Color(0xFFFFFFFF);
  static const Color infoContainerLight = Color(0xFFE3F2FD);
  static const Color onInfoContainerLight = Color(0xFF0D47A1);
  
  static const Color infoDark = Color(0xFF64B5F6);
  static const Color onInfoDark = Color(0xFF0D47A1);
  static const Color infoContainerDark = Color(0xFF1565C0);
  static const Color onInfoContainerDark = Color(0xFFE3F2FD);

  // ====== Brand Colors ======
  
  /// Primary brand color - Siraaj purple
  static const Color brandPrimary = Color(0xFF6750A4);
  static const Color brandPrimaryLight = Color(0xFF8B7DB8);
  static const Color brandPrimaryDark = Color(0xFF4F378A);
  
  /// Secondary brand color - Complementary gold
  static const Color brandSecondary = Color(0xFFFFC107);
  static const Color brandSecondaryLight = Color(0xFFFFD54F);
  static const Color brandSecondaryDark = Color(0xFFF57C00);

  // ====== Gradient Colors ======
  
  /// Primary gradient for backgrounds and accents
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF6750A4),
      Color(0xFF8B7DB8),
    ],
  );
  
  /// Secondary gradient for highlights
  static const LinearGradient secondaryGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFFFC107),
      Color(0xFFFFD54F),
    ],
  );
  
  /// Dark mode primary gradient
  static const LinearGradient primaryGradientDark = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFCFBCFF),
      Color(0xFF9A82DB),
    ],
  );

  // ====== Helper Methods ======
  
  /// Get success color based on brightness
  static Color getSuccessColor(bool isDark) {
    return isDark ? successDark : successLight;
  }
  
  /// Get success container color based on brightness
  static Color getSuccessContainer(bool isDark) {
    return isDark ? successContainerDark : successContainerLight;
  }
  
  /// Get warning color based on brightness
  static Color getWarningColor(bool isDark) {
    return isDark ? warningDark : warningLight;
  }
  
  /// Get warning container color based on brightness
  static Color getWarningContainer(bool isDark) {
    return isDark ? warningContainerDark : warningContainerLight;
  }
  
  /// Get info color based on brightness
  static Color getInfoColor(bool isDark) {
    return isDark ? infoDark : infoLight;
  }
  
  /// Get info container color based on brightness
  static Color getInfoContainer(bool isDark) {
    return isDark ? infoContainerDark : infoContainerLight;
  }
  
  /// Get primary gradient based on brightness
  static LinearGradient getPrimaryGradient(bool isDark) {
    return isDark ? primaryGradientDark : primaryGradient;
  }
}

/// Extension to add semantic colors to ColorScheme
extension AppColorScheme on ColorScheme {
  /// Success color
  Color get success => AppColors.getSuccessColor(brightness == Brightness.dark);
  
  /// On success color
  Color get onSuccess => brightness == Brightness.dark 
      ? AppColors.onSuccessDark 
      : AppColors.onSuccessLight;
  
  /// Success container color
  Color get successContainer => AppColors.getSuccessContainer(brightness == Brightness.dark);
  
  /// On success container color
  Color get onSuccessContainer => brightness == Brightness.dark 
      ? AppColors.onSuccessContainerDark 
      : AppColors.onSuccessContainerLight;
  
  /// Warning color
  Color get warning => AppColors.getWarningColor(brightness == Brightness.dark);
  
  /// On warning color
  Color get onWarning => brightness == Brightness.dark 
      ? AppColors.onWarningDark 
      : AppColors.onWarningLight;
  
  /// Warning container color
  Color get warningContainer => AppColors.getWarningContainer(brightness == Brightness.dark);
  
  /// On warning container color
  Color get onWarningContainer => brightness == Brightness.dark 
      ? AppColors.onWarningContainerDark 
      : AppColors.onWarningContainerLight;
  
  /// Info color
  Color get info => AppColors.getInfoColor(brightness == Brightness.dark);
  
  /// On info color
  Color get onInfo => brightness == Brightness.dark 
      ? AppColors.onInfoDark 
      : AppColors.onInfoLight;
  
  /// Info container color
  Color get infoContainer => AppColors.getInfoContainer(brightness == Brightness.dark);
  
  /// On info container color
  Color get onInfoContainer => brightness == Brightness.dark 
      ? AppColors.onInfoContainerDark 
      : AppColors.onInfoContainerLight;
  
  /// iOS-inspired background color
  Color get iosBackground => brightness == Brightness.dark 
      ? AppColors.iosDarkBackground 
      : AppColors.iosLightBackground;
  
  /// iOS-inspired system background color
  Color get iosSystemBackground => brightness == Brightness.dark 
      ? AppColors.iosDarkSystemBackground 
      : AppColors.iosLightSystemBackground;
}