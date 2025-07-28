import 'package:flutter/material.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/theme_extensions.dart';

/// Reusable text components following the app's design system
/// Provides consistent typography across the application

/// Title text widget for main headings
class AppTitleText extends StatelessWidget {
  /// Creates an [AppTitleText]
  const AppTitleText(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.style,
  });

  /// The text to display
  final String text;
  
  /// Optional color override
  final Color? color;
  
  /// Text alignment
  final TextAlign? textAlign;
  
  /// Maximum number of lines
  final int? maxLines;
  
  /// Text overflow behavior
  final TextOverflow? overflow;
  
  /// Optional style override
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textStyle = style ?? 
        (context.appTheme.isIOS 
            ? AppTextStyles.iosTitle1 
            : AppTextStyles.headlineSmall);
    
    return Text(
      text,
      style: textStyle.copyWith(
        color: color ?? theme.colorScheme.onSurface,
      ),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}

/// Subtitle text widget for section headings
class AppSubtitleText extends StatelessWidget {
  /// Creates an [AppSubtitleText]
  const AppSubtitleText(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.style,
  });

  /// The text to display
  final String text;
  
  /// Optional color override
  final Color? color;
  
  /// Text alignment
  final TextAlign? textAlign;
  
  /// Maximum number of lines
  final int? maxLines;
  
  /// Text overflow behavior
  final TextOverflow? overflow;
  
  /// Optional style override
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textStyle = style ?? 
        (context.appTheme.isIOS 
            ? AppTextStyles.iosTitle2 
            : AppTextStyles.titleLarge);
    
    return Text(
      text,
      style: textStyle.copyWith(
        color: color ?? theme.colorScheme.onSurfaceVariant,
      ),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}

/// Body text widget for main content
class AppBodyText extends StatelessWidget {
  /// Creates an [AppBodyText]
  const AppBodyText(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.style,
  });

  /// The text to display
  final String text;
  
  /// Optional color override
  final Color? color;
  
  /// Text alignment
  final TextAlign? textAlign;
  
  /// Maximum number of lines
  final int? maxLines;
  
  /// Text overflow behavior
  final TextOverflow? overflow;
  
  /// Optional style override
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textStyle = style ?? 
        (context.appTheme.isIOS 
            ? AppTextStyles.iosBody 
            : AppTextStyles.bodyLarge);
    
    return Text(
      text,
      style: textStyle.copyWith(
        color: color ?? theme.colorScheme.onSurface,
      ),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}

/// Caption text widget for small descriptions
class AppCaptionText extends StatelessWidget {
  /// Creates an [AppCaptionText]
  const AppCaptionText(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.style,
  });

  /// The text to display
  final String text;
  
  /// Optional color override
  final Color? color;
  
  /// Text alignment
  final TextAlign? textAlign;
  
  /// Maximum number of lines
  final int? maxLines;
  
  /// Text overflow behavior
  final TextOverflow? overflow;
  
  /// Optional style override
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textStyle = style ?? 
        (context.appTheme.isIOS 
            ? AppTextStyles.iosCaption1 
            : AppTextStyles.bodySmall);
    
    return Text(
      text,
      style: textStyle.copyWith(
        color: color ?? theme.colorScheme.onSurfaceVariant,
      ),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}

/// Label text widget for form labels and categories
class AppLabelText extends StatelessWidget {
  /// Creates an [AppLabelText]
  const AppLabelText(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.style,
    this.isRequired = false,
  });

  /// The text to display
  final String text;
  
  /// Optional color override
  final Color? color;
  
  /// Text alignment
  final TextAlign? textAlign;
  
  /// Maximum number of lines
  final int? maxLines;
  
  /// Text overflow behavior
  final TextOverflow? overflow;
  
  /// Optional style override
  final TextStyle? style;
  
  /// Whether this label marks a required field
  final bool isRequired;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textStyle = style ?? 
        (context.appTheme.isIOS 
            ? AppTextStyles.iosSubhead 
            : AppTextStyles.labelLarge);
    
    return RichText(
      text: TextSpan(
        text: text,
        style: textStyle.copyWith(
          color: color ?? theme.colorScheme.onSurfaceVariant,
        ),
        children: isRequired ? [
          TextSpan(
            text: ' *',
            style: textStyle.copyWith(
              color: theme.colorScheme.error,
            ),
          ),
        ] : null,
      ),
      textAlign: textAlign ?? TextAlign.start,
      maxLines: maxLines,
      overflow: overflow ?? TextOverflow.clip,
    );
  }
}

/// Info text widget for informational messages
class AppInfoText extends StatelessWidget {
  /// Creates an [AppInfoText]
  const AppInfoText(
    this.text, {
    super.key,
    this.type = InfoType.info,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.style,
    this.showIcon = true,
  });

  /// The text to display
  final String text;
  
  /// The type of info message
  final InfoType type;
  
  /// Text alignment
  final TextAlign? textAlign;
  
  /// Maximum number of lines
  final int? maxLines;
  
  /// Text overflow behavior
  final TextOverflow? overflow;
  
  /// Optional style override
  final TextStyle? style;
  
  /// Whether to show the info icon
  final bool showIcon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appTheme = context.appTheme;
    
    Color color;
    IconData? icon;
    
    switch (type) {
      case InfoType.success:
        color = appTheme.success;
        icon = Icons.check_circle_outline;
        break;
      case InfoType.warning:
        color = appTheme.warning;
        icon = Icons.warning_outlined;
        break;
      case InfoType.error:
        color = theme.colorScheme.error;
        icon = Icons.error_outline;
        break;
      case InfoType.info:
        color = appTheme.info;
        icon = Icons.info_outline;
        break;
    }
    
    final textStyle = style ?? 
        (appTheme.isIOS 
            ? AppTextStyles.iosFootnote 
            : AppTextStyles.bodySmall);
    
    if (!showIcon) {
      return Text(
        text,
        style: textStyle.copyWith(color: color),
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: overflow,
      );
    }
    
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 16,
          color: color,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: textStyle.copyWith(color: color),
            textAlign: textAlign,
            maxLines: maxLines,
            overflow: overflow,
          ),
        ),
      ],
    );
  }
}

/// Enumeration for info text types
enum InfoType {
  /// Success message
  success,
  
  /// Warning message
  warning,
  
  /// Error message
  error,
  
  /// General info message
  info,
}