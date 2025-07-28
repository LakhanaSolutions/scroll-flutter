import 'package:flutter/material.dart';
import '../../data/mock_data.dart';
import '../../theme/app_spacing.dart';
import '../text/app_text.dart';
import '../cards/app_card.dart';

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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AppCard(
      margin: margin ?? const EdgeInsets.only(bottom: AppSpacing.small),
      onTap: onTap,
      child: Row(
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
            // Availability badge
            Positioned(
              top: AppSpacing.extraSmall,
              right: AppSpacing.extraSmall,
              child: _buildAvailabilityBadge(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvailabilityBadge(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    Color badgeColor;
    String badgeText;
    IconData badgeIcon;

    switch (content.availability) {
      case AvailabilityType.free:
        badgeColor = colorScheme.tertiary;
        badgeText = 'FREE';
        badgeIcon = Icons.check_circle;
        break;
      case AvailabilityType.premium:
        badgeColor = colorScheme.secondary;
        badgeText = 'PRO';
        badgeIcon = Icons.star_rounded;
        break;
      case AvailabilityType.trial:
        badgeColor = colorScheme.error;
        badgeText = 'TRIAL';
        badgeIcon = Icons.access_time_rounded;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.extraSmall,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: badgeColor,
        borderRadius: BorderRadius.circular(AppSpacing.radiusExtraSmall),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            badgeIcon,
            color: colorScheme.onSecondary,
            size: 8,
          ),
          const SizedBox(width: 2),
          Text(
            badgeText,
            style: theme.textTheme.labelSmall?.copyWith(
              color: colorScheme.onSecondary,
              fontSize: 8,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
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
          ],
        ),
      ],
    );
  }
}