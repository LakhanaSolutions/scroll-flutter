import 'package:flutter/material.dart';

/// Comprehensive typography system for the Siraaj app
/// Implements Material You 3 typography scale and iOS San Francisco font system
class AppTextStyles {
  // Prevent instantiation
  AppTextStyles._();

  // ====== Font Families ======
  
  /// Primary font family for the app
  static const String primaryFontFamily = 'SF Pro Display';
  
  /// Secondary font family for body text
  static const String bodyFontFamily = 'SF Pro Text';
  
  /// Monospace font family for code
  static const String monospaceFontFamily = 'SF Mono';

  // ====== Material You 3 Typography Scale ======
  
  /// Display Large - 50sp
  static const TextStyle displayLarge = TextStyle(
    fontSize: 50,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.25,
    height: 1.12,
    fontFamily: primaryFontFamily,
  );

  /// Display Medium - 40sp
  static const TextStyle displayMedium = TextStyle(
    fontSize: 40,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.16,
    fontFamily: primaryFontFamily,
  );

  /// Display Small - 32sp
  static const TextStyle displaySmall = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.22,
    fontFamily: primaryFontFamily,
  );

  /// Headline Large - 28sp
  static const TextStyle headlineLarge = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.25,
    fontFamily: primaryFontFamily,
  );

  /// Headline Medium - 24sp
  static const TextStyle headlineMedium = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.29,
    fontFamily: primaryFontFamily,
  );

  /// Headline Small - 20sp
  static const TextStyle headlineSmall = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.33,
    fontFamily: primaryFontFamily,
  );

  /// Title Large - 18sp
  static const TextStyle titleLarge = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.27,
    fontFamily: primaryFontFamily,
  );

  /// Title Medium - 14sp
  static const TextStyle titleMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.15,
    height: 1.5,
    fontFamily: primaryFontFamily,
  );

  /// Title Small - 12sp
  static const TextStyle titleSmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    height: 1.43,
    fontFamily: primaryFontFamily,
  );

  /// Label Large - 12sp
  static const TextStyle labelLarge = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    height: 1.43,
    fontFamily: bodyFontFamily,
  );

  /// Label Medium - 11sp
  static const TextStyle labelMedium = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    height: 1.33,
    fontFamily: bodyFontFamily,
  );

  /// Label Small - 10sp
  static const TextStyle labelSmall = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    height: 1.45,
    fontFamily: bodyFontFamily,
  );

  /// Body Large - 14sp
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.15,
    height: 1.5,
    fontFamily: bodyFontFamily,
  );

  /// Body Medium - 12sp
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.25,
    height: 1.43,
    fontFamily: bodyFontFamily,
  );

  /// Body Small - 11sp
  static const TextStyle bodySmall = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
    height: 1.33,
    fontFamily: bodyFontFamily,
  );

  // ====== Custom Semantic Text Styles ======
  
  /// Hero text for landing pages and main headlines
  static const TextStyle hero = TextStyle(
    fontSize: 42,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    height: 1.1,
    fontFamily: primaryFontFamily,
  );

  /// Subtitle text for sections
  static const TextStyle subtitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.15,
    height: 1.44,
    fontFamily: primaryFontFamily,
  );

  /// Caption text for small descriptions
  static const TextStyle caption = TextStyle(
    fontSize: 9,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
    height: 1.4,
    fontFamily: bodyFontFamily,
  );

  /// Overline text for category labels
  static const TextStyle overline = TextStyle(
    fontSize: 9,
    fontWeight: FontWeight.w500,
    letterSpacing: 1.5,
    height: 1.4,
    fontFamily: bodyFontFamily,
  );

  /// Monospace text for code and technical content
  static const TextStyle monospace = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.43,
    fontFamily: monospaceFontFamily,
  );

  /// Button text style
  static const TextStyle button = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
    height: 1.43,
    fontFamily: bodyFontFamily,
  );

  // ====== Platform-Specific Styles ======
  
  /// iOS Large Title style
  static const TextStyle iosLargeTitle = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.374,
    height: 1.2,
    fontFamily: primaryFontFamily,
  );

  /// iOS Title 1 style
  static const TextStyle iosTitle1 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.364,
    height: 1.29,
    fontFamily: primaryFontFamily,
  );

  /// iOS Title 2 style
  static const TextStyle iosTitle2 = TextStyle(
    fontSize: 19,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.352,
    height: 1.27,
    fontFamily: primaryFontFamily,
  );

  /// iOS Title 3 style
  static const TextStyle iosTitle3 = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.38,
    height: 1.25,
    fontFamily: primaryFontFamily,
  );

  /// iOS Headline style
  static const TextStyle iosHeadline = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.408,
    height: 1.29,
    fontFamily: bodyFontFamily,
  );

  /// iOS Body style
  static const TextStyle iosBody = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.408,
    height: 1.29,
    fontFamily: bodyFontFamily,
  );

  /// iOS Callout style
  static const TextStyle iosCallout = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.32,
    height: 1.31,
    fontFamily: bodyFontFamily,
  );

  /// iOS Subhead style
  static const TextStyle iosSubhead = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.24,
    height: 1.33,
    fontFamily: bodyFontFamily,
  );

  /// iOS Footnote style
  static const TextStyle iosFootnote = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.08,
    height: 1.38,
    fontFamily: bodyFontFamily,
  );

  /// iOS Caption 1 style
  static const TextStyle iosCaption1 = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.33,
    fontFamily: bodyFontFamily,
  );

  /// iOS Caption 2 style
  static const TextStyle iosCaption2 = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.07,
    height: 1.27,
    fontFamily: bodyFontFamily,
  );

  // ====== Material TextTheme ======
  
  /// Complete Material TextTheme for use in ThemeData
  static const TextTheme materialTextTheme = TextTheme(
    displayLarge: displayLarge,
    displayMedium: displayMedium,
    displaySmall: displaySmall,
    headlineLarge: headlineLarge,
    headlineMedium: headlineMedium,
    headlineSmall: headlineSmall,
    titleLarge: titleLarge,
    titleMedium: titleMedium,
    titleSmall: titleSmall,
    labelLarge: labelLarge,
    labelMedium: labelMedium,
    labelSmall: labelSmall,
    bodyLarge: bodyLarge,
    bodyMedium: bodyMedium,
    bodySmall: bodySmall,
  );

  // ====== Helper Methods ======
  
  /// Get text style with color applied
  static TextStyle withColor(TextStyle style, Color color) {
    return style.copyWith(color: color);
  }

  /// Get text style with opacity applied
  static TextStyle withOpacity(TextStyle style, double opacity) {
    return style.copyWith(color: style.color?.withOpacity(opacity));
  }

  /// Get text style with weight applied
  static TextStyle withWeight(TextStyle style, FontWeight weight) {
    return style.copyWith(fontWeight: weight);
  }

  /// Get text style with size applied
  static TextStyle withSize(TextStyle style, double size) {
    return style.copyWith(fontSize: size);
  }

  /// Get responsive text style based on screen size
  static TextStyle responsive(BuildContext context, TextStyle style) {
    final screenWidth = MediaQuery.of(context).size.width;
    final scaleFactor = screenWidth < 600 ? 0.9 : 1.0;
    
    return style.copyWith(
      fontSize: (style.fontSize ?? 14) * scaleFactor,
    );
  }

  /// Get platform-appropriate text style
  static TextStyle platformStyle(BuildContext context, {
    required TextStyle materialStyle,
    required TextStyle iosStyle,
  }) {
    switch (Theme.of(context).platform) {
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return iosStyle;
      default:
        return materialStyle;
    }
  }
}