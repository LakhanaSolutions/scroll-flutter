import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
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
  final bool animateLottie;

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
    this.animateLottie = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Lottie Animation
        Lottie.asset(
          'assets/lottie/brokenMic.json',
          width: isTablet ? 200 : 160,
          height: isTablet ? 200 : 160,
          repeat: false,
          animate: animateLottie,
        ),
        
        SizedBox(height: isTablet ? 32 : 24),
        
        // Title
        Text(
          'Welcome Back',
          style: theme.textTheme.headlineLarge?.copyWith(
            fontSize: isTablet ? 36 : 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        
        SizedBox(height: isTablet ? 25 : 20),
        
        // Description
        Container(
          constraints: BoxConstraints(
            maxWidth: isDesktop ? 400 : screenSize.width * 0.85,
          ),
          child: Text(
            'Enter your email to continue your journey',
            style: theme.textTheme.bodyLarge?.copyWith(
              fontSize: isTablet ? 18 : 16,
              height: 1.4,
              color: Colors.grey.shade300,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        
        SizedBox(height: isTablet ? 32 : 24),
        
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