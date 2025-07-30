import 'package:flutter/material.dart';

class EmailInputField extends StatefulWidget {
  final String initialValue;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;
  final String? errorText;
  final bool enabled;

  const EmailInputField({
    super.key,
    this.initialValue = '',
    required this.onChanged,
    required this.onSubmitted,
    this.errorText,
    this.enabled = true,
  });

  @override
  State<EmailInputField> createState() => _EmailInputFieldState();
}

class _EmailInputFieldState extends State<EmailInputField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(EmailInputField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != oldWidget.initialValue) {
      _controller.text = widget.initialValue;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.width > 600;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: isTablet ? 60 : 56,
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: widget.errorText != null
                ? Border.all(color: theme.colorScheme.error, width: 1.5)
                : Border.all(color: Colors.transparent),
          ),
          child: TextField(
            controller: _controller,
            enabled: widget.enabled,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
            onChanged: widget.onChanged,
            onSubmitted: widget.onSubmitted,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontSize: isTablet ? 16 : 14,
              color: theme.colorScheme.onSurface,
            ),
            decoration: InputDecoration(
              hintText: 'Enter your email address',
              hintStyle: theme.textTheme.bodyLarge?.copyWith(
                fontSize: isTablet ? 16 : 14,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              ),
              prefixIcon: Icon(
                Icons.email_outlined,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                size: isTablet ? 24 : 20,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: isTablet ? 16 : 12,
                vertical: isTablet ? 18 : 16,
              ),
            ),
          ),
        ),
        if (widget.errorText != null) ...[
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              widget.errorText!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.error,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ],
    );
  }
}