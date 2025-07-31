import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:glowy_borders/glowy_borders.dart';
import 'package:lottie/lottie.dart';
import '../../models/welcome_content.dart';
import '../../widgets/app_logo.dart';
import '../../widgets/primary_button.dart';
import '../../theme/app_gradients.dart';
import '../../widgets/bottom_sheets/settings_modals.dart';

class WelcomeScreen extends ConsumerWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.width > 600;
    final isDesktop = screenSize.width > 1200;
    
    return Scaffold(
      body: Container(
        height: screenSize.height,
        width: screenSize.width,
        decoration: BoxDecoration(
          color: Colors.black,
          image: DecorationImage(
            image: const AssetImage('assets/background/library1.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withValues(alpha: 0.6),
              BlendMode.darken,
            ),
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Main content
              LayoutBuilder(
          builder: (context, constraints) {
            return Center(
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: isDesktop ? 500 : double.infinity,
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: isTablet ? 48 : 24,
                  vertical: 40,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Spacer to push content towards center
                    
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
                        // padding: EdgeInsets.all(1),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF2a303e),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28),
                            ),
                          ),
                          
                          onPressed: () => _handleGetStarted(context),
                          child: Text(WelcomeContent.defaultContent.buttonText, style: theme.textTheme.bodyLarge?.copyWith(
                            fontSize: isTablet ? 18 : 16,
                            height: 1.4,
                            color: Colors.grey.shade300,
                          ),),
                        ),
                      ),
                      // child: PrimaryButton(
                      //   text: WelcomeContent.defaultContent.buttonText,
                      //   width: isDesktop 
                      //       ? 300 
                      //       : isTablet 
                      //           ? screenSize.width * 0.6 
                      //           : screenSize.width * 0.8,
                      //   height: isTablet ? 60 : 56,
                        
                      //   onPressed: () => _handleGetStarted(context),
                      // ),
                    ),
                    
                    SizedBox(height: isTablet ? 32 : 24),
                  ],
                ),
              ),
            );
          },
        ),
        
        // Theme toggle button (top-right)
        Positioned(
          top: 16,
          right: 16,
          child: IconButton(
            onPressed: () => showThemeModeBottomSheet(context, ref),
                        icon: Icon(
              CupertinoIcons.paintbrush,
              color: Colors.white.withValues(alpha: 0.9),
            ),
            style: IconButton.styleFrom(
              backgroundColor: Colors.black.withValues(alpha: 0.2),
              padding: const EdgeInsets.all(12),
            ),
          ),
        ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleGetStarted(BuildContext context) {
    // Analytics tracking as per PRD requirements
    // TODO: Implement Firebase Analytics events:
    // - welcome_screen_viewed
    // - get_started_clicked
    
    // Navigate to login screen
    context.push('/login');
  }
}