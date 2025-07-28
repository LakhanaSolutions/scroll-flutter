import 'package:flutter/material.dart';
import '../theme/app_spacing.dart';
import '../theme/theme_extensions.dart';
import '../widgets/text/app_text.dart';
import '../widgets/app_bar/app_app_bar.dart';
import '../widgets/cards/app_card.dart';
import '../widgets/buttons/app_buttons.dart';
import '../widgets/inputs/app_text_field.dart';
import 'subscription_screen.dart';

/// Upgrade plan screen showing plan details, coupon field, and payment options
class UpgradePlanScreen extends StatefulWidget {
  final SubscriptionPlan plan;

  const UpgradePlanScreen({
    super.key,
    required this.plan,
  });

  @override
  State<UpgradePlanScreen> createState() => _UpgradePlanScreenState();
}

class _UpgradePlanScreenState extends State<UpgradePlanScreen> {
  final _couponController = TextEditingController();
  bool _couponApplied = false;
  double _discount = 0.0;
  String _discountedPrice = '';

  @override
  void initState() {
    super.initState();
    _discountedPrice = widget.plan.price;
  }

  @override
  void dispose() {
    _couponController.dispose();
    super.dispose();
  }

  void _applyCoupon() {
    final couponCode = _couponController.text.trim().toLowerCase();
    
    // Mock coupon validation
    if (couponCode == 'save20') {
      setState(() {
        _couponApplied = true;
        _discount = 0.20; // 20% discount
        _calculateDiscountedPrice();
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Coupon applied! 20% discount'),
          backgroundColor: Colors.green,
        ),
      );
    } else if (couponCode == 'first10') {
      setState(() {
        _couponApplied = true;
        _discount = 0.10; // 10% discount
        _calculateDiscountedPrice();
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Coupon applied! 10% discount'),
          backgroundColor: Colors.green,
        ),
      );
    } else if (couponCode.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid coupon code'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _calculateDiscountedPrice() {
    // Extract numeric value from price (remove SAR and /month)
    final priceText = widget.plan.price.replaceAll(RegExp(r'[^\d.]'), '');
    final originalPrice = double.tryParse(priceText) ?? 0.0;
    final discountedValue = originalPrice * (1 - _discount);
    
    if (widget.plan.price.contains('/month')) {
      _discountedPrice = '${discountedValue.toStringAsFixed(2)} SAR/month';
    } else if (widget.plan.price.contains('/year')) {
      _discountedPrice = '${discountedValue.toStringAsFixed(2)} SAR/year';
    } else {
      _discountedPrice = '${discountedValue.toStringAsFixed(2)} SAR';
    }
  }

  DateTime get _startDate => DateTime.now();
  DateTime get _endDate {
    if (widget.plan.timePeriod.toLowerCase().contains('month')) {
      return _startDate.add(const Duration(days: 30));
    } else if (widget.plan.timePeriod.toLowerCase().contains('annual') || 
               widget.plan.timePeriod.toLowerCase().contains('year')) {
      return _startDate.add(const Duration(days: 365));
    } else {
      return _startDate.add(const Duration(days: 365 * 10)); // Lifetime
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: const AppAppBar(
        title: 'Upgrade Plan',
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Plan Summary Header
            _buildPlanSummary(context),
            // Plan Benefits
            _buildPlanBenefits(context),
            // Coupon Section
            _buildCouponSection(context),
            // Plan Duration
            _buildPlanDuration(context),
            // Payment Button
            _buildPaymentSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanSummary(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.large),
      child: Column(
        children: [
          // Plan Icon
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: widget.plan.accentColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
            ),
            child: Icon(
              _getPlanIcon(),
              color: widget.plan.accentColor,
              size: 40,
            ),
          ),
          const SizedBox(height: AppSpacing.medium),
          
          // Plan Name
          AppTitleText(
            widget.plan.name,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.small),
          
          // Plan Type
          AppBodyText(
            widget.plan.type,
            color: colorScheme.onSurfaceVariant,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.medium),
          
          // Price
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_couponApplied && _discount > 0) ...[
                Text(
                  widget.plan.price,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
                const SizedBox(width: AppSpacing.small),
              ],
              Text(
                _discountedPrice,
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: widget.plan.accentColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          
          if (_couponApplied && _discount > 0) ...[
            const SizedBox(height: AppSpacing.small),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.medium,
                vertical: AppSpacing.small,
              ),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
              ),
              child: Text(
                'You save ${(_discount * 100).toInt()}%!',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPlanBenefits(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.medium),
      child: AppCard(
        gradient: context.surfaceGradient,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppSubtitleText('What you\'ll get:'),
            const SizedBox(height: AppSpacing.medium),
            
            // Benefits
            ...widget.plan.pros.map((benefit) => _buildBenefitItem(benefit, true)),
            
            // Limitations (if any)
            if (widget.plan.cons.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.medium),
              const AppSubtitleText('Limitations:'),
              const SizedBox(height: AppSpacing.medium),
              ...widget.plan.cons.map((limitation) => _buildBenefitItem(limitation, false)),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildBenefitItem(String text, bool isPositive) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.small),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            isPositive ? Icons.check_circle_rounded : Icons.cancel_rounded,
            color: isPositive ? Colors.green : Colors.red,
            size: AppSpacing.iconSmall,
          ),
          const SizedBox(width: AppSpacing.small),
          Expanded(
            child: AppCaptionText(
              text,
              color: isPositive ? colorScheme.onSurface : colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCouponSection(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.medium),
      child: AppCard(
        elevation: AppSpacing.elevationNone,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.local_offer_rounded,
                  color: colorScheme.primary,
                  size: AppSpacing.iconSmall,
                ),
                const SizedBox(width: AppSpacing.small),
                const AppSubtitleText('Have a coupon code?'),
              ],
            ),
            const SizedBox(height: AppSpacing.medium),
            
            Row(
              children: [
                Expanded(
                  child: AppTextField(
                    controller: _couponController,
                    enabled: !_couponApplied,
                    labelText: 'Coupon Code',
                    hintText: 'Enter coupon code',
                    prefixIcon: const Icon(Icons.confirmation_number_rounded),
                    suffixIcon: _couponApplied 
                        ? Icon(
                            Icons.check_circle_rounded,
                            color: Colors.green,
                          )
                        : null,
                    onChanged: (value) {
                      if (_couponApplied && value != _couponController.text) {
                        setState(() {
                          _couponApplied = false;
                          _discount = 0.0;
                          _discountedPrice = widget.plan.price;
                        });
                      }
                    },
                  ),
                ),
                const SizedBox(width: AppSpacing.small),
                AppSecondaryButton(
                  onPressed: _couponApplied ? null : _applyCoupon,
                  child: Text(_couponApplied ? 'Applied' : 'Apply'),
                ),
              ],
            ),
            
            if (!_couponApplied) ...[
              const SizedBox(height: AppSpacing.small),
              AppCaptionText(
                'Try: SAVE20 or FIRST10',
                color: colorScheme.onSurfaceVariant,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPlanDuration(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.medium),
      child: AppCard(
        elevation: AppSpacing.elevationNone,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.schedule_rounded,
                  color: colorScheme.primary,
                  size: AppSpacing.iconSmall,
                ),
                const SizedBox(width: AppSpacing.small),
                const AppSubtitleText('Plan Duration'),
              ],
            ),
            const SizedBox(height: AppSpacing.medium),
            
            _buildDurationRow('Start Date', _formatDate(_startDate)),
            _buildDurationRow('End Date', _formatDate(_endDate)),
            _buildDurationRow('Billing Period', widget.plan.timePeriod),
          ],
        ),
      ),
    );
  }

  Widget _buildDurationRow(String label, String value) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.small),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: AppLabelText(label),
          ),
          Expanded(
            child: AppBodyText(
              value,
              color: colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentSection(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.large),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: colorScheme.outline.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          // Payment Summary
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const AppSubtitleText('Total Amount:'),
              Text(
                _discountedPrice,
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: widget.plan.accentColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.medium),
          
          // Payment Button
          SizedBox(
            width: double.infinity,
            child: AppPrimaryButton(
              onPressed: () => _processPayment(context),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.payment_rounded),
                  const SizedBox(width: AppSpacing.small),
                  Text('Pay $_discountedPrice'),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: AppSpacing.small),
          
          // Terms and conditions
          AppCaptionText(
            'By proceeding, you agree to our Terms of Service and Privacy Policy. You can cancel anytime.',
            textAlign: TextAlign.center,
            color: colorScheme.onSurfaceVariant,
          ),
        ],
      ),
    );
  }

  IconData _getPlanIcon() {
    if (widget.plan.name.contains('Glimpse')) {
      return Icons.visibility_rounded;
    } else if (widget.plan.name.contains('Premium')) {
      return Icons.stars_rounded;
    } else if (widget.plan.name.contains('Scholar')) {
      return Icons.school_rounded;
    } else {
      return Icons.subscriptions_rounded;
    }
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  void _processPayment(BuildContext context) {
    // TODO: Implement actual payment processing
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Payment Confirmation'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Plan: ${widget.plan.name}'),
            Text('Amount: $_discountedPrice'),
            Text('Start Date: ${_formatDate(_startDate)}'),
            Text('End Date: ${_formatDate(_endDate)}'),
            const SizedBox(height: 16),
            const Text('Proceed with payment?'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
              Navigator.of(context).pop(); // Go back to subscription screen
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Successfully subscribed to ${widget.plan.name}!'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Confirm Payment'),
          ),
        ],
      ),
    );
  }
}