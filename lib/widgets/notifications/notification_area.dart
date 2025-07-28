import 'package:flutter/material.dart';
import '../../data/mock_data.dart';
import '../../theme/app_spacing.dart';

/// Notification area widget that displays dismissible notifications from API
/// Supports different notification types: info, warning, success, error
class NotificationArea extends StatefulWidget {
  final List<NotificationData> notifications;
  final Function(String)? onDismiss;
  final Function(NotificationData)? onAction;

  const NotificationArea({
    super.key,
    required this.notifications,
    this.onDismiss,
    this.onAction,
  });

  @override
  State<NotificationArea> createState() => _NotificationAreaState();
}

class _NotificationAreaState extends State<NotificationArea> {
  late List<NotificationData> _displayedNotifications;

  @override
  void initState() {
    super.initState();
    _displayedNotifications = List.from(widget.notifications);
  }

  @override
  void didUpdateWidget(NotificationArea oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.notifications != oldWidget.notifications) {
      _displayedNotifications = List.from(widget.notifications);
    }
  }

  void _dismissNotification(String notificationId) {
    setState(() {
      _displayedNotifications.removeWhere((n) => n.id == notificationId);
    });
    widget.onDismiss?.call(notificationId);
  }

  @override
  Widget build(BuildContext context) {
    if (_displayedNotifications.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: _displayedNotifications
          .map((notification) => _NotificationCard(
                notification: notification,
                onDismiss: () => _dismissNotification(notification.id),
                onAction: () => widget.onAction?.call(notification),
              ))
          .toList(),
    );
  }
}

/// Individual notification card widget
class _NotificationCard extends StatelessWidget {
  final NotificationData notification;
  final VoidCallback? onDismiss;
  final VoidCallback? onAction;

  const _NotificationCard({
    required this.notification,
    this.onDismiss,
    this.onAction,
  });

  Color _getBackgroundColor(BuildContext context, NotificationType type) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    switch (type) {
      case NotificationType.info:
        return isDark
            ? const Color(0xFF1E293B) // dark blue-gray
            : Colors.white;
      case NotificationType.warning:
        return isDark
            ? const Color(0xFF3B2F13) // dark yellow-brown
            : const Color(0xFFFFF9E5);
      case NotificationType.success:
        return isDark
            ? const Color(0xFF1B3C2E) // dark green
            : const Color(0xFFF1FAF5);
      case NotificationType.error:
        return isDark
            ? const Color(0xFF3B2323) // dark red
            : const Color(0xFFFDF2F2);
    }
  }

  Color _getTextColor(BuildContext context, NotificationType type) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? Colors.white : Colors.black;
  }

  IconData _getIcon(NotificationType type) {
    switch (type) {
      case NotificationType.info:
        return Icons.info_outline;
      case NotificationType.warning:
        return Icons.warning_amber_outlined;
      case NotificationType.success:
        return Icons.check_circle_outline;
      case NotificationType.error:
        return Icons.error_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final backgroundColor = _getBackgroundColor(context, notification.type);
    final textColor = _getTextColor(context, notification.type);

    return Container(
      margin: const EdgeInsets.only(
        left: AppSpacing.medium,
        right: AppSpacing.medium,
        bottom: AppSpacing.small,
      ),
      child: Material(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.small),
          child: Row(
            children: [
              Icon(
                _getIcon(notification.type),
                color: textColor,
                size: AppSpacing.iconSmall,
              ),
              const SizedBox(width: AppSpacing.small),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notification.title,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: textColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      notification.message,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: textColor.withValues(alpha: 0.8),
                        fontSize: 11,
                      ),
                    ),
                    if (notification.actionText != null) ...[
                      const SizedBox(height: AppSpacing.extraSmall),
                      GestureDetector(
                        onTap: onAction,
                        child: Text(
                          notification.actionText!,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: textColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 10,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (notification.isDismissible)
                GestureDetector(
                  onTap: onDismiss,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    child: Icon(
                      Icons.close,
                      color: textColor.withValues(alpha: 0.6),
                      size: 16,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}