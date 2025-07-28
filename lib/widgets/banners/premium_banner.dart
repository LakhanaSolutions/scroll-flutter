import 'package:flutter/material.dart';
import '../../theme/app_spacing.dart';
import '../text/app_text.dart';
import '../buttons/app_buttons.dart';
import '../cards/app_card_home.dart';

/// Premium upgrade banner widget to convince users to upgrade to premium
/// Shows premium benefits and call-to-action button
class PremiumBanner extends StatelessWidget {
  final String title;
  final String description;
  final List<String> benefits;
  final String actionText;
  final VoidCallback? onAction;
  final bool showBenefits;

  const PremiumBanner({
    super.key,
    this.title = 'Upgrade to Premium',
    this.description = 'Unlock unlimited access to our entire library',
    this.benefits = const [],
    this.actionText = 'Get Premium',
    this.onAction,
    this.showBenefits = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AppCardHome(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.medium,
        vertical: AppSpacing.small,
      ),
      padding: EdgeInsets.zero,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
          gradient: LinearGradient(
            colors: [
              colorScheme.primaryContainer.withValues(alpha: 0.6),
              colorScheme.primaryContainer.withValues(alpha: 0.4),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(AppSpacing.large),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.small),
                    decoration: BoxDecoration(
                      color: colorScheme.primary,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
                    ),
                    child: Icon(
                      Icons.star_rounded,
                      color: colorScheme.onPrimary,
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
                          color: colorScheme.onPrimaryContainer,
                        ),
                        const SizedBox(height: AppSpacing.extraSmall),
                        AppBodyText(
                          description,
                          color: colorScheme.onPrimaryContainer.withValues(alpha: 0.8),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (showBenefits && benefits.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.medium),
                ...benefits.take(3).map((benefit) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.extraSmall),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: colorScheme.primary,
                        size: AppSpacing.iconSmall,
                      ),
                      const SizedBox(width: AppSpacing.small),
                      Expanded(
                        child: AppCaptionText(
                          benefit,
                          color: colorScheme.onPrimaryContainer.withValues(alpha: 0.9),
                        ),
                      ),
                    ],
                  ),
                )),
              ],
              const SizedBox(height: AppSpacing.medium),
              SizedBox(
                width: double.infinity,
                child: AppPrimaryButton(
                  onPressed: onAction,
                  child: Text(actionText),
                ),
              ),
            ],
        ),
      ),
    );
  }
}