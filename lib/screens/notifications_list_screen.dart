import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../data/mock_data.dart';
import '../theme/app_spacing.dart';
import '../theme/theme_extensions.dart';
import '../widgets/text/app_text.dart';
import '../widgets/cards/app_card.dart';
import '../widgets/app_bar/app_app_bar.dart';

/// Notifications list screen that displays actual notifications
/// Shows all notifications with action buttons and dismissal functionality
class NotificationsListScreen extends StatefulWidget {
  const NotificationsListScreen({super.key});

  @override
  State<NotificationsListScreen> createState() => _NotificationsListScreenState();
}

class _NotificationsListScreenState extends State<NotificationsListScreen> {
  List<NotificationData> notifications = [];

  @override
  void initState() {
    super.initState();
    notifications = List.from(MockData.getNotifications());
  }

  void _dismissNotification(String id) {
    setState(() {
      notifications.removeWhere((notification) => notification.id == id);
    });
  }

  void _handleNotificationAction(NotificationData notification) {
    // Handle notification action based on type
    switch (notification.type) {
      case NotificationType.warning:
      case NotificationType.info:
        context.push('/home/subscription');
        break;
      case NotificationType.success:
        // Handle success notifications
        break;
      case NotificationType.error:
        // Handle error notifications
        break;
    }
  }

  void _clearAllNotifications() {
    setState(() {
      notifications.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.appTheme.iosSystemBackground,
      appBar: AppAppBarExtensions.withBackButton(
        title: 'Notifications',
        onBackPressed: () => Navigator.of(context).pop(),
        actions: notifications.isNotEmpty ? [
          TextButton(
            onPressed: _clearAllNotifications,
            child: const Text('Clear All'),
          ),
        ] : null,
      ),
      body: notifications.isEmpty 
          ? _buildEmptyState() 
          : _buildNotificationsList(),
    );
  }

  Widget _buildEmptyState() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.large),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notifications_none_rounded,
              size: AppSpacing.iconHero,
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            ),
            const SizedBox(height: AppSpacing.large),
            const AppTitleText('No Notifications'),
            const SizedBox(height: AppSpacing.small),
            AppBodyText(
              'When you have new updates, they\'ll appear here.',
              textAlign: TextAlign.center,
              color: colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.medium),
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        final notification = notifications[index];
        return _NotificationTile(
          notification: notification,
          onDismiss: () => _dismissNotification(notification.id),
          onAction: () => _handleNotificationAction(notification),
          margin: const EdgeInsets.only(bottom: AppSpacing.small),
        );
      },
    );
  }
}

/// Individual notification tile widget
class _NotificationTile extends StatelessWidget {
  final NotificationData notification;
  final VoidCallback? onDismiss;
  final VoidCallback? onAction;
  final EdgeInsets? margin;

  const _NotificationTile({
    required this.notification,
    this.onDismiss,
    this.onAction,
    this.margin,
  });

  IconData _getNotificationIcon() {
    switch (notification.type) {
      case NotificationType.warning:
        return Icons.warning_amber_rounded;
      case NotificationType.info:
        return Icons.info_outline_rounded;
      case NotificationType.success:
        return Icons.check_circle_outline_rounded;
      case NotificationType.error:
        return Icons.error_outline_rounded;
    }
  }

  Color _getNotificationColor(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    switch (notification.type) {
      case NotificationType.warning:
        return Colors.orange;
      case NotificationType.info:
        return colorScheme.primary;
      case NotificationType.success:
        return Colors.green;
      case NotificationType.error:
        return colorScheme.error;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final notificationColor = _getNotificationColor(context);

    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDismiss?.call(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: AppSpacing.medium),
        decoration: BoxDecoration(
          color: colorScheme.error,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
        ),
        child: Icon(
          Icons.delete_rounded,
          color: colorScheme.onError,
        ),
      ),
      child: AppCard(
        margin: margin ?? EdgeInsets.zero,
        gradient: context.surfaceGradient,
        elevation: AppSpacing.elevationNone,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Notification icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: notificationColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
              ),
              child: Icon(
                _getNotificationIcon(),
                color: notificationColor,
                size: AppSpacing.iconMedium,
              ),
            ),
            const SizedBox(width: AppSpacing.medium),
            // Notification content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  AppSubtitleText(
                    notification.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSpacing.extraSmall),
                  // Message
                  AppBodyText(
                    notification.message,
                    color: colorScheme.onSurfaceVariant,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (notification.actionText != null) ...[
                    const SizedBox(height: AppSpacing.medium),
                    // Action button
                    GestureDetector(
                      onTap: onAction,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.medium,
                          vertical: AppSpacing.small,
                        ),
                        decoration: BoxDecoration(
                          color: notificationColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
                          border: Border.all(
                            color: notificationColor.withValues(alpha: 0.3),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          notification.actionText!,
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: notificationColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            // Dismiss button
            GestureDetector(
              onTap: onDismiss,
              child: Container(
                padding: const EdgeInsets.all(4),
                child: Icon(
                  Icons.close_rounded,
                  color: colorScheme.onSurfaceVariant,
                  size: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}