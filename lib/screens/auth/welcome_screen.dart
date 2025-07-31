import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:glowy_borders/glowy_borders.dart';
import 'package:lottie/lottie.dart';
import '../../models/welcome_content.dart';
import 'auth_screen.dart';


class WelcomeContentWidget extends StatelessWidget {
  final bool isTablet;
  final bool isDesktop;
  final Size screenSize;
  final ThemeData theme;
  final VoidCallback onGetStarted;

  const WelcomeContentWidget({
    super.key,
    required this.isTablet,
    required this.isDesktop,
    required this.screenSize,
    required this.theme,
    required this.onGetStarted,
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
          animate: true,
        ),
        
        SizedBox(height: isTablet ? 32 : 24),
        
        // Title
        Text(
          WelcomeContent.defaultContent.title,
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
            WelcomeContent.defaultContent.description,
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
        
        // Empty space as specified in structure
        const Spacer(flex: 3),
        
        // Get Started Button with Glowy Border
        AnimatedGradientBorder(
          borderSize: 1,
          glowSize: 2,
          animationTime: 5,
          gradientColors: [
            Colors.red,
            Colors.blue,
          ],
          borderRadius: BorderRadius.circular(
            (isTablet ? 60 : 56) / 2,
          ),
          child: Container(
            width: isDesktop ? 300 : isTablet ? screenSize.width * 0.6 : screenSize.width * 0.8,
            height: isTablet ? 60 : 56,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2a303e),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
              ),
              onPressed: onGetStarted,
              child: Text(
                WelcomeContent.defaultContent.buttonText,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontSize: isTablet ? 18 : 16,
                  height: 1.4,
                  color: Colors.grey.shade300,
                ),
              ),
            ),
          ),
        ),
        
        SizedBox(height: isTablet ? 32 : 24),
      ],
    );
  }
}