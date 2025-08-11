import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../data/mock_data.dart';
import '../providers/bookmarks_provider.dart';
import '../theme/app_spacing.dart';
import '../widgets/text/app_text.dart';
import '../widgets/app_bar/app_app_bar.dart';
import '../widgets/cards/app_card.dart';
import '../widgets/indicators/app_badges.dart';

/// Bookmarks screen that displays user's bookmarked playlists
class BookmarksScreen extends ConsumerWidget {
  const BookmarksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Get bookmarked content from provider
    final bookmarkedContent = ref.watch(bookmarkedContentProvider);

    return Scaffold(
      appBar: AppAppBar(
        title: 'Bookmarks',
        backgroundColor: colorScheme.surface,
      ),
      body: bookmarkedContent.isEmpty
          ? _buildEmptyState(context)
          : _buildBookmarksList(context, bookmarkedContent),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.large),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.bookmark_border_rounded,
              size: 80,
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            ),
            const SizedBox(height: AppSpacing.large),
            AppTitleText(
              'No Bookmarks Yet',
              color: colorScheme.onSurface,
            ),
            const SizedBox(height: AppSpacing.small),
            AppBodyText(
              'Start bookmarking your favorite playlists and books to find them easily later.',
              color: colorScheme.onSurfaceVariant,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.large),
            ElevatedButton.icon(
              onPressed: () => context.go('/home/library'),
              icon: const Icon(Icons.explore_rounded),
              label: const Text('Explore Content'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookmarksList(BuildContext context, List<ContentItemData> bookmarkedContent) {
    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.medium),
      itemCount: bookmarkedContent.length,
      separatorBuilder: (context, index) => const SizedBox(height: AppSpacing.medium),
      itemBuilder: (context, index) {
        final content = bookmarkedContent[index];
        return _BookmarkTile(content: content);
      },
    );
  }
}

/// Individual bookmark tile widget
class _BookmarkTile extends ConsumerWidget {
  final ContentItemData content;

  const _BookmarkTile({required this.content});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isBookmarked = ref.watch(isBookmarkedProvider(content.id));

    return AppCard(
      elevation: 0,
      backgroundColor: colorScheme.surfaceContainer,
      padding: EdgeInsets.zero,
      child: InkWell(
        onTap: () {
          context.push('/home/playlist/${content.id}', extra: content);
        },
        borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.medium),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Content cover
              Container(
                width: 80,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.shadow.withValues(alpha: 0.15),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
                  child: Container(
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
                        size: AppSpacing.iconLarge,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.medium),
              // Content details
              Expanded(
                child: Column(
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
                          size: AppSpacing.iconSmall,
                        ),
                        const SizedBox(width: AppSpacing.extraSmall),
                        AppCaptionText(
                          content.type == ContentType.book ? 'Book' : 'Podcast',
                          color: colorScheme.primary,
                        ),
                        const Spacer(),
                        AppAvailabilityBadge(
                          availability: content.availability,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.small),
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
                    // Rating, duration, chapters
                    Row(
                      children: [
                        _buildInfoChip(
                          context,
                          Icons.star_rounded,
                          content.rating.toString(),
                          colorScheme.primary,
                        ),
                        const SizedBox(width: AppSpacing.small),
                        _buildInfoChip(
                          context,
                          Icons.access_time_rounded,
                          content.duration,
                          colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: AppSpacing.small),
                        _buildInfoChip(
                          context,
                          Icons.list_rounded,
                          '${content.chapterCount}',
                          colorScheme.onSurfaceVariant,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.small),
              // Bookmark button
              IconButton(
                icon: Icon(
                  isBookmarked ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                  color: isBookmarked ? colorScheme.primary : colorScheme.onSurfaceVariant,
                ),
                onPressed: () {
                  ref.read(bookmarksProvider.notifier).toggleBookmark(content.id);
                  
                  // Show snackbar
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(isBookmarked ? 'Removed from bookmarks' : 'Added to bookmarks'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(BuildContext context, IconData icon, String text, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: color,
          size: AppSpacing.iconExtraSmall,
        ),
        const SizedBox(width: AppSpacing.extraSmall),
        AppCaptionText(
          text,
          color: color,
        ),
      ],
    );
  }

}