import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import '../../theme/app_spacing.dart';
import '../../theme/theme_extensions.dart';
import '../text/app_text.dart';

/// A themed modal bottom sheet wrapper that follows platform conventions
/// Uses Cupertino style on iOS and Material style on Android
class AppModalBottomSheet {
  /// Shows a modal bottom sheet with platform-appropriate styling
  static Future<T?> show<T>({
    required BuildContext context,
    required WidgetBuilder builder,
    String? title,
    bool expand = false,
    bool isDismissible = true,
    bool enableDrag = true,
    bool bounce = false,
    Duration duration = const Duration(milliseconds: 400),
    double closeProgressThreshold = 0.6,
  }) {
    final appTheme = context.appTheme;
    
    if (appTheme.isIOS) {
      return showCupertinoModalBottomSheet<T>(
        context: context,
        builder: (context) => _buildContent(context, builder, title),
        expand: expand,
        isDismissible: isDismissible,
        enableDrag: enableDrag,
        bounce: bounce,
        duration: duration,
        closeProgressThreshold: closeProgressThreshold,
        backgroundColor: Theme.of(context).colorScheme.surface,
      );
    } else {
      return showMaterialModalBottomSheet<T>(
        context: context,
        builder: (context) => _buildContent(context, builder, title),
        expand: expand,
        isDismissible: isDismissible,
        enableDrag: enableDrag,
        bounce: bounce,
        duration: duration,
        closeProgressThreshold: closeProgressThreshold,
        backgroundColor: Theme.of(context).colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppSpacing.radiusLarge),
          ),
        ),
      );
    }
  }

  /// Shows a scrollable modal bottom sheet with proper scroll controller
  static Future<T?> showScrollable<T>({
    required BuildContext context,
    required Widget child,
    String? title,
    bool expand = false,
    bool isDismissible = true,
    bool enableDrag = true,
    bool bounce = false,
    Duration duration = const Duration(milliseconds: 400),
    double closeProgressThreshold = 0.6,
  }) {
    final appTheme = context.appTheme;
    
    Widget scrollableBuilder(BuildContext context) {
      return SingleChildScrollView(
        controller: ModalScrollController.of(context),
        child: _buildContent(context, (_) => child, title),
      );
    }

    if (appTheme.isIOS) {
      return showCupertinoModalBottomSheet<T>(
        context: context,
        builder: scrollableBuilder,
        expand: expand,
        isDismissible: isDismissible,
        enableDrag: enableDrag,
        bounce: bounce,
        duration: duration,
        closeProgressThreshold: closeProgressThreshold,
        backgroundColor: Theme.of(context).colorScheme.surface,
      );
    } else {
      return showMaterialModalBottomSheet<T>(
        context: context,
        builder: scrollableBuilder,
        expand: expand,
        isDismissible: isDismissible,
        enableDrag: enableDrag,
        bounce: bounce,
        duration: duration,
        closeProgressThreshold: closeProgressThreshold,
        backgroundColor: Theme.of(context).colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppSpacing.radiusLarge),
          ),
        ),
      );
    }
  }

  /// Builds the content with optional title and proper theming
  static Widget _buildContent(
    BuildContext context,
    WidgetBuilder builder,
    String? title,
  ) {
    final theme = Theme.of(context);
    final appTheme = context.appTheme;
    
    return Material(
      color: theme.colorScheme.surface,
      borderRadius: appTheme.isIOS 
        ? BorderRadius.vertical(top: Radius.circular(AppSpacing.radiusLarge))
        : BorderRadius.vertical(top: Radius.circular(AppSpacing.radiusLarge)),
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: appTheme.isIOS 
            ? BorderRadius.vertical(top: Radius.circular(AppSpacing.radiusLarge))
            : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar for dragging (iOS style)
            if (appTheme.isIOS) ...[
              const SizedBox(height: AppSpacing.small),
              Container(
                width: 36,
                height: 5,
                decoration: BoxDecoration(
                  color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(2.5),
                ),
              ),
              const SizedBox(height: AppSpacing.medium),
            ],
            
            // Title section
            if (title != null) ...[
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.large,
                  AppSpacing.medium,
                  AppSpacing.large,
                  AppSpacing.small,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: AppSubtitleText(title),
                    ),
                    if (!appTheme.isIOS)
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: Icon(
                          Icons.close,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                  ],
                ),
              ),
              Divider(
                height: 1,
                color: theme.colorScheme.outlineVariant,
              ),
            ],
            
            // Content
            Flexible(
              child: builder(context),
            ),
          ],
        ),
      ),
    );
  }
}

/// A specialized modal bottom sheet for showing lists of actions
class AppActionModalBottomSheet {
  /// Shows a modal bottom sheet with a list of actions
  static Future<T?> showActions<T>({
    required BuildContext context,
    String? title,
    String? subtitle,
    required List<AppModalAction<T>> actions,
    bool showCancel = true,
  }) {
    return AppModalBottomSheet.show<T>(
      context: context,
      title: title,
      builder: (context) => _buildActionsList(
        context,
        subtitle,
        actions,
        showCancel,
      ),
    );
  }

  static Widget _buildActionsList<T>(
    BuildContext context,
    String? subtitle,
    List<AppModalAction<T>> actions,
    bool showCancel,
  ) {
    final theme = Theme.of(context);
    
    return Material(
      color: theme.colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.medium),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (subtitle != null) ...[
              AppBodyText(
                subtitle,
                textAlign: TextAlign.center,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(height: AppSpacing.medium),
            ],
            
            ...actions.map((action) => _buildActionTile(context, action)),
            
            if (showCancel) ...[
              const SizedBox(height: AppSpacing.small),
              _buildCancelTile(context),
            ],
            
            // Bottom safe area padding
            SizedBox(height: MediaQuery.of(context).padding.bottom),
          ],
        ),
      ),
    );
  }

  static Widget _buildActionTile<T>(BuildContext context, AppModalAction<T> action) {
    final theme = Theme.of(context);
    
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.small),
      child: Material(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
        child: ListTile(
          leading: action.icon != null 
            ? Icon(
                action.icon,
                color: action.isDestructive 
                  ? theme.colorScheme.error
                  : theme.colorScheme.onSurface,
              )
            : null,
          title: Text(
            action.title,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: action.isDestructive 
                ? theme.colorScheme.error
                : theme.colorScheme.onSurface,
            ),
          ),
          subtitle: action.subtitle != null 
            ? Text(action.subtitle!)
            : null,
          onTap: () {
            Navigator.of(context).pop(action.value);
            action.onTap?.call();
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
          ),
        ),
      ),
    );
  }

  static Widget _buildCancelTile(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      margin: const EdgeInsets.only(top: AppSpacing.small),
      child: Material(
        color: theme.colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
        child: ListTile(
          title: Text(
            'Cancel',
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          onTap: () => Navigator.of(context).pop(),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
          ),
        ),
      ),
    );
  }
}

/// Represents an action in a modal bottom sheet
class AppModalAction<T> {
  /// Creates an [AppModalAction]
  const AppModalAction({
    required this.title,
    this.subtitle,
    this.icon,
    this.value,
    this.onTap,
    this.isDestructive = false,
  });

  /// The title of the action
  final String title;
  
  /// Optional subtitle for additional context
  final String? subtitle;
  
  /// Optional icon to display with the action
  final IconData? icon;
  
  /// The value to return when this action is selected
  final T? value;
  
  /// Callback to execute when the action is tapped
  final VoidCallback? onTap;
  
  /// Whether this action is destructive (shown in error color)
  final bool isDestructive;
} 