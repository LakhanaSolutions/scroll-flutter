import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/auth_state_model.dart';
import '../models/user_model.dart';
import '../services/token_service.dart';
import 'subscription_provider.dart';

/// Authentication provider with test users for different subscription plans:
/// - trial@example.com: Trial user with 8/15 minutes used
/// - premium@example.com: Premium subscriber with unlimited access
/// - free@example.com: Free user (trial expired)
/// - new@example.com: New trial user with 2/15 minutes used
/// OTP for all test accounts: 123456

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref);
});

final isLoadingProvider = Provider<bool>((ref) {
  final authState = ref.watch(authProvider);
  return authState.isLoading;
});

class AuthNotifier extends StateNotifier<AuthState> {
  final Ref _ref;
  
  AuthNotifier(this._ref) : super(AuthState.initial());

  // Dummy user data - in real app this would come from API
  // Each user represents a different subscription plan for testing
  static const Map<String, Map<String, dynamic>> _dummyUsers = {
    'trial@example.com': {
      'id': '1',
      'email': 'trial@example.com',
      'name': 'Trial User',
      'isNew': false,
      'createdAt': '2024-01-01T00:00:00.000Z',
      'lastLoginAt': '2024-01-15T00:00:00.000Z',
      'subscriptionPlan': 'trial',
    },
    'premium@example.com': {
      'id': '2',
      'email': 'premium@example.com',
      'name': 'Premium User',
      'isNew': false,
      'createdAt': '2024-01-01T00:00:00.000Z',
      'lastLoginAt': '2024-01-15T00:00:00.000Z',
      'subscriptionPlan': 'premium',
    },
    'free@example.com': {
      'id': '3',
      'email': 'free@example.com',
      'name': 'Free User',
      'isNew': false,
      'createdAt': '2024-01-01T00:00:00.000Z',
      'lastLoginAt': '2024-01-15T00:00:00.000Z',
      'subscriptionPlan': 'free',
    },
    'new@example.com': {
      'id': '4',
      'email': 'new@example.com',
      'name': null,
      'isNew': true,
      'createdAt': '2024-01-20T00:00:00.000Z',
      'lastLoginAt': null,
      'subscriptionPlan': 'trial',
    },
  };

  DateTime? _otpSentAt;
  String? _currentOTP;
  int _resendCount = 0;

  Future<void> initialize() async {
    if (await TokenService.hasToken()) {
      final userData = await TokenService.getUserData();
      final token = await TokenService.getToken();
      
      if (userData != null && token != null) {
        final user = User.fromJson(userData);
        state = state.copyWith(
          status: AuthStatus.authenticated,
          user: user,
          token: token,
          email: user.email,
        );
        
        // Set subscription status for existing user
        _setSubscriptionForUser(user.email);
        return;
      }
    }
    
    state = state.copyWith(status: AuthStatus.initial);
  }

  Future<void> submitEmail(String email) async {
    if (email.trim().isEmpty) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: 'Email is required',
      );
      return;
    }

    if (!_isValidEmail(email)) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: 'Please enter a valid email address',
      );
      return;
    }

    state = state.copyWith(status: AuthStatus.loading, clearError: true);

    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 800));

    // Check if user exists in dummy data
    if (_dummyUsers.containsKey(email.toLowerCase())) {
      final userData = _dummyUsers[email.toLowerCase()]!;
      final user = User.fromJson(userData);
      
      state = state.copyWith(
        status: AuthStatus.userDetected,
        user: user,
        email: email.toLowerCase(),
      );
    } else {
      // New user
      final newUser = User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        email: email.toLowerCase(),
        isNew: true,
        createdAt: DateTime.now(),
      );
      
      state = state.copyWith(
        status: AuthStatus.userDetected,
        user: newUser,
        email: email.toLowerCase(),
      );
    }
  }

  Future<void> sendOTP() async {
    if (state.email == null) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: 'Email is required',
      );
      return;
    }

    state = state.copyWith(status: AuthStatus.loading, clearError: true);

    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 1000));

    // Generate dummy OTP (in real app, this would be sent via email)
    _currentOTP = '123456'; // Fixed OTP for testing
    _otpSentAt = DateTime.now();
    _resendCount++;

    state = state.copyWith(
      status: AuthStatus.otpSent,
      otpSentAt: _otpSentAt,
      otpResendCount: _resendCount,
    );
  }

  Future<void> verifyOTP(String otp) async {
    if (otp.length != 6) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: 'Please enter the complete 6-digit code',
      );
      return;
    }

    state = state.copyWith(status: AuthStatus.otpVerifying, clearError: true);

    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 1200));

    // Check if OTP matches (in real app, this would be verified by API)
    if (otp == _currentOTP) {
      // Generate dummy token
      final token = 'dummy_token_${DateTime.now().millisecondsSinceEpoch}';
      
      // Update user's last login
      final updatedUser = state.user!.copyWith(
        lastLoginAt: DateTime.now(),
      );

      // Save token and user data
      await TokenService.saveToken(token);
      await TokenService.saveUserData(updatedUser.toJson());

      state = state.copyWith(
        status: AuthStatus.authenticated,
        user: updatedUser,
        token: token,
      );

      // Set subscription status based on user plan
      _setSubscriptionForUser(updatedUser.email);
      
      // Clear OTP data
      _currentOTP = null;
      _otpSentAt = null;
    } else {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: 'Invalid verification code. Please try again.',
      );
    }
  }

  Future<void> resendOTP() async {
    if (canResendOTP()) {
      await sendOTP();
    } else {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: 'Please wait before requesting another code',
      );
    }
  }

  bool canResendOTP() {
    if (_otpSentAt == null) return true;
    
    final timeSinceOtp = DateTime.now().difference(_otpSentAt!);
    return timeSinceOtp.inMinutes >= 1; // Allow resend after 1 minute
  }

  String getFormattedTimeRemaining() {
    if (_otpSentAt == null) return '00:00';
    
    const duration = Duration(minutes: 1);
    final elapsed = DateTime.now().difference(_otpSentAt!);
    final remaining = duration - elapsed;
    
    if (remaining.inSeconds <= 0) return '00:00';
    
    final minutes = remaining.inMinutes;
    final seconds = remaining.inSeconds % 60;
    
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  void goBackToUserDetected() {
    state = state.copyWith(
      status: AuthStatus.userDetected,
      clearError: true,
    );
  }

  Future<void> logout() async {
    await TokenService.clearAll();
    
    state = AuthState.initial();
    
    // Reset OTP data
    _currentOTP = null;
    _otpSentAt = null;
    _resendCount = 0;
  }

  void clearError() {
    if (state.hasError) {
      AuthStatus newStatus;
      if (state.user != null) {
        newStatus = AuthStatus.userDetected;
      } else if (state.email != null) {
        newStatus = AuthStatus.emailInput;
      } else {
        newStatus = AuthStatus.initial;
      }
      
      state = state.copyWith(
        status: newStatus,
        clearError: true,
      );
    }
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email);
  }
  
  /// Sets subscription status based on user's email/plan for testing purposes
  void _setSubscriptionForUser(String email) {
    final subscriptionNotifier = _ref.read(subscriptionProvider.notifier);
    final userData = _dummyUsers[email.toLowerCase()];
    final plan = userData?['subscriptionPlan'] as String?;
    
    switch (plan) {
      case 'premium':
        subscriptionNotifier.setPremium();
        break;
      case 'free':
        subscriptionNotifier.setFree();
        break;
      case 'trial':
      default:
        // Set trial with different usage amounts based on email
        final now = DateTime.now();
        final TrialUsageData trialUsage;
        
        if (email.contains('trial')) {
          // Trial user with some usage (8 minutes used)
          trialUsage = TrialUsageData(
            minutesUsed: 8,
            maxMinutes: 15,
            lastResetAt: now.subtract(const Duration(days: 10)),
            currentMonth: now.month,
            currentYear: now.year,
          );
        } else {
          // New user with minimal usage (2 minutes used)
          trialUsage = TrialUsageData(
            minutesUsed: 2,
            maxMinutes: 15,
            lastResetAt: now.subtract(const Duration(days: 5)),
            currentMonth: now.month,
            currentYear: now.year,
          );
        }
        
        subscriptionNotifier.setFreeTrial();
        subscriptionNotifier.updateTrialUsage(trialUsage);
        break;
    }
  }
}