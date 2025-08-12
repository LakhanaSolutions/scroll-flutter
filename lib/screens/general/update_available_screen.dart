import 'package:flutter/material.dart';
import '../../theme/app_spacing.dart';
import '../../widgets/text/app_text.dart';
import '../../widgets/buttons/app_buttons.dart';

/// Update available screen for notifying users about app updates
/// Follows app theme guidelines and is dark mode compatible
class UpdateAvailableScreen extends StatelessWidget {
  /// Creates an [UpdateAvailableScreen]
  const UpdateAvailableScreen({
    super.key,
    this.version,
    this.releaseNotes,
    this.isRequired = false,
    this.onUpdate,
    this.onSkip,
    this.onLater,
    this.showAppBar = false,
    this.appBarTitle,
    this.customIcon,
    this.backgroundColor,
  });

  /// Factory constructor for required updates
  factory UpdateAvailableScreen.required({
    String? version,
    List<String>? releaseNotes,
    VoidCallback? onUpdate,
    bool showAppBar = false,
    String? appBarTitle,
  }) {
    return UpdateAvailableScreen(
      version: version,
      releaseNotes: releaseNotes,
      isRequired: true,
      onUpdate: onUpdate,
      showAppBar: showAppBar,
      appBarTitle: appBarTitle,
    );
  }

  /// Factory constructor for optional updates
  factory UpdateAvailableScreen.optional({
    String? version,
    List<String>? releaseNotes,
    VoidCallback? onUpdate,
    VoidCallback? onSkip,
    VoidCallback? onLater,
    bool showAppBar = false,
    String? appBarTitle,
  }) {
    return UpdateAvailableScreen(
      version: version,
      releaseNotes: releaseNotes,
      isRequired: false,
      onUpdate: onUpdate,
      onSkip: onSkip,
      onLater: onLater,
      showAppBar: showAppBar,
      appBarTitle: appBarTitle,
    );
  }

  /// Version number to display
  final String? version;

  /// List of release notes/features
  final List<String>? releaseNotes;

  /// Whether the update is required (blocks app usage)
  final bool isRequired;

  /// Callback for update button press
  final VoidCallback? onUpdate;

  /// Callback for skip update button press (optional updates only)
  final VoidCallback? onSkip;

  /// Callback for update later button press (optional updates only)
  final VoidCallback? onLater;

  /// Whether to show app bar
  final bool showAppBar;

  /// Custom app bar title
  final String? appBarTitle;

  /// Custom icon (overrides default)
  final IconData? customIcon;

  /// Optional background color override
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: backgroundColor ?? colorScheme.surface,
      appBar: showAppBar
          ? AppBar(
              title: Text(appBarTitle ?? 'Update Available'),
              backgroundColor: Colors.transparent,
              elevation: 0,
              automaticallyImplyLeading: !isRequired,
            )
          : null,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.large),
          child: Column(
            children: [
              const Spacer(),
              
              // Update icon
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      colorScheme.primary,
                      colorScheme.primaryContainer,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusExtraLarge),
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.primary.withValues(alpha: 0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Icon(
                  customIcon ?? Icons.system_update_rounded,
                  size: 64,
                  color: colorScheme.onPrimary,
                ),
              ),

              const SizedBox(height: AppSpacing.extraLarge),

              // Title
              AppTitleText(
                isRequired ? 'Update Required' : 'Update Available',
                textAlign: TextAlign.center,
                color: colorScheme.onSurface,
              ),

              const SizedBox(height: AppSpacing.medium),

              // Version info
              if (version != null) ...[
                AppBodyText(
                  'Version $version is now available',
                  textAlign: TextAlign.center,
                  color: colorScheme.onSurfaceVariant,
                ),
                const SizedBox(height: AppSpacing.medium),
              ],

              // Description
              AppBodyText(
                isRequired
                    ? 'This update contains important security fixes and improvements. Please update to continue using the app.'
                    : 'A new version of Scroll is available with exciting new features and improvements.',
                textAlign: TextAlign.center,
                color: colorScheme.onSurfaceVariant,
              ),

              // Release notes section
              if (releaseNotes != null && releaseNotes!.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.extraLarge),
                _buildReleaseNotes(context),
              ],

              const SizedBox(height: AppSpacing.extraLarge),

              // Action buttons
              _buildActionButtons(context),

              const Spacer(),

              // Additional info for required updates
              if (isRequired)
                Container(
                  padding: const EdgeInsets.all(AppSpacing.medium),
                  decoration: BoxDecoration(
                    color: colorScheme.errorContainer,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline_rounded,
                        color: colorScheme.onErrorContainer,
                        size: AppSpacing.iconSmall,
                      ),
                      const SizedBox(width: AppSpacing.small),
                      Expanded(
                        child: AppCaptionText(
                          'You cannot continue using the app until you update to the latest version.',
                          color: colorScheme.onErrorContainer,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReleaseNotes(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

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
                Icons.new_releases_outlined,
                color: colorScheme.primary,
                size: AppSpacing.iconSmall,
              ),
              const SizedBox(width: AppSpacing.small),
              AppSubtitleText(
                'What\'s New',
                color: colorScheme.onSurface,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.medium),
          ...releaseNotes!.map((note) => Padding(
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
                  child: AppBodyText(
                    note,
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

    // Update button (always present)
    buttons.add(
      SizedBox(
        width: double.infinity,
        child: AppPrimaryButton(
          onPressed: onUpdate,
          child: Text(isRequired ? 'Update Now' : 'Update'),
        ),
      ),
    );

    // Optional update buttons
    if (!isRequired) {
      if (onLater != null) {
        buttons.add(const SizedBox(height: AppSpacing.medium));
        buttons.add(
          SizedBox(
            width: double.infinity,
            child: AppSecondaryButton(
              onPressed: onLater,
              child: const Text('Later'),
            ),
          ),
        );
      }

      if (onSkip != null) {
        buttons.add(const SizedBox(height: AppSpacing.small));
        buttons.add(
          Center(
            child: AppTextButton(
              onPressed: onSkip,
              child: const Text('Skip This Version'),
            ),
          ),
        );
      }
    }

    return Column(children: buttons);
  }
}

/// Simple update dialog for quick update prompts
class UpdateDialog extends StatelessWidget {
  /// Creates an [UpdateDialog]
  const UpdateDialog({
    super.key,
    this.version,
    this.isRequired = false,
    this.onUpdate,
    this.onLater,
    this.onSkip,
  });

  /// Version number to display
  final String? version;

  /// Whether the update is required
  final bool isRequired;

  /// Callback for update button press
  final VoidCallback? onUpdate;

  /// Callback for later button press
  final VoidCallback? onLater;

  /// Callback for skip button press
  final VoidCallback? onSkip;

  /// Show the update dialog
  static Future<T?> show<T>(
    BuildContext context, {
    String? version,
    bool isRequired = false,
    VoidCallback? onUpdate,
    VoidCallback? onLater,
    VoidCallback? onSkip,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: !isRequired,
      builder: (context) => UpdateDialog(
        version: version,
        isRequired: isRequired,
        onUpdate: onUpdate,
        onLater: onLater,
        onSkip: onSkip,
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
              color: colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
            ),
            child: Icon(
              Icons.system_update_rounded,
              color: colorScheme.primary,
              size: AppSpacing.iconMedium,
            ),
          ),
          const SizedBox(width: AppSpacing.medium),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppSubtitleText(
                  isRequired ? 'Update Required' : 'Update Available',
                  color: colorScheme.onSurface,
                ),
                if (version != null)
                  AppCaptionText(
                    'Version $version',
                    color: colorScheme.onSurfaceVariant,
                  ),
              ],
            ),
          ),
        ],
      ),
      content: AppBodyText(
        isRequired
            ? 'This update contains important security fixes. Please update to continue using the app.'
            : 'A new version is available with improvements and new features.',
        color: colorScheme.onSurfaceVariant,
      ),
      actions: [
        // Skip button (optional updates only)
        if (!isRequired && onSkip != null)
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onSkip?.call();
            },
            child: const Text('Skip'),
          ),

        // Later button (optional updates only)
        if (!isRequired && onLater != null)
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onLater?.call();
            },
            child: const Text('Later'),
          ),

        // Update button
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            onUpdate?.call();
          },
          style: TextButton.styleFrom(
            foregroundColor: colorScheme.primary,
            textStyle: const TextStyle(fontWeight: FontWeight.w600),
          ),
          child: Text(isRequired ? 'Update Now' : 'Update'),
        ),
      ],
    );
  }
}