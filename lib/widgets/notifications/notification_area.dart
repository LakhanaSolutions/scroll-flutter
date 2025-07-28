import 'package:flutter/material.dart';
import '../../data/mock_data.dart';
import '../../theme/app_spacing.dart';
import '../text/app_text.dart';
import '../buttons/app_buttons.dart';

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
    final colorScheme = Theme.of(context).colorScheme;
    switch (type) {
      case NotificationType.info:
        return colorScheme.primaryContainer;
      case NotificationType.warning:
        return colorScheme.errorContainer.withValues(alpha: 0.8);
      case NotificationType.success:
        return colorScheme.primaryContainer.withValues(alpha: 0.8);
      case NotificationType.error:
        return colorScheme.errorContainer;
    }
  }

  Color _getTextColor(BuildContext context, NotificationType type) {
    final colorScheme = Theme.of(context).colorScheme;
    switch (type) {
      case NotificationType.info:
        return colorScheme.onPrimaryContainer;
      case NotificationType.warning:
        return colorScheme.onErrorContainer;
      case NotificationType.success:
        return colorScheme.onPrimaryContainer;
      case NotificationType.error:
        return colorScheme.onErrorContainer;
    }
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
        elevation: 1,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.medium),
          child: Row(
            children: [
              Icon(
                _getIcon(notification.type),
                color: textColor,
                size: AppSpacing.iconMedium,
              ),
              const SizedBox(width: AppSpacing.medium),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppSubtitleText(
                      notification.title,
                      color: textColor,
                    ),
                    const SizedBox(height: AppSpacing.extraSmall),
                    AppBodyText(
                      notification.message,
                      color: textColor.withValues(alpha: 0.9),
                    ),
                    if (notification.actionText != null) ...[
                      const SizedBox(height: AppSpacing.small),
                      AppTextButton(
                        onPressed: onAction,
                        child: Text(
                          notification.actionText!,
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: textColor,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (notification.isDismissible)
                IconButton(
                  icon: Icon(
                    Icons.close,
                    color: textColor.withValues(alpha: 0.7),
                    size: AppSpacing.iconSmall,
                  ),
                  onPressed: onDismiss,
                  constraints: const BoxConstraints(
                    minWidth: AppSpacing.touchTarget,
                    minHeight: AppSpacing.touchTarget,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}