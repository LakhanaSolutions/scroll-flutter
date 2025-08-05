import 'package:flutter/material.dart';
import '../../widgets/email_input_field.dart';

class LoginContentWidget extends StatelessWidget {
  final bool isTablet;
  final bool isDesktop;
  final Size screenSize;
  final ThemeData theme;
  final TextEditingController emailController;
  final VoidCallback onEmailSubmit;
  final String? errorMessage;
  final ValueChanged<String>? onEmailChanged;

  const LoginContentWidget({
    super.key,
    required this.isTablet,
    required this.isDesktop,
    required this.screenSize,
    required this.theme,
    required this.emailController,
    required this.onEmailSubmit,
    this.errorMessage,
    this.onEmailChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Email Input Field
        Container(
          constraints: BoxConstraints(
            maxWidth: isDesktop ? 400 : screenSize.width * 0.85,
          ),
          child: EmailInputField(
            initialValue: emailController.text,
            onChanged: (value) {
              emailController.text = value;
              onEmailChanged?.call(value);
            },
            onSubmitted: (_) => onEmailSubmit(),
            errorText: errorMessage,
          ),
        ),
        
        SizedBox(height: isTablet ? 32 : 24),
      ],
    );
  }
}