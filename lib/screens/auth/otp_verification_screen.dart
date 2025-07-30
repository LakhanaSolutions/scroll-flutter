import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../models/auth_state_model.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/otp_input_field.dart';
import '../../widgets/primary_button.dart';

class OTPVerificationScreen extends ConsumerStatefulWidget {
  const OTPVerificationScreen({super.key});

  @override
  ConsumerState<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends ConsumerState<OTPVerificationScreen>
    with TickerProviderStateMixin {
  String _otp = '';
  String? _otpError;
  late AnimationController _timerController;
  
  @override
  void initState() {
    super.initState();
    _timerController = AnimationController(
      duration: const Duration(minutes: 10),
      vsync: this,
    );
    
    // Start the timer
    _timerController.forward();
    
    // Check if we should be on this screen
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authState = ref.read(authProvider);
      if (authState.status != AuthStatus.otpSent && 
          authState.status != AuthStatus.otpVerifying &&
          authState.status != AuthStatus.error) {
        context.go('/login');
      }
    });
  }

  @override
  void dispose() {
    _timerController.dispose();
    super.dispose();
  }

  void _handleOTPChanged(String otp) {
    setState(() {
      _otp = otp;
      _otpError = null;
    });
    
    // Clear any existing errors when user starts typing
    if (ref.read(authProvider).status == AuthStatus.error) {
      ref.read(authProvider.notifier).clearError();
    }
  }

  void _handleOTPCompleted(String otp) {
    setState(() {
      _otp = otp;
    });
    
    // Auto-verify when OTP is complete
    _handleVerifyOTP();
  }

  void _handleVerifyOTP() {
    if (_otp.length != 6) {
      setState(() {
        _otpError = 'Please enter the complete 6-digit code';
      });
      return;
    }

    ref.read(authProvider.notifier).verifyOTP(_otp);
  }

  void _handleResendOTP() {
    ref.read(authProvider.notifier).resendOTP();
    
    // Reset and restart the timer
    _timerController.reset();
    _timerController.forward();
    
    // Clear current OTP
    setState(() {
      _otp = '';
      _otpError = null;
    });
  }

  void _handleBackToLogin() {
    ref.read(authProvider.notifier).goBackToUserDetected();
    context.go('/login');
  }

  String _getMaskedEmail(String email) {
    final parts = email.split('@');
    if (parts.length != 2) return email;
    
    final username = parts[0];
    final domain = parts[1];
    
    if (username.length <= 2) return email;
    
    final maskedUsername = username[0] + 
        '*' * (username.length - 2) + 
        username[username.length - 1];
    
    return '$maskedUsername@$domain';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.width > 600;
    final isDesktop = screenSize.width > 1200;
    
    final authState = ref.watch(authProvider);
    final isLoading = ref.watch(isLoadingProvider);

    // Listen for authentication success or navigation needs
    ref.listen<AuthState>(authProvider, (previous, next) {
      if (next.status == AuthStatus.authenticated) {
        // Navigate based on user status
        if (next.user?.isNew == true) {
          context.go('/finish-profile');
        } else {
          context.go('/home');
        }
      } else if (next.status == AuthStatus.userDetected) {
        // Navigate back to login screen
        context.go('/login');
      }
    });

    // If we don't have the required state, redirect to login
    if (authState.email == null || authState.user == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.go('/login');
      });
      return const SizedBox.shrink();
    }

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _handleBackToLogin,
        ),
        title: Text(
          'Verify Email',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
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
                    
                    // Greeting and instruction
                    _buildInstructionMessage(authState, theme, isTablet),
                    
                    SizedBox(height: isTablet ? 32 : 24),
                    
                    // OTP Input Field
                    OTPInputField(
                      onChanged: _handleOTPChanged,
                      onCompleted: _handleOTPCompleted,
                      errorText: _otpError ?? authState.errorMessage,
                      enabled: !isLoading,
                    ),
                    
                    SizedBox(height: isTablet ? 24 : 16),
                    
                    // Timer and Resend
                    _buildTimerAndResend(authState, theme),
                    
                    SizedBox(height: isTablet ? 32 : 24),
                    
                    // Verify Button
                    PrimaryButton(
                      text: 'Verify Code',
                      width: isDesktop 
                          ? 300 
                          : isTablet 
                              ? screenSize.width * 0.6 
                              : screenSize.width * 0.8,
                      height: isTablet ? 60 : 56,
                      onPressed: _otp.length == 6 && !isLoading ? _handleVerifyOTP : null,
                      isLoading: isLoading && authState.status == AuthStatus.otpVerifying,
                    ),
                    
                    const Spacer(flex: 2),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildInstructionMessage(AuthState authState, ThemeData theme, bool isTablet) {
    final maskedEmail = _getMaskedEmail(authState.email!);
    
    return Column(
      children: [
        // Icon
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(50),
          ),
          child: Icon(
            Icons.mark_email_read_outlined,
            size: isTablet ? 32 : 28,
            color: theme.colorScheme.primary,
          ),
        ),
        
        SizedBox(height: isTablet ? 20 : 16),
        
        // Main message
        Text(
          'Enter Verification Code',
          style: theme.textTheme.headlineMedium?.copyWith(
            fontSize: isTablet ? 28 : 24,
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
          textAlign: TextAlign.center,
        ),
        
        SizedBox(height: isTablet ? 12 : 8),
        
        // Instruction
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: theme.textTheme.bodyLarge?.copyWith(
              fontSize: isTablet ? 16 : 14,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              height: 1.4,
            ),
            children: [
              const TextSpan(text: 'We sent a 6-digit code to\n'),
              TextSpan(
                text: maskedEmail,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTimerAndResend(AuthState authState, ThemeData theme) {
    final canResend = ref.read(authProvider.notifier).canResendOTP();
    final timeRemaining = ref.read(authProvider.notifier).getFormattedTimeRemaining();
    
    return AnimatedBuilder(
      animation: _timerController,
      builder: (context, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!canResend) ...[
              Icon(
                Icons.timer_outlined,
                size: 16,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
              const SizedBox(width: 4),
              Text(
                'Resend code in $timeRemaining',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ] else ...[
              TextButton.icon(
                onPressed: _handleResendOTP,
                icon: const Icon(Icons.refresh, size: 16),
                label: const Text('Resend Code'),
                style: TextButton.styleFrom(
                  foregroundColor: theme.colorScheme.primary,
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}