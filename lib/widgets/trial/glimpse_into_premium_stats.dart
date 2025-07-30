import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_spacing.dart';
import '../../providers/subscription_provider.dart';
import '../text/app_text.dart';
import '../buttons/app_buttons.dart';
import '../cards/app_card.dart';

/// Reusable widget that shows trial users their premium content usage stats
/// Displays remaining minutes, progress bar, and upgrade call-to-action
class GlimpseIntoPremiumStats extends ConsumerWidget {
  final bool isCompact;
  final VoidCallback? onUpgrade;
  final EdgeInsets? margin;
  final EdgeInsets? padding;

  const GlimpseIntoPremiumStats({
    super.key,
    this.isCompact = false,
    this.onUpgrade,
    this.margin,
    this.padding,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final trialUsage = ref.watch(trialUsageDataProvider);
    final isFreeTrial = ref.watch(isFreeTrialProvider);

    // Only show for trial users
    if (!isFreeTrial || trialUsage == null) {
      return const SizedBox.shrink();
    }

    return AppCard(
      margin: margin ?? const EdgeInsets.all(AppSpacing.medium),
      padding: padding ?? const EdgeInsets.all(AppSpacing.large),
      child: isCompact ? _buildCompactLayout(context, trialUsage, colorScheme) : _buildFullLayout(context, trialUsage, colorScheme),
    );
  }

  Widget _buildFullLayout(BuildContext context, TrialUsageData trialUsage, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.small),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
              ),
              child: Icon(
                Icons.star_rounded,
                color: colorScheme.onPrimaryContainer,
                size: AppSpacing.iconMedium,
              ),
            ),
            const SizedBox(width: AppSpacing.medium),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppSubtitleText(
                    'Premium Trial',
                    color: colorScheme.onSurface,
                  ),
                  const SizedBox(height: AppSpacing.extraSmall),
                  AppCaptionText(
                    '${trialUsage.remainingMinutes} minutes remaining this month',
                    color: colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.large),
        
        // Progress section
        _buildProgressSection(context, trialUsage, colorScheme),
        
        const SizedBox(height: AppSpacing.large),
        
        // Stats row
        _buildStatsRow(context, trialUsage, colorScheme),
        
        const SizedBox(height: AppSpacing.large),
        
        // Upgrade button
        SizedBox(
          width: double.infinity,
          child: AppPrimaryButton(
            onPressed: onUpgrade ?? () => context.push('/home/subscription'),
            child: const Text('Upgrade to Premium'),
          ),
        ),
      ],
    );
  }

  Widget _buildCompactLayout(BuildContext context, TrialUsageData trialUsage, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header row
        Row(
          children: [
            Icon(
              Icons.star_rounded,
              color: colorScheme.primary,
              size: AppSpacing.iconSmall,
            ),
            const SizedBox(width: AppSpacing.small),
            Expanded(
              child: AppCaptionText(
                'Premium Trial: ${trialUsage.remainingMinutes} min left',
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.small),
        
        // Progress bar
        _buildProgressBar(context, trialUsage, colorScheme),
        
        const SizedBox(height: AppSpacing.small),
        
        // Upgrade link
        GestureDetector(
          onTap: onUpgrade ?? () => context.push('/home/subscription'),
          child: AppCaptionText(
            'Upgrade to Premium →',
            color: colorScheme.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressSection(BuildContext context, TrialUsageData trialUsage, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppBodyText(
              'Premium Access',
              color: colorScheme.onSurface,
            ),
            AppBodyText(
              '${trialUsage.minutesUsed}/${trialUsage.maxMinutes} min',
              color: colorScheme.onSurfaceVariant,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.small),
        _buildProgressBar(context, trialUsage, colorScheme),
      ],
    );
  }

  Widget _buildProgressBar(BuildContext context, TrialUsageData trialUsage, ColorScheme colorScheme) {
    final progress = trialUsage.usagePercentage.clamp(0.0, 1.0);
    
    return Container(
      height: 8,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(4),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: progress,
        child: Container(
          decoration: BoxDecoration(
            color: _getProgressColor(progress, colorScheme),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }

  Widget _buildStatsRow(BuildContext context, TrialUsageData trialUsage, ColorScheme colorScheme) {
    return Row(
      children: [
        Expanded(
          child: _buildStatItem(
            context,
            Icons.access_time_rounded,
            '${trialUsage.minutesUsed}',
            'Minutes Used',
            colorScheme,
          ),
        ),
        const SizedBox(width: AppSpacing.medium),
        Expanded(
          child: _buildStatItem(
            context,
            Icons.timer_rounded,
            '${trialUsage.remainingMinutes}',
            'Remaining',
            colorScheme,
          ),
        ),
        const SizedBox(width: AppSpacing.medium),
        Expanded(
          child: _buildStatItem(
            context,
            Icons.calendar_month_rounded,
            'Monthly',
            'Resets',
            colorScheme,
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem(BuildContext context, IconData icon, String value, String label, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.medium),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: colorScheme.primary,
            size: AppSpacing.iconMedium,
          ),
          const SizedBox(height: AppSpacing.small),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.extraSmall),
          AppCaptionText(
            label,
            color: colorScheme.onSurfaceVariant,
          ),
        ],
      ),
    );
  }

  Color _getProgressColor(double progress, ColorScheme colorScheme) {
    if (progress < 0.5) {
      return colorScheme.primary;
    } else if (progress < 0.8) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }
}

/// Compact version specifically for floating action buttons
class GlimpseIntoPremiumStatsFAB extends ConsumerWidget {
  final VoidCallback? onPressed;

  const GlimpseIntoPremiumStatsFAB({
    super.key,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final trialUsage = ref.watch(trialUsageDataProvider);
    final isFreeTrial = ref.watch(isFreeTrialProvider);

    // Only show for trial users
    if (!isFreeTrial || trialUsage == null) {
      return const SizedBox.shrink();
    }

    return FloatingActionButton.extended(
      onPressed: onPressed,
      backgroundColor: colorScheme.primaryContainer,
      foregroundColor: colorScheme.onPrimaryContainer,
      icon: Icon(
        Icons.star_rounded,
        size: AppSpacing.iconSmall,
      ),
      label: Text(
        '${trialUsage.remainingMinutes} min left',
        style: theme.textTheme.labelMedium?.copyWith(
          color: colorScheme.onPrimaryContainer,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}