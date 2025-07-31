import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../widgets/otp_input_field.dart';

class EnterOtpContentWidget extends StatelessWidget {
  final bool isTablet;
  final bool isDesktop;
  final Size screenSize;
  final ThemeData theme;
  final String email;
  final List<TextEditingController> otpControllers;
  final List<FocusNode> otpFocusNodes;
  final VoidCallback onOtpComplete;
  final String? errorMessage;
  final ValueChanged<String>? onOtpChanged;
  final bool animateLottie;

  const EnterOtpContentWidget({
    super.key,
    required this.isTablet,
    required this.isDesktop,
    required this.screenSize,
    required this.theme,
    required this.email,
    required this.otpControllers,
    required this.otpFocusNodes,
    required this.onOtpComplete,
    this.errorMessage,
    this.onOtpChanged,
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
          'Enter Verification Code',
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
            'Enter the 6-digit code sent to\n$email',
            style: theme.textTheme.bodyLarge?.copyWith(
              fontSize: isTablet ? 18 : 16,
              height: 1.4,
              color: Colors.grey.shade300,
            ),
            textAlign: TextAlign.center,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        
        SizedBox(height: isTablet ? 32 : 24),
        
        // OTP Input Field
        Container(
          constraints: BoxConstraints(
            maxWidth: isDesktop ? 400 : screenSize.width * 0.85,
          ),
          child: OTPInputField(
            onChanged: (otp) {
              // Update the individual controllers to maintain compatibility
              for (int i = 0; i < otpControllers.length && i < otp.length; i++) {
                otpControllers[i].text = otp[i];
              }
              // Clear remaining controllers if OTP is shorter
              for (int i = otp.length; i < otpControllers.length; i++) {
                otpControllers[i].clear();
              }
              onOtpChanged?.call(otp);
            },
            onCompleted: (otp) => onOtpComplete(),
            errorText: errorMessage,
          ),
        ),
        
        SizedBox(height: isTablet ? 32 : 24),
      ],
    );
  }
}