import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/theme_provider.dart';
import '../providers/locale_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(themeProvider);
    final localeState = ref.watch(localeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        actions: [
          IconButton(
            icon: Icon(themeState.isDark ? Icons.light_mode : Icons.dark_mode),
            onPressed: () => ref.read(themeProvider.notifier).toggleTheme(),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SwitchListTile(
            secondary: Icon(themeState.isDark ? Icons.dark_mode : Icons.light_mode),
            title: const Text('Dark Theme'),
            value: themeState.isDark,
            onChanged: (_) => ref.read(themeProvider.notifier).toggleTheme(),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('Language'),
            subtitle: Text('Current: ${localeState.languageCode.toUpperCase()}'),
            trailing: DropdownButton<String>(
              value: localeState.languageCode,
              onChanged: (String? newValue) {
                if (newValue != null) {
                  ref.read(localeProvider.notifier).setLanguage(newValue);
                }
              },
              items: const [
                DropdownMenuItem(value: 'en', child: Text('English')),
                DropdownMenuItem(value: 'ar', child: Text('العربية')),
                DropdownMenuItem(value: 'es', child: Text('Español')),
                DropdownMenuItem(value: 'fr', child: Text('Français')),
              ],
            ),
          ),
          SwitchListTile(
            secondary: Icon(localeState.isRTL ? Icons.format_textdirection_r_to_l : Icons.format_textdirection_l_to_r),
            title: const Text('Text Direction'),
            subtitle: Text(localeState.isRTL ? 'Right to Left' : 'Left to Right'),
            value: localeState.isRTL,
            onChanged: (_) => ref.read(localeProvider.notifier).toggleTextDirection(),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('About'),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('About Siraaj'),
                  content: const Text('A Flutter app with Riverpod, routing, and persistent preferences.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Use the back button in the app bar to return to home',
              style: TextStyle(fontSize: 12, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}