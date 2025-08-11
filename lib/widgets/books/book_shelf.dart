import 'package:flutter/material.dart';
import '../../data/mock_data.dart';
import '../../theme/app_spacing.dart';
import '../../theme/theme_extensions.dart';
import '../text/app_text.dart';
import '../images/app_image.dart';

/// Book shelf widget that displays books in a shelf-like UI
/// Shows book covers with titles and authors in a horizontal scrollable layout
class BookShelf extends StatelessWidget {
  final String title;
  final List<BookData> books;
  final Function(BookData)? onBookTap;
  final EdgeInsets? padding;
  final bool showProgress;

  const BookShelf({
    super.key,
    required this.title,
    required this.books,
    this.onBookTap,
    this.padding,
    this.showProgress = false,
  });

  @override
  Widget build(BuildContext context) {
    if (books.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(vertical: AppSpacing.medium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.medium),
            child: AppSubtitleText(title),
          ),
          const SizedBox(height: AppSpacing.medium),
          SizedBox(
            height: 280,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.medium),
              itemCount: books.length,
              itemBuilder: (context, index) {
                final book = books[index];
                return _BookShelfItem(
                  book: book,
                  showProgress: showProgress,
                  onTap: () => onBookTap?.call(book),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Individual book item in the shelf
class _BookShelfItem extends StatelessWidget {
  final BookData book;
  final VoidCallback? onTap;
  final bool showProgress;

  const _BookShelfItem({
    required this.book,
    this.onTap,
    this.showProgress = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final appTheme = context.appTheme;

    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: AppSpacing.medium),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Book cover
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.shadow.withValues(alpha: 0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    AppBookCover(
                      imageUrl: book.coverUrl,
                      width: 160,
                      height: 180,
                      backgroundColor: colorScheme.primaryContainer,
                    ),
                    // Premium badge
                    if (book.isPremium)
                      Positioned(
                        top: AppSpacing.small,
                        right: AppSpacing.small,
                        child: Container(
                          padding: const EdgeInsets.all(AppSpacing.extraSmall),
                          decoration: BoxDecoration(
                            color: colorScheme.secondary,
                            borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
                          ),
                          child: Icon(
                            Icons.star_rounded,
                            color: colorScheme.onSecondary,
                            size: AppSpacing.iconExtraSmall,
                          ),
                        ),
                      ),
                    // Progress bar for continue listening
                    if (showProgress && book.progress != null)
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.2),
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(AppSpacing.radiusMedium),
                              bottomRight: Radius.circular(AppSpacing.radiusMedium),
                            ),
                          ),
                          child: FractionallySizedBox(
                            alignment: Alignment.centerLeft,
                            widthFactor: book.progress,
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    appTheme.warning,
                                    appTheme.warningContainer,
                                  ],
                                ),
                                borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(AppSpacing.radiusMedium),
                                  bottomRight: Radius.circular(AppSpacing.radiusMedium),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.small),
              // Book title with prominent rating
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppBodyText(
                    book.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSpacing.extraSmall),
                  // Large gold star rating - closer to title
                  Row(
                    children: [
                      Icon(
                        Icons.star_rounded,
                        color: appTheme.warning,
                        size: AppSpacing.iconMedium, // Larger size
                      ),
                      const SizedBox(width: AppSpacing.extraSmall),
                      Text(
                        book.rating.toString(),
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.extraSmall),
              // Author
              AppCaptionText(
                book.author,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                color: colorScheme.onSurfaceVariant,
              ),
              // Progress text for continue listening
              if (showProgress && book.progress != null)
                Padding(
                  padding: const EdgeInsets.only(top: AppSpacing.extraSmall),
                  child: AppCaptionText(
                    '${(book.progress! * 100).round()}% complete',
                    color: appTheme.warning,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}