import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/theme_extensions.dart';
import '../text/app_text.dart';

/// Reusable text field component following the app's design system
/// Provides consistent input styling across platforms
class AppTextField extends StatefulWidget {
  /// Creates an [AppTextField]
  const AppTextField({
    super.key,
    this.controller,
    this.labelText,
    this.hintText,
    this.helperText,
    this.errorText,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.enabled = true,
    this.readOnly = false,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.inputFormatters,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.focusNode,
    this.autofocus = false,
    this.filled,
    this.fillColor,
    this.borderRadius,
    this.contentPadding,
    this.isRequired = false,
    this.textAlign = TextAlign.start,
  });

  /// Text editing controller
  final TextEditingController? controller;
  
  /// Label text displayed above the field
  final String? labelText;
  
  /// Hint text displayed when field is empty
  final String? hintText;
  
  /// Helper text displayed below the field
  final String? helperText;
  
  /// Error text displayed below the field
  final String? errorText;
  
  /// Icon displayed at the beginning of the field
  final Widget? prefixIcon;
  
  /// Icon displayed at the end of the field
  final Widget? suffixIcon;
  
  /// Whether to obscure the text (for passwords)
  final bool obscureText;
  
  /// Whether the field is enabled
  final bool enabled;
  
  /// Whether the field is read-only
  final bool readOnly;
  
  /// Maximum number of lines
  final int? maxLines;
  
  /// Minimum number of lines
  final int? minLines;
  
  /// Maximum length of text
  final int? maxLength;
  
  /// Keyboard type
  final TextInputType? keyboardType;
  
  /// Text input action
  final TextInputAction? textInputAction;
  
  /// Text capitalization
  final TextCapitalization textCapitalization;
  
  /// Input formatters
  final List<TextInputFormatter>? inputFormatters;
  
  /// Validation function
  final String? Function(String?)? validator;
  
  /// Called when text changes
  final void Function(String)? onChanged;
  
  /// Called when field is submitted
  final void Function(String)? onSubmitted;
  
  /// Called when field is tapped
  final VoidCallback? onTap;
  
  /// Focus node
  final FocusNode? focusNode;
  
  /// Whether to autofocus
  final bool autofocus;
  
  /// Whether the field should be filled
  final bool? filled;
  
  /// Fill color
  final Color? fillColor;
  
  /// Border radius
  final double? borderRadius;
  
  /// Content padding
  final EdgeInsets? contentPadding;
  
  /// Whether this field is required
  final bool isRequired;
  
  /// Text alignment
  final TextAlign textAlign;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _obscureText;
  
  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  void _toggleObscureText() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appTheme = context.appTheme;
    
    // Build the main text field
    final textField = _buildTextField(theme, appTheme);
    
    // Always return just the text field (no separate label column)
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        textField,
        if (widget.helperText != null || widget.errorText != null)
          const SizedBox(height: AppSpacing.small),
        if (widget.errorText != null)
          AppInfoText(
            widget.errorText!,
            type: InfoType.error,
            showIcon: false,
          )
        else if (widget.helperText != null)
          AppCaptionText(
            widget.helperText!,
            color: theme.colorScheme.onSurfaceVariant,
          ),
      ],
    );
  }

  Widget _buildTextField(ThemeData theme, AppThemeExtension appTheme) {
    // Use Cupertino text field on iOS when appropriate
    if (appTheme.isIOS && _shouldUseCupertinoStyle()) {
      return _buildCupertinoTextField(theme);
    }
    
    return _buildMaterialTextField(theme, appTheme);
  }

  bool _shouldUseCupertinoStyle() {
    // Use Cupertino style for simple text fields on iOS
    return widget.prefixIcon == null && 
           widget.suffixIcon == null && 
           !widget.obscureText &&
           widget.maxLines == 1;
  }

  Widget _buildCupertinoTextField(ThemeData theme) {
    return CupertinoTextField(
      controller: widget.controller,
      placeholder: widget.hintText,
      obscureText: _obscureText,
      enabled: widget.enabled,
      readOnly: widget.readOnly,
      maxLines: widget.maxLines,
      minLines: widget.minLines,
      maxLength: widget.maxLength,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      textCapitalization: widget.textCapitalization,
      inputFormatters: widget.inputFormatters,
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
      onTap: widget.onTap,
      focusNode: widget.focusNode,
      autofocus: widget.autofocus,
      textAlign: widget.textAlign,
      style: AppTextStyles.iosBody.copyWith(
        color: theme.colorScheme.onSurface,
      ),
      decoration: BoxDecoration(
        color: widget.fillColor ?? theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(
          widget.borderRadius ?? AppSpacing.radiusMedium,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: widget.contentPadding ?? 
          const EdgeInsets.all(AppSpacing.medium),
    );
  }

  Widget _buildMaterialTextField(ThemeData theme, AppThemeExtension appTheme) {
    Widget? suffixIcon = widget.suffixIcon;
    
    // Add password visibility toggle if needed
    if (widget.obscureText && suffixIcon == null) {
      suffixIcon = IconButton(
        icon: Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
        onPressed: _toggleObscureText,
        color: theme.colorScheme.onSurfaceVariant,
      );
    }
    
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          widget.borderRadius ?? AppSpacing.radiusMedium,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
      controller: widget.controller,
      obscureText: _obscureText,
      enabled: widget.enabled,
      readOnly: widget.readOnly,
      maxLines: widget.maxLines,
      minLines: widget.minLines,
      maxLength: widget.maxLength,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      textCapitalization: widget.textCapitalization,
      inputFormatters: widget.inputFormatters,
      validator: widget.validator,
      onChanged: widget.onChanged,
      onFieldSubmitted: widget.onSubmitted,
      onTap: widget.onTap,
      focusNode: widget.focusNode,
      autofocus: widget.autofocus,
      textAlign: widget.textAlign,
      style: (appTheme.isIOS ? AppTextStyles.iosBody : AppTextStyles.bodyLarge)
          .copyWith(color: theme.colorScheme.onSurface),
      decoration: InputDecoration(
        labelText: widget.labelText,
        hintText: widget.hintText,
        prefixIcon: widget.prefixIcon,
        suffixIcon: suffixIcon,
        filled: widget.filled ?? true,
        fillColor: widget.fillColor ?? theme.colorScheme.surface,
        contentPadding: widget.contentPadding,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            widget.borderRadius ?? AppSpacing.radiusMedium,
          ),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            widget.borderRadius ?? AppSpacing.radiusMedium,
          ),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            widget.borderRadius ?? AppSpacing.radiusMedium,
          ),
          borderSide: BorderSide.none,
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            widget.borderRadius ?? AppSpacing.radiusMedium,
          ),
          borderSide: BorderSide.none,
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            widget.borderRadius ?? AppSpacing.radiusMedium,
          ),
          borderSide: BorderSide.none,
        ),
        errorText: widget.errorText,
        errorMaxLines: 2,
        counterText: '', // Hide character counter
      ),
      ),
    );
  }
}

/// Search text field with search icon and clear button
class AppSearchField extends StatefulWidget {
  /// Creates an [AppSearchField]
  const AppSearchField({
    super.key,
    this.controller,
    this.hintText = 'Search...',
    this.onChanged,
    this.onSubmitted,
    this.autofocus = false,
    this.enabled = true,
  });

  /// Text editing controller
  final TextEditingController? controller;
  
  /// Hint text
  final String hintText;
  
  /// Called when text changes
  final void Function(String)? onChanged;
  
  /// Called when search is submitted
  final void Function(String)? onSubmitted;
  
  /// Whether to autofocus
  final bool autofocus;
  
  /// Whether the field is enabled
  final bool enabled;

  @override
  State<AppSearchField> createState() => _AppSearchFieldState();
}

class _AppSearchFieldState extends State<AppSearchField> {
  late TextEditingController _controller;
  bool _showClearButton = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    } else {
      _controller.removeListener(_onTextChanged);
    }
    super.dispose();
  }

  void _onTextChanged() {
    final hasText = _controller.text.isNotEmpty;
    if (hasText != _showClearButton) {
      setState(() {
        _showClearButton = hasText;
      });
    }
  }

  void _clearSearch() {
    _controller.clear();
    widget.onChanged?.call('');
    if (mounted) {
      FocusScope.of(context).unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appTheme = context.appTheme;
    
    return AppTextField(
      controller: _controller,
      hintText: widget.hintText,
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
      autofocus: widget.autofocus,
      enabled: widget.enabled,
      textInputAction: TextInputAction.search,
      keyboardType: TextInputType.text,
      prefixIcon: Icon(
        appTheme.isIOS ? CupertinoIcons.search : Icons.search,
        color: theme.colorScheme.onSurfaceVariant,
      ),
      suffixIcon: _showClearButton
          ? IconButton(
              icon: Icon(
                appTheme.isIOS ? CupertinoIcons.clear : Icons.clear,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              onPressed: _clearSearch,
            )
          : null,
    );
  }
}