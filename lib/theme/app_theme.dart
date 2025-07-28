import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';
import 'app_spacing.dart';

/// Comprehensive theme configuration for the Siraaj app
/// Implements Material You 3 for Android and iOS native styling for iOS
class AppTheme {
  // Prevent instantiation
  AppTheme._();

  /// Material You 3 light theme for Android
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: AppColors.lightColorScheme,
      
      // Typography
      textTheme: GoogleFonts.josefinSansTextTheme(AppTextStyles.materialTextTheme),
      
      // App Bar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.lightColorScheme.surface,
        foregroundColor: AppColors.lightColorScheme.onSurface,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: AppTextStyles.headlineSmall.copyWith(
          color: AppColors.lightColorScheme.onSurface,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(
          color: AppColors.lightColorScheme.onSurface,
        ),
      ),
      
      // Card Theme
      cardTheme: CardThemeData(
        color: AppColors.lightColorScheme.surface,
        surfaceTintColor: AppColors.lightColorScheme.surfaceTint,
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
        ),
      ),
      
      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.lightColorScheme.primary,
          foregroundColor: AppColors.lightColorScheme.onPrimary,
          elevation: 1,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.large,
            vertical: AppSpacing.medium,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
          ),
          textStyle: AppTextStyles.labelLarge.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      
      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.lightColorScheme.primary,
          side: BorderSide(color: AppColors.lightColorScheme.outline),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.large,
            vertical: AppSpacing.medium,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
          ),
          textStyle: AppTextStyles.labelLarge.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      
      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.lightColorScheme.primary,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.medium,
            vertical: AppSpacing.small,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
          ),
          textStyle: AppTextStyles.labelLarge.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      
      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.lightColorScheme.surfaceContainerHighest,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
          borderSide: BorderSide(color: AppColors.lightColorScheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
          borderSide: BorderSide(
            color: AppColors.lightColorScheme.primary,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
          borderSide: BorderSide(color: AppColors.lightColorScheme.error),
        ),
        contentPadding: const EdgeInsets.all(AppSpacing.medium),
        labelStyle: AppTextStyles.bodyLarge.copyWith(
          color: AppColors.lightColorScheme.onSurfaceVariant,
        ),
        hintStyle: AppTextStyles.bodyLarge.copyWith(
          color: AppColors.lightColorScheme.onSurfaceVariant.withOpacity(0.6),
        ),
      ),
      
      // Dialog Theme
      dialogTheme: DialogThemeData(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
        ),
        titleTextStyle: AppTextStyles.headlineSmall.copyWith(
          color: AppColors.lightColorScheme.onSurface,
        ),
        contentTextStyle: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.lightColorScheme.onSurfaceVariant,
        ),
      ),
      
      // Bottom Sheet Theme
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: AppColors.lightColorScheme.surface,
        surfaceTintColor: AppColors.lightColorScheme.surfaceTint,
        elevation: 1,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppSpacing.radiusLarge),
          ),
        ),
      ),
      
      // Floating Action Button Theme
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.lightColorScheme.primaryContainer,
        foregroundColor: AppColors.lightColorScheme.onPrimaryContainer,
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
        ),
      ),
      
      // List Tile Theme
      listTileTheme: ListTileThemeData(
        tileColor: Colors.transparent,
        selectedTileColor: AppColors.lightColorScheme.secondaryContainer,
        iconColor: AppColors.lightColorScheme.onSurfaceVariant,
        textColor: AppColors.lightColorScheme.onSurface,
        titleTextStyle: AppTextStyles.bodyLarge.copyWith(
          color: AppColors.lightColorScheme.onSurface,
        ),
        subtitleTextStyle: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.lightColorScheme.onSurfaceVariant,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.medium,
          vertical: AppSpacing.small,
        ),
      ),
    );
  }

  /// Material You 3 dark theme for Android
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: AppColors.darkColorScheme,
      
      // Typography
      textTheme: GoogleFonts.josefinSansTextTheme(AppTextStyles.materialTextTheme),
      
      // App Bar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.darkColorScheme.surface,
        foregroundColor: AppColors.darkColorScheme.onSurface,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: AppTextStyles.headlineSmall.copyWith(
          color: AppColors.darkColorScheme.onSurface,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(
          color: AppColors.darkColorScheme.onSurface,
        ),
      ),
      
      // Card Theme
      cardTheme: CardThemeData(
        color: AppColors.darkColorScheme.surface,
        surfaceTintColor: AppColors.darkColorScheme.surfaceTint,
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
        ),
      ),
      
      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.darkColorScheme.primary,
          foregroundColor: AppColors.darkColorScheme.onPrimary,
          elevation: 1,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.large,
            vertical: AppSpacing.medium,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
          ),
          textStyle: AppTextStyles.labelLarge.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      
      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.darkColorScheme.primary,
          side: BorderSide(color: AppColors.darkColorScheme.outline),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.large,
            vertical: AppSpacing.medium,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
          ),
          textStyle: AppTextStyles.labelLarge.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      
      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.darkColorScheme.primary,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.medium,
            vertical: AppSpacing.small,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
          ),
          textStyle: AppTextStyles.labelLarge.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      
      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.darkColorScheme.surfaceContainerHighest,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
          borderSide: BorderSide(color: AppColors.darkColorScheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
          borderSide: BorderSide(
            color: AppColors.darkColorScheme.primary,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
          borderSide: BorderSide(color: AppColors.darkColorScheme.error),
        ),
        contentPadding: const EdgeInsets.all(AppSpacing.medium),
        labelStyle: AppTextStyles.bodyLarge.copyWith(
          color: AppColors.darkColorScheme.onSurfaceVariant,
        ),
        hintStyle: AppTextStyles.bodyLarge.copyWith(
          color: AppColors.darkColorScheme.onSurfaceVariant.withOpacity(0.6),
        ),
      ),
      
      // Dialog Theme
      dialogTheme: DialogThemeData(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
        ),
        titleTextStyle: AppTextStyles.headlineSmall.copyWith(
          color: AppColors.darkColorScheme.onSurface,
        ),
        contentTextStyle: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.darkColorScheme.onSurfaceVariant,
        ),
      ),
      
      // Bottom Sheet Theme
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: AppColors.darkColorScheme.surface,
        surfaceTintColor: AppColors.darkColorScheme.surfaceTint,
        elevation: 1,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppSpacing.radiusLarge),
          ),
        ),
      ),
      
      // Floating Action Button Theme
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.darkColorScheme.primaryContainer,
        foregroundColor: AppColors.darkColorScheme.onPrimaryContainer,
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
        ),
      ),
      
      // List Tile Theme
      listTileTheme: ListTileThemeData(
        tileColor: Colors.transparent,
        selectedTileColor: AppColors.darkColorScheme.secondaryContainer,
        iconColor: AppColors.darkColorScheme.onSurfaceVariant,
        textColor: AppColors.darkColorScheme.onSurface,
        titleTextStyle: AppTextStyles.bodyLarge.copyWith(
          color: AppColors.darkColorScheme.onSurface,
        ),
        subtitleTextStyle: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.darkColorScheme.onSurfaceVariant,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.medium,
          vertical: AppSpacing.small,
        ),
      ),
    );
  }

  /// iOS-style theme using Cupertino design language
  static CupertinoThemeData get cupertinoLightTheme {
    return CupertinoThemeData(
      brightness: Brightness.light,
      primaryColor: AppColors.iosPrimary,
      primaryContrastingColor: AppColors.iosOnPrimary,
      scaffoldBackgroundColor: AppColors.iosBackground,
      barBackgroundColor: AppColors.iosSystemBackground,
      textTheme: CupertinoTextThemeData(
        primaryColor: AppColors.iosLabel,
        textStyle: AppTextStyles.bodyLarge.copyWith(
          color: AppColors.iosLabel,
        ),
        actionTextStyle: AppTextStyles.bodyLarge.copyWith(
          color: AppColors.iosPrimary,
        ),
        tabLabelTextStyle: AppTextStyles.bodySmall.copyWith(
          color: AppColors.iosSecondaryLabel,
        ),
        navTitleTextStyle: AppTextStyles.headlineSmall.copyWith(
          color: AppColors.iosLabel,
          fontWeight: FontWeight.w600,
        ),
        navLargeTitleTextStyle: AppTextStyles.displaySmall.copyWith(
          color: AppColors.iosLabel,
          fontWeight: FontWeight.bold,
        ),
        navActionTextStyle: AppTextStyles.bodyLarge.copyWith(
          color: AppColors.iosPrimary,
        ),
        pickerTextStyle: AppTextStyles.bodyLarge.copyWith(
          color: AppColors.iosLabel,
        ),
        dateTimePickerTextStyle: AppTextStyles.bodyLarge.copyWith(
          color: AppColors.iosLabel,
        ),
      ),
    );
  }

  /// iOS-style dark theme using Cupertino design language
  static CupertinoThemeData get cupertinoDarkTheme {
    return CupertinoThemeData(
      brightness: Brightness.dark,
      primaryColor: AppColors.iosPrimary,
      primaryContrastingColor: AppColors.iosOnPrimary,
      scaffoldBackgroundColor: AppColors.iosBackgroundDark,
      barBackgroundColor: AppColors.iosSystemBackgroundDark,
      textTheme: CupertinoTextThemeData(
        primaryColor: AppColors.iosLabelDark,
        textStyle: AppTextStyles.bodyLarge.copyWith(
          color: AppColors.iosLabelDark,
        ),
        actionTextStyle: AppTextStyles.bodyLarge.copyWith(
          color: AppColors.iosPrimary,
        ),
        tabLabelTextStyle: AppTextStyles.bodySmall.copyWith(
          color: AppColors.iosSecondaryLabelDark,
        ),
        navTitleTextStyle: AppTextStyles.headlineSmall.copyWith(
          color: AppColors.iosLabelDark,
          fontWeight: FontWeight.w600,
        ),
        navLargeTitleTextStyle: AppTextStyles.displaySmall.copyWith(
          color: AppColors.iosLabelDark,
          fontWeight: FontWeight.bold,
        ),
        navActionTextStyle: AppTextStyles.bodyLarge.copyWith(
          color: AppColors.iosPrimary,
        ),
        pickerTextStyle: AppTextStyles.bodyLarge.copyWith(
          color: AppColors.iosLabelDark,
        ),
        dateTimePickerTextStyle: AppTextStyles.bodyLarge.copyWith(
          color: AppColors.iosLabelDark,
        ),
      ),
    );
  }

  /// Helper method to determine if current platform is iOS
  static bool get isIOS => Platform.isIOS;

  /// Helper method to get the appropriate theme data based on platform
  static ThemeData getThemeForPlatform({required bool isDark}) {
    if (isIOS) {
      // For iOS, we still use Material theme but with iOS-inspired colors
      return isDark ? darkTheme : lightTheme;
    }
    return isDark ? darkTheme : lightTheme;
  }

  /// Helper method to get Cupertino theme data
  static CupertinoThemeData getCupertinoTheme({required bool isDark}) {
    return isDark ? cupertinoDarkTheme : cupertinoLightTheme;
  }
}