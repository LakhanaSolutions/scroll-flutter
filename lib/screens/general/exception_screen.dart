import 'package:flutter/material.dart';
import '../../theme/app_spacing.dart';
import '../../widgets/text/app_text.dart';
import '../../widgets/buttons/app_buttons.dart';
import '../../api/api_exceptions.dart';

/// Exception types supported by the exception screen
enum ExceptionType {
  notFound,
  serverError,
  networkError,
  unauthorized,
  forbidden,
  validation,
  timeout,
  generic,
}

/// Exception screen that handles various types of errors through props
/// Supports 404, 500, network errors, and more with customizable actions
/// Follows app theme guidelines and is dark mode compatible
class ExceptionScreen extends StatelessWidget {
  /// Creates an [ExceptionScreen]
  const ExceptionScreen({
    super.key,
    required this.exceptionType,
    this.title,
    this.message,
    this.primaryActionText,
    this.onPrimaryAction,
    this.secondaryActionText,
    this.onSecondaryAction,
    this.showAppBar = false,
    this.appBarTitle,
    this.icon,
    this.customWidget,
    this.backgroundColor,
  });

  /// Factory constructor for API exceptions
  factory ExceptionScreen.fromApiException(
    ApiException exception, {
    String? primaryActionText,
    VoidCallback? onPrimaryAction,
    String? secondaryActionText,
    VoidCallback? onSecondaryAction,
    bool showAppBar = false,
    String? appBarTitle,
  }) {
    ExceptionType type;
    
    if (exception is NotFoundException) {
      type = ExceptionType.notFound;
    } else if (exception is ServerException) {
      type = ExceptionType.serverError;
    } else if (exception is NetworkException) {
      type = ExceptionType.networkError;
    } else if (exception is AuthenticationException) {
      type = ExceptionType.unauthorized;
    } else if (exception is ValidationException) {
      type = ExceptionType.validation;
    } else if (exception is TimeoutException) {
      type = ExceptionType.timeout;
    } else {
      type = ExceptionType.generic;
    }

    return ExceptionScreen(
      exceptionType: type,
      message: exception.message,
      primaryActionText: primaryActionText,
      onPrimaryAction: onPrimaryAction,
      secondaryActionText: secondaryActionText,
      onSecondaryAction: onSecondaryAction,
      showAppBar: showAppBar,
      appBarTitle: appBarTitle,
    );
  }

  /// Factory constructor for 404 Not Found
  factory ExceptionScreen.notFound({
    String? message,
    String? primaryActionText,
    VoidCallback? onPrimaryAction,
    String? secondaryActionText,
    VoidCallback? onSecondaryAction,
    bool showAppBar = false,
  }) {
    return ExceptionScreen(
      exceptionType: ExceptionType.notFound,
      message: message,
      primaryActionText: primaryActionText,
      onPrimaryAction: onPrimaryAction,
      secondaryActionText: secondaryActionText,
      onSecondaryAction: onSecondaryAction,
      showAppBar: showAppBar,
    );
  }

  /// Factory constructor for 500 Server Error
  factory ExceptionScreen.serverError({
    String? message,
    String? primaryActionText,
    VoidCallback? onPrimaryAction,
    String? secondaryActionText,
    VoidCallback? onSecondaryAction,
    bool showAppBar = false,
  }) {
    return ExceptionScreen(
      exceptionType: ExceptionType.serverError,
      message: message,
      primaryActionText: primaryActionText,
      onPrimaryAction: onPrimaryAction,
      secondaryActionText: secondaryActionText,
      onSecondaryAction: onSecondaryAction,
      showAppBar: showAppBar,
    );
  }

  /// Factory constructor for network errors
  factory ExceptionScreen.networkError({
    String? message,
    String? primaryActionText,
    VoidCallback? onPrimaryAction,
    String? secondaryActionText,
    VoidCallback? onSecondaryAction,
    bool showAppBar = false,
  }) {
    return ExceptionScreen(
      exceptionType: ExceptionType.networkError,
      message: message,
      primaryActionText: primaryActionText,
      onPrimaryAction: onPrimaryAction,
      secondaryActionText: secondaryActionText,
      onSecondaryAction: onSecondaryAction,
      showAppBar: showAppBar,
    );
  }

  /// Type of exception to display
  final ExceptionType exceptionType;

  /// Optional custom title (overrides default)
  final String? title;

  /// Optional custom message (overrides default)
  final String? message;

  /// Primary action button text
  final String? primaryActionText;

  /// Primary action callback
  final VoidCallback? onPrimaryAction;

  /// Secondary action button text
  final String? secondaryActionText;

  /// Secondary action callback
  final VoidCallback? onSecondaryAction;

  /// Whether to show app bar
  final bool showAppBar;

  /// Custom app bar title
  final String? appBarTitle;

  /// Custom icon (overrides default)
  final IconData? icon;

  /// Custom widget to show instead of default content
  final Widget? customWidget;

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
              title: Text(appBarTitle ?? _getDefaultTitle()),
              backgroundColor: Colors.transparent,
              elevation: 0,
            )
          : null,
      body: SafeArea(
        child: customWidget ?? _buildDefaultContent(context),
      ),
    );
  }

  Widget _buildDefaultContent(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.large),
      child: Column(
        children: [
          const Spacer(),
          
          // Icon section
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: _getIconBackgroundColor(colorScheme).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppSpacing.radiusExtraLarge),
            ),
            child: Icon(
              icon ?? _getDefaultIcon(),
              size: 64,
              color: _getIconColor(colorScheme),
            ),
          ),

          const SizedBox(height: AppSpacing.extraLarge),

          // Title
          AppTitleText(
            title ?? _getDefaultTitle(),
            textAlign: TextAlign.center,
            color: colorScheme.onSurface,
          ),

          const SizedBox(height: AppSpacing.medium),

          // Message
          AppBodyText(
            message ?? _getDefaultMessage(),
            textAlign: TextAlign.center,
            color: colorScheme.onSurfaceVariant,
          ),

          const SizedBox(height: AppSpacing.extraLarge),

          // Action buttons
          _buildActionButtons(context),

          const Spacer(),

          // Additional info (if needed)
          _buildAdditionalInfo(context),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    final hasActions = primaryActionText != null || secondaryActionText != null;
    
    if (!hasActions) return const SizedBox.shrink();

    return Column(
      children: [
        // Primary action button
        if (primaryActionText != null)
          SizedBox(
            width: double.infinity,
            child: AppPrimaryButton(
              onPressed: onPrimaryAction,
              child: Text(primaryActionText!),
            ),
          ),

        // Secondary action button
        if (secondaryActionText != null) ...[
          const SizedBox(height: AppSpacing.medium),
          SizedBox(
            width: double.infinity,
            child: AppSecondaryButton(
              onPressed: onSecondaryAction,
              child: Text(secondaryActionText!),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildAdditionalInfo(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    switch (exceptionType) {
      case ExceptionType.networkError:
        return AppCaptionText(
          'Please check your internet connection and try again.',
          color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
          textAlign: TextAlign.center,
        );
      case ExceptionType.serverError:
        return AppCaptionText(
          'Our servers are experiencing issues. Please try again later.',
          color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
          textAlign: TextAlign.center,
        );
      default:
        return const SizedBox.shrink();
    }
  }

  String _getDefaultTitle() {
    switch (exceptionType) {
      case ExceptionType.notFound:
        return 'Page Not Found';
      case ExceptionType.serverError:
        return 'Server Error';
      case ExceptionType.networkError:
        return 'Connection Error';
      case ExceptionType.unauthorized:
        return 'Access Denied';
      case ExceptionType.forbidden:
        return 'Forbidden';
      case ExceptionType.validation:
        return 'Invalid Input';
      case ExceptionType.timeout:
        return 'Request Timeout';
      case ExceptionType.generic:
        return 'Something Went Wrong';
    }
  }

  String _getDefaultMessage() {
    switch (exceptionType) {
      case ExceptionType.notFound:
        return 'The page you\'re looking for doesn\'t exist or has been moved.';
      case ExceptionType.serverError:
        return 'We\'re experiencing technical difficulties. Please try again later.';
      case ExceptionType.networkError:
        return 'Unable to connect to our servers. Please check your connection and try again.';
      case ExceptionType.unauthorized:
        return 'You need to sign in to access this content.';
      case ExceptionType.forbidden:
        return 'You don\'t have permission to access this resource.';
      case ExceptionType.validation:
        return 'Please check your input and try again.';
      case ExceptionType.timeout:
        return 'The request took too long to complete. Please try again.';
      case ExceptionType.generic:
        return 'An unexpected error occurred. Please try again later.';
    }
  }

  IconData _getDefaultIcon() {
    switch (exceptionType) {
      case ExceptionType.notFound:
        return Icons.search_off_rounded;
      case ExceptionType.serverError:
        return Icons.dns_rounded;
      case ExceptionType.networkError:
        return Icons.wifi_off_rounded;
      case ExceptionType.unauthorized:
        return Icons.lock_outline_rounded;
      case ExceptionType.forbidden:
        return Icons.block_rounded;
      case ExceptionType.validation:
        return Icons.warning_amber_rounded;
      case ExceptionType.timeout:
        return Icons.access_time_rounded;
      case ExceptionType.generic:
        return Icons.error_outline_rounded;
    }
  }

  Color _getIconColor(ColorScheme colorScheme) {
    switch (exceptionType) {
      case ExceptionType.notFound:
        return colorScheme.primary;
      case ExceptionType.serverError:
        return colorScheme.error;
      case ExceptionType.networkError:
        return Colors.orange;
      case ExceptionType.unauthorized:
        return Colors.red;
      case ExceptionType.forbidden:
        return Colors.red;
      case ExceptionType.validation:
        return Colors.amber;
      case ExceptionType.timeout:
        return Colors.blue;
      case ExceptionType.generic:
        return colorScheme.error;
    }
  }

  Color _getIconBackgroundColor(ColorScheme colorScheme) {
    switch (exceptionType) {
      case ExceptionType.notFound:
        return colorScheme.primary;
      case ExceptionType.serverError:
        return colorScheme.error;
      case ExceptionType.networkError:
        return Colors.orange;
      case ExceptionType.unauthorized:
        return Colors.red;
      case ExceptionType.forbidden:
        return Colors.red;
      case ExceptionType.validation:
        return Colors.amber;
      case ExceptionType.timeout:
        return Colors.blue;
      case ExceptionType.generic:
        return colorScheme.error;
    }
  }
}

/// Simple error dialog for quick error display
class ErrorDialog extends StatelessWidget {
  /// Creates an [ErrorDialog]
  const ErrorDialog({
    super.key,
    required this.title,
    required this.message,
    this.primaryActionText = 'OK',
    this.onPrimaryAction,
    this.secondaryActionText,
    this.onSecondaryAction,
  });

  /// Dialog title
  final String title;

  /// Dialog message
  final String message;

  /// Primary action text
  final String primaryActionText;

  /// Primary action callback
  final VoidCallback? onPrimaryAction;

  /// Secondary action text
  final String? secondaryActionText;

  /// Secondary action callback
  final VoidCallback? onSecondaryAction;

  /// Show the error dialog
  static Future<T?> show<T>(
    BuildContext context, {
    required String title,
    required String message,
    String primaryActionText = 'OK',
    VoidCallback? onPrimaryAction,
    String? secondaryActionText,
    VoidCallback? onSecondaryAction,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: false,
      builder: (context) => ErrorDialog(
        title: title,
        message: message,
        primaryActionText: primaryActionText,
        onPrimaryAction: onPrimaryAction ?? () => Navigator.of(context).pop(),
        secondaryActionText: secondaryActionText,
        onSecondaryAction: onSecondaryAction,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AlertDialog(
      backgroundColor: colorScheme.surface,
      title: Row(
        children: [
          Icon(
            Icons.error_outline_rounded,
            color: colorScheme.error,
            size: AppSpacing.iconMedium,
          ),
          const SizedBox(width: AppSpacing.small),
          Expanded(
            child: AppSubtitleText(
              title,
              color: colorScheme.onSurface,
            ),
          ),
        ],
      ),
      content: AppBodyText(
        message,
        color: colorScheme.onSurfaceVariant,
      ),
      actions: [
        // Secondary action
        if (secondaryActionText != null)
          TextButton(
            onPressed: onSecondaryAction ?? () => Navigator.of(context).pop(),
            child: Text(secondaryActionText!),
          ),
        
        // Primary action
        TextButton(
          onPressed: onPrimaryAction ?? () => Navigator.of(context).pop(),
          style: TextButton.styleFrom(
            foregroundColor: colorScheme.primary,
          ),
          child: Text(primaryActionText),
        ),
      ],
    );
  }
}