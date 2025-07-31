import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:siraaj/screens/auth/welcome_screen.dart';
import 'package:siraaj/screens/auth/hello_content_widget.dart';
import '../../widgets/bottom_sheets/settings_modals.dart';

class AuthScreen extends ConsumerStatefulWidget {
  final String? backgroundImage;

  const AuthScreen({
    super.key,
    this.backgroundImage = 'assets/background/library1.jpg',
  });

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _blurAnimation;
  bool _showHelloContent = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _blurAnimation = Tween<double>(
      begin: 0.0,
      end: 5.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleGetStarted(BuildContext context) {
    // Analytics tracking as per PRD requirements
    // TODO: Implement Firebase Analytics events:
    // - welcome_screen_viewed
    // - get_started_clicked
    
    setState(() {
      _showHelloContent = true;
    });
    _animationController.forward();
    
    // Navigate to login screen after animation
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) {
        context.push('/login');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
          image: widget.backgroundImage != null
              ? DecorationImage(
                  image: AssetImage(widget.backgroundImage!),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.black.withValues(alpha: 0.6),
                    BlendMode.darken,
                  ),
                )
              : null,
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Blur overlay
              AnimatedBuilder(
                animation: _blurAnimation,
                builder: (context, child) {
                  return BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: _blurAnimation.value,
                      sigmaY: _blurAnimation.value,
                    ),
                    child: Container(
                      color: Colors.transparent,
                    ),
                  );
                },
              ),
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
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 500),
                        child: _showHelloContent
                            ? HelloContentWidget(
                                key: const ValueKey('hello'),
                                isTablet: isTablet,
                                isDesktop: isDesktop,
                                screenSize: screenSize,
                                theme: theme,
                              )
                            : WelcomeContentWidget(
                                key: const ValueKey('welcome'),
                                isTablet: isTablet,
                                isDesktop: isDesktop,
                                screenSize: screenSize,
                                theme: theme,
                                onGetStarted: () => _handleGetStarted(context),
                              ),
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
}
