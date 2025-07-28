import 'package:go_router/go_router.dart';
import '../screens/home_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/theme_demo_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
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