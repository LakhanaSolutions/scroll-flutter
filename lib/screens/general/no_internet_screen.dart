import 'package:flutter/material.dart';
import '../../theme/app_spacing.dart';
import '../../widgets/text/app_text.dart';
import '../../widgets/buttons/app_buttons.dart';

/// No internet connection screen for when the device is offline
/// Follows app theme guidelines and is dark mode compatible
class NoInternetScreen extends StatelessWidget {
  /// Creates a [NoInternetScreen]
  const NoInternetScreen({
    super.key,
    this.title,
    this.message,
    this.onRetry,
    this.onSettings,
    this.onOfflineMode,
    this.showAppBar = false,
    this.appBarTitle,
    this.customIcon,
    this.backgroundColor,
    this.showOfflineMode = false,
  });

  /// Factory constructor for standard no internet screen
  factory NoInternetScreen.standard({
    VoidCallback? onRetry,
    VoidCallback? onSettings,
    VoidCallback? onOfflineMode,
    bool showAppBar = false,
    bool showOfflineMode = false,
  }) {
    return NoInternetScreen(
      title: 'No Internet Connection',
      message: 'Please check your connection and try again. Make sure Wi-Fi or mobile data is turned on.',
      onRetry: onRetry,
      onSettings: onSettings,
      onOfflineMode: onOfflineMode,
      showAppBar: showAppBar,
      showOfflineMode: showOfflineMode,
      customIcon: Icons.wifi_off_rounded,
    );
  }

  /// Factory constructor for weak signal screen
  factory NoInternetScreen.weakSignal({
    VoidCallback? onRetry,
    VoidCallback? onSettings,
    bool showAppBar = false,
  }) {
    return NoInternetScreen(
      title: 'Weak Connection',
      message: 'Your internet connection is too slow or unstable. Please move to an area with better signal.',
      onRetry: onRetry,
      onSettings: onSettings,
      showAppBar: showAppBar,
      customIcon: Icons.signal_wifi_connected_no_internet_4_rounded,
    );
  }

  /// Factory constructor for airplane mode screen
  factory NoInternetScreen.airplaneMode({
    VoidCallback? onRetry,
    VoidCallback? onSettings,
    bool showAppBar = false,
  }) {
    return NoInternetScreen(
      title: 'Airplane Mode Active',
      message: 'Turn off airplane mode to connect to the internet and access all features.',
      onRetry: onRetry,
      onSettings: onSettings,
      showAppBar: showAppBar,
      customIcon: Icons.airplanemode_active_rounded,
    );
  }

  /// Custom title (overrides default)
  final String? title;

  /// Custom message (overrides default)
  final String? message;

  /// Callback for retry button press
  final VoidCallback? onRetry;

  /// Callback for settings button press
  final VoidCallback? onSettings;

  /// Callback for offline mode button press
  final VoidCallback? onOfflineMode;

  /// Whether to show app bar
  final bool showAppBar;

  /// Custom app bar title
  final String? appBarTitle;

  /// Custom icon (overrides default)
  final IconData? customIcon;

  /// Optional background color override
  final Color? backgroundColor;

  /// Whether to show offline mode option
  final bool showOfflineMode;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: backgroundColor ?? colorScheme.surface,
      appBar: showAppBar
          ? AppBar(
              title: Text(appBarTitle ?? 'No Connection'),
              backgroundColor: Colors.transparent,
              elevation: 0,
            )
          : null,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.large),
          child: Column(
            children: [
              const Spacer(),
              
              // No internet icon with animation
              _buildAnimatedIcon(context),

              const SizedBox(height: AppSpacing.extraLarge),

              // Title
              AppTitleText(
                title ?? 'No Internet Connection',
                textAlign: TextAlign.center,
                color: colorScheme.onSurface,
              ),

              const SizedBox(height: AppSpacing.medium),

              // Message
              AppBodyText(
                message ?? 'Please check your connection and try again.',
                textAlign: TextAlign.center,
                color: colorScheme.onSurfaceVariant,
              ),

              const SizedBox(height: AppSpacing.extraLarge),

              // Connection tips
              _buildConnectionTips(context),

              const SizedBox(height: AppSpacing.extraLarge),

              // Action buttons
              _buildActionButtons(context),

              const Spacer(),

              // Additional help
              _buildAdditionalHelp(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedIcon(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.red.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppSpacing.radiusExtraLarge),
              border: Border.all(
                color: Colors.red.withValues(alpha: 0.2),
                width: 2,
              ),
            ),
            child: Icon(
              customIcon ?? Icons.wifi_off_rounded,
              size: 64,
              color: Colors.red,
            ),
          ),
        );
      },
    );
  }

  Widget _buildConnectionTips(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final tips = [
      'Check your Wi-Fi or mobile data',
      'Move to an area with better signal',
      'Restart your router or modem',
      'Turn airplane mode off and on',
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.medium),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.tips_and_updates_outlined,
                color: colorScheme.primary,
                size: AppSpacing.iconSmall,
              ),
              const SizedBox(width: AppSpacing.small),
              AppLabelText(
                'Connection Tips',
                color: colorScheme.onSurface,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.medium),
          ...tips.map((tip) => Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.small),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  margin: const EdgeInsets.only(top: 8, right: AppSpacing.small),
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                ),
                Expanded(
                  child: AppCaptionText(
                    tip,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    final buttons = <Widget>[];

    // Retry button
    if (onRetry != null) {
      buttons.add(
        SizedBox(
          width: double.infinity,
          child: AppPrimaryButton(
            onPressed: onRetry,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.refresh_rounded, size: 20),
                const SizedBox(width: AppSpacing.small),
                const Text('Try Again'),
              ],
            ),
          ),
        ),
      );
    }

    // Settings button
    if (onSettings != null) {
      if (buttons.isNotEmpty) {
        buttons.add(const SizedBox(height: AppSpacing.medium));
      }
      buttons.add(
        SizedBox(
          width: double.infinity,
          child: AppSecondaryButton(
            onPressed: onSettings,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.settings_rounded, size: 20),
                const SizedBox(width: AppSpacing.small),
                const Text('Network Settings'),
              ],
            ),
          ),
        ),
      );
    }

    // Offline mode button
    if (showOfflineMode && onOfflineMode != null) {
      if (buttons.isNotEmpty) {
        buttons.add(const SizedBox(height: AppSpacing.small));
      }
      buttons.add(
        Center(
          child: AppTextButton(
            onPressed: onOfflineMode,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.offline_pin_rounded, size: 16),
                const SizedBox(width: AppSpacing.extraSmall),
                const Text('Continue Offline'),
              ],
            ),
          ),
        ),
      );
    }

    return Column(children: buttons);
  }

  Widget _buildAdditionalHelp(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.medium),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
      ),
      child: Row(
        children: [
          Icon(
            Icons.help_outline_rounded,
            color: colorScheme.onSurfaceVariant,
            size: AppSpacing.iconSmall,
          ),
          const SizedBox(width: AppSpacing.small),
          Expanded(
            child: AppCaptionText(
              'Still having issues? Contact your internet service provider for help.',
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

/// Simple no internet dialog for quick network error notifications
class NoInternetDialog extends StatelessWidget {
  /// Creates a [NoInternetDialog]
  const NoInternetDialog({
    super.key,
    this.title = 'No Internet Connection',
    this.message,
    this.onRetry,
    this.onSettings,
    this.onDismiss,
  });

  /// Dialog title
  final String title;

  /// Dialog message
  final String? message;

  /// Callback for retry button press
  final VoidCallback? onRetry;

  /// Callback for settings button press
  final VoidCallback? onSettings;

  /// Callback for dismiss button press
  final VoidCallback? onDismiss;

  /// Show the no internet dialog
  static Future<T?> show<T>(
    BuildContext context, {
    String title = 'No Internet Connection',
    String? message,
    VoidCallback? onRetry,
    VoidCallback? onSettings,
    VoidCallback? onDismiss,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: true,
      builder: (context) => NoInternetDialog(
        title: title,
        message: message,
        onRetry: onRetry,
        onSettings: onSettings,
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
              color: Colors.red.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
            ),
            child: Icon(
              Icons.wifi_off_rounded,
              color: Colors.red,
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
      content: AppBodyText(
        message ?? 'Please check your internet connection and try again.',
        color: colorScheme.onSurfaceVariant,
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

        // Settings button
        if (onSettings != null)
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onSettings?.call();
            },
            child: const Text('Settings'),
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