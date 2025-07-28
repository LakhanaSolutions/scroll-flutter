import 'package:flutter/material.dart';
import '../../theme/app_spacing.dart';

/// Light app card variant specifically for home tab with no shadows
/// Uses lighter background colors and no elevation
class AppCardHome extends StatelessWidget {
  /// Creates an [AppCardHome]
  const AppCardHome({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.onTap,
  });

  /// The widget to display inside the card
  final Widget child;
  
  /// Internal padding for the card content
  final EdgeInsetsGeometry? padding;
  
  /// External margin around the card
  final EdgeInsetsGeometry? margin;
  
  /// Tap callback for the card
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: margin ?? const EdgeInsets.all(AppSpacing.small),
      child: Material(
        color: colorScheme.surface.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
        elevation: 0, // No shadow for home tab cards
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
          child: Padding(
            padding: padding ?? const EdgeInsets.all(AppSpacing.medium),
            child: child,
          ),
        ),
      ),
    );
  }
}