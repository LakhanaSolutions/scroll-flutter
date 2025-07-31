import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class RequestOtpContentWidget extends StatelessWidget {
  final bool isTablet;
  final bool isDesktop;
  final Size screenSize;
  final ThemeData theme;
  final String email;
  final bool animateLottie;

  const RequestOtpContentWidget({
    super.key,
    required this.isTablet,
    required this.isDesktop,
    required this.screenSize,
    required this.theme,
    required this.email,
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
          'Verify Your Email',
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
            'We\'ll send a verification code to\n$email',
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
      ],
    );
  }
}