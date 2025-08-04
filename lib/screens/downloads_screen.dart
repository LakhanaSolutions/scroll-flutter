import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../data/mock_data.dart';
import '../theme/app_spacing.dart';
import '../widgets/text/app_text.dart';
import '../widgets/app_bar/app_app_bar.dart';
import '../widgets/cards/app_card.dart';
import '../widgets/dialogs/app_dialogs.dart';

/// Downloads screen that displays user's downloaded content
class DownloadsScreen extends ConsumerWidget {
  const DownloadsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final downloads = MockData.getDownloadedBooks();

    return Scaffold(
      appBar: AppAppBar(
        title: 'Downloads',
        backgroundColor: colorScheme.surface,
      ),
      body: downloads.isEmpty
          ? _buildEmptyState(context)
          : _buildDownloadsList(context, downloads),
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
              Icons.download_rounded,
              size: 80,
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            ),
            const SizedBox(height: AppSpacing.large),
            AppTitleText(
              'No Downloads',
              color: colorScheme.onSurface,
            ),
            const SizedBox(height: AppSpacing.small),
            AppBodyText(
              'Books you download will appear here for offline listening.',
              color: colorScheme.onSurfaceVariant,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.large),
            ElevatedButton.icon(
              onPressed: () => context.go('/home/library'),
              icon: const Icon(Icons.explore_rounded),
              label: const Text('Browse Books'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDownloadsList(BuildContext context, List<DownloadedBookData> downloads) {
    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.medium),
      itemCount: downloads.length,
      separatorBuilder: (context, index) => const SizedBox(height: AppSpacing.medium),
      itemBuilder: (context, index) {
        final book = downloads[index];
        return _DownloadTile(
          book: book,
          onTap: () {
            debugPrint('Downloaded book tapped: ${book.title}');
          },
          onDelete: () => _showDeleteConfirmation(context, book),
        );
      },
    );
  }

  void _showDeleteConfirmation(BuildContext context, DownloadedBookData book) {
    AppAlertDialog.show(
      context,
      title: 'Delete Download',
      content: Text('Are you sure you want to delete "${book.title}" from your downloads?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            debugPrint('Deleting book: ${book.title}');
            // Handle delete logic here
          },
          style: TextButton.styleFrom(
            foregroundColor: Theme.of(context).colorScheme.error,
          ),
          child: const Text('Delete'),
        ),
      ],
    );
  }
}

/// Downloaded book tile widget
class _DownloadTile extends StatelessWidget {
  final DownloadedBookData book;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const _DownloadTile({
    required this.book,
    this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AppCard(
      elevation: 0,
      backgroundColor: colorScheme.surfaceContainer,
      padding: EdgeInsets.zero,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.medium),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Book cover with download indicator
              Stack(
                children: [
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
                            Icons.menu_book_rounded,
                            color: colorScheme.onPrimary,
                            size: AppSpacing.iconLarge,
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Download status indicator
                  Positioned(
                    top: 4,
                    right: 4,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: book.isDownloading 
                            ? colorScheme.secondary 
                            : colorScheme.tertiary,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        book.isDownloading 
                            ? Icons.download_rounded 
                            : Icons.download_done_rounded,
                        color: book.isDownloading 
                            ? colorScheme.onSecondary 
                            : colorScheme.onTertiary,
                        size: 16,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: AppSpacing.medium),
              // Book details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    AppSubtitleText(
                      book.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      color: colorScheme.onSurface,
                    ),
                    const SizedBox(height: AppSpacing.extraSmall),
                    // Narrator
                    AppCaptionText(
                      'by ${book.narrator}',
                      color: colorScheme.onSurfaceVariant,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppSpacing.small),
                    // Download size and status
                    Row(
                      children: [
                        Icon(
                          Icons.storage_rounded,
                          color: colorScheme.onSurfaceVariant,
                          size: AppSpacing.iconExtraSmall,
                        ),
                        const SizedBox(width: AppSpacing.extraSmall),
                        AppCaptionText(
                          book.downloadSize,
                          color: colorScheme.onSurfaceVariant,
                        ),
                        if (book.isDownloading) ...[
                          const SizedBox(width: AppSpacing.medium),
                          AppCaptionText(
                            '${(book.downloadProgress * 100).toInt()}%',
                            color: colorScheme.secondary,
                          ),
                        ],
                      ],
                    ),
                    if (book.isDownloading) ...[
                      const SizedBox(height: AppSpacing.small),
                      // Download progress bar
                      LinearProgressIndicator(
                        value: book.downloadProgress,
                        backgroundColor: colorScheme.surfaceContainer,
                        valueColor: AlwaysStoppedAnimation<Color>(colorScheme.secondary),
                      ),
                    ],
                  ],
                ),
              ),
              // Menu button
              PopupMenuButton<String>(
                icon: Icon(
                  Icons.more_vert_rounded,
                  color: colorScheme.onSurfaceVariant,
                ),
                onSelected: (value) {
                  if (value == 'delete') {
                    onDelete?.call();
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem<String>(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(
                          Icons.delete_rounded,
                          color: colorScheme.error,
                          size: AppSpacing.iconSmall,
                        ),
                        const SizedBox(width: AppSpacing.small),
                        Text(
                          'Delete',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.error,
                          ),
                        ),
                      ],
                    ),
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