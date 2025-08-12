import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'router/app_router.dart';
import 'providers/theme_provider.dart' as providers;
import 'providers/locale_provider.dart';
import 'providers/auth_provider.dart';
import 'services/preferences_service.dart';
import 'api/api_client.dart';
import 'theme/app_theme.dart';
import 'theme/theme_extensions.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PreferencesService.init();
  
  // Initialize API client
  ApiClient().initialize();
  
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    
    // Initialize auth provider after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(authProvider.notifier).initialize();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangePlatformBrightness() {
    super.didChangePlatformBrightness();
    // Update theme when system brightness changes
    final brightness = WidgetsBinding.instance.platformDispatcher.platformBrightness;
    ref.read(providers.themeProvider.notifier).updateSystemBrightness(brightness);
  }

  @override
  Widget build(BuildContext context) {
    final themeState = ref.watch(providers.themeProvider);
    final localeState = ref.watch(localeProvider);

    return MaterialApp.router(
      title: 'Scroll',
      locale: localeState.locale,
      theme: AppTheme.lightTheme.copyWith(
        extensions: [AppThemeExtension.getForPlatform(isDark: false)],
      ),
      darkTheme: AppTheme.darkTheme.copyWith(
        extensions: [AppThemeExtension.getForPlatform(isDark: true)],
      ),
      themeMode: _getFlutterThemeMode(themeState),
      routerConfig: appRouter,
      builder: (context, child) {
        return Directionality(
          textDirection: localeState.textDirection,
          child: child!,
        );
      },
    );
  }

  ThemeMode _getFlutterThemeMode(providers.ThemeState themeState) {
    switch (themeState.mode) {
      case providers.AppThemeMode.light:
        return ThemeMode.light;
      case providers.AppThemeMode.dark:
        return ThemeMode.dark;
      case providers.AppThemeMode.system:
        return ThemeMode.system;
    }
  }
}

