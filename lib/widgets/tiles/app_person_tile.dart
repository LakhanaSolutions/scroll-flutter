import 'package:flutter/material.dart';
import '../../data/mock_data.dart';
import '../../theme/app_spacing.dart';
import '../../theme/theme_extensions.dart';
import '../text/app_text.dart';
import '../cards/app_card.dart';
import '../images/app_image.dart';
import '../indicators/app_badges.dart';

/// Person type enumeration for different person tiles
enum PersonType {
  author,
  narrator,
}

/// Reusable tile widget for displaying person information (authors/narrators)
/// Consolidates the duplicated tile patterns across author and narrator displays
class AppPersonTile extends StatelessWidget {
  final PersonType type;
  final String id;
  final String name;
  final String description;
  final String? imageUrl;
  final bool isFollowing;
  final VoidCallback? onTap;
  final EdgeInsets? margin;

  // Author-specific fields
  final int? totalBooks;
  final String? nationality;
  final List<String>? awards;

  // Narrator-specific fields
  final int? totalNarrations;
  final int? experienceYears;
  final List<String>? languages;

  // Common fields
  final Map<String, dynamic>? customStats;
  final List<String>? genres;

  const AppPersonTile({
    super.key,
    required this.type,
    required this.id,
    required this.name,
    required this.description,
    this.imageUrl,
    this.isFollowing = false,
    this.onTap,
    this.margin,
    this.totalBooks,
    this.nationality,
    this.awards,
    this.totalNarrations,
    this.experienceYears,
    this.languages,
    this.customStats,
    this.genres,
  });

  /// Creates a tile for an author
  factory AppPersonTile.author({
    Key? key,
    required AuthorData author,
    VoidCallback? onTap,
    EdgeInsets? margin,
  }) {
    return AppPersonTile(
      key: key,
      type: PersonType.author,
      id: author.id,
      name: author.name,
      description: author.bio,
      imageUrl: author.imageUrl,
      isFollowing: author.isFollowing,
      onTap: onTap,
      margin: margin,
      totalBooks: author.totalBooks,
      nationality: author.nationality,
      awards: author.awards,
      genres: author.genres,
    );
  }

  /// Creates a tile for a narrator
  factory AppPersonTile.narrator({
    Key? key,
    required NarratorData narrator,
    VoidCallback? onTap,
    EdgeInsets? margin,
    String? voiceType,
  }) {
    return AppPersonTile(
      key: key,
      type: PersonType.narrator,
      id: narrator.id,
      name: narrator.name,
      description: narrator.voiceDescription,
      imageUrl: narrator.imageUrl,
      isFollowing: narrator.isFollowing,
      onTap: onTap,
      margin: margin,
      totalNarrations: narrator.totalNarrations,
      experienceYears: narrator.experienceYears,
      languages: narrator.languages,
      genres: narrator.genres,
      customStats: voiceType != null ? {'voiceType': voiceType} : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AppCard(
      margin: margin ?? const EdgeInsets.only(bottom: AppSpacing.small),
      gradient: context.surfaceGradient,
      elevation: AppSpacing.elevationNone,
      onTap: onTap,
      child: Row(
        children: [
          // Person avatar
          _buildAvatar(context),
          const SizedBox(width: AppSpacing.medium),
          // Person info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTypeIndicator(context),
                const SizedBox(height: AppSpacing.extraSmall),
                _buildName(context),
                const SizedBox(height: AppSpacing.extraSmall),
                _buildDescription(context),
                const SizedBox(height: AppSpacing.small),
                _buildStats(context),
                if (type == PersonType.narrator && languages != null) ...[
                  const SizedBox(height: AppSpacing.extraSmall),
                  _buildLanguages(context),
                ],
              ],
            ),
          ),
          // Arrow icon
          Icon(
            Icons.chevron_right_rounded,
            color: colorScheme.onSurfaceVariant,
            size: AppSpacing.iconMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AppCircularImage(
      imageUrl: imageUrl,
      fallbackIcon: type == PersonType.author 
          ? Icons.person_rounded 
          : Icons.mic_rounded,
      size: 60,
      backgroundColor: type == PersonType.author
          ? colorScheme.primaryContainer
          : colorScheme.secondaryContainer,
      iconColor: type == PersonType.author
          ? colorScheme.onPrimaryContainer
          : colorScheme.onSecondaryContainer,
      iconSize: AppSpacing.iconLarge,
    );
  }

  Widget _buildTypeIndicator(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    IconData icon;
    String label;
    Color color;

    switch (type) {
      case PersonType.author:
        icon = Icons.edit_rounded;
        label = 'Author';
        color = colorScheme.primary;
        break;
      case PersonType.narrator:
        icon = Icons.record_voice_over_rounded;
        label = customStats?['voiceType'] ?? 'Narrator';
        color = colorScheme.secondary;
        break;
    }

    return Row(
      children: [
        Icon(
          icon,
          color: color,
          size: AppSpacing.iconExtraSmall,
        ),
        const SizedBox(width: AppSpacing.extraSmall),
        AppCaptionText(
          label,
          color: color,
        ),
        const SizedBox(width: AppSpacing.small),
        AppFollowingBadge(isFollowing: isFollowing),
      ],
    );
  }

  Widget _buildName(BuildContext context) {
    return AppSubtitleText(
      name,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildDescription(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AppCaptionText(
      description,
      color: colorScheme.onSurfaceVariant,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildStats(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    List<Widget> statWidgets = [];

    switch (type) {
      case PersonType.author:
        if (totalBooks != null) {
          statWidgets.addAll([
            Icon(
              Icons.book_rounded,
              color: colorScheme.onSurfaceVariant,
              size: AppSpacing.iconExtraSmall,
            ),
            const SizedBox(width: AppSpacing.extraSmall),
            AppCaptionText(
              '$totalBooks books',
              color: colorScheme.onSurfaceVariant,
            ),
          ]);
        }

        if (nationality != null) {
          if (statWidgets.isNotEmpty) {
            statWidgets.add(const SizedBox(width: AppSpacing.medium));
          }
          statWidgets.addAll([
            Icon(
              Icons.public_rounded,
              color: colorScheme.onSurfaceVariant,
              size: AppSpacing.iconExtraSmall,
            ),
            const SizedBox(width: AppSpacing.extraSmall),
            AppCaptionText(
              nationality!,
              color: colorScheme.onSurfaceVariant,
            ),
          ]);
        }
        break;

      case PersonType.narrator:
        if (totalNarrations != null) {
          statWidgets.addAll([
            Icon(
              Icons.library_music_rounded,
              color: colorScheme.onSurfaceVariant,
              size: AppSpacing.iconExtraSmall,
            ),
            const SizedBox(width: AppSpacing.extraSmall),
            AppCaptionText(
              '$totalNarrations narrations',
              color: colorScheme.onSurfaceVariant,
            ),
          ]);
        }

        if (experienceYears != null) {
          if (statWidgets.isNotEmpty) {
            statWidgets.add(const SizedBox(width: AppSpacing.medium));
          }
          statWidgets.addAll([
            Icon(
              Icons.schedule_rounded,
              color: colorScheme.onSurfaceVariant,
              size: AppSpacing.iconExtraSmall,
            ),
            const SizedBox(width: AppSpacing.extraSmall),
            AppCaptionText(
              '$experienceYears years',
              color: colorScheme.onSurfaceVariant,
            ),
          ]);
        }
        break;
    }

    return Row(children: statWidgets);
  }

  Widget _buildLanguages(BuildContext context) {
    if (languages == null || languages!.isEmpty) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Wrap(
      spacing: AppSpacing.extraSmall,
      children: languages!.take(3).map((language) {
        return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.small,
            vertical: 2,
          ),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainer,
            borderRadius: BorderRadius.circular(AppSpacing.radiusExtraSmall),
          ),
          child: Text(
            language,
            style: theme.textTheme.labelSmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontSize: 9,
            ),
          ),
        );
      }).toList(),
    );
  }
}