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

  /// Dark color scheme following the provided CSS dark theme variables
  static const ColorScheme darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    
    // Primary colors - based on CSS --primary: #e05d38 (orange)
    primary: Color(0xFFe05d38),
    onPrimary: Color(0xFFffffff), // CSS --primary-foreground
    primaryContainer: Color(0xFFb8472a), // Darker variant of primary
    onPrimaryContainer: Color(0xFFffffff),
    
    // Secondary colors - based on CSS --secondary: #2a303e
    secondary: Color(0xFF2a303e),
    onSecondary: Color(0xFFe5e5e5), // CSS --secondary-foreground
    secondaryContainer: Color(0xFF2a3656), // CSS --accent
    onSecondaryContainer: Color(0xFFbfdbfe), // CSS --accent-foreground
    
    // Tertiary colors - using chart colors for variety
    tertiary: Color(0xFF86a7c8), // CSS --chart-1
    onTertiary: Color(0xFF1a1a1a),
    tertiaryContainer: Color(0xFF5a7ca6), // CSS --chart-3
    onTertiaryContainer: Color(0xFFffffff),
    
    // Error colors - based on CSS --destructive: #ef4444
    error: Color(0xFFef4444),
    onError: Color(0xFFffffff), // CSS --destructive-foreground
    errorContainer: Color(0xFFdc2626), // Darker variant
    onErrorContainer: Color(0xFFffffff),
    
    // Background colors - based on CSS variables
    surface: Color(0xFF1c2433), // CSS --background
    onSurface: Color(0xFFe5e5e5), // CSS --foreground
    surfaceContainerLowest: Color(0xFF161e2b), // Darker than background
    surfaceContainerLow: Color(0xFF2a3040), // CSS --card
    surfaceContainer: Color(0xFF2a303e), // CSS --muted/secondary
    surfaceContainerHigh: Color(0xFF262b38), // CSS --popover
    surfaceContainerHighest: Color(0xFF2a3656), // CSS --accent
    onSurfaceVariant: Color(0xFFa3a3a3), // CSS --muted-foreground
    
    // Outline colors - based on CSS --border and ring
    outline: Color(0xFF3d4354), // CSS --border/input
    outlineVariant: Color(0xFF2a303e), // Subtle variant
    
    // Other colors
    shadow: Color(0xFF000000),
    scrim: Color(0xFF000000),
    inverseSurface: Color(0xFFe5e5e5),
    onInverseSurface: Color(0xFF1c2433),
    inversePrimary: Color(0xFFe05d38),
    surfaceTint: Color(0xFFe05d38), // CSS --ring
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
  
  /// iOS system colors for dark mode - updated to match new CSS theme
  static const Color iosBackgroundDark = Color(0xFF1c2433); // CSS --background
  static const Color iosSystemBackgroundDark = Color(0xFF2a3040); // CSS --card
  static const Color iosLabelDark = Color(0xFFe5e5e5); // CSS --foreground
  static const Color iosSecondaryLabelDark = Color(0xFFe5e5e5); // CSS --popover-foreground
  static const Color iosTertiaryLabelDark = Color(0xFFa3a3a3); // CSS --muted-foreground
  static const Color iosQuaternaryLabelDark = Color(0xFFe5e5e5); // CSS --sidebar-foreground
  static const Color iosSeparatorDark = Color(0xFF3d4354); // CSS --border
  static const Color iosOpaqueSeparatorDark = Color(0xFF2a303e); // CSS --secondary/muted
  
  /// iOS-inspired background colors for dark mode - updated to match new CSS theme
  static const Color iosDarkBackground = Color(0xFF1c2433); // CSS --background
  static const Color iosDarkSystemBackground = Color(0xFF2a3040); // CSS --card

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
  
  /// Primary brand color - Updated to match new CSS theme
  static const Color brandPrimary = Color(0xFFe05d38); // CSS --primary (orange)
  static const Color brandPrimaryLight = Color(0xFFe6a08f); // CSS --chart-2 (lighter orange)
  static const Color brandPrimaryDark = Color(0xFFb8472a); // Darker variant of primary
  
  /// Secondary brand color - Blue accent from chart colors
  static const Color brandSecondary = Color(0xFF86a7c8); // CSS --chart-1 (blue)
  static const Color brandSecondaryLight = Color(0xFFbfdbfe); // Light blue
  static const Color brandSecondaryDark = Color(0xFF5a7ca6); // CSS --chart-3 (darker blue)

  // ====== Gradient Colors ======
  
  /// Primary gradient for backgrounds and accents
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFe05d38), // CSS --primary (orange)
      Color(0xFFe6a08f), // CSS --chart-2 (lighter orange)
    ],
  );
  
  /// Secondary gradient for highlights - blue theme
  static const LinearGradient secondaryGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF86a7c8), // CSS --chart-1 (blue)
      Color(0xFF5a7ca6), // CSS --chart-3 (darker blue)
    ],
  );
  
  /// Dark mode primary gradient - orange to blue
  static const LinearGradient primaryGradientDark = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFe05d38), // CSS --primary (orange)
      Color(0xFF86a7c8), // CSS --chart-1 (blue)
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