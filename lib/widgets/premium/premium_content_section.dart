import 'package:flutter/material.dart';
import '../../theme/app_spacing.dart';
import '../text/app_text.dart';
import '../buttons/app_buttons.dart';
import '../cards/app_card_home.dart';

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
    this.title = '✨ Premium Awaits You',
    this.description = 'Transform your spiritual journey with these exclusive benefits',
    required this.features,
    this.actionText = 'Get Premium',
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

    return AppCardHome(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.medium,
        vertical: AppSpacing.medium,
      ),
      padding: EdgeInsets.zero,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
          gradient: LinearGradient(
            colors: [
              colorScheme.primaryContainer.withValues(alpha: 0.3),
              colorScheme.secondaryContainer.withValues(alpha: 0.2),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(
            color: colorScheme.primary.withValues(alpha: 0.2),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: colorScheme.primary.withValues(alpha: 0.1),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(AppSpacing.large),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with premium icon
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.medium),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFFFFD700), // Gold
                          const Color(0xFFFFA500), // Orange
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFFD700).withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.diamond_rounded,
                      color: Colors.white,
                      size: AppSpacing.iconMedium,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.medium),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: colorScheme.onSurface,
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                          ),
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
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        colorScheme.primary,
                        colorScheme.primary.withValues(alpha: 0.8),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
                    boxShadow: [
                      BoxShadow(
                        color: colorScheme.primary.withValues(alpha: 0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
                      onTap: onAction,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: AppSpacing.medium,
                          horizontal: AppSpacing.large,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.rocket_launch_rounded,
                              color: colorScheme.onPrimary,
                              size: AppSpacing.iconMedium,
                            ),
                            const SizedBox(width: AppSpacing.small),
                            Text(
                              actionText,
                              style: theme.textTheme.titleSmall?.copyWith(
                                color: colorScheme.onPrimary,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
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
    if (lowerFeature.contains('offline') || lowerFeature.contains('anytime')) return Icons.offline_bolt_rounded;
    if (lowerFeature.contains('immerse') || lowerFeature.contains('interruptions')) return Icons.headphones_rounded;
    if (lowerFeature.contains('exclusive') || lowerFeature.contains('libraries')) return Icons.library_books_rounded;
    if (lowerFeature.contains('devices') || lowerFeature.contains('seamlessly')) return Icons.devices_rounded;
    if (lowerFeature.contains('first') || lowerFeature.contains('discover')) return Icons.explore_rounded;
    if (lowerFeature.contains('crystal') || lowerFeature.contains('audio')) return Icons.graphic_eq_rounded;
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
        gradient: LinearGradient(
          colors: [
            Colors.white.withValues(alpha: 0.8),
            Colors.white.withValues(alpha: 0.4),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
        border: Border.all(
          color: colorScheme.primary.withValues(alpha: 0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.small),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF00D2FF), // Teal
                  const Color(0xFF3A7BD5), // Blue
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF00D2FF).withValues(alpha: 0.3),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: AppSpacing.iconSmall,
            ),
          ),
          const SizedBox(width: AppSpacing.medium),
          Expanded(
            child: Text(
              feature,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
          Icon(
            Icons.check_circle_rounded,
            color: const Color(0xFF4CAF50),
            size: AppSpacing.iconMedium,
          ),
        ],
      ),
    );
  }
}