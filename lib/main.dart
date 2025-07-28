import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'router/app_router.dart';
import 'providers/theme_provider.dart';
import 'providers/locale_provider.dart';
import 'services/preferences_service.dart';
import 'theme/app_theme.dart';
import 'theme/theme_extensions.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PreferencesService.init();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeProvider);
    final localeState = ref.watch(localeProvider);

    return MaterialApp.router(
      title: 'Siraaj',
      locale: localeState.locale,
      theme: AppTheme.lightTheme.copyWith(
        extensions: [AppThemeExtension.getForPlatform(isDark: false)],
      ),
      darkTheme: AppTheme.darkTheme.copyWith(
        extensions: [AppThemeExtension.getForPlatform(isDark: true)],
      ),
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      routerConfig: appRouter,
      builder: (context, child) {
        return Directionality(
          textDirection: localeState.textDirection,
          child: child!,
        );
      },
    );
  }
}

