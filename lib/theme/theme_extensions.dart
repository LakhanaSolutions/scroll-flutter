import 'dart:io';
import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_spacing.dart';
import 'app_gradients.dart';

/// Platform-specific theme extensions for the Siraaj app
/// Provides iOS-specific design tokens and behaviors
@immutable
class AppThemeExtension extends ThemeExtension<AppThemeExtension> {
  /// Creates an [AppThemeExtension]
  const AppThemeExtension({
    required this.success,
    required this.onSuccess,
    required this.successContainer,
    required this.onSuccessContainer,
    required this.warning,
    required this.onWarning,
    required this.warningContainer,
    required this.onWarningContainer,
    required this.info,
    required this.onInfo,
    required this.infoContainer,
    required this.onInfoContainer,
    required this.brand,
    required this.onBrand,
    required this.brandContainer,
    required this.onBrandContainer,
    required this.isIOS,
    required this.cardElevation,
    required this.dialogElevation,
    required this.bottomSheetElevation,
    required this.fabElevation,
    required this.iosBackground,
    required this.iosSystemBackground,
  });

  /// Success color
  final Color success;
  
  /// On success color
  final Color onSuccess;
  
  /// Success container color
  final Color successContainer;
  
  /// On success container color
  final Color onSuccessContainer;
  
  /// Warning color
  final Color warning;
  
  /// On warning color
  final Color onWarning;
  
  /// Warning container color
  final Color warningContainer;
  
  /// On warning container color
  final Color onWarningContainer;
  
  /// Info color
  final Color info;
  
  /// On info color
  final Color onInfo;
  
  /// Info container color
  final Color infoContainer;
  
  /// On info container color
  final Color onInfoContainer;
  
  /// Brand color
  final Color brand;
  
  /// On brand color
  final Color onBrand;
  
  /// Brand container color
  final Color brandContainer;
  
  /// On brand container color
  final Color onBrandContainer;
  
  /// Whether the current platform is iOS
  final bool isIOS;
  
  /// Card elevation
  final double cardElevation;
  
  /// Dialog elevation
  final double dialogElevation;
  
  /// Bottom sheet elevation
  final double bottomSheetElevation;
  
  /// Floating action button elevation
  final double fabElevation;
  
  /// iOS-inspired background color
  final Color iosBackground;
  
  /// iOS-inspired system background color
  final Color iosSystemBackground;

  /// Light theme extension
  static const AppThemeExtension light = AppThemeExtension(
    success: AppColors.successLight,
    onSuccess: AppColors.onSuccessLight,
    successContainer: AppColors.successContainerLight,
    onSuccessContainer: AppColors.onSuccessContainerLight,
    warning: AppColors.warningLight,
    onWarning: AppColors.onWarningLight,
    warningContainer: AppColors.warningContainerLight,
    onWarningContainer: AppColors.onWarningContainerLight,
    info: AppColors.infoLight,
    onInfo: AppColors.onInfoLight,
    infoContainer: AppColors.infoContainerLight,
    onInfoContainer: AppColors.onInfoContainerLight,
    brand: AppColors.brandPrimary,
    onBrand: Colors.white,
    brandContainer: AppColors.brandSecondary,
    onBrandContainer: Colors.black,
    isIOS: false, // Will be set dynamically
    cardElevation: AppSpacing.elevationSmall,
    dialogElevation: AppSpacing.elevationExtraLarge,
    bottomSheetElevation: AppSpacing.elevationMedium,
    fabElevation: AppSpacing.elevationLarge,
    iosBackground: AppColors.iosLightBackground,
    iosSystemBackground: AppColors.iosLightSystemBackground,
  );

  /// Dark theme extension
  static const AppThemeExtension dark = AppThemeExtension(
    success: AppColors.successDark,
    onSuccess: AppColors.onSuccessDark,
    successContainer: AppColors.successContainerDark,
    onSuccessContainer: AppColors.onSuccessContainerDark,
    warning: AppColors.warningDark,
    onWarning: AppColors.onWarningDark,
    warningContainer: AppColors.warningContainerDark,
    onWarningContainer: AppColors.onWarningContainerDark,
    info: AppColors.infoDark,
    onInfo: AppColors.onInfoDark,
    infoContainer: AppColors.infoContainerDark,
    onInfoContainer: AppColors.onInfoContainerDark,
    brand: AppColors.brandPrimary,
    onBrand: Colors.white,
    brandContainer: AppColors.brandSecondaryDark,
    onBrandContainer: Colors.white,
    isIOS: false, // Will be set dynamically
    cardElevation: AppSpacing.elevationSmall,
    dialogElevation: AppSpacing.elevationExtraLarge,
    bottomSheetElevation: AppSpacing.elevationMedium,
    fabElevation: AppSpacing.elevationLarge,
    iosBackground: AppColors.iosDarkBackground,
    iosSystemBackground: AppColors.iosDarkSystemBackground,
  );

  /// iOS light theme extension with minimal elevations
  static const AppThemeExtension iosLight = AppThemeExtension(
    success: AppColors.successLight,
    onSuccess: AppColors.onSuccessLight,
    successContainer: AppColors.successContainerLight,
    onSuccessContainer: AppColors.onSuccessContainerLight,
    warning: AppColors.warningLight,
    onWarning: AppColors.onWarningLight,
    warningContainer: AppColors.warningContainerLight,
    onWarningContainer: AppColors.onWarningContainerLight,
    info: AppColors.infoLight,
    onInfo: AppColors.onInfoLight,
    infoContainer: AppColors.infoContainerLight,
    onInfoContainer: AppColors.onInfoContainerLight,
    brand: AppColors.iosPrimary,
    onBrand: AppColors.iosOnPrimary,
    brandContainer: AppColors.iosSystemBackground,
    onBrandContainer: AppColors.iosLabel,
    isIOS: true,
    cardElevation: AppSpacing.elevationNone, // iOS uses minimal elevation
    dialogElevation: AppSpacing.elevationNone,
    bottomSheetElevation: AppSpacing.elevationNone,
    fabElevation: AppSpacing.elevationSmall,
    iosBackground: AppColors.iosLightBackground,
    iosSystemBackground: AppColors.iosLightSystemBackground,
  );

  /// iOS dark theme extension with minimal elevations
  static const AppThemeExtension iosDark = AppThemeExtension(
    success: AppColors.successDark,
    onSuccess: AppColors.onSuccessDark,
    successContainer: AppColors.successContainerDark,
    onSuccessContainer: AppColors.onSuccessContainerDark,
    warning: AppColors.warningDark,
    onWarning: AppColors.onWarningDark,
    warningContainer: AppColors.warningContainerDark,
    onWarningContainer: AppColors.onWarningContainerDark,
    info: AppColors.infoDark,
    onInfo: AppColors.onInfoDark,
    infoContainer: AppColors.infoContainerDark,
    onInfoContainer: AppColors.onInfoContainerDark,
    brand: AppColors.iosPrimary,
    onBrand: AppColors.iosOnPrimary,
    brandContainer: AppColors.iosSystemBackgroundDark,
    onBrandContainer: AppColors.iosLabelDark,
    isIOS: true,
    cardElevation: AppSpacing.elevationNone,
    dialogElevation: AppSpacing.elevationNone,
    bottomSheetElevation: AppSpacing.elevationNone,
    fabElevation: AppSpacing.elevationSmall,
    iosBackground: AppColors.iosDarkBackground,
    iosSystemBackground: AppColors.iosDarkSystemBackground,
  );

  @override
  AppThemeExtension copyWith({
    Color? success,
    Color? onSuccess,
    Color? successContainer,
    Color? onSuccessContainer,
    Color? warning,
    Color? onWarning,
    Color? warningContainer,
    Color? onWarningContainer,
    Color? info,
    Color? onInfo,
    Color? infoContainer,
    Color? onInfoContainer,
    Color? brand,
    Color? onBrand,
    Color? brandContainer,
    Color? onBrandContainer,
    bool? isIOS,
    double? cardElevation,
    double? dialogElevation,
    double? bottomSheetElevation,
    double? fabElevation,
    Color? iosBackground,
    Color? iosSystemBackground,
  }) {
    return AppThemeExtension(
      success: success ?? this.success,
      onSuccess: onSuccess ?? this.onSuccess,
      successContainer: successContainer ?? this.successContainer,
      onSuccessContainer: onSuccessContainer ?? this.onSuccessContainer,
      warning: warning ?? this.warning,
      onWarning: onWarning ?? this.onWarning,
      warningContainer: warningContainer ?? this.warningContainer,
      onWarningContainer: onWarningContainer ?? this.onWarningContainer,
      info: info ?? this.info,
      onInfo: onInfo ?? this.onInfo,
      infoContainer: infoContainer ?? this.infoContainer,
      onInfoContainer: onInfoContainer ?? this.onInfoContainer,
      brand: brand ?? this.brand,
      onBrand: onBrand ?? this.onBrand,
      brandContainer: brandContainer ?? this.brandContainer,
      onBrandContainer: onBrandContainer ?? this.onBrandContainer,
      isIOS: isIOS ?? this.isIOS,
      cardElevation: cardElevation ?? this.cardElevation,
      dialogElevation: dialogElevation ?? this.dialogElevation,
      bottomSheetElevation: bottomSheetElevation ?? this.bottomSheetElevation,
      fabElevation: fabElevation ?? this.fabElevation,
      iosBackground: iosBackground ?? this.iosBackground,
      iosSystemBackground: iosSystemBackground ?? this.iosSystemBackground,
    );
  }

  @override
  AppThemeExtension lerp(AppThemeExtension? other, double t) {
    if (other is! AppThemeExtension) {
      return this;
    }
    return AppThemeExtension(
      success: Color.lerp(success, other.success, t)!,
      onSuccess: Color.lerp(onSuccess, other.onSuccess, t)!,
      successContainer: Color.lerp(successContainer, other.successContainer, t)!,
      onSuccessContainer: Color.lerp(onSuccessContainer, other.onSuccessContainer, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      onWarning: Color.lerp(onWarning, other.onWarning, t)!,
      warningContainer: Color.lerp(warningContainer, other.warningContainer, t)!,
      onWarningContainer: Color.lerp(onWarningContainer, other.onWarningContainer, t)!,
      info: Color.lerp(info, other.info, t)!,
      onInfo: Color.lerp(onInfo, other.onInfo, t)!,
      infoContainer: Color.lerp(infoContainer, other.infoContainer, t)!,
      onInfoContainer: Color.lerp(onInfoContainer, other.onInfoContainer, t)!,
      brand: Color.lerp(brand, other.brand, t)!,
      onBrand: Color.lerp(onBrand, other.onBrand, t)!,
      brandContainer: Color.lerp(brandContainer, other.brandContainer, t)!,
      onBrandContainer: Color.lerp(onBrandContainer, other.onBrandContainer, t)!,
      isIOS: t < 0.5 ? isIOS : other.isIOS,
      cardElevation: (1.0 - t) * cardElevation + t * other.cardElevation,
      dialogElevation: (1.0 - t) * dialogElevation + t * other.dialogElevation,
      bottomSheetElevation: (1.0 - t) * bottomSheetElevation + t * other.bottomSheetElevation,
      fabElevation: (1.0 - t) * fabElevation + t * other.fabElevation,
      iosBackground: Color.lerp(iosBackground, other.iosBackground, t)!,
      iosSystemBackground: Color.lerp(iosSystemBackground, other.iosSystemBackground, t)!,
    );
  }

  /// Get the appropriate extension for the current platform and theme
  static AppThemeExtension getForPlatform({required bool isDark}) {
    if (Platform.isIOS) {
      return isDark ? iosDark : iosLight;
    }
    return isDark ? dark : light;
  }
}

/// Extension to easily access the theme extension from BuildContext
extension AppThemeExtensionGetter on BuildContext {
  /// Get the app theme extension
  AppThemeExtension get appTheme => Theme.of(this).extension<AppThemeExtension>()!;

  /// Get the color scheme
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  /// Standard surface gradient from low to highest container
  LinearGradient get surfaceGradient => AppGradients.surfaceGradient(colorScheme);

  /// Subtle surface gradient with transparency
  LinearGradient get subtleSurfaceGradient => AppGradients.subtleSurfaceGradient(colorScheme);

  /// Primary gradient using primary colors
  LinearGradient get primaryGradient => AppGradients.primaryGradient(colorScheme);

  /// Secondary gradient using secondary colors
  LinearGradient get secondaryGradient => AppGradients.secondaryGradient(colorScheme);

  /// Tertiary gradient using tertiary colors
  LinearGradient get tertiaryGradient => AppGradients.tertiaryGradient(colorScheme);

  /// Error gradient using error colors
  LinearGradient get errorGradient => AppGradients.errorGradient(colorScheme);

  /// Success gradient using green tones
  LinearGradient get successGradient => AppGradients.successGradient(colorScheme);

  /// Warning gradient using orange tones
  LinearGradient get warningGradient => AppGradients.warningGradient(colorScheme);

  /// Premium gradient with gold tones
  LinearGradient get premiumGradient => AppGradients.premiumGradient(colorScheme);

  /// Glass morphism gradient with transparency
  LinearGradient get glassGradient => AppGradients.glassGradient(colorScheme);

  /// Radial gradient for spotlight effects
  RadialGradient get spotlightGradient => AppGradients.spotlightGradient(colorScheme);

  /// Sweep gradient for circular elements
  SweepGradient get sweepGradient => AppGradients.sweepGradient(colorScheme);
}

/// Extension to easily access the theme extension from ThemeData
extension AppThemeDataExtension on ThemeData {
  /// Get the app theme extension
  AppThemeExtension get appTheme => extension<AppThemeExtension>()!;
}