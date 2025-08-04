import 'package:flutter/material.dart';
import '../theme/app_spacing.dart';
import '../theme/theme_extensions.dart';
import '../widgets/text/app_text.dart';
import '../widgets/app_bar/app_app_bar.dart';
import '../widgets/cards/app_card.dart';

enum SubscriptionStatus { active, expired, cancelled, pending }

class SubscriptionHistoryItem {
  final String id;
  final String planName;
  final String price;
  final DateTime startDate;
  final DateTime endDate;
  final SubscriptionStatus status;
  final String paymentMethod;
  final String transactionId;

  SubscriptionHistoryItem({
    required this.id,
    required this.planName,
    required this.price,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.paymentMethod,
    required this.transactionId,
  });
}

/// Subscription history screen showing past and current subscriptions
class SubscriptionHistoryScreen extends StatelessWidget {
  const SubscriptionHistoryScreen({super.key});

  List<SubscriptionHistoryItem> get _historyItems => [
    SubscriptionHistoryItem(
      id: '1',
      planName: 'Siraaj Premium Monthly',
      price: '29.99 SAR',
      startDate: DateTime(2024, 1, 15),
      endDate: DateTime(2024, 12, 15),
      status: SubscriptionStatus.active,
      paymentMethod: 'Visa •••• 4532',
      transactionId: 'TXN-2024-001',
    ),
    SubscriptionHistoryItem(
      id: '2',
      planName: 'Siraaj Glimpse',
      price: '0 SAR',
      startDate: DateTime(2023, 8, 1),
      endDate: DateTime(2024, 1, 14),
      status: SubscriptionStatus.expired,
      paymentMethod: 'Free Plan',
      transactionId: 'FREE-2023-001',
    ),
    SubscriptionHistoryItem(
      id: '3',
      planName: 'Siraaj Scholar\'s Circle',
      price: '299.99 SAR',
      startDate: DateTime(2022, 10, 1),
      endDate: DateTime(2023, 9, 30),
      status: SubscriptionStatus.expired,
      paymentMethod: 'Mastercard •••• 8901',
      transactionId: 'TXN-2022-042',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: context.appTheme.iosSystemBackground,
      appBar: const AppAppBar(
        title: 'Subscription History',
      ),
      body: Column(
        children: [
          // Header section
          Container(
            width: double.infinity,
            color: colorScheme.surface,
            padding: const EdgeInsets.all(AppSpacing.large),
            child: Column(
              children: [
                Icon(
                  Icons.receipt_long_rounded,
                  size: 48,
                  color: colorScheme.primary,
                ),
                const SizedBox(height: AppSpacing.medium),
                const AppTitleText(
                  'Your Subscription History',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.small),
                AppBodyText(
                  'View all your past and current subscriptions',
                  textAlign: TextAlign.center,
                  color: colorScheme.onSurfaceVariant,
                ),
              ],
            ),
          ),
          
          // History list
          Expanded(
            child: _historyItems.isEmpty
                ? _buildEmptyState(context)
                : ListView.builder(
                    padding: const EdgeInsets.all(AppSpacing.medium),
                    itemCount: _historyItems.length,
                    itemBuilder: (context, index) {
                      final item = _historyItems[index];
                      return _HistoryCard(
                        item: item,
                        onTap: () => _showHistoryDetails(context, item),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.large),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.history_toggle_off_rounded,
              size: AppSpacing.iconHero,
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            ),
            const SizedBox(height: AppSpacing.large),
            const AppTitleText('No Subscription History'),
            const SizedBox(height: AppSpacing.small),
            AppBodyText(
              'You haven\'t subscribed to any plans yet.',
              textAlign: TextAlign.center,
              color: colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }

  void _showHistoryDetails(BuildContext context, SubscriptionHistoryItem item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _HistoryDetailsBottomSheet(item: item),
    );
  }
}

/// Individual history item card
class _HistoryCard extends StatelessWidget {
  final SubscriptionHistoryItem item;
  final VoidCallback? onTap;

  const _HistoryCard({
    required this.item,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.medium),
      child: AppCard(
        gradient: LinearGradient(
          colors: [
            colorScheme.surfaceContainer.withValues(alpha: 0.8),
            colorScheme.surfaceContainerHigh.withValues(alpha: 0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with plan name and status
            Row(
              children: [
                Expanded(
                  child: AppSubtitleText(
                    item.planName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                _StatusBadge(status: item.status),
              ],
            ),
            const SizedBox(height: AppSpacing.small),
            
            // Price and duration
            Row(
              children: [
                Text(
                  item.price,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: AppSpacing.medium),
                AppCaptionText(
                  '${_formatDate(item.startDate)} - ${_formatDate(item.endDate)}',
                  color: colorScheme.onSurfaceVariant,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.small),
            
            // Payment method and transaction
            Row(
              children: [
                Icon(
                  Icons.payment_rounded,
                  size: AppSpacing.iconExtraSmall,
                  color: colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: AppSpacing.extraSmall),
                AppCaptionText(
                  item.paymentMethod,
                  color: colorScheme.onSurfaceVariant,
                ),
                const Spacer(),
                AppCaptionText(
                  item.transactionId,
                  color: colorScheme.onSurfaceVariant,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

/// Status badge widget
class _StatusBadge extends StatelessWidget {
  final SubscriptionStatus status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    Color backgroundColor;
    Color textColor;
    String text;
    IconData icon;

    switch (status) {
      case SubscriptionStatus.active:
        backgroundColor = colorScheme.primaryContainer;
        textColor = colorScheme.onPrimaryContainer;
        text = 'ACTIVE';
        icon = Icons.check_circle_rounded;
        break;
      case SubscriptionStatus.expired:
        backgroundColor = colorScheme.errorContainer;
        textColor = colorScheme.onErrorContainer;
        text = 'EXPIRED';
        icon = Icons.cancel_rounded;
        break;
      case SubscriptionStatus.cancelled:
        backgroundColor = colorScheme.surfaceContainer;
        textColor = colorScheme.onSurfaceVariant;
        text = 'CANCELLED';
        icon = Icons.block_rounded;
        break;
      case SubscriptionStatus.pending:
        backgroundColor = colorScheme.secondaryContainer;
        textColor = colorScheme.onSecondaryContainer;
        text = 'PENDING';
        icon = Icons.schedule_rounded;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.small,
        vertical: AppSpacing.extraSmall,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: textColor,
            size: AppSpacing.iconExtraSmall,
          ),
          const SizedBox(width: AppSpacing.extraSmall),
          Text(
            text,
            style: theme.textTheme.labelSmall?.copyWith(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: 9,
            ),
          ),
        ],
      ),
    );
  }
}

/// History details bottom sheet
class _HistoryDetailsBottomSheet extends StatelessWidget {
  final SubscriptionHistoryItem item;

  const _HistoryDetailsBottomSheet({required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusLarge),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: AppSpacing.medium),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // Content
          Padding(
            padding: const EdgeInsets.all(AppSpacing.large),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Row(
                  children: [
                    Expanded(
                      child: AppTitleText('Subscription Details'),
                    ),
                    _StatusBadge(status: item.status),
                  ],
                ),
                const SizedBox(height: AppSpacing.large),
                
                // Details
                _buildDetailRow('Plan Name', item.planName),
                _buildDetailRow('Price', item.price),
                _buildDetailRow('Start Date', _formatDate(item.startDate)),
                _buildDetailRow('End Date', _formatDate(item.endDate)),
                _buildDetailRow('Payment Method', item.paymentMethod),
                _buildDetailRow('Transaction ID', item.transactionId),
                
                const SizedBox(height: AppSpacing.large),
                
                // Actions
                if (item.status == SubscriptionStatus.active) ...[
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        // TODO-024: Navigate to manage subscription
                      },
                      child: const Text('Manage Subscription'),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.medium),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: AppLabelText(label),
          ),
          Expanded(
            child: AppBodyText(value),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}