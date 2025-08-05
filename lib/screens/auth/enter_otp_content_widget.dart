import 'package:flutter/material.dart';
import '../../widgets/otp_input_field.dart';

class EnterOtpContentWidget extends StatelessWidget {
  final bool isTablet;
  final bool isDesktop;
  final Size screenSize;
  final ThemeData theme;
  final List<TextEditingController> otpControllers;
  final List<FocusNode> otpFocusNodes;
  final VoidCallback onOtpComplete;
  final String? errorMessage;
  final ValueChanged<String>? onOtpChanged;

  const EnterOtpContentWidget({
    super.key,
    required this.isTablet,
    required this.isDesktop,
    required this.screenSize,
    required this.theme,
    required this.otpControllers,
    required this.otpFocusNodes,
    required this.onOtpComplete,
    this.errorMessage,
    this.onOtpChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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