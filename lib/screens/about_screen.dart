import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_spacing.dart';
import '../widgets/text/app_text.dart';
import '../widgets/cards/app_card.dart';

/// About screen showing app information, version, and credits
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F7), // iOS background
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_rounded,
            color: colorScheme.onSurface,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(
          children: [
            Icon(
              Icons.info_outline_rounded,
              color: colorScheme.primary,
              size: AppSpacing.iconMedium,
            ),
            const SizedBox(width: AppSpacing.small),
            const AppTitleText('About'),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // App header
            Container(
              width: double.infinity,
              color: colorScheme.surface,
              padding: const EdgeInsets.all(AppSpacing.large),
              child: Column(
                children: [
                  // App icon
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          colorScheme.primary,
                          colorScheme.secondary,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
                    ),
                    child: Icon(
                      Icons.headphones_rounded,
                      color: colorScheme.onPrimary,
                      size: 48,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.large),
                  
                  // App name and tagline
                  const AppTitleText(
                    'Siraaj',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.small),
                  AppBodyText(
                    'Your Spiritual Audio Companion',
                    textAlign: TextAlign.center,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(height: AppSpacing.small),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.medium,
                      vertical: AppSpacing.small,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
                    ),
                    child: Text(
                      'Version 1.0.0 (Build 1)',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.medium),

            // App description
            _buildSection(
              context,
              title: 'About Siraaj',
              child: AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppBodyText(
                      'Siraaj is a premium Islamic audiobook platform designed to enrich your spiritual journey. We curate high-quality content from renowned scholars and speakers, making Islamic knowledge accessible anytime, anywhere.',
                      color: colorScheme.onSurface,
                    ),
                    const SizedBox(height: AppSpacing.medium),
                    AppBodyText(
                      'Our mission is to illuminate hearts and minds through authentic Islamic teachings, providing a distraction-free environment for learning and reflection.',
                      color: colorScheme.onSurface,
                    ),
                  ],
                ),
              ),
            ),

            // Features
            _buildSection(
              context,
              title: 'Features',
              child: AppCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    _buildFeatureItem(
                      context,
                      icon: Icons.library_music_rounded,
                      title: 'Curated Content Library',
                      description: 'Access thousands of Islamic audiobooks and lectures',
                      isFirst: true,
                    ),
                    _buildFeatureItem(
                      context,
                      icon: Icons.download_rounded,
                      title: 'Offline Listening',
                      description: 'Download content for listening without internet',
                    ),
                    _buildFeatureItem(
                      context,
                      icon: Icons.sync_rounded,
                      title: 'Cross-Device Sync',
                      description: 'Continue where you left off on any device',
                    ),
                    _buildFeatureItem(
                      context,
                      icon: Icons.bookmark_rounded,
                      title: 'Bookmarks & Notes',
                      description: 'Save important moments and add personal notes',
                    ),
                    _buildFeatureItem(
                      context,
                      icon: Icons.tune_rounded,
                      title: 'Personalized Experience',
                      description: 'Customizable playback and reading preferences',
                      isLast: true,
                    ),
                  ],
                ),
              ),
            ),

            // App info
            _buildSection(
              context,
              title: 'App Information',
              child: AppCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    _buildInfoItem(
                      context,
                      icon: Icons.info_rounded,
                      title: 'Version',
                      value: '1.0.0 (Build 1)',
                      onTap: () => _showVersionDetails(context),
                      isFirst: true,
                    ),
                    _buildInfoItem(
                      context,
                      icon: Icons.update_rounded,
                      title: 'Last Updated',
                      value: 'January 2024',
                    ),
                    _buildInfoItem(
                      context,
                      icon: Icons.language_rounded,
                      title: 'Supported Languages',
                      value: 'English, العربية',
                    ),
                    _buildInfoItem(
                      context,
                      icon: Icons.phone_android_rounded,
                      title: 'Compatibility',
                      value: 'iOS 12.0+ • Android 7.0+',
                      isLast: true,
                    ),
                  ],
                ),
              ),
            ),

            // Credits and acknowledgments
            _buildSection(
              context,
              title: 'Credits & Acknowledgments',
              child: AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const AppSubtitleText('Development Team'),
                    const SizedBox(height: AppSpacing.small),
                    AppBodyText(
                      '• UI/UX Design & Development\n'
                      '• Backend Architecture\n'
                      '• Content Curation\n'
                      '• Quality Assurance',
                      color: colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(height: AppSpacing.large),
                    
                    const AppSubtitleText('Special Thanks'),
                    const SizedBox(height: AppSpacing.small),
                    AppBodyText(
                      'We extend our gratitude to the scholars, speakers, and content creators who have made their valuable teachings available through our platform.',
                      color: colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(height: AppSpacing.medium),
                    AppBodyText(
                      'Thank you to our beta testers and the community for their valuable feedback and support.',
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ],
                ),
              ),
            ),

            // Legal links
            _buildSection(
              context,
              title: 'Legal',
              child: AppCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    _buildLegalItem(
                      context,
                      icon: Icons.privacy_tip_rounded,
                      title: 'Privacy Policy',
                      onTap: () => debugPrint('Privacy Policy'),
                      isFirst: true,
                    ),
                    _buildLegalItem(
                      context,
                      icon: Icons.description_rounded,
                      title: 'Terms of Service',
                      onTap: () => debugPrint('Terms of Service'),
                    ),
                    _buildLegalItem(
                      context,
                      icon: Icons.copyright_rounded,
                      title: 'Licenses',
                      onTap: () => _showLicenses(context),
                      isLast: true,
                    ),
                  ],
                ),
              ),
            ),

            // Contact information
            _buildSection(
              context,
              title: 'Contact Us',
              child: AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.email_rounded,
                          color: colorScheme.primary,
                          size: AppSpacing.iconSmall,
                        ),
                        const SizedBox(width: AppSpacing.small),
                        const AppSubtitleText('Email'),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.small),
                    GestureDetector(
                      onTap: () => _copyToClipboard(context, 'contact@siraaj.app'),
                      child: AppBodyText(
                        'contact@siraaj.app',
                        color: colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.large),
                    
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_rounded,
                          color: colorScheme.primary,
                          size: AppSpacing.iconSmall,
                        ),
                        const SizedBox(width: AppSpacing.small),
                        const AppSubtitleText('Location'),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.small),
                    AppBodyText(
                      'Riyadh, Saudi Arabia',
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: AppSpacing.section),

            // Copyright
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.medium),
              child: AppCaptionText(
                '© 2024 Siraaj. All rights reserved.\nMade with ❤️ for the Muslim community',
                textAlign: TextAlign.center,
                color: colorScheme.onSurfaceVariant,
              ),
            ),

            const SizedBox(height: AppSpacing.large),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required Widget child,
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
          child: child,
        ),
        const SizedBox(height: AppSpacing.large),
      ],
    );
  }

  Widget _buildFeatureItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    bool isFirst = false,
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
          color: colorScheme.primary,
          size: AppSpacing.iconMedium,
        ),
        title: AppBodyText(title),
        subtitle: AppCaptionText(
          description,
          color: colorScheme.onSurfaceVariant,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.medium,
          vertical: AppSpacing.small,
        ),
      ),
    );
  }

  Widget _buildInfoItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
    VoidCallback? onTap,
    bool isFirst = false,
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
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppBodyText(
              value,
              color: colorScheme.onSurfaceVariant,
            ),
            if (onTap != null) ...[
              const SizedBox(width: AppSpacing.small),
              Icon(
                Icons.chevron_right_rounded,
                color: colorScheme.onSurfaceVariant,
              ),
            ],
          ],
        ),
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.medium,
          vertical: AppSpacing.small,
        ),
      ),
    );
  }

  Widget _buildLegalItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isFirst = false,
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
        trailing: Icon(
          Icons.chevron_right_rounded,
          color: colorScheme.onSurfaceVariant,
        ),
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.medium,
          vertical: AppSpacing.small,
        ),
      ),
    );
  }

  void _showVersionDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Version Information'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Version: 1.0.0'),
            const Text('Build: 1'),
            const Text('Release Date: January 2024'),
            const SizedBox(height: 16),
            const Text('What\'s New:'),
            const Text('• Initial release'),
            const Text('• Core audio streaming features'),
            const Text('• Offline download capability'),
            const Text('• User account management'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showLicenses(BuildContext context) {
    showLicensePage(
      context: context,
      applicationName: 'Siraaj',
      applicationVersion: '1.0.0',
      applicationIcon: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.secondary,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
        ),
        child: Icon(
          Icons.headphones_rounded,
          color: Theme.of(context).colorScheme.onPrimary,
          size: 32,
        ),
      ),
    );
  }

  void _copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Copied "$text" to clipboard'),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}