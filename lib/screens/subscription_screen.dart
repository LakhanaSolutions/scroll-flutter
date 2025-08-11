import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_spacing.dart';
import '../theme/theme_extensions.dart';
import '../widgets/text/app_text.dart';
import '../widgets/app_bar/app_app_bar.dart';
import '../widgets/cards/app_card.dart';
import '../widgets/buttons/app_buttons.dart';
import '../widgets/dialogs/app_dialogs.dart';
import 'upgrade_plan_screen.dart';

enum SubscriptionType { trial, basic, premium, family }

class SubscriptionPlan {
  final String name;
  final String type;
  final String price;
  final String timePeriod;
  final List<String> pros;
  final List<String> cons;
  final Color accentColor;
  final bool isPopular;
  final bool isCurrent;

  SubscriptionPlan({
    required this.name,
    required this.type,
    required this.price,
    required this.timePeriod,
    required this.pros,
    required this.cons,
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
      name: 'Scroll Glimpse',
      type: 'Free Plan',
      price: '0 SAR',
      timePeriod: 'Lifetime',
      pros: [
        'Experience a truly distraction-free listening environment',
        'Access a curated selection of introductory content',
        'Discover the app\'s quality and ease of use',
        'Basic search functionality',
        'Try premium content: 15 minutes per month of premium audiobooks',
      ],
      cons: [
        'Your content options are limited.',
        'Not all scholars or series will be available.',
        'No offline premium content.',
      ],
      accentColor: Colors.grey,
      isCurrent: true,
    ),
    SubscriptionPlan(
      name: 'Scroll Premium',
      type: 'Paid Plan',
      price: '29.99 SAR',
      timePeriod: 'Monthly',
      pros: [
        'Unlock the entire, vast content library',
        'Access all exclusive audiobooks and lecture series',
        'Enjoy immediate access to all new releases',
        'Experience seamless listening across all your devices',
        'Benefit from the flexibility to cancel anytime',
        'Enjoy offline playback for all content',
        'Download as much content as you want',
        'Option to volunteer your own narration. Each book narration gets you 1 more month of Premium plan',
      ],
      cons: [],
      accentColor: const Color(0xFF4CAF50),
      isPopular: true,
    ),
    SubscriptionPlan(
      name: 'Scroll Scholar\'s Circle',
      type: 'Paid Plan',
      price: '299.99 SAR',
      timePeriod: 'Annual',
      pros: [
        'Save 59.89 SAR compared to monthly payments',
        'Enjoy uninterrupted, comprehensive learning for a full year',
        'Secure your access at a lower annual rate',
        'Make one convenient payment for 12 months of premium content',
      ],
      cons: [],
      accentColor: const Color(0xFF9C27B0),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: const AppAppBar(
        title: 'Subscription',
      ),
      body: Column(
        children: [
          // Plans list with header
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.medium),
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
                ..._subscriptionPlans.map((plan) => _PlanCard(
                  plan: plan,
                  onTap: () => _selectPlan(plan),
                )),
                
                // Bottom spacing for bottom action area
                const SizedBox(height: AppSpacing.large),
              ],
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
                      onPressed: () {
                        context.push('/home/terms-of-service');
                      },
                      child: AppCaptionText(
                        'Terms of Service',
                        color: colorScheme.primary,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.medium),
                    TextButton(
                      onPressed: () {
                        context.push('/home/privacy-policy');
                      },
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
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => UpgradePlanScreen(plan: plan),
        ),
      );
    }
  }

  void _showCurrentPlanDialog(SubscriptionPlan plan) {
    AppAlertDialog.show(
      context,
      title: 'Current Plan: ${plan.name}',
      content: const Text('This is your current active plan. You can upgrade to a higher plan anytime.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('OK'),
        ),
      ],
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
              elevation: 0,
              gradient: context.planGradient(plan.name),
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
                        _getPlanIcon(plan.name),
                        color: plan.accentColor,
                        size: AppSpacing.iconMedium,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.medium),
                    // Plan name and type
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: AppSubtitleText(
                                  plan.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
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
                          AppCaptionText(
                            plan.type,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: AppSpacing.medium),
                
                // Price
                Row(
                  children: [
                    Text(
                      plan.price,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: plan.accentColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.small),
                    AppCaptionText(
                      plan.timePeriod,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ],
                ),
                
                const SizedBox(height: AppSpacing.large),
                
                // Pros
                if (plan.pros.isNotEmpty) ...[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppLabelText('Benefits:'),
                      const SizedBox(height: AppSpacing.small),
                      ...plan.pros.map((pro) => _FeatureItem(
                        feature: pro,
                        isIncluded: true,
                      )),
                    ],
                  ),
                ],
                
                // Cons (if any)
                if (plan.cons.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.medium),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppLabelText('Limitations:'),
                      const SizedBox(height: AppSpacing.small),
                      ...plan.cons.map((con) => _FeatureItem(
                        feature: con,
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
                          child: Text(plan.price == '0 SAR' ? 'Current Plan' : 'Choose Plan'),
                        ),
                ),
              ],
            ),
          ),
          
          // Popular badge
          if (plan.isPopular)
            Positioned(
              top: 8,
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
                    topLeft: Radius.circular(0),
                    topRight: Radius.circular(0),
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

  IconData _getPlanIcon(String planName) {
    if (planName.contains('Glimpse')) {
      return Icons.visibility_rounded;
    } else if (planName.contains('Premium')) {
      return Icons.stars_rounded;
    } else if (planName.contains('Scholar')) {
      return Icons.school_rounded;
    } else {
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