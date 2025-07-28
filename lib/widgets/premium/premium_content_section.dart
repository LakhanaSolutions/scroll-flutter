import 'package:flutter/material.dart';
import '../../theme/app_spacing.dart';
import '../text/app_text.dart';
import '../buttons/app_buttons.dart';

/// Premium exclusive content section widget
/// Shows trial users what premium features they're missing out on
class PremiumContentSection extends StatelessWidget {
  final String title;
  final String description;
  final List<String> features;
  final String actionText;
  final VoidCallback? onAction;
  final bool showFeatures;

  const PremiumContentSection({
    super.key,
    this.title = 'Premium Exclusive Content',
    this.description = 'Unlock these amazing features with Premium',
    required this.features,
    this.actionText = 'Try Premium',
    this.onAction,
    this.showFeatures = true,
  });

  @override
  Widget build(BuildContext context) {
    if (features.isEmpty) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.medium,
        vertical: AppSpacing.medium,
      ),
      child: Material(
        color: colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
        elevation: AppSpacing.elevationMedium,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
            border: Border.all(
              color: colorScheme.outline.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          padding: const EdgeInsets.all(AppSpacing.large),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with premium icon
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.small),
                    decoration: BoxDecoration(
                      color: colorScheme.secondary,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
                    ),
                    child: Icon(
                      Icons.workspace_premium_rounded,
                      color: colorScheme.onSecondary,
                      size: AppSpacing.iconMedium,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.medium),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppSubtitleText(
                          title,
                          color: colorScheme.onSurface,
                        ),
                        const SizedBox(height: AppSpacing.extraSmall),
                        AppBodyText(
                          description,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (showFeatures && features.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.large),
                // Premium features grid
                _buildFeaturesGrid(context, features),
              ],
              const SizedBox(height: AppSpacing.large),
              // Action button
              SizedBox(
                width: double.infinity,
                child: AppSecondaryButton(
                  onPressed: onAction,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.star_rounded,
                        size: AppSpacing.iconSmall,
                      ),
                      const SizedBox(width: AppSpacing.small),
                      Text(actionText),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeaturesGrid(BuildContext context, List<String> features) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      children: features.map((feature) => Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.small),
        child: _PremiumFeatureItem(
          feature: feature,
          icon: _getFeatureIcon(feature),
          color: colorScheme.secondary,
        ),
      )).toList(),
    );
  }

  IconData _getFeatureIcon(String feature) {
    final lowerFeature = feature.toLowerCase();
    if (lowerFeature.contains('download')) return Icons.download_rounded;
    if (lowerFeature.contains('ad-free') || lowerFeature.contains('ads')) return Icons.block_rounded;
    if (lowerFeature.contains('exclusive')) return Icons.diamond_rounded;
    if (lowerFeature.contains('sync')) return Icons.sync_rounded;
    if (lowerFeature.contains('early') || lowerFeature.contains('access')) return Icons.fast_forward_rounded;
    if (lowerFeature.contains('quality') || lowerFeature.contains('hd')) return Icons.high_quality_rounded;
    return Icons.star_rounded;
  }
}

/// Individual premium feature item
class _PremiumFeatureItem extends StatelessWidget {
  final String feature;
  final IconData icon;
  final Color color;

  const _PremiumFeatureItem({
    required this.feature,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.medium),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.small),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
            ),
            child: Icon(
              icon,
              color: color,
              size: AppSpacing.iconSmall,
            ),
          ),
          const SizedBox(width: AppSpacing.medium),
          Expanded(
            child: AppBodyText(
              feature,
              color: colorScheme.onSurface,
            ),
          ),
          Icon(
            Icons.lock_rounded,
            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            size: AppSpacing.iconSmall,
          ),
        ],
      ),
    );
  }
}