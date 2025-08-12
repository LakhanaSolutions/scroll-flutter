import 'package:flutter/material.dart';
import 'api/api_client.dart';
import 'services/app_data_service.dart';

/// Handles app initialization including data loading and session validation
class AppInitialization {
  static bool _isInitialized = false;

  /// Initialize the app with session checking and data loading
  /// Call this during app startup in main() or App widget
  static Future<void> initialize() async {
    if (_isInitialized) return;

    print('🚀 Starting app initialization...');
    
    try {
      // Check if user has valid session
      final hasValidSession = await _checkValidSession();
      print('📱 Valid session: $hasValidSession');
      
      // Initialize data service with session status
      await AppDataService().initialize(hasValidSession: hasValidSession);
      
      _isInitialized = true;
      print('✅ App initialization completed');
      
    } catch (e) {
      print('❌ App initialization failed: $e');
      // Initialize with offline mode
      await AppDataService().initialize(hasValidSession: false);
      _isInitialized = true;
    }
  }

  /// Check if user has a valid session token
  static Future<bool> _checkValidSession() async {
    try {
      // Check if we have a stored session token and validate it
      final apiClient = ApiClient();
      
      if (!apiClient.isAuthenticated) {
        print('📱 No session token found');
        return false;
      }
      
      // Verify session is still valid by calling the session endpoint
      final isValid = await apiClient.validateSession();
      print('📱 Session validation result: $isValid');
      return isValid;
      
    } catch (e) {
      print('❌ Session validation failed: $e');
      return false;
    }
  }

  /// Force re-initialization (useful after login/logout)
  static Future<void> reinitialize() async {
    _isInitialized = false;
    await initialize();
  }

  /// Check if app is initialized
  static bool get isInitialized => _isInitialized;
}

/// Widget that ensures app is initialized before showing content
class AppInitializationWrapper extends StatefulWidget {
  final Widget child;
  
  const AppInitializationWrapper({
    super.key,
    required this.child,
  });

  @override
  State<AppInitializationWrapper> createState() => _AppInitializationWrapperState();
}

class _AppInitializationWrapperState extends State<AppInitializationWrapper> {
  bool _isLoading = true;
  String _loadingMessage = 'Initializing app...';

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      setState(() {
        _loadingMessage = 'Checking session...';
      });
      
      await AppInitialization.initialize();
      
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _loadingMessage = 'Loading offline data...';
      });
      
      // Short delay to show the message
      await Future.delayed(const Duration(milliseconds: 500));
      
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return MaterialApp(
        home: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 16),
                Text(
                  _loadingMessage,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ),
      );
    }
    
    return widget.child;
  }
}