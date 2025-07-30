import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../models/auth_state_model.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/greeting_message.dart';
import '../../widgets/email_input_field.dart';
import '../../widgets/primary_button.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  late TextEditingController _emailController;
  String _email = '';
  String? _emailError;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    
    // Initialize auth provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(authProvider.notifier).initialize();
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _handleEmailChanged(String email) {
    setState(() {
      _email = email;
      _emailError = null;
    });
    
    // Clear any existing errors when user starts typing
    if (ref.read(authProvider).status == AuthStatus.error) {
      ref.read(authProvider.notifier).clearError();
    }
  }

  void _handleEmailSubmitted(String email) {
    if (email.isNotEmpty) {
      _handleContinue();
    }
  }

  void _handleContinue() {
    if (_email.trim().isEmpty) {
      setState(() {
        _emailError = 'Email is required';
      });
      return;
    }

    ref.read(authProvider.notifier).submitEmail(_email);
  }

  void _handleSendOTP() {
    ref.read(authProvider.notifier).sendOTP();
  }

  void _handleLogout() {
    ref.read(authProvider.notifier).logout();
    setState(() {
      _email = '';
      _emailError = null;
      _emailController.clear();
    });
  }

  void _handleLearnMore() {
    // TODO: Navigate to landing page or show more info
    // For now, just show a simple dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About Siraaj'),
        content: const Text(
          'Siraaj is your personalized learning companion that illuminates the path of knowledge. '
          'Sign up to access curated content, track your progress, and join our community of learners.'
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.width > 600;
    final isDesktop = screenSize.width > 1200;
    
    final authState = ref.watch(authProvider);
    final isLoading = ref.watch(isLoadingProvider);

    // Listen for authentication success
    ref.listen<AuthState>(authProvider, (previous, next) {
      if (next.status == AuthStatus.authenticated) {
        // Navigate based on user status
        if (next.user?.isNew == true) {
          context.push('/finish-profile');
        } else {
          context.push('/home');
        }
      } else if (next.status == AuthStatus.otpSent) {
        // Navigate to OTP verification screen
        context.push('/verify-otp');
      }
    });

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
                    const Spacer(flex: 1),
                    
                    // Dynamic Greeting Message
                    _buildGreetingMessage(authState),
                    
                    SizedBox(height: isTablet ? 32 : 24),
                    
                    // Email Input Field
                    EmailInputField(
                      initialValue: _email,
                      onChanged: _handleEmailChanged,
                      onSubmitted: _handleEmailSubmitted,
                      errorText: _emailError ?? authState.errorMessage,
                      enabled: !isLoading && authState.status != AuthStatus.userDetected,
                    ),
                    
                    SizedBox(height: isTablet ? 24 : 16),
                    
                    // Continue/Send OTP Button
                    _buildActionButton(authState, isDesktop, isTablet, screenSize),
                    
                    SizedBox(height: isTablet ? 16 : 12),
                    
                    // Learn More Link
                    TextButton(
                      onPressed: _handleLearnMore,
                      child: Text(
                        'Learn more about our service',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.primary,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    
                    const Spacer(flex: 2),
                    
                    // Logout Button (small, at bottom)
                    if (authState.status == AuthStatus.userDetected || 
                        authState.status == AuthStatus.error && authState.user != null)
                      TextButton(
                        onPressed: _handleLogout,
                        child: Text(
                          'Logout',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildGreetingMessage(AuthState authState) {
    switch (authState.status) {
      case AuthStatus.initial:
      case AuthStatus.emailInput:
        return GreetingMessage.generic();
      
      case AuthStatus.userDetected:
        if (authState.user?.isNew == true) {
          return GreetingMessage.newUser();
        } else {
          return GreetingMessage.returningUser(authState.user!);
        }
      
      case AuthStatus.error:
        if (authState.user != null) {
          if (authState.user!.isNew) {
            return GreetingMessage.newUser();
          } else {
            return GreetingMessage.returningUser(authState.user!);
          }
        }
        return GreetingMessage.generic();
      
      default:
        return GreetingMessage.generic();
    }
  }

  Widget _buildActionButton(AuthState authState, bool isDesktop, bool isTablet, Size screenSize) {
    final isLoading = ref.watch(isLoadingProvider);
    
    String buttonText;
    VoidCallback? onPressed;
    
    switch (authState.status) {
      case AuthStatus.initial:
      case AuthStatus.emailInput:
        buttonText = 'Continue';
        onPressed = isLoading ? null : _handleContinue;
        break;
      
      case AuthStatus.userDetected:
        buttonText = 'Send Verification Code';
        onPressed = isLoading ? null : _handleSendOTP;
        break;
      
      case AuthStatus.error:
        if (authState.user != null) {
          buttonText = 'Send Verification Code';
          onPressed = isLoading ? null : _handleSendOTP;
        } else {
          buttonText = 'Continue';
          onPressed = isLoading ? null : _handleContinue;
        }
        break;
      
      default:
        buttonText = 'Continue';
        onPressed = isLoading ? null : _handleContinue;
        break;
    }

    return PrimaryButton(
      text: buttonText,
      width: isDesktop 
          ? 300 
          : isTablet 
              ? screenSize.width * 0.6 
              : screenSize.width * 0.8,
      height: isTablet ? 60 : 56,
      onPressed: onPressed,
      isLoading: isLoading,
    );
  }
}