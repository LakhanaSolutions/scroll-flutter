import 'package:flutter/material.dart';
import '../theme/app_spacing.dart';
import '../widgets/text/app_text.dart';
import '../widgets/cards/app_card.dart';
import '../widgets/buttons/app_buttons.dart';

enum SubscriptionType { trial, basic, premium, family }

class SubscriptionPlan {
  final String id;
  final String name;
  final String price;
  final String period;
  final String originalPrice;
  final String discount;
  final List<String> features;
  final List<String> limitations;
  final Color accentColor;
  final bool isPopular;
  final bool isCurrent;

  SubscriptionPlan({
    required this.id,
    required this.name,
    required this.price,
    required this.period,
    this.originalPrice = '',
    this.discount = '',
    required this.features,
    this.limitations = const [],
    required this.accentColor,
    this.isPopular = false,
    this.isCurrent = false,
  });
}

/// Subscription screen showing all available plans with benefits
class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  
  List<SubscriptionPlan> get _subscriptionPlans => [
    SubscriptionPlan(
      id: 'trial',
      name: 'Free Trial',
      price: 'Free',
      period: '14 days',
      features: [
        'Access to basic Islamic content',
        'Limited downloads (5 per month)',
        'Standard audio quality',
        'Basic search functionality',
        'Community support',
      ],
      limitations: [
        'Limited to 5 downloads per month',
        'Ads between content',
        'No offline premium content',
      ],
      accentColor: Colors.grey,
      isCurrent: true,
    ),
    SubscriptionPlan(
      id: 'basic',
      name: 'Basic',
      price: '\$4.99',
      period: 'month',
      originalPrice: '\$6.99',
      discount: '29% OFF',
      features: [
        'Ad-free listening experience',
        'Unlimited downloads',
        'High-quality audio (320kbps)',
        'Access to exclusive basic content',
        'Priority customer support',
        'Sync across 2 devices',
      ],
      accentColor: const Color(0xFF2196F3),
      isPopular: false,
    ),
    SubscriptionPlan(
      id: 'premium',
      name: 'Premium',
      price: '\$9.99',
      period: 'month',
      originalPrice: '\$14.99',
      discount: '33% OFF',
      features: [
        'Everything in Basic plan',
        'Access to premium Islamic content',
        'Early access to new releases',
        'Offline reading mode',
        'Advanced search and filters',
        'Sync across unlimited devices',
        'HD audio quality (FLAC)',
        'Exclusive scholarly content',
        'Priority narrator requests',
      ],
      accentColor: const Color(0xFF4CAF50),
      isPopular: true,
    ),
    SubscriptionPlan(
      id: 'family',
      name: 'Family',
      price: '\$14.99',
      period: 'month',
      originalPrice: '\$19.99',
      discount: '25% OFF',
      features: [
        'Everything in Premium plan',
        'Up to 6 family member accounts',
        'Individual profiles and preferences',
        'Parental controls for kids content',
        'Family sharing library',
        'Kids-only content section',
        'Screen time management',
        'Family listening history',
        'Bulk download management',
      ],
      accentColor: const Color(0xFF9C27B0),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F7), // iOS background
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_rounded,
            color: colorScheme.onSurface,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(
          children: [
            Icon(
              Icons.subscriptions_rounded,
              color: colorScheme.primary,
              size: AppSpacing.iconMedium,
            ),
            const SizedBox(width: AppSpacing.small),
            const AppTitleText('Subscription Plans'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Header section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.large),
            child: Column(
              children: [
                Icon(
                  Icons.star_rounded,
                  size: 48,
                  color: colorScheme.primary,
                ),
                const SizedBox(height: AppSpacing.medium),
                AppTitleText(
                  'Unlock Premium Islamic Content',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.small),
                AppBodyText(
                  'Choose the perfect plan for your spiritual journey',
                  textAlign: TextAlign.center,
                  color: colorScheme.onSurfaceVariant,
                ),
              ],
            ),
          ),
          
          // Plans list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.medium),
              itemCount: _subscriptionPlans.length,
              itemBuilder: (context, index) {
                final plan = _subscriptionPlans[index];
                return _PlanCard(
                  plan: plan,
                  onTap: () => _selectPlan(plan),
                );
              },
            ),
          ),
          
          // Bottom action area
          Container(
            padding: const EdgeInsets.all(AppSpacing.medium),
            child: Column(
              children: [
                AppBodyText(
                  'All plans include 14-day free trial',
                  textAlign: TextAlign.center,
                  color: colorScheme.onSurfaceVariant,
                ),
                const SizedBox(height: AppSpacing.small),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () => debugPrint('Terms tapped'),
                      child: AppCaptionText(
                        'Terms of Service',
                        color: colorScheme.primary,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.medium),
                    TextButton(
                      onPressed: () => debugPrint('Privacy tapped'),
                      child: AppCaptionText(
                        'Privacy Policy',
                        color: colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _selectPlan(SubscriptionPlan plan) {
    if (plan.isCurrent) {
      _showCurrentPlanDialog(plan);
    } else {
      _showUpgradeDialog(plan);
    }
  }

  void _showCurrentPlanDialog(SubscriptionPlan plan) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Current Plan: ${plan.name}'),
        content: const Text('This is your current active plan. You can upgrade to a higher plan anytime.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showUpgradeDialog(SubscriptionPlan plan) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Upgrade to ${plan.name}'),
        content: Text('Would you like to upgrade to ${plan.name} for ${plan.price}/${plan.period}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              debugPrint('Upgrading to ${plan.name}');
            },
            child: const Text('Upgrade'),
          ),
        ],
      ),
    );
  }
}

/// Individual plan card widget
class _PlanCard extends StatelessWidget {
  final SubscriptionPlan plan;
  final VoidCallback? onTap;

  const _PlanCard({
    required this.plan,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.medium),
      child: Stack(
        children: [
          AppCard(
            onTap: onTap,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    // Plan icon
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: plan.accentColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
                      ),
                      child: Icon(
                        _getPlanIcon(plan.id),
                        color: plan.accentColor,
                        size: AppSpacing.iconMedium,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.medium),
                    // Plan name and price
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              AppSubtitleText(plan.name),
                              if (plan.isCurrent) ...[
                                const SizedBox(width: AppSpacing.small),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: AppSpacing.small,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: colorScheme.primary,
                                    borderRadius: BorderRadius.circular(AppSpacing.radiusExtraSmall),
                                  ),
                                  child: Text(
                                    'CURRENT',
                                    style: theme.textTheme.labelSmall?.copyWith(
                                      color: colorScheme.onPrimary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 9,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: AppSpacing.extraSmall),
                          Row(
                            children: [
                              Text(
                                plan.price,
                                style: theme.textTheme.titleLarge?.copyWith(
                                  color: plan.accentColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (plan.period.isNotEmpty)
                                Text(
                                  '/${plan.period}',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              if (plan.originalPrice.isNotEmpty) ...[
                                const SizedBox(width: AppSpacing.small),
                                Text(
                                  plan.originalPrice,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Discount badge
                    if (plan.discount.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.small,
                          vertical: AppSpacing.extraSmall,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
                        ),
                        child: Text(
                          plan.discount,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
                
                const SizedBox(height: AppSpacing.large),
                
                // Features
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppLabelText('Features:'),
                    const SizedBox(height: AppSpacing.small),
                    ...plan.features.map((feature) => _FeatureItem(
                      feature: feature,
                      isIncluded: true,
                    )),
                  ],
                ),
                
                // Limitations (if any)
                if (plan.limitations.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.medium),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppLabelText('Limitations:'),
                      const SizedBox(height: AppSpacing.small),
                      ...plan.limitations.map((limitation) => _FeatureItem(
                        feature: limitation,
                        isIncluded: false,
                      )),
                    ],
                  ),
                ],
                
                const SizedBox(height: AppSpacing.large),
                
                // Action button
                SizedBox(
                  width: double.infinity,
                  child: plan.isCurrent
                      ? AppSecondaryButton(
                          onPressed: onTap,
                          child: const Text('Current Plan'),
                        )
                      : AppPrimaryButton(
                          onPressed: onTap,
                          child: Text(plan.id == 'trial' ? 'Start Free Trial' : 'Choose Plan'),
                        ),
                ),
              ],
            ),
          ),
          
          // Popular badge
          if (plan.isPopular)
            Positioned(
              top: 0,
              right: AppSpacing.medium,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.medium,
                  vertical: AppSpacing.small,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(AppSpacing.radiusSmall),
                    bottomRight: Radius.circular(AppSpacing.radiusSmall),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.star_rounded,
                      color: colorScheme.onPrimary,
                      size: AppSpacing.iconExtraSmall,
                    ),
                    const SizedBox(width: AppSpacing.extraSmall),
                    Text(
                      'MOST POPULAR',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 9,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  IconData _getPlanIcon(String planId) {
    switch (planId) {
      case 'trial':
        return Icons.free_breakfast_rounded;
      case 'basic':
        return Icons.star_outline_rounded;
      case 'premium':
        return Icons.stars_rounded;
      case 'family':
        return Icons.family_restroom_rounded;
      default:
        return Icons.subscriptions_rounded;
    }
  }
}

/// Feature item widget for plan features
class _FeatureItem extends StatelessWidget {
  final String feature;
  final bool isIncluded;

  const _FeatureItem({
    required this.feature,
    required this.isIncluded,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.extraSmall),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            isIncluded ? Icons.check_circle_rounded : Icons.cancel_rounded,
            color: isIncluded ? Colors.green : Colors.red,
            size: AppSpacing.iconSmall,
          ),
          const SizedBox(width: AppSpacing.small),
          Expanded(
            child: AppCaptionText(
              feature,
              color: isIncluded ? colorScheme.onSurface : colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}