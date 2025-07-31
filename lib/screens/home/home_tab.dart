import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../data/mock_data.dart';
import '../../theme/app_spacing.dart';
import '../../widgets/notifications/notification_area.dart';
import '../../widgets/banners/premium_banner.dart';
import '../../widgets/books/book_shelf.dart';
import '../../widgets/mood/mood_selector.dart';
import '../../widgets/premium/premium_content_section.dart';
import '../../widgets/banners/audiobook_of_week.dart';
import '../../widgets/text/app_text.dart';
import '../../widgets/images/app_image.dart';
import '../../theme/app_icons.dart';
import '../../providers/subscription_provider.dart';
import '../../widgets/cards/app_card.dart';

/// Home tab content widget
/// Displays the main home feed with notifications, banners, book shelves, and featured content
class HomeTab extends ConsumerWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final shouldShowPremiumAds = ref.watch(shouldShowPremiumAdsProvider);

    return Scaffold(
      body: Column(
      children: [
        // Header/AppBar area
        Container(
          padding: const EdgeInsets.all(AppSpacing.medium),
          decoration: BoxDecoration(
            // color: const Color(0xFFF2F2F7), // iOS background
            border: Border(
              bottom: BorderSide(
                color: colorScheme.outline.withValues(alpha: 0.1),
                width: 1,
              ),
            ),
          ),
          child: Row(
            children: [
              Icon(
                AppIcons.home,
                color: colorScheme.primary,
                size: AppSpacing.iconMedium,
              ),
              const SizedBox(width: AppSpacing.small),
              const Expanded(
                child: AppTitleText('Home'),
              ),
              // Profile avatar
              GestureDetector(
                onTap: () => context.push('/home/profile'),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: colorScheme.outline.withValues(alpha: 0.2),
                      width: 1,
                    ),
                  ),
                  child: AppCircularImage(
                    imageUrl: null, // No user image in current data
                    fallbackIcon: AppIcons.person,
                    size: 40,
                    backgroundColor: colorScheme.primary,
                    iconColor: colorScheme.onPrimary,
                    iconSize: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
        // Content
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppSpacing.medium),
                
                // Search card
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.medium),
                  child: AppCardFlat(
                    onTap: () => context.push('/home/search'),
                    backgroundColor: colorScheme.surfaceContainerLow,
                    child: Row(
                      children: [
                        Icon(
                          AppIcons.search,
                          color: colorScheme.onSurfaceVariant,
                          size: AppSpacing.iconMedium,
                        ),
                        const SizedBox(width: AppSpacing.medium),
                        Expanded(
                          child: AppBodyText(
                            'Search books, authors, narrators...',
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: AppSpacing.large),
          
          // Notification area
          NotificationArea(
            notifications: MockData.getNotifications(),
            onDismiss: (id) {
              // Handle notification dismissal
              debugPrint('Dismissed notification: $id');
            },
            onAction: (notification) {
              // Handle notification action - navigate to subscriptions page
              context.push('/home/subscription');
            },
          ),
          
          // Premium upgrade banner (only show to free trial users)
          if (shouldShowPremiumAds)
            PremiumBanner(
              benefits: MockData.getPremiumFeatures().take(3).toList(),
              onAction: () => context.push('/home/subscription'),
            ),
          
          // Top shelf books
          BookShelf(
            title: 'Top Shelf',
            books: MockData.getShelfBooks(),
            onBookTap: (book) {
              debugPrint('Book tapped: ${book.title}');
            },
          ),
          
          // Mood selector
          MoodSelector(
            categories: MockData.getMoodCategories(),
            onMoodTap: (category) {
              debugPrint('Mood selected: ${category.name}');
            },
          ),
          
          // Premium exclusive content (only show to free trial users)
          if (shouldShowPremiumAds)
            PremiumContentSection(
              features: MockData.getPremiumFeatures(),
              onAction: () => context.push('/home/subscription'),
            ),
          
          // Audiobook of the week
          AudiobookOfWeekBanner(
            book: MockData.getAudiobookOfTheWeek(),
            onAction: () {
              final audiobook = MockData.getAudiobookOfTheWeek();
              context.push('/home/playlist/${audiobook.id}');
            },
          ),
          
          const SizedBox(height: AppSpacing.large),
            ],
          ),
        ),
      ),
      ],
      ),
    );
  }
}