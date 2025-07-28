import 'package:flutter/material.dart';
import '../../data/mock_data.dart';
import '../../theme/app_spacing.dart';
import '../text/app_text.dart';
import '../cards/app_card.dart';

/// Narrator search result tile widget
/// Displays narrator information in search results with avatar, name, voice description, and statistics
class NarratorResultTile extends StatelessWidget {
  final NarratorData narrator;
  final VoidCallback? onTap;
  final EdgeInsets? margin;

  const NarratorResultTile({
    super.key,
    required this.narrator,
    this.onTap,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AppCard(
      margin: margin ?? const EdgeInsets.only(bottom: AppSpacing.small),
      onTap: onTap,
      child: Row(
        children: [
          // Narrator avatar
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colorScheme.secondaryContainer,
              boxShadow: [
                BoxShadow(
                  color: colorScheme.shadow.withValues(alpha: 0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              Icons.mic_rounded,
              color: colorScheme.onSecondaryContainer,
              size: AppSpacing.iconMedium,
            ),
          ),
          const SizedBox(width: AppSpacing.medium),
          // Narrator info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Type indicator
                Row(
                  children: [
                    Icon(
                      Icons.record_voice_over_rounded,
                      color: colorScheme.primary,
                      size: AppSpacing.iconExtraSmall,
                    ),
                    const SizedBox(width: AppSpacing.extraSmall),
                    AppCaptionText(
                      'Narrator',
                      color: colorScheme.primary,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.extraSmall),
                // Narrator name
                AppSubtitleText(
                  narrator.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  color: colorScheme.onSurface,
                ),
                const SizedBox(height: AppSpacing.extraSmall),
                // Voice description
                AppCaptionText(
                  narrator.voiceDescription,
                  color: colorScheme.onSurfaceVariant,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.small),
                // Statistics
                Row(
                  children: [
                    Icon(
                      Icons.library_music_rounded,
                      color: colorScheme.onSurfaceVariant,
                      size: AppSpacing.iconExtraSmall,
                    ),
                    const SizedBox(width: AppSpacing.extraSmall),
                    AppCaptionText(
                      '${narrator.totalNarrations} narrations',
                      color: colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: AppSpacing.medium),
                    Icon(
                      Icons.access_time_rounded,
                      color: colorScheme.onSurfaceVariant,
                      size: AppSpacing.iconExtraSmall,
                    ),
                    const SizedBox(width: AppSpacing.extraSmall),
                    AppCaptionText(
                      '${narrator.experienceYears} years',
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}