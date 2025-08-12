import 'package:flutter/material.dart';
import '../api/api_client.dart';
import '../screens/general/loading_screen.dart';
import '../screens/auth/auth_screen.dart';

/// Widget that validates session on app startup and shows appropriate screen
class SessionValidator extends StatefulWidget {
  const SessionValidator({
    super.key,
    required this.onValidSession,
    required this.onInvalidSession,
  });

  /// Callback when session is valid - returns the widget to show
  final Widget Function() onValidSession;

  /// Callback when session is invalid - returns the widget to show  
  final Widget Function() onInvalidSession;

  @override
  State<SessionValidator> createState() => _SessionValidatorState();
}

class _SessionValidatorState extends State<SessionValidator> {
  bool _isValidating = true;
  bool _hasValidSession = false;

  @override
  void initState() {
    super.initState();
    _validateSession();
  }

  Future<void> _validateSession() async {
    try {
      // Initialize API client if not already initialized
      final apiClient = ApiClient();
      
      // Validate session
      final hasValidSession = await apiClient.validateSession();
      
      if (mounted) {
        setState(() {
          _hasValidSession = hasValidSession;
          _isValidating = false;
        });
      }
    } catch (e) {
      // If validation fails, treat as invalid session
      if (mounted) {
        setState(() {
          _hasValidSession = false;
          _isValidating = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isValidating) {
      return const LoadingScreen(
        message: 'Validating session...',
        showAppName: true,
      );
    }

    if (_hasValidSession) {
      return widget.onValidSession();
    } else {
      return widget.onInvalidSession();
    }
  }
}

/// Simple session validation screen that shows loading then redirects
class SessionValidationScreen extends StatefulWidget {
  const SessionValidationScreen({super.key});

  @override
  State<SessionValidationScreen> createState() => _SessionValidationScreenState();
}

class _SessionValidationScreenState extends State<SessionValidationScreen> {
  @override
  void initState() {
    super.initState();
    _validateAndRedirect();
  }

  Future<void> _validateAndRedirect() async {
    try {
      final apiClient = ApiClient();
      final hasValidSession = await apiClient.validateSession();
      
      if (mounted) {
        if (hasValidSession) {
          // Navigate to home
          Navigator.of(context).pushReplacementNamed('/home');
        } else {
          // Navigate to welcome/auth
          Navigator.of(context).pushReplacementNamed('/welcome');
        }
      }
    } catch (e) {
      // If validation fails, go to auth
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/welcome');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return const LoadingScreen(
      message: 'Checking authentication...',
      showAppName: true,
    );
  }
}