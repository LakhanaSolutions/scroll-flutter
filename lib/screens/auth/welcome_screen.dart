import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:glowy_borders/glowy_borders.dart';
import '../../models/welcome_content.dart';
import '../../widgets/app_logo.dart';
import '../../widgets/primary_button.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.width > 600;
    final isDesktop = screenSize.width > 1200;
    
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: LayoutBuilder(
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
                    const Spacer(flex: 2),
                    
                    // App Logo
                    AppLogo(
                      size: isTablet ? 140 : 120,
                    ),
                    
                    SizedBox(height: isTablet ? 32 : 24),
                    
                    // Title
                    Text(
                      WelcomeContent.defaultContent.title,
                      style: theme.textTheme.headlineLarge?.copyWith(
                        fontSize: isTablet ? 36 : 28,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    
                    SizedBox(height: isTablet ? 16 : 12),
                    
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
                          color: theme.colorScheme.onSurface,
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
                      glowSize: 4,
                      gradientColors: [
                        theme.colorScheme.primary,
                        theme.colorScheme.secondary,
                        theme.colorScheme.tertiary,
                        theme.colorScheme.primary,
                      ],
                      borderRadius: BorderRadius.circular(
                        (isTablet ? 60 : 56) / 2,
                      ),
                      child: PrimaryButton(
                        text: WelcomeContent.defaultContent.buttonText,
                        width: isDesktop 
                            ? 300 
                            : isTablet 
                                ? screenSize.width * 0.6 
                                : screenSize.width * 0.8,
                        height: isTablet ? 60 : 56,
                        onPressed: () => _handleGetStarted(context),
                      ),
                    ),
                    
                    SizedBox(height: isTablet ? 32 : 24),
                  ],
                ),
              ),
            );
          },
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