import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/theme_provider.dart';
import '../../theme/app_spacing.dart';
import '../text/app_text.dart';
import '../cards/app_card.dart';

/// Theme mode selection bottom sheet
void showThemeModeBottomSheet(BuildContext context, WidgetRef ref) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => _ThemeModeBottomSheet(ref: ref),
  );
}

/// Text size selection bottom sheet
void showTextSizeBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => const _TextSizeBottomSheet(),
  );
}

/// Language selection bottom sheet
void showLanguageBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => const _LanguageBottomSheet(),
  );
}

/// Audio quality selection bottom sheet
void showAudioQualityBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => const _AudioQualityBottomSheet(),
  );
}

/// Download quality selection bottom sheet
void showDownloadQualityBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => const _DownloadQualityBottomSheet(),
  );
}

/// Playback speed selection bottom sheet
void showPlaybackSpeedBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => const _PlaybackSpeedBottomSheet(),
  );
}

/// Base bottom sheet widget
abstract class _BaseBottomSheet extends StatelessWidget {
  const _BaseBottomSheet();

  String get title;
  List<Widget> buildOptions(BuildContext context);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusLarge),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: AppSpacing.medium),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // Title
          Padding(
            padding: const EdgeInsets.all(AppSpacing.large),
            child: AppTitleText(title),
          ),
          
          // Options
          Padding(
            padding: const EdgeInsets.only(
              left: AppSpacing.large,
              right: AppSpacing.large,
              bottom: AppSpacing.large,
            ),
            child: Column(
              children: buildOptions(context),
            ),
          ),
        ],
      ),
    );
  }
}

/// Theme mode bottom sheet
class _ThemeModeBottomSheet extends _BaseBottomSheet {
  final WidgetRef ref;

  const _ThemeModeBottomSheet({required this.ref});

  @override
  String get title => 'Theme';

  @override
  List<Widget> buildOptions(BuildContext context) {
    return [
      _buildThemeOption(
        context,
        'System Default',
        'Follow system theme',
        Icons.brightness_auto_rounded,
        () {
          ref.read(themeProvider.notifier).setSystemTheme();
          Navigator.pop(context);
        },
      ),
      const SizedBox(height: AppSpacing.small),
      _buildThemeOption(
        context,
        'Light Mode',
        'Always use light theme',
        Icons.light_mode_rounded,
        () {
          ref.read(themeProvider.notifier).setLightTheme();
          Navigator.pop(context);
        },
      ),
      const SizedBox(height: AppSpacing.small),
      _buildThemeOption(
        context,
        'Dark Mode',
        'Always use dark theme',
        Icons.dark_mode_rounded,
        () {
          ref.read(themeProvider.notifier).setDarkTheme();
          Navigator.pop(context);
        },
      ),
    ];
  }

  Widget _buildThemeOption(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AppCard(
      onTap: onTap,
      child: ListTile(
        leading: Icon(
          icon,
          color: colorScheme.primary,
        ),
        title: AppBodyText(title),
        subtitle: AppCaptionText(
          subtitle,
          color: colorScheme.onSurfaceVariant,
        ),
        trailing: Icon(
          Icons.chevron_right_rounded,
          color: colorScheme.onSurfaceVariant,
        ),
        contentPadding: EdgeInsets.zero,
      ),
    );
  }
}

/// Text size bottom sheet
class _TextSizeBottomSheet extends _BaseBottomSheet {
  const _TextSizeBottomSheet();

  @override
  String get title => 'Text Size';

  @override
  List<Widget> buildOptions(BuildContext context) {
    final options = [
      ('Small', 12.0),
      ('Default', 14.0),
      ('Medium', 16.0),
      ('Large', 18.0),
      ('Extra Large', 20.0),
    ];

    return options.map((option) {
      return Column(
        children: [
          _buildTextSizeOption(context, option.$1, option.$2),
          if (option != options.last) const SizedBox(height: AppSpacing.small),
        ],
      );
    }).toList();
  }

  Widget _buildTextSizeOption(BuildContext context, String label, double size) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AppCard(
      onTap: () {
        // TODO: Implement text size setting
        Navigator.pop(context);
      },
      child: ListTile(
        title: Text(
          label,
          style: theme.textTheme.bodyLarge?.copyWith(fontSize: size),
        ),
        subtitle: AppCaptionText(
          'Sample text at ${size.toInt()}px',
          color: colorScheme.onSurfaceVariant,
        ),
        trailing: Radio<double>(
          value: size,
          groupValue: 14.0, // Default size
          onChanged: (value) {
            // TODO: Implement text size setting
            Navigator.pop(context);
          },
        ),
        contentPadding: EdgeInsets.zero,
      ),
    );
  }
}

/// Language bottom sheet
class _LanguageBottomSheet extends _BaseBottomSheet {
  const _LanguageBottomSheet();

  @override
  String get title => 'Language';

  @override
  List<Widget> buildOptions(BuildContext context) {
    final languages = [
      ('English (US)', 'en_US', '🇺🇸', true),
      ('العربية', 'ar_SA', '🇸🇦', false),
      ('Français', 'fr_FR', '🇫🇷', false),
      ('Español', 'es_ES', '🇪🇸', false),
      ('Deutsch', 'de_DE', '🇩🇪', false),
    ];

    return languages.map((lang) {
      return Column(
        children: [
          _buildLanguageOption(context, lang.$1, lang.$2, lang.$3, lang.$4),
          if (lang != languages.last) const SizedBox(height: AppSpacing.small),
        ],
      );
    }).toList();
  }

  Widget _buildLanguageOption(
    BuildContext context,
    String name,
    String code,
    String flag,
    bool isSelected,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AppCard(
      onTap: () {
        // TODO: Implement language setting
        Navigator.pop(context);
      },
      child: ListTile(
        leading: Text(
          flag,
          style: const TextStyle(fontSize: 24),
        ),
        title: AppBodyText(name),
        subtitle: AppCaptionText(
          code,
          color: colorScheme.onSurfaceVariant,
        ),
        trailing: isSelected
            ? Icon(
                Icons.check_circle_rounded,
                color: colorScheme.primary,
              )
            : Icon(
                Icons.circle_outlined,
                color: colorScheme.onSurfaceVariant,
              ),
        contentPadding: EdgeInsets.zero,
      ),
    );
  }
}

/// Audio quality bottom sheet
class _AudioQualityBottomSheet extends _BaseBottomSheet {
  const _AudioQualityBottomSheet();

  @override
  String get title => 'Audio Quality';

  @override
  List<Widget> buildOptions(BuildContext context) {
    final qualities = [
      ('Standard', '128 kbps', 'Good quality, less data usage', false),
      ('High', '256 kbps', 'Better quality, moderate data usage', true),
      ('Premium', '320 kbps', 'Best quality, more data usage', false),
    ];

    return qualities.map((quality) {
      return Column(
        children: [
          _buildQualityOption(
            context,
            quality.$1,
            quality.$2,
            quality.$3,
            quality.$4,
            quality.$1 == 'Premium',
          ),
          if (quality != qualities.last) const SizedBox(height: AppSpacing.small),
        ],
      );
    }).toList();
  }

  Widget _buildQualityOption(
    BuildContext context,
    String name,
    String bitrate,
    String description,
    bool isSelected,
    bool isPremium,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AppCard(
      onTap: () {
        if (isPremium) {
          // Show premium required dialog
          return;
        }
        // TODO: Implement audio quality setting
        Navigator.pop(context);
      },
      child: ListTile(
        title: Row(
          children: [
            AppBodyText(name),
            if (isPremium) ...[
              const SizedBox(width: AppSpacing.small),
              Icon(
                Icons.lock_rounded,
                size: AppSpacing.iconSmall,
                color: colorScheme.onSurfaceVariant,
              ),
            ],
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppCaptionText(
              bitrate,
              color: colorScheme.primary,
            ),
            AppCaptionText(
              description,
              color: colorScheme.onSurfaceVariant,
            ),
          ],
        ),
        trailing: Radio<String>(
          value: name,
          groupValue: isSelected ? name : null,
          onChanged: isPremium ? null : (value) {
            // TODO: Implement audio quality setting
            Navigator.pop(context);
          },
        ),
        contentPadding: EdgeInsets.zero,
      ),
    );
  }
}

/// Download quality bottom sheet
class _DownloadQualityBottomSheet extends _BaseBottomSheet {
  const _DownloadQualityBottomSheet();

  @override
  String get title => 'Download Quality';

  @override
  List<Widget> buildOptions(BuildContext context) {
    final qualities = [
      ('Low', '64 kbps', 'Smallest file size', false),
      ('Standard', '128 kbps', 'Good balance of quality and size', true),
      ('High', '256 kbps', 'Better quality, larger files', false),
    ];

    return qualities.map((quality) {
      return Column(
        children: [
          _buildDownloadQualityOption(
            context,
            quality.$1,
            quality.$2,
            quality.$3,
            quality.$4,
          ),
          if (quality != qualities.last) const SizedBox(height: AppSpacing.small),
        ],
      );
    }).toList();
  }

  Widget _buildDownloadQualityOption(
    BuildContext context,
    String name,
    String bitrate,
    String description,
    bool isSelected,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AppCard(
      onTap: () {
        // TODO: Implement download quality setting
        Navigator.pop(context);
      },
      child: ListTile(
        title: AppBodyText(name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppCaptionText(
              bitrate,
              color: colorScheme.primary,
            ),
            AppCaptionText(
              description,
              color: colorScheme.onSurfaceVariant,
            ),
          ],
        ),
        trailing: Radio<String>(
          value: name,
          groupValue: isSelected ? name : null,
          onChanged: (value) {
            // TODO: Implement download quality setting
            Navigator.pop(context);
          },
        ),
        contentPadding: EdgeInsets.zero,
      ),
    );
  }
}

/// Playback speed bottom sheet
class _PlaybackSpeedBottomSheet extends _BaseBottomSheet {
  const _PlaybackSpeedBottomSheet();

  @override
  String get title => 'Playback Speed';

  @override
  List<Widget> buildOptions(BuildContext context) {
    final speeds = [
      (0.5, '0.5x'),
      (0.75, '0.75x'),
      (1.0, '1.0x'),
      (1.25, '1.25x'),
      (1.5, '1.5x'),
      (1.75, '1.75x'),
      (2.0, '2.0x'),
    ];

    return speeds.map((speed) {
      return Column(
        children: [
          _buildSpeedOption(context, speed.$1, speed.$2, speed.$1 == 1.0),
          if (speed != speeds.last) const SizedBox(height: AppSpacing.small),
        ],
      );
    }).toList();
  }

  Widget _buildSpeedOption(
    BuildContext context,
    double speed,
    String label,
    bool isSelected,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AppCard(
      onTap: () {
        // TODO: Implement playback speed setting
        Navigator.pop(context);
      },
      child: ListTile(
        title: AppBodyText(label),
        subtitle: AppCaptionText(
          speed == 1.0 ? 'Normal speed' : 
          speed < 1.0 ? 'Slower' : 'Faster',
          color: colorScheme.onSurfaceVariant,
        ),
        trailing: Radio<double>(
          value: speed,
          groupValue: isSelected ? speed : null,
          onChanged: (value) {
            // TODO: Implement playback speed setting
            Navigator.pop(context);
          },
        ),
        contentPadding: EdgeInsets.zero,
      ),
    );
  }
}