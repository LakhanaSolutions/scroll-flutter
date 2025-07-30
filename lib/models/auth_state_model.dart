import 'user_model.dart';

enum AuthStatus {
  initial,
  loading,
  emailInput,
  userDetected,
  otpSent,
  otpVerifying,
  authenticated,
  error,
}

class AuthState {
  final AuthStatus status;
  final User? user;
  final String? email;
  final String? token;
  final String? errorMessage;
  final DateTime? otpSentAt;
  final int otpResendCount;

  const AuthState({
    required this.status,
    this.user,
    this.email,
    this.token,
    this.errorMessage,
    this.otpSentAt,
    this.otpResendCount = 0,
  });

  factory AuthState.initial() {
    return const AuthState(status: AuthStatus.initial);
  }

  AuthState copyWith({
    AuthStatus? status,
    User? user,
    String? email,
    String? token,
    String? errorMessage,
    DateTime? otpSentAt,
    int? otpResendCount,
    bool clearUser = false,
    bool clearEmail = false,
    bool clearToken = false,
    bool clearError = false,
    bool clearOtpSentAt = false,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: clearUser ? null : (user ?? this.user),
      email: clearEmail ? null : (email ?? this.email),
      token: clearToken ? null : (token ?? this.token),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      otpSentAt: clearOtpSentAt ? null : (otpSentAt ?? this.otpSentAt),
      otpResendCount: otpResendCount ?? this.otpResendCount,
    );
  }

  bool get isAuthenticated => status == AuthStatus.authenticated && token != null;
  bool get isLoading => status == AuthStatus.loading || status == AuthStatus.otpVerifying;
  bool get hasError => status == AuthStatus.error && errorMessage != null;

  @override
  String toString() {
    return 'AuthState(status: $status, user: $user, email: $email, hasToken: ${token != null}, error: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AuthState &&
        other.status == status &&
        other.user == user &&
        other.email == email &&
        other.token == token &&
        other.errorMessage == errorMessage &&
        other.otpSentAt == otpSentAt &&
        other.otpResendCount == otpResendCount;
  }

  @override
  int get hashCode {
    return Object.hash(
      status,
      user,
      email,
      token,
      errorMessage,
      otpSentAt,
      otpResendCount,
    );
  }
}