import 'package:flutter/material.dart';
import '../../data/mock_data.dart';
import '../../theme/app_spacing.dart';
import '../text/app_text.dart';
import '../cards/app_card.dart';

/// Chapter search result tile widget
/// Displays chapter information in search results with content type, title, description, and parent content
class ChapterResultTile extends StatelessWidget {
  final ChapterData chapter;
  final ContentItemData parentContent;
  final VoidCallback? onTap;
  final EdgeInsets? margin;

  const ChapterResultTile({
    super.key,
    required this.chapter,
    required this.parentContent,
    this.onTap,
    this.margin,
  });

  String _getNarratorName() {
    if (parentContent.narrators.isEmpty) return 'Unknown';
    
    // Find the narrator for this specific chapter
    final narrator = parentContent.narrators.firstWhere(
      (n) => n.id == chapter.narratorId,
      orElse: () => parentContent.narrators.first,
    );
    
    return narrator.name;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AppCard(
      margin: margin ?? const EdgeInsets.only(bottom: AppSpacing.small),
      onTap: onTap,
      child: Row(
        children: [
          // Chapter cover/icon
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
              color: colorScheme.tertiaryContainer,
              boxShadow: [
                BoxShadow(
                  color: colorScheme.shadow.withValues(alpha: 0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              parentContent.type == ContentType.book 
                  ? Icons.menu_book_rounded 
                  : Icons.podcasts_rounded,
              color: colorScheme.onTertiaryContainer,
              size: AppSpacing.iconMedium,
            ),
          ),
          const SizedBox(width: AppSpacing.medium),
          // Chapter info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Type indicator
                Row(
                  children: [
                    Icon(
                      Icons.play_circle_outline_rounded,
                      color: colorScheme.primary,
                      size: AppSpacing.iconExtraSmall,
                    ),
                    const SizedBox(width: AppSpacing.extraSmall),
                    AppCaptionText(
                      parentContent.type == ContentType.book ? 'Chapter' : 'Episode',
                      color: colorScheme.primary,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.extraSmall),
                // Chapter title
                AppSubtitleText(
                  chapter.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  color: colorScheme.onSurface,
                ),
                const SizedBox(height: AppSpacing.extraSmall),
                // Parent content title
                AppCaptionText(
                  'From: ${parentContent.title}',
                  color: colorScheme.onSurfaceVariant,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.extraSmall),
                // Narrator name
                Row(
                  children: [
                    Icon(
                      Icons.person_rounded,
                      color: colorScheme.onSurfaceVariant,
                      size: AppSpacing.iconExtraSmall,
                    ),
                    const SizedBox(width: AppSpacing.extraSmall),
                    Expanded(
                      child: AppCaptionText(
                        'Narrated by ${_getNarratorName()}',
                        color: colorScheme.onSurfaceVariant,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.small),
                // Duration and progress
                Row(
                  children: [
                    Icon(
                      Icons.access_time_rounded,
                      color: colorScheme.onSurfaceVariant,
                      size: AppSpacing.iconExtraSmall,
                    ),
                    const SizedBox(width: AppSpacing.extraSmall),
                    AppCaptionText(
                      chapter.duration,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    if (chapter.progress > 0) ...[
                      const SizedBox(width: AppSpacing.medium),
                      Icon(
                        Icons.play_arrow_rounded,
                        color: colorScheme.primary,
                        size: AppSpacing.iconExtraSmall,
                      ),
                      const SizedBox(width: AppSpacing.extraSmall),
                      AppCaptionText(
                        '${(chapter.progress * 100).toInt()}% complete',
                        color: colorScheme.primary,
                      ),
                    ],
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