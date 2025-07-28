import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/theme_provider.dart';
import '../../theme/app_spacing.dart';
import '../../widgets/text/app_text.dart';
import '../../widgets/buttons/app_buttons.dart';

/// Settings tab content widget
/// Provides access to app settings, account management, and preferences
class SettingsTab extends ConsumerWidget {
  const SettingsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDarkMode = ref.watch(themeProvider);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSpacing.medium),
          
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.medium),
            child: Row(
              children: [
                Icon(
                  Icons.settings_rounded,
                  color: colorScheme.primary,
                  size: AppSpacing.iconMedium,
                ),
                const SizedBox(width: AppSpacing.small),
                const AppTitleText('Settings'),
              ],
            ),
          ),
          
          const SizedBox(height: AppSpacing.large),
          
          // Account section
          _buildSection(
            context,
            title: 'Account',
            children: [
              _buildListTile(
                context,
                icon: Icons.person_rounded,
                title: 'Profile',
                subtitle: 'Manage your profile information',
                onTap: () => debugPrint('Profile tapped'),
              ),
              _buildListTile(
                context,
                icon: Icons.star_rounded,
                title: 'Subscription',
                subtitle: 'Manage your premium subscription',
                trailing: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.small,
                    vertical: AppSpacing.extraSmall,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.secondary,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusExtraSmall),
                  ),
                  child: Text(
                    'TRIAL',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: colorScheme.onSecondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                onTap: () => debugPrint('Subscription tapped'),
              ),
              _buildListTile(
                context,
                icon: Icons.cloud_sync_rounded,
                title: 'Sync Settings',
                subtitle: 'Sync across devices',
                onTap: () => debugPrint('Sync settings tapped'),
              ),
            ],
          ),
          
          // Appearance section
          _buildSection(
            context,
            title: 'Appearance',
            children: [
              _buildSwitchTile(
                context,
                icon: isDarkMode ? Icons.light_mode : Icons.dark_mode,
                title: 'Dark Mode',
                subtitle: 'Switch between light and dark themes',
                value: isDarkMode,
                onChanged: (value) => ref.read(themeProvider.notifier).toggleTheme(),
              ),
              _buildListTile(
                context,
                icon: Icons.text_fields_rounded,
                title: 'Text Size',
                subtitle: 'Adjust reading text size',
                onTap: () => debugPrint('Text size tapped'),
              ),
              _buildListTile(
                context,
                icon: Icons.palette_rounded,
                title: 'Theme Demo',
                subtitle: 'View design system components',
                onTap: () => context.go('/theme-demo'),
              ),
            ],
          ),
          
          // Audio section
          _buildSection(
            context,
            title: 'Audio',
            children: [
              _buildListTile(
                context,
                icon: Icons.volume_up_rounded,
                title: 'Audio Quality',
                subtitle: 'High quality (Premium)',
                trailing: Icon(
                  Icons.lock_rounded,
                  size: AppSpacing.iconSmall,
                  color: colorScheme.onSurfaceVariant,
                ),
                onTap: () => debugPrint('Audio quality tapped'),
              ),
              _buildListTile(
                context,
                icon: Icons.download_rounded,
                title: 'Download Quality',
                subtitle: 'Standard',
                onTap: () => debugPrint('Download quality tapped'),
              ),
              _buildListTile(
                context,
                icon: Icons.speed_rounded,
                title: 'Playback Speed',
                subtitle: '1.0x',
                onTap: () => debugPrint('Playback speed tapped'),
              ),
            ],
          ),
          
          // Support section
          _buildSection(
            context,
            title: 'Support',
            children: [
              _buildListTile(
                context,
                icon: Icons.help_outline_rounded,
                title: 'Help & Support',
                subtitle: 'Get help and contact support',
                onTap: () => debugPrint('Help tapped'),
              ),
              _buildListTile(
                context,
                icon: Icons.feedback_rounded,
                title: 'Send Feedback',
                subtitle: 'Share your thoughts with us',
                onTap: () => debugPrint('Feedback tapped'),
              ),
              _buildListTile(
                context,
                icon: Icons.star_rate_rounded,
                title: 'Rate App',
                subtitle: 'Rate us on the App Store',
                onTap: () => debugPrint('Rate app tapped'),
              ),
            ],
          ),
          
          // Legal section
          _buildSection(
            context,
            title: 'Legal',
            children: [
              _buildListTile(
                context,
                icon: Icons.privacy_tip_rounded,
                title: 'Privacy Policy',
                onTap: () => debugPrint('Privacy policy tapped'),
              ),
              _buildListTile(
                context,
                icon: Icons.description_rounded,
                title: 'Terms of Service',
                onTap: () => debugPrint('Terms tapped'),
              ),
              _buildListTile(
                context,
                icon: Icons.info_outline_rounded,
                title: 'About',
                subtitle: 'Version 1.0.0',
                onTap: () => debugPrint('About tapped'),
              ),
            ],
          ),
          
          const SizedBox(height: AppSpacing.section),
          
          // Sign out button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.medium),
            child: SizedBox(
              width: double.infinity,
              child: AppSecondaryButton(
                onPressed: () => debugPrint('Sign out tapped'),
                child: const Text('Sign Out'),
              ),
            ),
          ),
          
          const SizedBox(height: AppSpacing.large),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.medium),
          child: AppSubtitleText(title),
        ),
        const SizedBox(height: AppSpacing.small),
        ...children,
        const SizedBox(height: AppSpacing.large),
      ],
    );
  }

  Widget _buildListTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ListTile(
      leading: Icon(
        icon,
        color: colorScheme.onSurfaceVariant,
        size: AppSpacing.iconMedium,
      ),
      title: AppBodyText(title),
      subtitle: subtitle != null 
          ? AppCaptionText(
              subtitle,
              color: colorScheme.onSurfaceVariant,
            )
          : null,
      trailing: trailing ?? Icon(
        Icons.chevron_right_rounded,
        color: colorScheme.onSurfaceVariant,
        size: AppSpacing.iconMedium,
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.medium,
        vertical: AppSpacing.extraSmall,
      ),
    );
  }

  Widget _buildSwitchTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SwitchListTile(
      secondary: Icon(
        icon,
        color: colorScheme.onSurfaceVariant,
        size: AppSpacing.iconMedium,
      ),
      title: AppBodyText(title),
      subtitle: subtitle != null 
          ? AppCaptionText(
              subtitle,
              color: colorScheme.onSurfaceVariant,
            )
          : null,
      value: value,
      onChanged: onChanged,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.medium,
        vertical: AppSpacing.extraSmall,
      ),
    );
  }
}