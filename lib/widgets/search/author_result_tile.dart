import 'package:flutter/material.dart';
import '../../data/mock_data.dart';
import '../../theme/app_spacing.dart';
import '../text/app_text.dart';
import '../cards/app_card.dart';

/// Author search result tile widget
/// Displays author information in search results with avatar, name, bio, and statistics
class AuthorResultTile extends StatelessWidget {
  final AuthorData author;
  final VoidCallback? onTap;
  final EdgeInsets? margin;

  const AuthorResultTile({
    super.key,
    required this.author,
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
          // Author avatar
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colorScheme.primaryContainer,
              boxShadow: [
                BoxShadow(
                  color: colorScheme.shadow.withValues(alpha: 0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              Icons.person_rounded,
              color: colorScheme.onPrimaryContainer,
              size: AppSpacing.iconMedium,
            ),
          ),
          const SizedBox(width: AppSpacing.medium),
          // Author info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Type indicator
                Row(
                  children: [
                    Icon(
                      Icons.edit_rounded,
                      color: colorScheme.primary,
                      size: AppSpacing.iconExtraSmall,
                    ),
                    const SizedBox(width: AppSpacing.extraSmall),
                    AppCaptionText(
                      'Author',
                      color: colorScheme.primary,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.extraSmall),
                // Author name
                AppSubtitleText(
                  author.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  color: colorScheme.onSurface,
                ),
                const SizedBox(height: AppSpacing.extraSmall),
                // Bio
                AppCaptionText(
                  author.bio,
                  color: colorScheme.onSurfaceVariant,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.small),
                // Statistics
                Row(
                  children: [
                    Icon(
                      Icons.book_rounded,
                      color: colorScheme.onSurfaceVariant,
                      size: AppSpacing.iconExtraSmall,
                    ),
                    const SizedBox(width: AppSpacing.extraSmall),
                    AppCaptionText(
                      '${author.totalBooks} books',
                      color: colorScheme.onSurfaceVariant,
                    ),
                    if (author.awards.isNotEmpty) ...[
                      const SizedBox(width: AppSpacing.medium),
                      Icon(
                        Icons.emoji_events_rounded,
                        color: colorScheme.secondary,
                        size: AppSpacing.iconExtraSmall,
                      ),
                      const SizedBox(width: AppSpacing.extraSmall),
                      AppCaptionText(
                        '${author.awards.length} awards',
                        color: colorScheme.onSurfaceVariant,
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