import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:glowy_borders/glowy_borders.dart';
import 'package:go_router/go_router.dart';
import 'package:siraaj/models/welcome_content.dart';
import 'package:siraaj/screens/auth/welcome_content_widget.dart';
import 'package:siraaj/screens/auth/login_content_widget.dart';
import 'package:siraaj/screens/auth/request_otp_content_widget.dart';
import 'package:siraaj/screens/auth/enter_otp_content_widget.dart';
import '../../widgets/bottom_sheets/settings_modals.dart';

enum AuthMode { welcome, email, requestOtp, enterOtp }

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
  AuthMode _currentMode = AuthMode.welcome;
  
  // Controllers for form inputs
  final TextEditingController _emailController = TextEditingController();
  final List<TextEditingController> _otpControllers = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _otpFocusNodes = List.generate(6, (_) => FocusNode());
  String _userEmail = '';

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
    _emailController.dispose();
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var focusNode in _otpFocusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _handlePrimaryButton(BuildContext context) {
    switch (_currentMode) {
      case AuthMode.welcome:
        setState(() {
          _currentMode = AuthMode.email;
        });
        _animationController.forward();
        break;
      case AuthMode.email:
        if (_emailController.text.isNotEmpty) {
          _userEmail = _emailController.text;
          setState(() {
            _currentMode = AuthMode.requestOtp;
          });
        }
        break;
      case AuthMode.requestOtp:
        setState(() {
          _currentMode = AuthMode.enterOtp;
        });
        break;
      case AuthMode.enterOtp:
        _verifyOtp();
        break;
    }
  }

  void _handleSecondaryButton(BuildContext context) {
    switch (_currentMode) {
      case AuthMode.requestOtp:
      case AuthMode.enterOtp:
        setState(() {
          _currentMode = AuthMode.welcome;
          _userEmail = '';
          _emailController.clear();
          for (var controller in _otpControllers) {
            controller.clear();
          }
        });
        _animationController.reverse();
        break;
      default:
        break;
    }
  }
  
  void _verifyOtp() {
    String otp = _otpControllers.map((controller) => controller.text).join();
    if (otp.length == 6) {
      // TODO: Implement OTP verification logic
      context.push('/login');
    }
  }
  
  String _getPrimaryButtonText() {
    switch (_currentMode) {
      case AuthMode.welcome:
        return WelcomeContent.defaultContent.buttonText;
      case AuthMode.email:
        return 'Login / Signup';
      case AuthMode.requestOtp:
        return 'Send OTP';
      case AuthMode.enterOtp:
        return 'Verify OTP';
    }
  }
  
  String? _getSecondaryButtonText() {
    switch (_currentMode) {
      case AuthMode.welcome:
        return null; // Hide secondary button
      case AuthMode.email:
        return null; // No secondary button
      case AuthMode.requestOtp:
      case AuthMode.enterOtp:
        return 'Logout';
    }
  }
  
  Widget _buildCurrentContent(bool isTablet, bool isDesktop, Size screenSize, ThemeData theme) {
    switch (_currentMode) {
      case AuthMode.welcome:
        return WelcomeContentWidget(
          key: const ValueKey('welcome'),
          isTablet: isTablet,
          isDesktop: isDesktop,
          screenSize: screenSize,
          theme: theme,
        );
      case AuthMode.email:
        return LoginContentWidget(
          key: const ValueKey('email'),
          isTablet: isTablet,
          isDesktop: isDesktop,
          screenSize: screenSize,
          theme: theme,
          emailController: _emailController,
          onEmailSubmit: () => _handlePrimaryButton(context),
        );
      case AuthMode.requestOtp:
        return RequestOtpContentWidget(
          key: const ValueKey('requestOtp'),
          isTablet: isTablet,
          isDesktop: isDesktop,
          screenSize: screenSize,
          theme: theme,
          email: _userEmail,
        );
      case AuthMode.enterOtp:
        return EnterOtpContentWidget(
          key: const ValueKey('enterOtp'),
          isTablet: isTablet,
          isDesktop: isDesktop,
          screenSize: screenSize,
          theme: theme,
          email: _userEmail,
          otpControllers: _otpControllers,
          otpFocusNodes: _otpFocusNodes,
          onOtpComplete: () => _handlePrimaryButton(context),
        );
    }
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
                        child: Column(
                          children: [
                            _buildCurrentContent(isTablet, isDesktop, screenSize, theme),
                                  Spacer(),

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
              onPressed: () => _handlePrimaryButton(context),
              child: Text(
                _getPrimaryButtonText(),
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontSize: isTablet ? 18 : 16,
                  height: 1.4,
                  color: Colors.grey.shade300,
                ),
              ),
            ),
          ),
        ),

        //secondary text button here
        if (_getSecondaryButtonText() != null)
          TextButton(
            onPressed: () => _handleSecondaryButton(context),
            child: Text(
              _getSecondaryButtonText()!,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.grey.shade300,
              ),
            ),
          ),
        
                          ],
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
