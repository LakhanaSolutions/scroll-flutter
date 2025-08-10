import 'package:flutter/material.dart';
import '../../theme/app_spacing.dart';
import '../text/app_text.dart';
import '../buttons/app_buttons.dart';

/// Reusable empty state widget for consistent empty state displays
/// Handles various empty states throughout the app with optional action button
class AppEmptyState extends StatelessWidget {
  /// The icon to display in the empty state
  final IconData icon;
  
  /// The title text to display
  final String title;
  
  /// The description text to display
  final String description;
  
  /// Optional action button text
  final String? actionText;
  
  /// Optional action button callback
  final VoidCallback? onAction;
  
  /// Optional custom content widget to replace the standard layout
  final Widget? customContent;
  
  /// Whether to center the content horizontally
  final bool centerContent;
  
  /// Custom icon color
  final Color? iconColor;
  
  /// Custom padding around the empty state
  final EdgeInsets? padding;

  const AppEmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    this.actionText,
    this.onAction,
    this.customContent,
    this.centerContent = true,
    this.iconColor,
    this.padding,
  });

  /// Creates an empty state for search results
  const AppEmptyState.search({
    super.key,
    this.actionText,
    this.onAction,
    this.customContent,
    this.centerContent = true,
    this.iconColor,
    this.padding,
  }) : icon = Icons.search_off_rounded,
       title = 'No Results Found',
       description = 'Try adjusting your search terms or explore other content.';

  /// Creates an empty state for bookmarks
  const AppEmptyState.bookmarks({
    super.key,
    this.actionText,
    this.onAction,
    this.customContent,
    this.centerContent = true,
    this.iconColor,
    this.padding,
  }) : icon = Icons.bookmark_border_rounded,
       title = 'No Bookmarks Yet',
       description = 'Start bookmarking your favorite content to see them here.';

  /// Creates an empty state for downloads
  const AppEmptyState.downloads({
    super.key,
    this.actionText,
    this.onAction,
    this.customContent,
    this.centerContent = true,
    this.iconColor,
    this.padding,
  }) : icon = Icons.download_rounded,
       title = 'No Downloads',
       description = 'Downloaded content will appear here for offline listening.';

  /// Creates an empty state for following
  const AppEmptyState.following({
    super.key,
    this.actionText,
    this.onAction,
    this.customContent,
    this.centerContent = true,
    this.iconColor,
    this.padding,
  }) : icon = Icons.person_add_rounded,
       title = 'Not Following Anyone',
       description = 'Follow authors and narrators to get updates on their latest content.';

  /// Creates an empty state for notifications
  const AppEmptyState.notifications({
    super.key,
    this.actionText,
    this.onAction,
    this.customContent,
    this.centerContent = true,
    this.iconColor,
    this.padding,
  }) : icon = Icons.notifications_none_rounded,
       title = 'No Notifications',
       description = 'When you have new updates, they\'ll appear here.';

  /// Creates an empty state for authors
  const AppEmptyState.authors({
    super.key,
    required String language,
    this.actionText,
    this.onAction,
    this.customContent,
    this.centerContent = true,
    this.iconColor,
    this.padding,
  }) : icon = Icons.person_search_rounded,
       title = 'No Authors Found',
       description = language == 'All'
           ? 'No authors available at the moment.'
           : 'No authors found for $language language.';

  /// Creates an empty state for narrators
  const AppEmptyState.narrators({
    super.key,
    required String voiceType,
    this.actionText,
    this.onAction,
    this.customContent,
    this.centerContent = true,
    this.iconColor,
    this.padding,
  }) : icon = Icons.mic_off_rounded,
       title = 'No Narrators Found',
       description = voiceType == 'All'
           ? 'No narrators available at the moment.'
           : 'No narrators found for $voiceType.';

  /// Creates an empty state for content
  const AppEmptyState.content({
    super.key,
    this.actionText,
    this.onAction,
    this.customContent,
    this.centerContent = true,
    this.iconColor,
    this.padding,
  }) : icon = Icons.library_books_outlined,
       title = 'No Content Available',
       description = 'Content for this category will be added soon.';

  /// Creates an empty state for library
  const AppEmptyState.library({
    super.key,
    this.actionText,
    this.onAction,
    this.customContent,
    this.centerContent = true,
    this.iconColor,
    this.padding,
  }) : icon = Icons.library_music_outlined,
       title = 'Your Library is Empty',
       description = 'Start exploring to add books and podcasts to your library.';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (customContent != null) {
      return Padding(
        padding: padding ?? const EdgeInsets.all(AppSpacing.large),
        child: customContent!,
      );
    }

    final content = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: AppSpacing.iconHero,
          color: iconColor ?? colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
        ),
        const SizedBox(height: AppSpacing.large),
        AppTitleText(
          title,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.small),
        AppBodyText(
          description,
          textAlign: TextAlign.center,
          color: colorScheme.onSurfaceVariant,
        ),
        if (actionText != null && onAction != null) ...[
          const SizedBox(height: AppSpacing.large),
          AppPrimaryButton(
            onPressed: onAction!,
            child: Text(actionText!),
          ),
        ],
      ],
    );

    final paddedContent = Padding(
      padding: padding ?? const EdgeInsets.all(AppSpacing.large),
      child: content,
    );

    return centerContent
        ? Center(child: paddedContent)
        : paddedContent;
  }
}