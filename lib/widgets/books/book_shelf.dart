import 'package:flutter/material.dart';
import '../../data/mock_data.dart';
import '../../theme/app_spacing.dart';
import '../text/app_text.dart';
import '../images/app_image.dart';

/// Book shelf widget that displays books in a shelf-like UI
/// Shows book covers with titles and authors in a horizontal scrollable layout
class BookShelf extends StatelessWidget {
  final String title;
  final List<BookData> books;
  final Function(BookData)? onBookTap;
  final EdgeInsets? padding;

  const BookShelf({
    super.key,
    required this.title,
    required this.books,
    this.onBookTap,
    this.padding,
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
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.medium),
              itemCount: books.length,
              itemBuilder: (context, index) {
                final book = books[index];
                return _BookShelfItem(
                  book: book,
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

  const _BookShelfItem({
    required this.book,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: 120,
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
                      width: 120,
                      height: 140,
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
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.small),
              // Book title
              AppCaptionText(
                book.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AppSpacing.extraSmall),
              // Author and rating
              Row(
                children: [
                  Expanded(
                    child: AppCaptionText(
                      book.author,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.extraSmall),
                  Icon(
                    Icons.star_rounded,
                    color: colorScheme.primary,
                    size: AppSpacing.iconExtraSmall,
                  ),
                  AppCaptionText(
                    book.rating.toString(),
                    color: colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}