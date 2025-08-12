import 'package:flutter/material.dart';
import '../../theme/app_spacing.dart';
import '../../widgets/text/app_text.dart';
import '../../widgets/buttons/app_buttons.dart';

/// Maintenance screen for when the app or server is under maintenance
/// Follows app theme guidelines and is dark mode compatible
class MaintenanceScreen extends StatelessWidget {
  /// Creates a [MaintenanceScreen]
  const MaintenanceScreen({
    super.key,
    this.title,
    this.message,
    this.estimatedTime,
    this.supportEmail,
    this.onRetry,
    this.onContactSupport,
    this.showAppBar = false,
    this.appBarTitle,
    this.customIcon,
    this.backgroundColor,
    this.showRetryButton = true,
  });

  /// Factory constructor for scheduled maintenance
  factory MaintenanceScreen.scheduled({
    String? estimatedTime,
    String? message,
    VoidCallback? onRetry,
    VoidCallback? onContactSupport,
    String? supportEmail,
    bool showAppBar = false,
  }) {
    return MaintenanceScreen(
      title: 'Scheduled Maintenance',
      message: message ?? 'We\'re performing scheduled maintenance to improve your experience. We\'ll be back shortly.',
      estimatedTime: estimatedTime,
      onRetry: onRetry,
      onContactSupport: onContactSupport,
      supportEmail: supportEmail,
      showAppBar: showAppBar,
      customIcon: Icons.build_rounded,
    );
  }

  /// Factory constructor for emergency maintenance
  factory MaintenanceScreen.emergency({
    String? message,
    VoidCallback? onRetry,
    VoidCallback? onContactSupport,
    String? supportEmail,
    bool showAppBar = false,
  }) {
    return MaintenanceScreen(
      title: 'Under Maintenance',
      message: message ?? 'We\'re experiencing technical difficulties and are working to resolve them as quickly as possible.',
      onRetry: onRetry,
      onContactSupport: onContactSupport,
      supportEmail: supportEmail,
      showAppBar: showAppBar,
      customIcon: Icons.warning_rounded,
    );
  }

  /// Factory constructor for server maintenance
  factory MaintenanceScreen.server({
    String? estimatedTime,
    VoidCallback? onRetry,
    VoidCallback? onContactSupport,
    String? supportEmail,
    bool showAppBar = false,
  }) {
    return MaintenanceScreen(
      title: 'Server Maintenance',
      message: 'Our servers are currently undergoing maintenance. Please try again later.',
      estimatedTime: estimatedTime,
      onRetry: onRetry,
      onContactSupport: onContactSupport,
      supportEmail: supportEmail,
      showAppBar: showAppBar,
      customIcon: Icons.dns_rounded,
    );
  }

  /// Custom title (overrides default)
  final String? title;

  /// Custom message (overrides default)
  final String? message;

  /// Estimated time for maintenance completion
  final String? estimatedTime;

  /// Support email for contact
  final String? supportEmail;

  /// Callback for retry button press
  final VoidCallback? onRetry;

  /// Callback for contact support button press
  final VoidCallback? onContactSupport;

  /// Whether to show app bar
  final bool showAppBar;

  /// Custom app bar title
  final String? appBarTitle;

  /// Custom icon (overrides default)
  final IconData? customIcon;

  /// Optional background color override
  final Color? backgroundColor;

  /// Whether to show retry button
  final bool showRetryButton;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: backgroundColor ?? colorScheme.surface,
      appBar: showAppBar
          ? AppBar(
              title: Text(appBarTitle ?? 'Maintenance'),
              backgroundColor: Colors.transparent,
              elevation: 0,
              automaticallyImplyLeading: false,
            )
          : null,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.large),
          child: Column(
            children: [
              const Spacer(),
              
              // Maintenance icon
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusExtraLarge),
                  border: Border.all(
                    color: Colors.orange.withValues(alpha: 0.2),
                    width: 2,
                  ),
                ),
                child: Icon(
                  customIcon ?? Icons.construction_rounded,
                  size: 64,
                  color: Colors.orange,
                ),
              ),

              const SizedBox(height: AppSpacing.extraLarge),

              // Title
              AppTitleText(
                title ?? 'Under Maintenance',
                textAlign: TextAlign.center,
                color: colorScheme.onSurface,
              ),

              const SizedBox(height: AppSpacing.medium),

              // Message
              AppBodyText(
                message ?? 'We\'re currently performing maintenance to improve your experience. Please check back soon.',
                textAlign: TextAlign.center,
                color: colorScheme.onSurfaceVariant,
              ),

              // Estimated time
              if (estimatedTime != null) ...[
                const SizedBox(height: AppSpacing.large),
                _buildEstimatedTime(context),
              ],

              const SizedBox(height: AppSpacing.extraLarge),

              // Action buttons
              _buildActionButtons(context),

              const Spacer(),

              // Support info
              _buildSupportInfo(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEstimatedTime(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.medium),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.access_time_rounded,
            color: colorScheme.primary,
            size: AppSpacing.iconMedium,
          ),
          const SizedBox(width: AppSpacing.medium),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppLabelText(
                  'Estimated Completion',
                  color: colorScheme.onSurfaceVariant,
                ),
                const SizedBox(height: AppSpacing.extraSmall),
                AppBodyText(
                  estimatedTime!,
                  color: colorScheme.onSurface,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    final buttons = <Widget>[];

    // Retry button
    if (showRetryButton && onRetry != null) {
      buttons.add(
        SizedBox(
          width: double.infinity,
          child: AppPrimaryButton(
            onPressed: onRetry,
            child: const Text('Try Again'),
          ),
        ),
      );
    }

    // Contact support button
    if (onContactSupport != null) {
      if (buttons.isNotEmpty) {
        buttons.add(const SizedBox(height: AppSpacing.medium));
      }
      buttons.add(
        SizedBox(
          width: double.infinity,
          child: AppSecondaryButton(
            onPressed: onContactSupport,
            child: const Text('Contact Support'),
          ),
        ),
      );
    }

    return Column(children: buttons);
  }

  Widget _buildSupportInfo(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.medium),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline_rounded,
                color: colorScheme.onSurfaceVariant,
                size: AppSpacing.iconSmall,
              ),
              const SizedBox(width: AppSpacing.small),
              Expanded(
                child: AppCaptionText(
                  'We apologize for any inconvenience. Follow us on social media for updates.',
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          if (supportEmail != null) ...[
            const SizedBox(height: AppSpacing.small),
            Row(
              children: [
                Icon(
                  Icons.email_outlined,
                  color: colorScheme.onSurfaceVariant,
                  size: AppSpacing.iconSmall,
                ),
                const SizedBox(width: AppSpacing.small),
                Expanded(
                  child: AppCaptionText(
                    'Support: $supportEmail',
                    color: colorScheme.primary,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

/// Simple maintenance dialog for quick maintenance notifications
class MaintenanceDialog extends StatelessWidget {
  /// Creates a [MaintenanceDialog]
  const MaintenanceDialog({
    super.key,
    this.title = 'Under Maintenance',
    this.message,
    this.estimatedTime,
    this.onRetry,
    this.onDismiss,
  });

  /// Dialog title
  final String title;

  /// Dialog message
  final String? message;

  /// Estimated completion time
  final String? estimatedTime;

  /// Callback for retry button press
  final VoidCallback? onRetry;

  /// Callback for dismiss button press
  final VoidCallback? onDismiss;

  /// Show the maintenance dialog
  static Future<T?> show<T>(
    BuildContext context, {
    String title = 'Under Maintenance',
    String? message,
    String? estimatedTime,
    VoidCallback? onRetry,
    VoidCallback? onDismiss,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: false,
      builder: (context) => MaintenanceDialog(
        title: title,
        message: message,
        estimatedTime: estimatedTime,
        onRetry: onRetry,
        onDismiss: onDismiss,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AlertDialog(
      backgroundColor: colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
      ),
      title: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.orange.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
            ),
            child: Icon(
              Icons.construction_rounded,
              color: Colors.orange,
              size: AppSpacing.iconMedium,
            ),
          ),
          const SizedBox(width: AppSpacing.medium),
          Expanded(
            child: AppSubtitleText(
              title,
              color: colorScheme.onSurface,
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppBodyText(
            message ?? 'We\'re currently performing maintenance. Please try again later.',
            color: colorScheme.onSurfaceVariant,
          ),
          if (estimatedTime != null) ...[
            const SizedBox(height: AppSpacing.medium),
            Container(
              padding: const EdgeInsets.all(AppSpacing.small),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.access_time_rounded,
                    color: colorScheme.primary,
                    size: AppSpacing.iconSmall,
                  ),
                  const SizedBox(width: AppSpacing.small),
                  Expanded(
                    child: AppCaptionText(
                      'Expected completion: $estimatedTime',
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
      actions: [
        // Dismiss button
        if (onDismiss != null)
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onDismiss?.call();
            },
            child: const Text('OK'),
          ),

        // Retry button
        if (onRetry != null)
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onRetry?.call();
            },
            style: TextButton.styleFrom(
              foregroundColor: colorScheme.primary,
              textStyle: const TextStyle(fontWeight: FontWeight.w600),
            ),
            child: const Text('Try Again'),
          ),
      ],
    );
  }
}