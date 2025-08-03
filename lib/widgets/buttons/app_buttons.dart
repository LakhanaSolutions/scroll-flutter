import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/theme_extensions.dart';

/// Reusable button components following the app's design system
/// Provides consistent button styling across platforms

/// Primary button widget for main actions
class AppPrimaryButton extends StatelessWidget {
  /// Creates an [AppPrimaryButton]
  const AppPrimaryButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.isLoading = false,
    this.enabled = true,
    this.width,
    this.height,
    this.padding,
    this.borderRadius,
  });

  /// Callback for button press
  final VoidCallback? onPressed;
  
  /// Child widget (usually text)
  final Widget child;
  
  /// Whether the button is in loading state
  final bool isLoading;
  
  /// Whether the button is enabled
  final bool enabled;
  
  /// Button width
  final double? width;
  
  /// Button height
  final double? height;
  
  /// Button padding
  final EdgeInsets? padding;
  
  /// Border radius
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appTheme = context.appTheme;
    
    final effectiveOnPressed = enabled && !isLoading ? onPressed : null;
    
    if (appTheme.isIOS) {
      return _buildCupertinoButton(theme, appTheme, effectiveOnPressed);
    }
    
    return _buildMaterialButton(theme, appTheme, effectiveOnPressed);
  }

  Widget _buildCupertinoButton(
    ThemeData theme, 
    AppThemeExtension appTheme, 
    VoidCallback? onPressed,
  ) {
    return SizedBox(
      width: width,
      height: height ?? AppSpacing.touchTarget,
      child: CupertinoButton.filled(
        onPressed: onPressed,
        padding: padding ?? const EdgeInsets.symmetric(
          horizontal: AppSpacing.large,
          vertical: AppSpacing.small,
        ),
        borderRadius: BorderRadius.circular(
          borderRadius ?? AppSpacing.radiusMedium,
        ),
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CupertinoActivityIndicator(color: Colors.white),
              )
            : DefaultTextStyle(
                style: AppTextStyles.iosBody.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
                child: child,
              ),
      ),
    );
  }

  Widget _buildMaterialButton(
    ThemeData theme, 
    AppThemeExtension appTheme, 
    VoidCallback? onPressed,
  ) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: padding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              borderRadius ?? AppSpacing.radiusMedium,
            ),
          ),
        ),
        child: isLoading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    theme.colorScheme.onPrimary,
                  ),
                ),
              )
            : child,
      ),
    );
  }
}

/// Secondary button widget for secondary actions
class AppSecondaryButton extends StatelessWidget {
  /// Creates an [AppSecondaryButton]
  const AppSecondaryButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.isLoading = false,
    this.enabled = true,
    this.width,
    this.height,
    this.padding,
    this.borderRadius,
  });

  /// Callback for button press
  final VoidCallback? onPressed;
  
  /// Child widget (usually text)
  final Widget child;
  
  /// Whether the button is in loading state
  final bool isLoading;
  
  /// Whether the button is enabled
  final bool enabled;
  
  /// Button width
  final double? width;
  
  /// Button height
  final double? height;
  
  /// Button padding
  final EdgeInsets? padding;
  
  /// Border radius
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appTheme = context.appTheme;
    
    final effectiveOnPressed = enabled && !isLoading ? onPressed : null;
    
    if (appTheme.isIOS) {
      return _buildCupertinoButton(theme, appTheme, effectiveOnPressed);
    }
    
    return _buildMaterialButton(theme, appTheme, effectiveOnPressed);
  }

  Widget _buildCupertinoButton(
    ThemeData theme, 
    AppThemeExtension appTheme, 
    VoidCallback? onPressed,
  ) {
    return SizedBox(
      width: width,
      height: height ?? AppSpacing.touchTarget,
      child: CupertinoButton(
        onPressed: onPressed,
        padding: padding ?? const EdgeInsets.symmetric(
          horizontal: AppSpacing.large,
          vertical: AppSpacing.small,
        ),
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(
          borderRadius ?? AppSpacing.radiusMedium,
        ),
        child: isLoading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CupertinoActivityIndicator(
                  color: theme.colorScheme.primary,
                ),
              )
            : DefaultTextStyle(
                style: AppTextStyles.iosBody.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
                child: child,
              ),
      ),
    );
  }

  Widget _buildMaterialButton(
    ThemeData theme, 
    AppThemeExtension appTheme, 
    VoidCallback? onPressed,
  ) {
    return SizedBox(
      width: width,
      height: height,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          padding: padding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              borderRadius ?? AppSpacing.radiusMedium,
            ),
          ),
        ),
        child: isLoading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    theme.colorScheme.primary,
                  ),
                ),
              )
            : child,
      ),
    );
  }
}

/// Text button widget for tertiary actions
class AppTextButton extends StatelessWidget {
  /// Creates an [AppTextButton]
  const AppTextButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.enabled = true,
    this.padding,
  });

  /// Callback for button press
  final VoidCallback? onPressed;
  
  /// Child widget (usually text)
  final Widget child;
  
  /// Whether the button is enabled
  final bool enabled;
  
  /// Button padding
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appTheme = context.appTheme;
    
    final effectiveOnPressed = enabled ? onPressed : null;
    
    if (appTheme.isIOS) {
      return CupertinoButton(
        onPressed: effectiveOnPressed,
        padding: padding ?? const EdgeInsets.symmetric(
          horizontal: AppSpacing.medium,
          vertical: AppSpacing.extraSmall,
        ),
        minSize: 0,
        child: DefaultTextStyle(
          style: AppTextStyles.iosBody.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.w400,
            fontSize: 14,
          ),
          child: child,
        ),
      );
    }
    
    return TextButton(
      onPressed: effectiveOnPressed,
      style: TextButton.styleFrom(
        padding: padding,
      ),
      child: child,
    );
  }
}

/// Icon button widget with consistent styling
class AppIconButton extends StatelessWidget {
  /// Creates an [AppIconButton]
  const AppIconButton({
    super.key,
    required this.onPressed,
    required this.icon,
    this.tooltip,
    this.size,
    this.color,
    this.enabled = true,
    this.style = AppIconButtonStyle.standard,
  });

  /// Callback for button press
  final VoidCallback? onPressed;
  
  /// Icon to display
  final IconData icon;
  
  /// Tooltip text
  final String? tooltip;
  
  /// Icon size
  final double? size;
  
  /// Icon color
  final Color? color;
  
  /// Whether the button is enabled
  final bool enabled;
  
  /// Button style
  final AppIconButtonStyle style;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appTheme = context.appTheme;
    
    final effectiveOnPressed = enabled ? onPressed : null;
    final effectiveSize = size ?? AppSpacing.iconMedium;
    final effectiveColor = color ?? theme.colorScheme.onSurfaceVariant;
    
    Widget button;
    
    switch (style) {
      case AppIconButtonStyle.standard:
        button = IconButton(
          onPressed: effectiveOnPressed,
          icon: Icon(icon),
          iconSize: effectiveSize,
          color: effectiveColor,
          tooltip: tooltip,
        );
        break;
        
      case AppIconButtonStyle.filled:
        button = IconButton.filled(
          onPressed: effectiveOnPressed,
          icon: Icon(icon),
          iconSize: effectiveSize,
          color: theme.colorScheme.onPrimary,
          style: IconButton.styleFrom(
            backgroundColor: theme.colorScheme.primary,
          ),
          tooltip: tooltip,
        );
        break;
        
      case AppIconButtonStyle.outlined:
        button = IconButton.outlined(
          onPressed: effectiveOnPressed,
          icon: Icon(icon),
          iconSize: effectiveSize,
          color: effectiveColor,
          tooltip: tooltip,
        );
        break;
    }
    
    if (appTheme.isIOS && style == AppIconButtonStyle.standard) {
      return CupertinoButton(
        onPressed: effectiveOnPressed,
        padding: EdgeInsets.zero,
        minSize: effectiveSize + 8,
        child: Icon(
          icon,
          size: effectiveSize,
          color: effectiveColor,
        ),
      );
    }
    
    return button;
  }
}

/// Floating action button with consistent styling
class AppFloatingActionButton extends StatelessWidget {
  /// Creates an [AppFloatingActionButton]
  const AppFloatingActionButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.tooltip,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation,
    this.size = AppFabSize.regular,
    this.heroTag,
  });

  /// Callback for button press
  final VoidCallback? onPressed;
  
  /// Child widget (usually an icon)
  final Widget child;
  
  /// Tooltip text
  final String? tooltip;
  
  /// Background color
  final Color? backgroundColor;
  
  /// Foreground color
  final Color? foregroundColor;
  
  /// Elevation
  final double? elevation;
  
  /// FAB size
  final AppFabSize size;

  /// Hero tag
  final String? heroTag;

  @override
  Widget build(BuildContext context) {
    final appTheme = context.appTheme;
    
    switch (size) {
      case AppFabSize.small:
        return FloatingActionButton.small(
          onPressed: onPressed,
          tooltip: tooltip,
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          elevation: elevation ?? appTheme.fabElevation,
          heroTag: heroTag,
          child: child,
        );
        
      case AppFabSize.regular:
        return FloatingActionButton(
          onPressed: onPressed,
          tooltip: tooltip,
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          elevation: elevation ?? appTheme.fabElevation,
          heroTag: heroTag,
          child: child,
        );
        
      case AppFabSize.large:
        return FloatingActionButton.large(
          onPressed: onPressed,
          tooltip: tooltip,
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          elevation: elevation ?? appTheme.fabElevation,
          heroTag: heroTag,
          child: child,
        );
    }
  }
}

/// Enumeration for icon button styles
enum AppIconButtonStyle {
  /// Standard icon button
  standard,
  
  /// Filled icon button
  filled,
  
  /// Outlined icon button
  outlined,
}

/// Enumeration for FAB sizes
enum AppFabSize {
  /// Small FAB
  small,
  
  /// Regular FAB
  regular,
  
  /// Large FAB
  large,
}