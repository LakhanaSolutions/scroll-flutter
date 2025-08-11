import 'package:flutter/material.dart';
import '../../theme/app_spacing.dart';

/// Modern app card widget with no border and prominent shadow
/// Provides consistent card styling across the application
class AppCard extends StatelessWidget {
  /// Creates an [AppCard]
  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.gradient,
    this.elevation,
    this.borderRadius,
    this.onTap,
  });

  /// The widget to display inside the card
  final Widget child;
  
  /// Internal padding for the card content
  final EdgeInsetsGeometry? padding;
  
  /// External margin around the card
  final EdgeInsetsGeometry? margin;
  
  /// Background color override
  final Color? backgroundColor;
  
  /// Gradient background override
  final Gradient? gradient;
  
  /// Shadow elevation override
  final double? elevation;
  
  /// Border radius override
  final BorderRadius? borderRadius;
  
  /// Tap callback for the card
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: margin ?? const EdgeInsets.all(AppSpacing.extraSmall),
      child: Material(
        color: gradient != null ? Colors.transparent : (backgroundColor ?? colorScheme.surface),
        borderRadius: borderRadius ?? BorderRadius.circular(AppSpacing.radiusLarge),
        elevation: elevation ?? AppSpacing.elevationMax,
        shadowColor: colorScheme.shadow.withValues(alpha: 0.2),
        child: Container(
          decoration: gradient != null ? BoxDecoration(
            gradient: gradient,
            borderRadius: borderRadius ?? BorderRadius.circular(AppSpacing.radiusLarge),
          ) : null,
          child: InkWell(
            onTap: onTap,
            borderRadius: borderRadius ?? BorderRadius.circular(AppSpacing.radiusLarge),
            child: Padding(
              padding: padding ?? const EdgeInsets.all(AppSpacing.small),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

/// Compact app card variant with smaller padding and elevation
class AppCardCompact extends StatelessWidget {
  /// Creates an [AppCardCompact]
  const AppCardCompact({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.gradient,
    this.onTap,
  });

  /// The widget to display inside the card
  final Widget child;
  
  /// Internal padding for the card content
  final EdgeInsetsGeometry? padding;
  
  /// External margin around the card
  final EdgeInsetsGeometry? margin;
  
  /// Background color override
  final Color? backgroundColor;
  
  /// Gradient background override
  final Gradient? gradient;
  
  /// Tap callback for the card
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: padding ?? const EdgeInsets.all(AppSpacing.small),
      margin: margin ?? const EdgeInsets.all(AppSpacing.extraSmall),
      backgroundColor: backgroundColor,
      gradient: gradient,
      elevation: AppSpacing.elevationMedium,
      borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
      onTap: onTap,
      child: child,
    );
  }
}

/// Elevated app card variant with more prominent shadow
class AppCardElevated extends StatelessWidget {
  /// Creates an [AppCardElevated]
  const AppCardElevated({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.gradient,
    this.onTap,
  });

  /// The widget to display inside the card
  final Widget child;
  
  /// Internal padding for the card content
  final EdgeInsetsGeometry? padding;
  
  /// External margin around the card
  final EdgeInsetsGeometry? margin;
  
  /// Background color override
  final Color? backgroundColor;
  
  /// Gradient background override
  final Gradient? gradient;
  
  /// Tap callback for the card
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: padding,
      margin: margin,
      backgroundColor: backgroundColor,
      gradient: gradient,
      elevation: AppSpacing.elevationExtraLarge,
      onTap: onTap,
      child: child,
    );
  }
}

/// Flat app card variant with minimal shadow
class AppCardFlat extends StatelessWidget {
  /// Creates an [AppCardFlat]
  const AppCardFlat({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.gradient,
    this.onTap,
  });

  /// The widget to display inside the card
  final Widget child;
  
  /// Internal padding for the card content
  final EdgeInsetsGeometry? padding;
  
  /// External margin around the card
  final EdgeInsetsGeometry? margin;
  
  /// Background color override
  final Color? backgroundColor;
  
  /// Gradient background override
  final Gradient? gradient;
  
  /// Tap callback for the card
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: padding,
      margin: margin,
      backgroundColor: backgroundColor,
      gradient: gradient,
      elevation: AppSpacing.elevationSmall,
      onTap: onTap,
      child: child,
    );
  }
}