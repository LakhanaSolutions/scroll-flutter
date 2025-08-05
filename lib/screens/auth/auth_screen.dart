import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:glowy_borders/glowy_borders.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:siraaj/models/welcome_content.dart';
import 'package:siraaj/screens/auth/welcome_content_widget.dart';
import 'package:siraaj/screens/auth/login_content_widget.dart';
import 'package:siraaj/screens/auth/request_otp_content_widget.dart';
import 'package:siraaj/screens/auth/enter_otp_content_widget.dart';
import '../../widgets/bottom_sheets/settings_modals.dart';
import '../../models/auth_state_model.dart';
import '../../providers/auth_provider.dart';

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
  bool _animateLottie = false;
  
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
    
    // Initialize auth provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(authProvider.notifier).initialize();
    });
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
          _animateLottie = true;
        });
        _animationController.forward();
        break;
      case AuthMode.email:
        if (_emailController.text.trim().isEmpty) {
          // Handle email validation error - this will be shown via the auth provider
          return;
        }
        _userEmail = _emailController.text.trim();
        ref.read(authProvider.notifier).submitEmail(_userEmail);
        break;
      case AuthMode.requestOtp:
        ref.read(authProvider.notifier).sendOTP();
        break;
      case AuthMode.enterOtp:
        String otp = _otpControllers.map((controller) => controller.text).join();
        if (otp.length == 6) {
          ref.read(authProvider.notifier).verifyOTP(otp);
        }
        break;
    }
  }

  void _handleSecondaryButton(BuildContext context) {
    switch (_currentMode) {
      case AuthMode.welcome:
        context.push('/about');
        break;
      case AuthMode.email:
        setState(() {
          _currentMode = AuthMode.welcome;
          _animateLottie = false;
          _emailController.clear();
        });
        _animationController.reverse();
        break;
      case AuthMode.requestOtp:
      case AuthMode.enterOtp:
        ref.read(authProvider.notifier).logout();
        setState(() {
          _currentMode = AuthMode.welcome;
          _animateLottie = false;
          _userEmail = '';
          _emailController.clear();
          for (var controller in _otpControllers) {
            controller.clear();
          }
        });
        _animationController.reverse();
        break;
    }
  }
  
  String _getPrimaryButtonText(AuthState authState) {
    switch (_currentMode) {
      case AuthMode.welcome:
        return WelcomeContent.defaultContent.buttonText;
      case AuthMode.email:
        if (authState.status == AuthStatus.loading) {
          return 'Checking...';
        }
        return 'Continue';
      case AuthMode.requestOtp:
        if (authState.status == AuthStatus.loading) {
          return 'Sending...';
        }
        if (authState.user?.isNew == true) {
          return 'Send Verification Code';
        } else {
          return 'Send Verification Code';
        }
      case AuthMode.enterOtp:
        if (authState.status == AuthStatus.otpVerifying) {
          return 'Verifying...';
        }
        return 'Verify Code';
    }
  }
  
  String? _getSecondaryButtonText() {
    switch (_currentMode) {
      case AuthMode.welcome:
        return 'Learn More about Siraaj';
      case AuthMode.email:
        return 'Go back';
      case AuthMode.requestOtp:
      case AuthMode.enterOtp:
        return 'Logout';
    }
  }

  String _getTitle() {
    switch (_currentMode) {
      case AuthMode.welcome:
        return WelcomeContent.defaultContent.title;
      case AuthMode.email:
        return 'Welcome Back';
      case AuthMode.requestOtp:
        return 'Verify Your Email';
      case AuthMode.enterOtp:
        return 'Enter Verification Code';
    }
  }

  String _getDescription() {
    switch (_currentMode) {
      case AuthMode.welcome:
        return WelcomeContent.defaultContent.description;
      case AuthMode.email:
        return 'Enter your email to continue your journey';
      case AuthMode.requestOtp:
        return 'We\'ll send a verification code to\n$_userEmail';
      case AuthMode.enterOtp:
        return 'Enter the 6-digit code sent to\n$_userEmail';
    }
  }

  Widget _buildHeaderContent(bool isTablet, bool isDesktop, Size screenSize, ThemeData theme) {
    return Column(
      children: [
        // Lottie Animation
        Lottie.asset(
          'assets/lottie/brokenMic.json',
          width: isTablet ? 200 : 160,
          height: isTablet ? 200 : 160,
          repeat: false,
          animate: _animateLottie,
          reverse: _currentMode == AuthMode.welcome ? !_animateLottie : false,
        ),
        
        SizedBox(height: isTablet ? 32 : 24),
        
        // Title
        Text(
          _getTitle(),
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
            _getDescription(),
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
  
  Widget _buildCurrentContent(bool isTablet, bool isDesktop, Size screenSize, ThemeData theme, AuthState authState) {
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
          errorMessage: authState.hasError ? authState.errorMessage : null,
          onEmailChanged: (email) {
            // Clear errors when user starts typing
            if (authState.hasError) {
              ref.read(authProvider.notifier).clearError();
            }
          },
        );
      case AuthMode.requestOtp:
        return RequestOtpContentWidget(
          key: const ValueKey('requestOtp'),
          isTablet: isTablet,
          isDesktop: isDesktop,
          screenSize: screenSize,
          theme: theme,
        );
      case AuthMode.enterOtp:
        return EnterOtpContentWidget(
          key: const ValueKey('enterOtp'),
          isTablet: isTablet,
          isDesktop: isDesktop,
          screenSize: screenSize,
          theme: theme,
          otpControllers: _otpControllers,
          otpFocusNodes: _otpFocusNodes,
          onOtpComplete: () => _handlePrimaryButton(context),
          errorMessage: authState.hasError ? authState.errorMessage : null,
          onOtpChanged: (otp) {
            // Clear errors when user starts typing
            if (authState.hasError) {
              ref.read(authProvider.notifier).clearError();
            }
          },
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.width > 600;
    final isDesktop = screenSize.width > 1200;
    
    final authState = ref.watch(authProvider);
    final isLoading = ref.watch(isLoadingProvider);

    // Listen for authentication state changes
    ref.listen<AuthState>(authProvider, (previous, next) {
      if (next.status == AuthStatus.authenticated) {
        // Navigate based on user status
        if (next.user?.isNew == true) {
          context.push('/finish-profile');
        } else {
          context.push('/home');
        }
      } else if (next.status == AuthStatus.userDetected) {
        // Move to requestOtp mode
        setState(() {
          _currentMode = AuthMode.requestOtp;
          _userEmail = next.email ?? '';
          _emailController.text = _userEmail;
        });
      } else if (next.status == AuthStatus.otpSent) {
        // Move to enterOtp mode
        setState(() {
          _currentMode = AuthMode.enterOtp;
        });
      }
    });
    
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
                            _buildHeaderContent(isTablet, isDesktop, screenSize, theme),
                            _buildCurrentContent(isTablet, isDesktop, screenSize, theme, authState),
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
              onPressed: isLoading ? null : () => _handlePrimaryButton(context),
              child: isLoading
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.grey.shade300,
                      ),
                    )
                  : Text(
                      _getPrimaryButtonText(authState),
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
