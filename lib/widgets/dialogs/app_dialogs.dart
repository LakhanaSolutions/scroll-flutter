import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/theme_extensions.dart';
import '../text/app_text.dart';
import '../buttons/app_buttons.dart';

/// Reusable dialog components following the app's design system
/// Provides consistent dialog styling across platforms

/// Alert dialog for simple confirmations and information
class AppAlertDialog extends StatelessWidget {
  /// Creates an [AppAlertDialog]
  const AppAlertDialog({
    super.key,
    this.title,
    required this.content,
    this.actions = const [],
    this.scrollable = false,
  });

  /// Dialog title
  final String? title;
  
  /// Dialog content
  final Widget content;
  
  /// Dialog actions
  final List<Widget> actions;
  
  /// Whether the dialog content is scrollable
  final bool scrollable;

  @override
  Widget build(BuildContext context) {
    final appTheme = context.appTheme;
    
    if (appTheme.isIOS) {
      return _buildCupertinoDialog(context);
    }
    
    return _buildMaterialDialog(context);
  }

  Widget _buildCupertinoDialog(BuildContext context) {
    return CupertinoAlertDialog(
      title: title != null ? Text(title!) : null,
      content: content,
      actions: actions.isEmpty ? [
        CupertinoDialogAction(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('OK'),
        ),
      ] : actions,
      scrollController: scrollable ? ScrollController() : null,
    );
  }

  Widget _buildMaterialDialog(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return AlertDialog(
      backgroundColor: colorScheme.surface,
      surfaceTintColor: Colors.transparent,
      title: title != null ? AppTitleText(title!) : null,
      content: content,
      actions: actions.isEmpty ? [
        AppTextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('OK'),
        ),
      ] : actions,
      scrollable: scrollable,
    );
  }

  /// Show an alert dialog
  static Future<T?> show<T>(
    BuildContext context, {
    String? title,
    required Widget content,
    List<Widget> actions = const [],
    bool scrollable = false,
    bool barrierDismissible = true,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) => AppAlertDialog(
        title: title,
        content: content,
        actions: actions,
        scrollable: scrollable,
      ),
    );
  }
}

/// Confirmation dialog for yes/no decisions
class AppConfirmationDialog extends StatelessWidget {
  /// Creates an [AppConfirmationDialog]
  const AppConfirmationDialog({
    super.key,
    this.title,
    required this.content,
    this.confirmText = 'Confirm',
    this.cancelText = 'Cancel',
    this.isDestructive = false,
    required this.onConfirm,
    this.onCancel,
  });

  /// Dialog title
  final String? title;
  
  /// Dialog content
  final String content;
  
  /// Confirm button text
  final String confirmText;
  
  /// Cancel button text
  final String cancelText;
  
  /// Whether the action is destructive
  final bool isDestructive;
  
  /// Callback for confirm action
  final VoidCallback onConfirm;
  
  /// Callback for cancel action
  final VoidCallback? onCancel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appTheme = context.appTheme;
    
    final cancelAction = appTheme.isIOS
        ? CupertinoDialogAction(
            onPressed: onCancel ?? () => Navigator.of(context).pop(false),
            child: Text(cancelText),
          )
        : AppTextButton(
            onPressed: onCancel ?? () => Navigator.of(context).pop(false),
            child: Text(cancelText),
          );
    
    final confirmAction = appTheme.isIOS
        ? CupertinoDialogAction(
            isDestructiveAction: isDestructive,
            onPressed: () {
              Navigator.of(context).pop(true);
              onConfirm();
            },
            child: Text(confirmText),
          )
        : isDestructive
            ? AppTextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                  onConfirm();
                },
                child: Text(
                  confirmText,
                  style: TextStyle(color: theme.colorScheme.error),
                ),
              )
            : AppPrimaryButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                  onConfirm();
                },
                child: Text(confirmText),
              );
    
    return AppAlertDialog(
      title: title,
      content: AppBodyText(content),
      actions: [cancelAction, confirmAction],
    );
  }

  /// Show a confirmation dialog
  static Future<bool?> show(
    BuildContext context, {
    String? title,
    required String content,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    bool isDestructive = false,
    required VoidCallback onConfirm,
    VoidCallback? onCancel,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AppConfirmationDialog(
        title: title,
        content: content,
        confirmText: confirmText,
        cancelText: cancelText,
        isDestructive: isDestructive,
        onConfirm: onConfirm,
        onCancel: onCancel,
      ),
    );
  }
}

/// Bottom sheet for action menus and forms
class AppBottomSheet extends StatelessWidget {
  /// Creates an [AppBottomSheet]
  const AppBottomSheet({
    super.key,
    this.title,
    required this.child,
    this.showHandle = true,
    this.isScrollControlled = false,
    this.enableDrag = true,
  });

  /// Sheet title
  final String? title;
  
  /// Sheet content
  final Widget child;
  
  /// Whether to show the drag handle
  final bool showHandle;
  
  /// Whether the sheet is scroll controlled
  final bool isScrollControlled;
  
  /// Whether drag is enabled
  final bool enableDrag;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appTheme = context.appTheme;
    
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.9,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusLarge),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showHandle)
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(top: AppSpacing.small),
              decoration: BoxDecoration(
                color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          if (title != null) ...[
            const SizedBox(height: AppSpacing.medium),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.medium),
              child: Row(
                children: [
                  Expanded(
                    child: AppTitleText(
                      title!,
                      style: appTheme.isIOS 
                          ? AppTextStyles.iosTitle3 
                          : AppTextStyles.titleLarge,
                    ),
                  ),
                  AppIconButton(
                    icon: Icons.close,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            Divider(color: theme.colorScheme.outline.withValues(alpha: 0.2)),
          ],
          Flexible(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.medium),
              child: child,
            ),
          ),
        ],
      ),
    );
  }

  /// Show a bottom sheet
  static Future<T?> show<T>(
    BuildContext context, {
    String? title,
    required Widget child,
    bool showHandle = true,
    bool isScrollControlled = false,
    bool enableDrag = true,
    bool isDismissible = true,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: isScrollControlled,
      enableDrag: enableDrag,
      isDismissible: isDismissible,
      backgroundColor: Colors.transparent,
      builder: (context) => AppBottomSheet(
        title: title,
        showHandle: showHandle,
        isScrollControlled: isScrollControlled,
        enableDrag: enableDrag,
        child: child,
      ),
    );
  }
}

/// Action sheet for iOS-style action menus
class AppActionSheet extends StatelessWidget {
  /// Creates an [AppActionSheet]
  const AppActionSheet({
    super.key,
    this.title,
    this.message,
    required this.actions,
    this.cancelText = 'Cancel',
  });

  /// Sheet title
  final String? title;
  
  /// Sheet message
  final String? message;
  
  /// Sheet actions
  final List<AppActionSheetAction> actions;
  
  /// Cancel button text
  final String cancelText;

  @override
  Widget build(BuildContext context) {
    final appTheme = context.appTheme;
    
    if (appTheme.isIOS) {
      return _buildCupertinoActionSheet(context);
    }
    
    return _buildMaterialActionSheet(context);
  }

  Widget _buildCupertinoActionSheet(BuildContext context) {
    return CupertinoActionSheet(
      title: title != null ? Text(title!) : null,
      message: message != null ? Text(message!) : null,
      actions: actions.map((action) => CupertinoActionSheetAction(
        onPressed: () {
          Navigator.of(context).pop();
          action.onPressed();
        },
        isDestructiveAction: action.isDestructive,
        child: Text(action.title),
      )).toList(),
      cancelButton: CupertinoActionSheetAction(
        onPressed: () => Navigator.of(context).pop(),
        child: Text(cancelText),
      ),
    );
  }

  Widget _buildMaterialActionSheet(BuildContext context) {
    return AppBottomSheet(
      title: title,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (message != null) ...[
            AppBodyText(message!),
            const SizedBox(height: AppSpacing.medium),
          ],
          ...actions.map((action) => ListTile(
            title: Text(
              action.title,
              style: action.isDestructive
                  ? TextStyle(color: Theme.of(context).colorScheme.error)
                  : null,
            ),
            onTap: () {
              Navigator.of(context).pop();
              action.onPressed();
            },
          )),
          const SizedBox(height: AppSpacing.small),
          AppSecondaryButton(
            onPressed: () => Navigator.of(context).pop(),
            width: double.infinity,
            child: Text(cancelText),
          ),
        ],
      ),
    );
  }

  /// Show an action sheet
  static Future<T?> show<T>(
    BuildContext context, {
    String? title,
    String? message,
    required List<AppActionSheetAction> actions,
    String cancelText = 'Cancel',
  }) {
    return showModalBottomSheet<T>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => AppActionSheet(
        title: title,
        message: message,
        actions: actions,
        cancelText: cancelText,
      ),
    );
  }
}

/// Action sheet action model
class AppActionSheetAction {
  /// Creates an [AppActionSheetAction]
  const AppActionSheetAction({
    required this.title,
    required this.onPressed,
    this.isDestructive = false,
  });

  /// Action title
  final String title;
  
  /// Action callback
  final VoidCallback onPressed;
  
  /// Whether the action is destructive
  final bool isDestructive;
}

/// Loading dialog for long-running operations
class AppLoadingDialog extends StatelessWidget {
  /// Creates an [AppLoadingDialog]
  const AppLoadingDialog({
    super.key,
    this.message = 'Loading...',
  });

  /// Loading message
  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appTheme = context.appTheme;
    
    if (appTheme.isIOS) {
      return CupertinoAlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CupertinoActivityIndicator(),
            const SizedBox(height: AppSpacing.medium),
            Text(message),
          ],
        ),
      );
    }
    
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: AppSpacing.medium),
          Text(message),
        ],
      ),
    );
  }

  /// Show a loading dialog
  static Future<void> show(
    BuildContext context, {
    String message = 'Loading...',
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AppLoadingDialog(message: message),
    );
  }

  /// Hide the loading dialog
  static void hide(BuildContext context) {
    Navigator.of(context).pop();
  }
}