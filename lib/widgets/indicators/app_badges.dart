import 'package:flutter/material.dart';
import '../../data/mock_data.dart';
import '../../theme/app_spacing.dart';

/// Comprehensive badge system for consistent badge styling throughout the app
/// Handles availability badges, status badges, and other indicator badges

/// Badge for showing content availability (free, premium, trial)
class AppAvailabilityBadge extends StatelessWidget {
  final AvailabilityType availability;
  final EdgeInsets? padding;
  final double? fontSize;

  const AppAvailabilityBadge({
    super.key,
    required this.availability,
    this.padding,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    Color badgeColor;
    IconData badgeIcon;
    String badgeText;

    switch (availability) {
      case AvailabilityType.free:
        badgeColor = colorScheme.tertiary;
        badgeIcon = Icons.public_rounded;
        badgeText = 'FREE';
        break;
      case AvailabilityType.premium:
        badgeColor = colorScheme.secondary;
        badgeIcon = Icons.star_rounded;
        badgeText = 'PREMIUM';
        break;
      case AvailabilityType.trial:
        badgeColor = colorScheme.error;
        badgeIcon = Icons.timer_rounded;
        badgeText = 'TRIAL';
        break;
    }

    return Container(
      padding: padding ?? const EdgeInsets.symmetric(
        horizontal: AppSpacing.small,
        vertical: AppSpacing.extraSmall,
      ),
      decoration: BoxDecoration(
        color: badgeColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSpacing.radiusExtraSmall),
        border: Border.all(
          color: badgeColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            badgeIcon,
            color: badgeColor,
            size: AppSpacing.iconExtraSmall,
          ),
          const SizedBox(width: AppSpacing.extraSmall),
          Text(
            badgeText,
            style: theme.textTheme.labelSmall?.copyWith(
              color: badgeColor,
              fontWeight: FontWeight.bold,
              fontSize: fontSize ?? 9,
            ),
          ),
        ],
      ),
    );
  }
}

/// Badge for showing following status
class AppFollowingBadge extends StatelessWidget {
  final bool isFollowing;
  final EdgeInsets? padding;
  final double? fontSize;

  const AppFollowingBadge({
    super.key,
    required this.isFollowing,
    this.padding,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    if (!isFollowing) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: padding ?? const EdgeInsets.symmetric(
        horizontal: AppSpacing.extraSmall,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(AppSpacing.radiusExtraSmall),
      ),
      child: Text(
        'FOLLOWING',
        style: theme.textTheme.labelSmall?.copyWith(
          color: colorScheme.onPrimaryContainer,
          fontWeight: FontWeight.bold,
          fontSize: fontSize ?? 8,
        ),
      ),
    );
  }
}

/// Generic status badge for various states
class AppStatusBadge extends StatelessWidget {
  final String text;
  final Color color;
  final IconData? icon;
  final EdgeInsets? padding;
  final double? fontSize;
  final bool outlined;

  const AppStatusBadge({
    super.key,
    required this.text,
    required this.color,
    this.icon,
    this.padding,
    this.fontSize,
    this.outlined = false,
  });

  /// Creates a badge for progress/completion status
  const AppStatusBadge.progress({
    super.key,
    required this.text,
    this.icon,
    this.padding,
    this.fontSize,
    this.outlined = false,
  }) : color = Colors.blue;

  /// Creates a badge for success status
  const AppStatusBadge.success({
    super.key,
    required this.text,
    this.icon,
    this.padding,
    this.fontSize,
    this.outlined = false,
  }) : color = Colors.green;

  /// Creates a badge for warning status
  const AppStatusBadge.warning({
    super.key,
    required this.text,
    this.icon,
    this.padding,
    this.fontSize,
    this.outlined = false,
  }) : color = Colors.orange;

  /// Creates a badge for error status
  const AppStatusBadge.error({
    super.key,
    required this.text,
    this.icon,
    this.padding,
    this.fontSize,
    this.outlined = false,
  }) : color = Colors.red;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: padding ?? const EdgeInsets.symmetric(
        horizontal: AppSpacing.small,
        vertical: AppSpacing.extraSmall,
      ),
      decoration: BoxDecoration(
        color: outlined ? Colors.transparent : color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSpacing.radiusExtraSmall),
        border: Border.all(
          color: color.withValues(alpha: outlined ? 1.0 : 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              color: color,
              size: AppSpacing.iconExtraSmall,
            ),
            const SizedBox(width: AppSpacing.extraSmall),
          ],
          Text(
            text,
            style: theme.textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: fontSize ?? 9,
            ),
          ),
        ],
      ),
    );
  }
}

/// Badge for showing count with a red circle indicator
class AppCountBadge extends StatelessWidget {
  final int count;
  final double? size;
  final Color? color;

  const AppCountBadge({
    super.key,
    required this.count,
    this.size,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    if (count == 0) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final badgeSize = size ?? 18;

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: color ?? colorScheme.error,
        shape: BoxShape.circle,
      ),
      constraints: BoxConstraints(
        minWidth: badgeSize,
        minHeight: badgeSize,
      ),
      child: Text(
        count > 99 ? '99+' : count.toString(),
        style: theme.textTheme.labelSmall?.copyWith(
          color: colorScheme.onError,
          fontWeight: FontWeight.bold,
          fontSize: 10,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

/// Badge for showing premium features
class AppPremiumBadge extends StatelessWidget {
  final EdgeInsets? padding;
  final double? fontSize;

  const AppPremiumBadge({
    super.key,
    this.padding,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: padding ?? const EdgeInsets.symmetric(
        horizontal: AppSpacing.small,
        vertical: AppSpacing.extraSmall,
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppSpacing.radiusExtraSmall),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFFD700).withValues(alpha: 0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.star_rounded,
            color: Colors.white,
            size: AppSpacing.iconExtraSmall,
          ),
          const SizedBox(width: AppSpacing.extraSmall),
          Text(
            'PREMIUM',
            style: theme.textTheme.labelSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: fontSize ?? 9,
            ),
          ),
        ],
      ),
    );
  }
}

/// Badge for showing language indicator
class AppLanguageBadge extends StatelessWidget {
  final String language;
  final EdgeInsets? padding;
  final double? fontSize;

  const AppLanguageBadge({
    super.key,
    required this.language,
    this.padding,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    IconData languageIcon;
    Color badgeColor;
    Color textColor;

    // Set language-specific styling
    switch (language.toLowerCase()) {
      case 'arabic':
        languageIcon = Icons.language_rounded;
        badgeColor = colorScheme.primaryContainer;
        textColor = colorScheme.onPrimaryContainer;
        break;
      case 'english':
        languageIcon = Icons.translate_rounded;
        badgeColor = colorScheme.secondaryContainer;
        textColor = colorScheme.onSecondaryContainer;
        break;
      case 'urdu':
        languageIcon = Icons.record_voice_over_rounded;
        badgeColor = colorScheme.tertiaryContainer;
        textColor = colorScheme.onTertiaryContainer;
        break;
      default:
        languageIcon = Icons.language_rounded;
        badgeColor = colorScheme.surfaceContainer;
        textColor = colorScheme.onSurface;
    }

    return Container(
      padding: padding ?? const EdgeInsets.symmetric(
        horizontal: AppSpacing.small,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: badgeColor,
        borderRadius: BorderRadius.circular(AppSpacing.radiusExtraSmall),
        border: Border.all(
          color: textColor.withValues(alpha: 0.2),
          width: 0.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            languageIcon,
            color: textColor,
            size: AppSpacing.iconExtraSmall,
          ),
          const SizedBox(width: AppSpacing.extraSmall),
          Text(
            language.toUpperCase(),
            style: theme.textTheme.labelSmall?.copyWith(
              color: textColor,
              fontWeight: FontWeight.w600,
              fontSize: fontSize ?? 9,
            ),
          ),
        ],
      ),
    );
  }
}