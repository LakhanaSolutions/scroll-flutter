import 'package:flutter/material.dart';
import '../../data/mock_data.dart';
import '../../theme/app_spacing.dart';
import '../text/app_text.dart';
import '../buttons/app_buttons.dart';
import '../cards/app_card_home.dart';

/// Audiobook of the week banner widget
/// Full width banner showcasing the featured audiobook with cover, title, author and action button
class AudiobookOfWeekBanner extends StatelessWidget {
  final BookData book;
  final String actionText;
  final VoidCallback? onAction;
  final EdgeInsets? margin;

  const AudiobookOfWeekBanner({
    super.key,
    required this.book,
    this.actionText = 'Listen Now',
    this.onAction,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AppCardHome(
      margin: margin ?? const EdgeInsets.symmetric(
        horizontal: AppSpacing.medium,
        vertical: AppSpacing.medium,
      ),
      padding: EdgeInsets.zero,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
          gradient: LinearGradient(
            colors: [
              colorScheme.surfaceContainer.withValues(alpha: 0.5),
              colorScheme.surfaceContainerHigh.withValues(alpha: 0.5),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(AppSpacing.large),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section header
              Row(
                children: [
                  Icon(
                    Icons.star_rounded,
                    color: colorScheme.primary,
                    size: AppSpacing.iconMedium,
                  ),
                  const SizedBox(width: AppSpacing.small),
                  AppSubtitleText(
                    'Audiobook of the Week',
                    color: colorScheme.primary,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.large),
              // Main content
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Book cover
                  _buildBookCover(context),
                  const SizedBox(width: AppSpacing.large),
                  // Book info
                  Expanded(
                    child: _buildBookInfo(context),
                  ),
                ],
              ),
            ],
        ),
      ),
    );
  }

  Widget _buildBookCover(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: 100,
      height: 140,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
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
                  Icons.menu_book_rounded,
                  color: colorScheme.onPrimary,
                  size: AppSpacing.iconLarge,
                ),
              ),
            ),
            // Premium badge
            if (book.isPremium)
              Positioned(
                top: AppSpacing.small,
                right: AppSpacing.small,
                child: Container(
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
                      const SizedBox(width: 2),
                      Text(
                        'PRO',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: colorScheme.onSecondary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookInfo(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Book title
        AppTitleText(
          book.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          color: colorScheme.onSurface,
        ),
        const SizedBox(height: AppSpacing.small),
        // Author
        AppBodyText(
          'by ${book.author}',
          color: colorScheme.onSurfaceVariant,
        ),
        const SizedBox(height: AppSpacing.small),
        // Rating and duration
        Row(
          children: [
            Icon(
              Icons.star_rounded,
              color: colorScheme.primary,
              size: AppSpacing.iconSmall,
            ),
            const SizedBox(width: AppSpacing.extraSmall),
            AppCaptionText(
              book.rating.toString(),
              color: colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: AppSpacing.medium),
            Icon(
              Icons.access_time_rounded,
              color: colorScheme.onSurfaceVariant,
              size: AppSpacing.iconSmall,
            ),
            const SizedBox(width: AppSpacing.extraSmall),
            AppCaptionText(
              book.duration,
              color: colorScheme.onSurfaceVariant,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.large),
        // Action button
        SizedBox(
          width: double.infinity,
          child: AppPrimaryButton(
            onPressed: onAction,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.play_arrow_rounded,
                  size: AppSpacing.iconSmall,
                ),
                const SizedBox(width: AppSpacing.small),
                Text(actionText),
              ],
            ),
          ),
        ),
      ],
    );
  }
}