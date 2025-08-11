import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../data/mock_data.dart';
import '../theme/app_spacing.dart';
import '../widgets/text/app_text.dart';
import '../widgets/app_bar/app_app_bar.dart';
import '../widgets/books/content_tile.dart';
import '../theme/app_icons.dart';
import '../providers/subscription_provider.dart';

/// Screen that displays content based on a specific mood category
/// Because sometimes your soul needs just the right spiritual vibe 🎵
class MoodScreen extends ConsumerWidget {
  final MoodCategory moodCategory;

  const MoodScreen({
    super.key,
    required this.moodCategory,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final shouldShowPremiumAds = ref.watch(shouldShowPremiumAdsProvider);

    return Scaffold(
      appBar: AppAppBar(
        title: moodCategory.name,
        backgroundColor: colorScheme.surface,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero section with mood info
            _buildMoodHeroSection(context),
            
            const SizedBox(height: AppSpacing.large),
            
            // Content section
            _buildContentSection(context, shouldShowPremiumAds),
            
            const SizedBox(height: AppSpacing.large),
          ],
        ),
      ),
    );
  }

  /// Builds the hero section with mood emoji, name, and description
  /// Making sure everyone knows what spiritual journey they're about to embark on
  Widget _buildMoodHeroSection(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.large),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorScheme.primaryContainer.withValues(alpha: 0.3),
            colorScheme.surfaceContainer.withValues(alpha: 0.2),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          // Large mood emoji - because size matters when expressing feelings
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer.withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(AppSpacing.radiusExtraLarge),
              border: Border.all(
                color: colorScheme.primary.withValues(alpha: 0.3),
                width: 3,
              ),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.shadow.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Text(
                moodCategory.emoji,
                style: theme.textTheme.displayLarge?.copyWith(
                  fontSize: 60,
                ),
              ),
            ),
          ),
          
          const SizedBox(height: AppSpacing.large),
          
          // Mood name
          AppTitleText(
            moodCategory.name,
            textAlign: TextAlign.center,
            color: colorScheme.onSurface,
          ),
          
          const SizedBox(height: AppSpacing.small),
          
          // Mood description - because context is everything
          Container(
            constraints: const BoxConstraints(maxWidth: 300),
            child: AppBodyText(
              moodCategory.description,
              textAlign: TextAlign.center,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the content section with books/podcasts for this mood
  /// Where the magic happens - turning feelings into audio experiences 🎵
  /// (Because sometimes you need to match your inner state with outer sound)
  Widget _buildContentSection(BuildContext context, bool shouldShowPremiumAds) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (moodCategory.books.isEmpty) {
      // Show empty state - because even moods can have off days
      return Container(
        padding: const EdgeInsets.all(AppSpacing.large),
        child: Column(
          children: [
            Icon(
              AppIcons.library,
              size: 64,
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            ),
            const SizedBox(height: AppSpacing.medium),
            AppSubtitleText(
              'No content available for this mood yet',
              color: colorScheme.onSurfaceVariant,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.small),
            AppBodyText(
              'Check back soon - we\'re always adding new content!',
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.medium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                AppIcons.playlist,
                color: colorScheme.primary,
                size: AppSpacing.iconSmall,
              ),
              const SizedBox(width: AppSpacing.small),
              AppSubtitleText('Perfect for your mood'),
              const Spacer(),
              AppCaptionText(
                '${moodCategory.books.length} items',
                color: colorScheme.onSurfaceVariant,
              ),
            ],
          ),
          
          const SizedBox(height: AppSpacing.medium),
          
          // Grid of content items - because variety is the spice of spiritual life
          ...moodCategory.books.map((book) {
            // Find the actual content item to get full details
            final allContent = [
              ...MockData.getCategoryContent('1'),
              ...MockData.getCategoryContent('2'),
              ...MockData.getCategoryContent('3'),
            ];
            
            final contentItem = allContent.firstWhere(
              (item) => item.title == book.title || item.id == book.id,
              orElse: () => allContent.first,
            );
            
            return Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.medium),
              child: ContentTile(
                content: contentItem,
                onTap: () {
                  context.push('/home/playlist/${contentItem.id}');
                },
              ),
            );
          }),
        ],
      ),
    );
  }
}

