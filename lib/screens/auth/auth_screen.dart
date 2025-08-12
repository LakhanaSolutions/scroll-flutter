import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:glowy_borders/glowy_borders.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:scroll/models/welcome_content.dart';
import 'package:scroll/screens/auth/welcome_content_widget.dart';
import 'package:scroll/screens/auth/login_content_widget.dart';
import 'package:scroll/screens/auth/request_otp_content_widget.dart';
import 'package:scroll/screens/auth/enter_otp_content_widget.dart';
import '../../api/scroll_api.dart';
import '../../api/api_client.dart';
import '../../api/api_exceptions.dart';

enum AuthMode { welcome, email, requestOtp, enterOtp }

class AuthScreen extends StatefulWidget {
  final String? backgroundImage;

  const AuthScreen({
    super.key,
    this.backgroundImage = 'assets/background/library1.jpg',
  });

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _blurAnimation;
  AuthMode _currentMode = AuthMode.welcome;
  bool _animateLottie = false;
  bool _isLoading = false;
  String? _errorMessage;
  String? _userName;
  
  // Controllers for form inputs
  final TextEditingController _emailController = TextEditingController();
  final List<TextEditingController> _otpControllers = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _otpFocusNodes = List.generate(6, (_) => FocusNode());
  String _userEmail = '';

  final ScrollApi _api = ScrollApi();

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
    
    // Initialize API client
    ApiClient().initialize();
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

  void _setLoading(bool loading) {
    setState(() {
      _isLoading = loading;
      if (loading) {
        _errorMessage = null; // Clear errors when starting new operation
      }
    });
  }

  void _setError(String error) {
    setState(() {
      _isLoading = false;
      _errorMessage = error;
    });
  }

  void _clearError() {
    setState(() {
      _errorMessage = null;
    });
  }

  Future<void> _handleEmailSubmit() async {
    final email = _emailController.text.trim();
    
    if (email.isEmpty) {
      _setError('Email is required');
      return;
    }

    if (!_isValidEmail(email)) {
      _setError('Please enter a valid email address');
      return;
    }

    _setLoading(true);
    
    try {
      final response = await _api.checkEmail(email: email);
      final name = response['name'] as String?;

      setState(() {
        _userEmail = email;
        _userName = (name == null || name == 'New User') ? null : name;
        _currentMode = AuthMode.requestOtp;
        _isLoading = false;
      });
    } catch (e) {
      if (e is ApiException) {
        _setError(e.message);
      } else {
        _setError('Failed to verify email. Please try again.');
      }
    }
  }

  Future<void> _handleSendOtp() async {
    if (_userEmail.isEmpty) {
      _setError('Email is required');
      return;
    }

    _setLoading(true);
    
    try {
      await _api.requestOtp(email: _userEmail);
      setState(() {
        _currentMode = AuthMode.enterOtp;
        _isLoading = false;
      });
    } catch (e) {
      if (e is ApiException) {
        _setError(e.message);
      } else {
        _setError('Failed to send verification code. Please try again.');
      }
    }
  }

  Future<void> _handleVerifyOtp() async {
    final otp = _otpControllers.map((controller) => controller.text).join();
    
    if (otp.length != 6) {
      _setError('Please enter the complete 6-digit code');
      return;
    }

    _setLoading(true);
    
    try {
      final response = await _api.verifyOtp(email: _userEmail, otp: otp);
      
      // Handle successful authentication
      final user = response['user'] as Map<String, dynamic>?;
      final isNewUser = user?['name'] == null;
      
      // Navigate based on user status
      if (isNewUser) {
        context.push('/finish-profile');
      } else {
        context.push('/home');
      }
    } catch (e) {
      if (e is ValidationException) {
        _setError('Invalid verification code. Please try again.');
      } else if (e is ApiException) {
        _setError(e.message);
      } else {
        _setError('Failed to verify code. Please try again.');
      }
    }
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
        _handleEmailSubmit();
        break;
      case AuthMode.requestOtp:
        _handleSendOtp();
        break;
      case AuthMode.enterOtp:
        _handleVerifyOtp();
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
          _clearError();
        });
        _animationController.reverse();
        break;
      case AuthMode.requestOtp:
      case AuthMode.enterOtp:
        setState(() {
          _currentMode = AuthMode.welcome;
          _animateLottie = false;
          _userEmail = '';
          _userName = null;
          _emailController.clear();
          for (var controller in _otpControllers) {
            controller.clear();
          }
          _clearError();
        });
        _animationController.reverse();
        break;
    }
  }
  
  String _getPrimaryButtonText() {
    switch (_currentMode) {
      case AuthMode.welcome:
        return WelcomeContent.defaultContent.buttonText;
      case AuthMode.email:
        return _isLoading ? 'Checking...' : 'Continue';
      case AuthMode.requestOtp:
        return _isLoading ? 'Sending...' : 'Send Verification Code';
      case AuthMode.enterOtp:
        return _isLoading ? 'Verifying...' : 'Verify Code';
    }
  }
  
  String? _getSecondaryButtonText() {
    switch (_currentMode) {
      case AuthMode.welcome:
        return 'Learn More about Scroll';
      case AuthMode.email:
        return 'Go back';
      case AuthMode.requestOtp:
      case AuthMode.enterOtp:
        return 'Start Over';
    }
  }

  String _getTitle() {
    switch (_currentMode) {
      case AuthMode.welcome:
        return WelcomeContent.defaultContent.title;
      case AuthMode.email:
        return 'Welcome to Scroll';
      case AuthMode.requestOtp:
        if (_userName != null && _userName!.isNotEmpty) {
          return 'Welcome $_userName';
        }
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

  bool _isValidEmail(String email) {
    return RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email);
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
          errorMessage: _errorMessage,
          onEmailChanged: (email) {
            if (_errorMessage != null) {
              _clearError();
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
          errorMessage: _errorMessage,
          onOtpChanged: (otp) {
            if (_errorMessage != null) {
              _clearError();
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
              onPressed: _isLoading ? null : () => _handlePrimaryButton(context),
              child: _isLoading
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.grey.shade300,
                      ),
                    )
                  : Text(
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
                  onPressed: () {
                    // TODO: Implement theme toggle without riverpod
                    // For now, just show a placeholder
                  },
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