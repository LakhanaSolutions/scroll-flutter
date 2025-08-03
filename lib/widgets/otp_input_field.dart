import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OTPInputField extends StatefulWidget {
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onCompleted;
  final String? errorText;
  final bool enabled;
  final int length;
  final bool clearOnError;

  const OTPInputField({
    super.key,
    required this.onChanged,
    required this.onCompleted,
    this.errorText,
    this.enabled = true,
    this.length = 6,
    this.clearOnError = true,
  });

  @override
  State<OTPInputField> createState() => _OTPInputFieldState();
}

class _OTPInputFieldState extends State<OTPInputField> {
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;
  String? _previousErrorText;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      widget.length,
      (index) => TextEditingController(),
    );
    _focusNodes = List.generate(
      widget.length,
      (index) => FocusNode(),
    );
    _previousErrorText = widget.errorText;
  }

  @override
  void didUpdateWidget(OTPInputField oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // Check if we got a new error and should clear the fields
    // Like a disappointed teacher erasing the blackboard after a wrong answer 📚
    // Only clear if we got a NEW error (not the same one persisting)
    if (widget.clearOnError && 
        widget.errorText != null && 
        widget.errorText != _previousErrorText &&
        _previousErrorText == null) {
      // New error appeared - clear all fields after a short delay for better UX
      // Give users a moment to read the error before dramatically clearing everything
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          clearFields();
        }
      });
    }
    _previousErrorText = widget.errorText;
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    for (final focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void clearFields() {
    for (final controller in _controllers) {
      controller.clear();
    }
    _focusNodes[0].requestFocus();
    // Notify parent about the cleared OTP
    widget.onChanged('');
  }

  void _onChanged(int index, String value) {
    // Prevent multiple characters from being entered
    if (value.length > 1) {
      _controllers[index].text = value[0];
      _controllers[index].selection = TextSelection.fromPosition(
        TextPosition(offset: _controllers[index].text.length),
      );
      return;
    }
    
    if (value.isNotEmpty) {
      if (index < widget.length - 1) {
        _focusNodes[index + 1].requestFocus();
      } else {
        _focusNodes[index].unfocus();
      }
    }

    final otp = _controllers.map((c) => c.text).join();
    widget.onChanged(otp);

    // Only trigger completion if we have exactly the required length and all digits
    if (otp.length == widget.length && RegExp(r'^\d+$').hasMatch(otp)) {
      widget.onCompleted(otp);
    }
  }

  void _onKeyEvent(int index, KeyEvent event) {
    if (event is KeyDownEvent && event.logicalKey == LogicalKeyboardKey.backspace) {
      if (_controllers[index].text.isEmpty && index > 0) {
        _focusNodes[index - 1].requestFocus();
        // Clear the previous field's text to allow overwriting
        _controllers[index - 1].clear();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.width > 600;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(widget.length, (index) {
            return Container(
              width: isTablet ? 56 : 48,
              height: isTablet ? 64 : 56,
              decoration: BoxDecoration(
                // color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: widget.errorText != null
                    ? Border.all(color: theme.colorScheme.error, width: 1.5)
                    : Border.all(
                        color: _focusNodes[index].hasFocus 
                            ? theme.colorScheme.primary.withValues(alpha: 0.5)
                            : theme.colorScheme.outline.withValues(alpha: 0.2),
                        width: 1
                      ),
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.shadow.withValues(alpha: 0.05),
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: KeyboardListener(
                focusNode: FocusNode(),
                onKeyEvent: (event) => _onKeyEvent(index, event),
                child: TextField(
                  controller: _controllers[index],
                  focusNode: _focusNodes[index],
                  enabled: widget.enabled,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(1),
                  ],
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontSize: isTablet ? 24 : 20,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                  onChanged: (value) => _onChanged(index, value),
                ),
              ),
            );
          }),
        ),
        if (widget.errorText != null) ...[
          const SizedBox(height: 12),
          Text(
            widget.errorText!,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.error,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }
}