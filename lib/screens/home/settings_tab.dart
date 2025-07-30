import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:siraaj/screens/manage_devices_screen.dart';
import 'package:siraaj/screens/profile_screen.dart';
import 'package:siraaj/screens/subscription_screen.dart';
import 'package:siraaj/screens/theme_demo_screen.dart';
import '../../providers/theme_provider.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_icons.dart';
import '../../widgets/text/app_text.dart';
import '../../widgets/buttons/app_buttons.dart';
import '../../widgets/cards/app_card.dart';
import '../../widgets/bottom_sheets/settings_modals.dart';
import '../privacy_policy_screen.dart';
import '../terms_of_service_screen.dart';
import '../help_support_screen.dart';
import '../send_feedback_screen.dart';
import '../notifications_screen.dart';
import '../about_screen.dart';

/// Settings tab content widget
/// Provides access to app settings, account management, and preferences
class SettingsTab extends ConsumerWidget {
  const SettingsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final themeState = ref.watch(themeProvider);

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
                  AppIcons.settings,
                  color: colorScheme.primary,
                  size: AppSpacing.iconMedium,
                ),
                const SizedBox(width: AppSpacing.small),
                const AppTitleText('Settings'),
              ],
            ),
          ),
          
          const SizedBox(height: AppSpacing.large),
          
          // Profile tile
          _buildProfileTile(context),
          
          const SizedBox(height: AppSpacing.large),
          
          // Main Features section
          _buildSection(
            context,
            title: 'Library',
            children: [
              _buildListTile(
                context,
                icon: Icons.subscriptions_rounded,
                title: 'Subscription',
                subtitle: 'Manage your premium plan',
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
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const SubscriptionScreen(),
                    ),
                  );
                },
                isLast: true,
              ),
            ],
          ),
          
          // App Settings section
          _buildSection(
            context,
            title: 'App Settings',
            children: [
              _buildListTile(
                context,
                icon: _getThemeIcon(themeState),
                title: 'Theme',
                subtitle: _getThemeLabel(themeState),
                onTap: () => showThemeModeBottomSheet(context, ref),
              ),
              _buildListTile(
                context,
                icon: Icons.text_fields_rounded,
                title: 'Text Size',
                subtitle: 'Default',
                onTap: () => showTextSizeBottomSheet(context),
              ),
              _buildListTile(
                context,
                icon: Icons.language_rounded,
                title: 'Language',
                subtitle: 'English (US)',
                onTap: () => showLanguageBottomSheet(context),
              ),
              _buildListTile(
                context,
                icon: Icons.notifications_rounded,
                title: 'Notifications',
                subtitle: 'Manage notification preferences',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const NotificationsScreen(),
                    ),
                  );
                },
                isLast: true,
              ),
            ],
          ),
          
          // Account section
          _buildSection(
            context,
            title: 'Account',
            children: [
              _buildListTile(
                context,
                icon: Icons.cloud_sync_rounded,
                title: 'Manage Devices',
                subtitle: 'Manage your devices',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const ManageDevicesScreen(),
                    ),
                  );
                },
              ),
              _buildListTile(
                context,
                icon: Icons.palette_rounded,
                title: 'Theme Demo',
                subtitle: 'View design system components',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const ThemeDemoScreen(),
                    ),
                  );
                },
                isLast: true,
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
                subtitle: 'High quality',
                onTap: () => showAudioQualityBottomSheet(context),
              ),
              _buildListTile(
                context,
                icon: Icons.download_rounded,
                title: 'Download Quality',
                subtitle: 'Standard',
                onTap: () => showDownloadQualityBottomSheet(context),
              ),
              _buildListTile(
                context,
                icon: Icons.speed_rounded,
                title: 'Playback Speed',
                subtitle: '1.0x',
                onTap: () => showPlaybackSpeedBottomSheet(context),
                isLast: true,
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
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const HelpSupportScreen(),
                    ),
                  );
                },
              ),
              _buildListTile(
                context,
                icon: Icons.feedback_rounded,
                title: 'Send Feedback',
                subtitle: 'Share your thoughts with us',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const SendFeedbackScreen(),
                    ),
                  );
                },
              ),
              _buildListTile(
                context,
                icon: Icons.star_rate_rounded,
                title: 'Rate App',
                subtitle: 'Rate us on the App Store',
                onTap: () => debugPrint('Rate app tapped'),
                isLast: true,
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
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const PrivacyPolicyScreen(),
                    ),
                  );
                },
              ),
              _buildListTile(
                context,
                icon: Icons.description_rounded,
                title: 'Terms of Service',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const TermsOfServiceScreen(),
                    ),
                  );
                },
              ),
              _buildListTile(
                context,
                icon: Icons.info_outline_rounded,
                title: 'About',
                subtitle: 'Version 1.0.0',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const AboutScreen(),
                    ),
                  );
                },
                isLast: true,
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.medium),
          child: Text(
            title.toUpperCase(),
            style: theme.textTheme.labelSmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.bold,
              fontSize: 10,
              letterSpacing: 1.2,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.small),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: AppSpacing.medium),
          child: AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: children,
            ),
          ),
        ),
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
    bool isLast = false,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        border: !isLast ? Border(
          bottom: BorderSide(
            color: colorScheme.outline.withValues(alpha: 0.1),
            width: 1,
          ),
        ) : null,
      ),
      child: ListTile(
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
          vertical: AppSpacing.small,
        ),
      ),
    );
  }


  Widget _buildProfileTile(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.medium),
      child: AppCard(
        padding: EdgeInsets.zero,
        child: ListTile(
          contentPadding: const EdgeInsets.all(AppSpacing.medium),
          leading: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colorScheme.primaryContainer,
            ),
            child: Icon(
              Icons.person_rounded,
              color: colorScheme.onPrimaryContainer,
              size: AppSpacing.iconLarge,
            ),
          ),
          title: const AppSubtitleText('Ahmed Al-Rashid'),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.extraSmall),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.small,
                      vertical: AppSpacing.extraSmall,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.secondary,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusExtraSmall),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.star_rounded,
                          color: colorScheme.onSecondary,
                          size: AppSpacing.iconExtraSmall,
                        ),
                        const SizedBox(width: AppSpacing.extraSmall),
                        Text(
                          'TRIAL',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: colorScheme.onSecondary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.small),
                  AppCaptionText(
                    '14 days remaining',
                    color: colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
            ],
          ),
          trailing: Icon(
            Icons.chevron_right_rounded,
            color: colorScheme.onSurfaceVariant,
            size: AppSpacing.iconMedium,
          ),
          onTap: () {
            Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const ProfileScreen(),
                    ),
                  );
          },
        ),
      ),
    );
  }

  IconData _getThemeIcon(ThemeState themeState) {
    switch (themeState.mode) {
      case AppThemeMode.light:
        return Icons.light_mode;
      case AppThemeMode.dark:
        return Icons.dark_mode;
      case AppThemeMode.system:
        return Icons.brightness_auto_rounded;
    }
  }

  String _getThemeLabel(ThemeState themeState) {
    switch (themeState.mode) {
      case AppThemeMode.light:
        return 'Light Mode';
      case AppThemeMode.dark:
        return 'Dark Mode';
      case AppThemeMode.system:
        return 'System Default';
    }
  }
}