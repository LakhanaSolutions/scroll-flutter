import 'package:flutter/material.dart';
import '../../data/mock_data.dart';
import '../../theme/app_spacing.dart';
import '../text/app_text.dart';
import '../cards/app_card.dart';
import '../indicators/app_badges.dart';

/// Reusable content tile widget for books and podcasts
/// Similar to audiobook_of_week.dart but more compact and versatile
class ContentTile extends StatelessWidget {
  final ContentItemData content;
  final VoidCallback? onTap;
  final EdgeInsets? margin;

  const ContentTile({
    super.key,
    required this.content,
    this.onTap,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {

    return AppCard(
      margin: margin ?? const EdgeInsets.only(bottom: AppSpacing.small),
      elevation: AppSpacing.elevationNone,
      onTap: onTap,
      child: Stack(
        children: [
          Row(
            children: [
              // Content cover
              _buildContentCover(context),
              const SizedBox(width: AppSpacing.medium),
              // Content info
              Expanded(
                child: _buildContentInfo(context),
              ),
            ],
          ),
          // Premium badge in top right corner - aligned like Most Popular badge
          if (content.availability == AvailabilityType.premium)
            Positioned(
              top: 8,
              right: AppSpacing.medium,
              child: AppAvailabilityBadge(
                availability: content.availability,
                fontSize: 8,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildContentCover(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: 100,
      height: 130,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
        child: Stack(
          children: [
            // Placeholder cover with gradient
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    colorScheme.primary,
                    colorScheme.primaryContainer,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Center(
                child: Icon(
                  content.type == ContentType.book 
                      ? Icons.menu_book_rounded 
                      : Icons.podcasts_rounded,
                  color: colorScheme.onPrimary,
                  size: AppSpacing.iconMedium,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildContentInfo(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Content type indicator
        Row(
          children: [
            Icon(
              content.type == ContentType.book 
                  ? Icons.book_rounded 
                  : Icons.podcasts_rounded,
              color: colorScheme.primary,
              size: AppSpacing.iconExtraSmall,
            ),
            const SizedBox(width: AppSpacing.extraSmall),
            AppCaptionText(
              content.type == ContentType.book ? 'Book' : 'Podcast',
              color: colorScheme.primary,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.extraSmall),
        // Title
        AppSubtitleText(
          content.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          color: colorScheme.onSurface,
        ),
        const SizedBox(height: AppSpacing.extraSmall),
        // Author
        AppCaptionText(
          'by ${content.author}',
          color: colorScheme.onSurfaceVariant,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: AppSpacing.extraSmall),
        // Narrator with gender
        _buildNarratorInfo(context),
        const SizedBox(height: AppSpacing.small),
        // Chapter count, duration, and rating
        Row(
          children: [
            Icon(
              Icons.list_rounded,
              color: colorScheme.onSurfaceVariant,
              size: AppSpacing.iconExtraSmall,
            ),
            const SizedBox(width: AppSpacing.extraSmall),
            AppCaptionText(
              '${content.chapterCount} chapters',
              color: colorScheme.onSurfaceVariant,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.extraSmall),
        Row(
          children: [
            Icon(
              Icons.star_rounded,
              color: colorScheme.primary,
              size: AppSpacing.iconExtraSmall,
            ),
            const SizedBox(width: AppSpacing.extraSmall),
            AppCaptionText(
              content.rating.toString(),
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
              content.duration,
              color: colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: AppSpacing.medium),
            Icon(
              Icons.language_rounded,
              color: colorScheme.onSurfaceVariant,
              size: AppSpacing.iconExtraSmall,
            ),
            const SizedBox(width: AppSpacing.extraSmall),
            AppCaptionText(
              content.language,
              color: colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNarratorInfo(BuildContext context) {
    if (content.narrators.isEmpty) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Show up to 2 narrators to avoid clutter
    final displayNarrators = content.narrators.take(2).toList();
    final hasMore = content.narrators.length > 2;

    return Row(
      children: [
        Icon(
          Icons.mic_rounded,
          color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
          size: AppSpacing.iconExtraSmall,
        ),
        const SizedBox(width: AppSpacing.extraSmall),
        Expanded(
          child: Wrap(
            spacing: AppSpacing.extraSmall,
            runSpacing: 2,
            children: [
              ...displayNarrators.map((narrator) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      narrator.name,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 3,
                        vertical: 1,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        narrator.gender == 'Male' ? 'M' : 'F',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                          fontSize: 7,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                );
              }),
              if (hasMore)
                Text(
                  '+${content.narrators.length - 2} more',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                    fontSize: 10,
                    fontStyle: FontStyle.italic,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}