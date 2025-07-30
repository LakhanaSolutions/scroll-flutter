import 'package:go_router/go_router.dart';
import '../screens/home_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/theme_demo_screen.dart';
import '../screens/auth/welcome_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/otp_verification_screen.dart';
import '../services/token_service.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  redirect: (context, state) async {
    // Check if user has a valid token
    final hasToken = await TokenService.hasToken();
    
    final isOnAuthRoute = state.matchedLocation.startsWith('/welcome') ||
                         state.matchedLocation.startsWith('/login') ||
                         state.matchedLocation.startsWith('/verify-otp');
    
    // If user has token and is on auth route, redirect to home
    if (hasToken && isOnAuthRoute) {
      return '/home';
    }
    
    // If user has no token and is not on auth route, redirect to welcome
    if (!hasToken && !isOnAuthRoute) {
      return '/welcome';
    }
    
    // Allow the route to proceed
    return null;
  },
  routes: [
    // Auth routes
    GoRoute(
      path: '/welcome',
      builder: (context, state) => const WelcomeScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/verify-otp',
      builder: (context, state) => const OTPVerificationScreen(),
    ),
    
    // Main app routes
    GoRoute(
      path: '/',
      redirect: (context, state) => '/home',
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeScreen(),
      routes: [
        GoRoute(
          path: 'profile',
          builder: (context, state) => const ProfileScreen(),
        ),
        GoRoute(
          path: 'settings',
          builder: (context, state) => const SettingsScreen(),
        ),
        GoRoute(
          path: 'theme-demo',
          builder: (context, state) => const ThemeDemoScreen(),
        ),
      ],
    ),
  ],
);