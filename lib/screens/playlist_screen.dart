import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:siraaj/theme/app_gradients.dart';
import 'package:siraaj/widgets/buttons/music_player_fab.dart';
import '../data/mock_data.dart';
import '../theme/app_spacing.dart';
import '../providers/subscription_provider.dart';
import '../providers/bookmarks_provider.dart';
import '../widgets/text/app_text.dart';
import '../widgets/app_bar/app_app_bar.dart';
import '../widgets/cards/app_card.dart';
import '../widgets/buttons/app_buttons.dart';
import '../widgets/trial/glimpse_into_premium_stats.dart';
import '../widgets/reviews/add_review_card.dart';
import '../widgets/social/social_listening_stats.dart';
import '../widgets/books/content_cover.dart';

/// Playlist screen that displays detailed information about a book or podcast
/// Shows description, actions, narrator selection, and chapters list
class PlaylistScreen extends ConsumerStatefulWidget {
  final ContentItemData content;
  final double? progress;

  const PlaylistScreen({
    super.key,
    required this.content,
    this.progress,
  });

  @override
  ConsumerState<PlaylistScreen> createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends ConsumerState<PlaylistScreen> {
  String _selectedNarratorId = '';

  @override
  void initState() {
    super.initState();
    _selectedNarratorId = widget.content.narrators.isNotEmpty 
        ? widget.content.narrators.first.id 
        : '';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isBookmarked = ref.watch(isBookmarkedProvider(widget.content.id));

    return Scaffold(
      floatingActionButton: const MusicPlayerFab(),
      appBar: AppAppBar(
        title: widget.content.title,
        backgroundColor: colorScheme.surface,
        actions: [
          if (widget.progress != null && widget.progress! > 0)
            Container(
              margin: const EdgeInsets.only(right: AppSpacing.small),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.small,
                vertical: AppSpacing.extraSmall,
              ),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.schedule_rounded,
                    color: colorScheme.onPrimaryContainer,
                    size: AppSpacing.iconExtraSmall,
                  ),
                  const SizedBox(width: AppSpacing.extraSmall),
                  Text(
                    '${(widget.progress! * 100).toInt()}%',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          IconButton(
            icon: Icon(
              isBookmarked ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
              color: isBookmarked ? colorScheme.primary : colorScheme.onSurfaceVariant,
            ),
            onPressed: () {
              ref.read(bookmarksProvider.notifier).toggleBookmark(widget.content.id);
            },
          ),
          IconButton(
            icon: Icon(
              Icons.share_rounded,
              color: colorScheme.onSurfaceVariant,
            ),
            onPressed: () {
              debugPrint('Share tapped for: ${widget.content.title}');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Content info section
            _buildContentInfoSection(context),
            // Trial usage stats section (for trial users only)
            _buildTrialStatsSection(context),
            // Actions section
            _buildActionsSection(context),
            // Narrator selection section
            _buildNarratorSection(context),
            // Chapters list section
            _buildChaptersSection(context),
            // Download section
            _buildDownloadSection(context),
            // Reviews section
            _buildReviewsSection(context),
            // Bottom padding
            const SizedBox(height: AppSpacing.large),
          ],
        ),
      ),
    );
  }

  Widget _buildContentInfoSection(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      color: colorScheme.surface,
      padding: const EdgeInsets.all(AppSpacing.large),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Content cover
          ContentCover(
            content: widget.content,
            width: 120,
            height: 160,
            elevation: 4,
            borderRadius: AppSpacing.radiusMedium,
            showAvailabilityBadge: widget.content.availability == AvailabilityType.premium,
          ),
          const SizedBox(width: AppSpacing.large),
          // Content details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Content type indicator with unique colors
                Row(
                  children: [
                    Icon(
                      _getContentTypeIcon(widget.content.type),
                      color: _getContentTypeColor(widget.content.type),
                      size: AppSpacing.iconSmall,
                    ),
                    const SizedBox(width: AppSpacing.extraSmall),
                    Text(
                      widget.content.type == ContentType.book ? 'Book' : 'Podcast',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: _getContentTypeColor(widget.content.type),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.extraSmall),
                // Title
                AppTitleText(
                  widget.content.title,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  color: colorScheme.onSurface,
                ),
                const SizedBox(height: AppSpacing.extraSmall),
                // Author
                AppSubtitleText(
                  'by ${widget.content.author}',
                  color: colorScheme.onSurfaceVariant,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.medium),
                // Rating, duration, chapters
                Row(
                  children: [
                    _buildInfoChip(
                      context,
                      Icons.star_rounded,
                      widget.content.rating.toString(),
                      colorScheme.primary,
                    ),
                    const SizedBox(width: AppSpacing.small),
                    _buildInfoChip(
                      context,
                      Icons.access_time_rounded,
                      widget.content.duration,
                      colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: AppSpacing.small),
                    _buildInfoChip(
                      context,
                      Icons.list_rounded,
                      '${widget.content.chapterCount} chapters',
                      colorScheme.onSurfaceVariant,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.small),
                // Social stats
                SocialListeningStats(
                  contentId: widget.content.id,
                  isCompact: true,
                  showBookmarks: true,
                  showMonthlyStats: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(BuildContext context, IconData icon, String text, Color color) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.small,
        vertical: AppSpacing.extraSmall,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: color,
            size: AppSpacing.iconExtraSmall,
          ),
          const SizedBox(width: AppSpacing.extraSmall),
          Text(
            text,
            style: theme.textTheme.labelSmall?.copyWith(
              color: color,
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildTrialStatsSection(BuildContext context) {
    final isFreeTrial = ref.watch(isFreeTrialProvider);
    
    // Only show for trial users on premium content
    if (!isFreeTrial || widget.content.availability != AvailabilityType.premium) {
      return const SizedBox.shrink();
    }

    return const GlimpseIntoPremiumStats();
  }

  Widget _buildReviewsSection(BuildContext context) {
    final reviewSummary = MockData.getReviewSummary(widget.content.id);
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.medium),
      child: AddReviewCard(
        contentId: widget.content.id,
        contentType: 'playlist',
        contentTitle: widget.content.title,
        reviewSummary: reviewSummary,
        onReviewTap: () {
          context.push('/home/reviews/content/${widget.content.id}');
        },
      ),
    );
  }

  Widget _buildActionsSection(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isFreeTrial = ref.watch(isFreeTrialProvider);
    final isPremium = ref.watch(isPremiumProvider);
    final canAccessPremiumContent = ref.watch(canAccessPremiumContentProvider);
    
    // Determine if we should show action buttons
    final showActionButtons = !isFreeTrial || 
                             widget.content.availability != AvailabilityType.premium ||
                             isPremium;

    return Container(
      margin: const EdgeInsets.all(AppSpacing.medium),
      child: AppCard(
        elevation: 0,
        backgroundColor: colorScheme.surfaceContainerLow,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.medium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppSubtitleText('Description'),
              const SizedBox(height: AppSpacing.small),
              AppBodyText(
                widget.content.description,
                color: colorScheme.onSurfaceVariant,
              ),
              if (showActionButtons) ...[
                const SizedBox(height: AppSpacing.large),
                // Play button
                SizedBox(
                  width: double.infinity,
                  child: AppPrimaryButton(
                    onPressed: () {
                      debugPrint('Play tapped for: ${widget.content.title}');
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.play_arrow_rounded,
                          size: AppSpacing.iconSmall,
                        ),
                        const SizedBox(width: AppSpacing.small),
                        const Text('Play'),
                      ],
                    ),
                  ),
                ),
              ] else if (isFreeTrial && widget.content.availability == AvailabilityType.premium && !canAccessPremiumContent) ...[
                const SizedBox(height: AppSpacing.large),
                // Message for trial users who have exceeded their limit
                Container(
                  padding: const EdgeInsets.all(AppSpacing.medium),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
                    border: Border.all(
                      color: colorScheme.outline.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.lock_rounded,
                        color: colorScheme.onSurfaceVariant,
                        size: AppSpacing.iconMedium,
                      ),
                      const SizedBox(width: AppSpacing.medium),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppBodyText(
                              'Premium Content',
                              color: colorScheme.onSurface,
                            ),
                            const SizedBox(height: AppSpacing.extraSmall),
                            AppCaptionText(
                              'You\'ve used all your trial minutes this month. Upgrade to continue listening.',
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNarratorSection(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (widget.content.narrators.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.medium),
      child: AppCard(
        elevation: 0,
        gradient: AppGradients.subtleSurfaceGradient(colorScheme),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.medium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  AppCard(
                    padding: const EdgeInsets.all(AppSpacing.extraSmall),
                    margin: EdgeInsets.zero,
                    gradient: AppGradients.tertiaryGradient(colorScheme),
                    child: Icon(
                      Icons.mic_rounded,
                      color: Colors.white,
                      size: AppSpacing.iconSmall,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.medium),
                  AppSubtitleText(
                    widget.content.type == ContentType.book ? 'Narrator' : 'Speakers',
                  ),
                  const Spacer(),
                  // Show count only when there are multiple narrators
                  if (widget.content.narrators.length > 1)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.small,
                        vertical: AppSpacing.extraSmall,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.tertiaryContainer.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
                        border: Border.all(
                          color: colorScheme.tertiary.withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        '${widget.content.narrators.length}',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: colorScheme.tertiary,
                          fontWeight: FontWeight.w600,
                          height: 1.0,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.medium),
              // Narrator selection
              if (widget.content.narrators.length == 1)
                _buildSingleNarrator(context)
              else
                _buildMultipleNarrators(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSingleNarrator(BuildContext context) {
    final narrator = widget.content.narrators.first;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AppCard(
      elevation: 0,
      borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
      padding: const EdgeInsets.all(AppSpacing.medium),
      margin: const EdgeInsets.all(AppSpacing.elevationNone),
      child: Row(
        children: [
          SizedBox(
            width: 56,
            height: 56,
            child: AppCard(
              padding: EdgeInsets.zero,
              margin: EdgeInsets.zero,
              gradient: AppGradients.tertiaryGradient(colorScheme),
              child: Icon(
                Icons.person_rounded,
                color: Colors.white,
                size: AppSpacing.iconMedium,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.large),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        narrator.name,
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        context.push('/home/narrator/${narrator.id}');
                      },
                      child: AppCard(
                        padding: const EdgeInsets.all(AppSpacing.extraSmall),
                        margin: EdgeInsets.zero,
                        backgroundColor: colorScheme.tertiaryContainer.withValues(alpha: 0.5),
                        child: Icon(
                          Icons.info_outline_rounded,
                          color: colorScheme.tertiary,
                          size: AppSpacing.iconSmall,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.extraSmall),
                AppCaptionText(
                  narrator.bio,
                  color: colorScheme.onSurfaceVariant,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMultipleNarrators(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (widget.content.type == ContentType.podcast) {
      // For podcasts, show all speakers with consistent design
      return Column(
        children: widget.content.narrators.map((narrator) {
          return AppCard(
            elevation: 0,
            borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
            padding: const EdgeInsets.all(AppSpacing.medium),
            margin: const EdgeInsets.only(bottom: AppSpacing.small),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFF00838F), // Teal
                        const Color(0xFF00695C), // Dark teal
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF00838F).withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.person_rounded,
                    color: Colors.white,
                    size: AppSpacing.iconMedium,
                  ),
                ),
                const SizedBox(width: AppSpacing.large),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              narrator.name,
                              style: theme.textTheme.titleSmall?.copyWith(
                                color: colorScheme.onSurface,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              context.push('/home/narrator/${narrator.id}');
                            },
                            child: Container(
                              padding: const EdgeInsets.all(AppSpacing.extraSmall),
                              decoration: BoxDecoration(
                                color: const Color(0xFF00838F).withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.info_outline_rounded,
                                color: const Color(0xFF00838F),
                                size: AppSpacing.iconSmall,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.extraSmall),
                      AppCaptionText(
                        narrator.bio,
                        color: colorScheme.onSurfaceVariant,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      );
    } else {
      // For books, show tappable narrator list
      return Column(
        children: widget.content.narrators.map((narrator) {
          final isSelected = narrator.id == _selectedNarratorId;
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedNarratorId = narrator.id;
              });
            },
            child: AppCard(
              margin: const EdgeInsets.only(bottom: AppSpacing.medium),
              padding: const EdgeInsets.all(AppSpacing.medium),
              borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
              elevation: isSelected ? AppSpacing.elevationMax : AppSpacing.elevationNone,
              backgroundColor: isSelected ? colorScheme.surfaceContainerLowest : colorScheme.surfaceContainerLow,
              // borderColor: isSelected ? colorScheme.outline : colorScheme.outline.withValues(alpha: 0.1),
              // borderWidth: 1,
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      gradient: isSelected 
                          ? LinearGradient(
                              colors: [
                                const Color(0xFF00838F), // Teal
                                const Color(0xFF00695C), // Dark teal
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            )
                          : LinearGradient(
                              colors: [
                                colorScheme.surfaceContainerHighest,
                                colorScheme.surfaceContainerHigh,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                      shape: BoxShape.circle,
                      border: isSelected 
                          ? null 
                          : Border.all(
                              color: colorScheme.outline.withValues(alpha: 0.2),
                              width: 1,
                            ),
                      boxShadow: isSelected 
                          ? [
                              BoxShadow(
                                color: const Color(0xFF00838F).withValues(alpha: 0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ] 
                          : null,
                    ),
                    child: Icon(
                      Icons.person_rounded,
                      color: isSelected ? Colors.white : colorScheme.onSurfaceVariant,
                      size: AppSpacing.iconMedium,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.medium),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                narrator.name,
                                style: theme.textTheme.titleSmall?.copyWith(
                                  color: colorScheme.onSurface,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            if (isSelected)
                              Container(
                                margin: const EdgeInsets.only(right: AppSpacing.small),
                                padding: const EdgeInsets.all(AppSpacing.extraSmall),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF4CAF50).withValues(alpha: 0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.check_rounded,
                                  color: const Color(0xFF4CAF50),
                                  size: AppSpacing.iconExtraSmall,
                                ),
                              ),
                            GestureDetector(
                              onTap: () {
                                context.push('/home/narrator/${narrator.id}');
                              },
                              child: Container(
                                padding: const EdgeInsets.all(AppSpacing.extraSmall),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF00838F).withValues(alpha: 0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.info_outline_rounded,
                                  color: const Color(0xFF00838F),
                                  size: AppSpacing.iconExtraSmall,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.extraSmall),
                        AppCaptionText(
                          narrator.bio,
                          color: colorScheme.onSurfaceVariant,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      );
    }
  }

  Widget _buildChaptersSection(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    // Filter chapters by selected narrator
    final filteredChapters = widget.content.chapters
        .where((chapter) => chapter.narratorId == _selectedNarratorId)
        .toList();

    return Container(
      margin: const EdgeInsets.fromLTRB(AppSpacing.medium, 0, AppSpacing.medium, AppSpacing.large),
      child: AppCard(
        // elevation: 0,
        // gradient: AppGradients.planGradient(colorScheme, 'Glimpse'),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.medium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.list_rounded,
                    color: colorScheme.primary,
                    size: AppSpacing.iconSmall,
                  ),
                  const SizedBox(width: AppSpacing.small),
                  AppSubtitleText('Chapters'),
                  const Spacer(),
                  AppCaptionText(
                    '${filteredChapters.length} chapters',
                    color: colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.medium),
              // Chapters list
              ...filteredChapters.asMap().entries.map((entry) {
                final index = entry.key;
                final chapter = entry.value;
                return Column(
                  children: [
                    _ChapterTile(
                      chapter: chapter,
                      onTap: () {
                        context.push('/home/chapter/${chapter.id}/${widget.content.id}');
                      },
                    ),
                    // Add divider between chapters (except after the last one)
                    if (index < filteredChapters.length - 1)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: AppSpacing.small),
                        child: Divider(
                          color: colorScheme.outline.withValues(alpha: 0.1),
                          thickness: 1,
                          height: 1,
                        ),
                      ),
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }


  IconData _getContentTypeIcon(ContentType type) {
    switch (type) {
      case ContentType.book:
        return Icons.menu_book_rounded;
      case ContentType.podcast:
        return Icons.podcasts_rounded;
    }
  }

  Color _getContentTypeColor(ContentType type) {
    switch (type) {
      case ContentType.book:
        return const Color(0xFF1976D2); // Blue
      case ContentType.podcast:
        return const Color(0xFFFF6F00); // Orange
    }
  }

  Widget _buildDownloadSection(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isFreeTrial = ref.watch(isFreeTrialProvider);
    final isPremium = ref.watch(isPremiumProvider);
    
    // Only show download section if user can access the content
    final showDownload = !isFreeTrial || 
                        widget.content.availability != AvailabilityType.premium ||
                        isPremium;
    
    if (!showDownload) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.fromLTRB(AppSpacing.medium, 0, AppSpacing.medium, AppSpacing.large),
      child: AppCard(
        gradient: AppGradients.subtleSurfaceGradient(colorScheme),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.medium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  AppCard(
                    padding: const EdgeInsets.all(AppSpacing.small),
                    margin: EdgeInsets.zero,
                    gradient: AppGradients.successGradient(colorScheme),
                    child: Icon(
                      Icons.download_rounded,
                      color: Colors.white,
                      size: AppSpacing.iconMedium,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.medium),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppSubtitleText('Download for Offline Listening'),
                        const SizedBox(height: AppSpacing.extraSmall),
                        AppCaptionText(
                          'Listen anytime without internet connection',
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.large),
              
              // App Store style storage information
              _buildAppStoreStyleStorage(context),
              const SizedBox(height: AppSpacing.large),
              
              // Download button
              SizedBox(
                width: double.infinity,
                child: AppPrimaryButton(
                  onPressed: () {
                    debugPrint('Download tapped for: ${widget.content.title}');
                    _showDownloadBottomSheet(context);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.download_rounded,
                        size: AppSpacing.iconSmall,
                      ),
                      const SizedBox(width: AppSpacing.small),
                      const Text('Download'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildAppStoreStyleStorage(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Row(
      children: [
        // Size info
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppCaptionText(
                'Size',
                color: colorScheme.onSurfaceVariant,
              ),
              const SizedBox(height: 2),
              AppSubtitleText(
                _getEstimatedStorageSize(),
                color: colorScheme.onSurface,
              ),
            ],
          ),
        ),
        // Listening Time info
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              AppCaptionText(
                'Listening Time',
                color: colorScheme.onSurfaceVariant,
              ),
              const SizedBox(height: 2),
              AppSubtitleText(
                widget.content.duration,
                color: colorScheme.onSurface,
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  
  String _getEstimatedStorageSize() {
    // Mock calculation based on duration
    final duration = widget.content.duration;
    if (duration.contains('hour')) {
      final hours = double.tryParse(duration.split(' ')[0]) ?? 1;
      final mbSize = (hours * 45).round(); // ~45MB per hour
      if (mbSize >= 1024) {
        return '${(mbSize / 1024).toStringAsFixed(1)} GB';
      }
      return '$mbSize MB';
    }
    return '120 MB'; // Default estimate
  }
  
  void _showDownloadBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _DownloadBottomSheet(
        content: widget.content,
        selectedNarratorId: _selectedNarratorId,
      ),
    );
  }

}

/// Custom clipper for ribbon effect

/// Individual chapter tile widget with play status indicators
class _ChapterTile extends StatelessWidget {
  final ChapterData chapter;
  final VoidCallback? onTap;

  const _ChapterTile({
    required this.chapter,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.small),
        child: Row(
          children: [
            // Chapter number with status indicator
            _buildChapterIndicator(context),
            const SizedBox(width: AppSpacing.medium),
            // Chapter info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppSubtitleText(
                    chapter.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSpacing.extraSmall),
                  AppCaptionText(
                    chapter.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(height: AppSpacing.small),
                  // Enhanced progress bar with gradient
                  if (chapter.progress > 0)
                    Column(
                      children: [
                        Container(
                          height: 6, // Thicker progress bar
                          decoration: BoxDecoration(
                            color: colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(3),
                          ),
                          child: Stack(
                            children: [
                              Container(
                                width: double.infinity,
                                height: 6,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ),
                              FractionallySizedBox(
                                alignment: Alignment.centerLeft,
                                widthFactor: chapter.progress,
                                child: Container(
                                  height: 6,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: chapter.status == ChapterStatus.completed
                                          ? [
                                              const Color(0xFF4CAF50), // Green
                                              const Color(0xFF66BB6A), // Light green
                                            ]
                                          : [
                                              const Color(0xFFFFD700), // Gold
                                              const Color(0xFFFFA000), // Amber
                                            ],
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                    ),
                                    borderRadius: BorderRadius.circular(3),
                                    boxShadow: [
                                      BoxShadow(
                                        color: (chapter.status == ChapterStatus.completed
                                                ? const Color(0xFF4CAF50)
                                                : const Color(0xFFFFD700))
                                            .withValues(alpha: 0.3),
                                        blurRadius: 2,
                                        offset: const Offset(0, 1),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppSpacing.extraSmall),
                      ],
                    ),
                  Row(
                    children: [
                      Text(
                        'Chapter ${chapter.chapterNumber}',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w500,
                          height: 1.0,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.medium),
                      Icon(
                        Icons.schedule_rounded,
                        size: AppSpacing.iconExtraSmall,
                        color: const Color(0xFF607D8B),
                      ),
                      const SizedBox(width: AppSpacing.extraSmall),
                      Text(
                        chapter.duration,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: const Color(0xFF607D8B),
                          fontWeight: FontWeight.w500,
                          height: 1.0,
                        ),
                      ),
                      if (chapter.status == ChapterStatus.paused && chapter.pausedAt != null) ...[
                        const SizedBox(width: AppSpacing.medium),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.extraSmall,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFD700).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(AppSpacing.radiusExtraSmall),
                          ),
                          child: Text(
                            'Paused at ${chapter.pausedAt}',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: const Color(0xFFFFD700),
                              fontWeight: FontWeight.w600,
                              height: 1.0,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            // Play/Status icon
            _buildStatusIcon(context),
          ],
        ),
      ),
    );
  }

  Widget _buildChapterIndicator(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    Color backgroundColor;
    Color iconColor;
    IconData icon;

    switch (chapter.status) {
      case ChapterStatus.notPlayed:
        backgroundColor = colorScheme.surfaceContainerHighest;
        iconColor = colorScheme.onSurfaceVariant;
        icon = Icons.play_arrow_rounded;
        break;
      case ChapterStatus.playing:
        backgroundColor = colorScheme.primary;
        iconColor = colorScheme.onPrimary;
        icon = Icons.pause_rounded;
        break;
      case ChapterStatus.paused:
        backgroundColor = colorScheme.secondary;
        iconColor = colorScheme.onSecondary;
        icon = Icons.play_arrow_rounded;
        break;
      case ChapterStatus.completed:
        backgroundColor = colorScheme.tertiary;
        iconColor = colorScheme.onTertiary;
        icon = Icons.check_rounded;
        break;
    }

    return Container(
      width: AppSpacing.iconLarge,
      height: AppSpacing.iconLarge,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        color: iconColor,
        size: AppSpacing.iconSmall,
      ),
    );
  }

  Widget _buildStatusIcon(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    switch (chapter.status) {
      case ChapterStatus.playing:
        return Icon(
          Icons.volume_up_rounded,
          color: colorScheme.primary,
          size: AppSpacing.iconSmall,
        );
      case ChapterStatus.paused:
        return Icon(
          Icons.pause_circle_rounded,
          color: colorScheme.secondary,
          size: AppSpacing.iconSmall,
        );
      case ChapterStatus.completed:
        return Icon(
          Icons.check_circle_rounded,
          color: colorScheme.tertiary,
          size: AppSpacing.iconSmall,
        );
      default:
        return Icon(
          Icons.chevron_right_rounded,
          color: colorScheme.onSurfaceVariant,
          size: AppSpacing.iconSmall,
        );
    }
  }
}

/// Download bottom sheet with chapter selection
class _DownloadBottomSheet extends StatefulWidget {
  final ContentItemData content;
  final String selectedNarratorId;

  const _DownloadBottomSheet({
    required this.content,
    required this.selectedNarratorId,
  });

  @override
  State<_DownloadBottomSheet> createState() => _DownloadBottomSheetState();
}

class _DownloadBottomSheetState extends State<_DownloadBottomSheet> {
  bool _isCustomSelection = false;
  List<String> _selectedChapterIds = [];
  late List<ChapterData> _availableChapters;

  @override
  void initState() {
    super.initState();
    _availableChapters = widget.content.chapters
        .where((chapter) => chapter.narratorId == widget.selectedNarratorId)
        .toList();
    
    // Initially select all chapters
    _selectedChapterIds = _availableChapters.map((chapter) => chapter.id).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusLarge),
        ),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.symmetric(vertical: AppSpacing.medium),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.large),
            child: Row(
              children: [
                Icon(
                  Icons.download_rounded,
                  color: colorScheme.primary,
                  size: AppSpacing.iconExtraSmall,
                ),
                const SizedBox(width: AppSpacing.small),
                AppBodyText('Download Content'),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(
                    Icons.close_rounded,
                    color: colorScheme.onSurfaceVariant,
                    size: AppSpacing.iconExtraSmall,
                  ),
                ),
              ],
            ),
          ),
          
          // Scrollable content area
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.large),
              child: Column(
                children: [
                  const SizedBox(height: AppSpacing.medium),
                  
                  // Compact content info with narrator
                  AppCard(
                    margin: const EdgeInsets.all(AppSpacing.elevationNone),
                    elevation: 0,
                    backgroundColor: colorScheme.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 40,
                          height: 40,
                          child: AppCard(
                            padding: EdgeInsets.zero,
                            margin: EdgeInsets.zero,
                            gradient: widget.content.type == ContentType.book 
                                ? AppGradients.primaryGradient(colorScheme)
                                : AppGradients.warningGradient(colorScheme),
                            child: Icon(
                              widget.content.type == ContentType.book 
                                  ? Icons.menu_book_rounded 
                                  : Icons.podcasts_rounded,
                              color: Colors.white,
                              size: AppSpacing.iconExtraSmall,
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.small),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppBodyText(
                                '${widget.content.title} by ${widget.content.author}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              AppLabelText(
                                _getSelectedNarratorName(),
                                color: colorScheme.onSurfaceVariant,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: AppSpacing.large),
                  
                  // Selection options
                  Column(
                    children: [
                      // All chapters option
                      Container(
                        decoration: BoxDecoration(
                          color: colorScheme.surface,
                          border: Border.all(
                            color: !_isCustomSelection ? colorScheme.primary : colorScheme.outline.withValues(alpha: 0.2),
                            width: !_isCustomSelection ? 2 : 1,
                          ),
                          borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
                        ),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _isCustomSelection = false;
                              _selectedChapterIds = _availableChapters.map((c) => c.id).toList();
                            });
                          },
                          borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
                          child: Padding(
                            padding: const EdgeInsets.all(AppSpacing.medium),
                            child: Row(
                              children: [
                                Radio<bool>(
                                  value: false,
                                  groupValue: _isCustomSelection,
                                  onChanged: (value) {
                                    setState(() {
                                      _isCustomSelection = false;
                                      _selectedChapterIds = _availableChapters.map((c) => c.id).toList();
                                    });
                                  },
                                ),
                                const SizedBox(width: AppSpacing.small),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      AppBodyText('All (${_availableChapters.length}) chapters'),
                                      AppLabelText(
                                        _getEstimatedStorageSize(_availableChapters.length),
                                        color: colorScheme.onSurfaceVariant,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: AppSpacing.small),
                      
                      // Custom selection option
                      Container(
                        decoration: BoxDecoration(
                          color: colorScheme.surface,
                          border: Border.all(
                            color: _isCustomSelection ? colorScheme.primary : colorScheme.outline.withValues(alpha: 0.2),
                            width: _isCustomSelection ? 2 : 1,
                          ),
                          borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
                        ),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _isCustomSelection = true;
                            });
                          },
                          borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
                          child: Padding(
                            padding: const EdgeInsets.all(AppSpacing.medium),
                            child: Row(
                              children: [
                                Radio<bool>(
                                  value: true,
                                  groupValue: _isCustomSelection,
                                  onChanged: (value) {
                                    setState(() {
                                      _isCustomSelection = true;
                                    });
                                  },
                                ),
                                const SizedBox(width: AppSpacing.small),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      AppBodyText('Select chapters'),
                                      AppLabelText(
                                        _isCustomSelection 
                                            ? '${_selectedChapterIds.length} selected • ${_getEstimatedStorageSize(_selectedChapterIds.length)}'
                                            : 'Choose specific chapters to download',
                                        color: colorScheme.onSurfaceVariant,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: AppSpacing.large),
                  
                  // Chapter list (when custom selection is enabled)
                  if (_isCustomSelection) ...[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppBodyText('Select Chapters'),
                        const SizedBox(height: AppSpacing.small),
                        ...List.generate(_availableChapters.length, (index) {
                          final chapter = _availableChapters[index];
                          final isSelected = _selectedChapterIds.contains(chapter.id);
                          
                          return Column(
                            children: [
                              CheckboxListTile(
                                value: isSelected,
                                onChanged: (value) {
                                  setState(() {
                                    if (value == true) {
                                      _selectedChapterIds.add(chapter.id);
                                    } else {
                                      _selectedChapterIds.remove(chapter.id);
                                    }
                                  });
                                },
                                title: AppBodyText(
                                  chapter.title,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                subtitle: AppLabelText(
                                  'Chapter ${chapter.chapterNumber} • ${chapter.duration} • ${_getChapterSize()}',
                                  color: colorScheme.onSurfaceVariant,
                                ),
                                controlAffinity: ListTileControlAffinity.leading,
                                contentPadding: EdgeInsets.zero,
                              ),
                              if (index < _availableChapters.length - 1)
                                Divider(
                                  color: colorScheme.outline.withValues(alpha: 0.1),
                                  thickness: 1,
                                  height: 1,
                                ),
                            ],
                          );
                        }),
                      ],
                    ),
                  ],
                  
                  const SizedBox(height: AppSpacing.large),
                ],
              ),
            ),
          ),
          
          // Fixed Download button at bottom
          Container(
            padding: const EdgeInsets.all(AppSpacing.large),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerLow,
              border: Border(
                top: BorderSide(
                  color: colorScheme.outline.withValues(alpha: 0.1),
                  width: 1,
                ),
              ),
            ),
            child: Column(
              children: [
                if (_selectedChapterIds.isNotEmpty) ...[
                  Padding(
                      padding: const EdgeInsets.all(AppSpacing.extraSmall),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AppBodyText('Total size:'),
                          AppBodyText(
                            _getEstimatedStorageSize(_selectedChapterIds.length),
                            color: colorScheme.primary,
                          ),
                        ],
                      ),
                  ),
                  const SizedBox(height: AppSpacing.small),
                ],
                SizedBox(
                  width: double.infinity,
                  child: AppPrimaryButton(
                    onPressed: _selectedChapterIds.isEmpty ? null : () {
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Download started for ${_selectedChapterIds.length} chapters!'),
                          backgroundColor: colorScheme.primary,
                        ),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.download_rounded,
                          size: AppSpacing.iconExtraSmall,
                        ),
                        const SizedBox(width: AppSpacing.small),
                        Text('Start Download (${_selectedChapterIds.length})'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.medium),
                AppCaptionText('Downloading will continue in the background even if you close this page.', color: colorScheme.onSurfaceVariant,),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  String _getEstimatedStorageSize(int chapterCount) {
    // Mock calculation based on chapters
    final mbSize = (chapterCount * 15).round(); // ~15MB per chapter
    if (mbSize >= 1024) {
      return '${(mbSize / 1024).toStringAsFixed(1)} GB';
    }
    return '$mbSize MB';
  }

  String _getSelectedNarratorName() {
    final narrator = widget.content.narrators
        .where((narrator) => narrator.id == widget.selectedNarratorId)
        .firstOrNull;
    return narrator?.name ?? 'Unknown';
  }

  String _getChapterSize() {
    // Mock calculation for individual chapter size
    return '15 MB'; // ~15MB per chapter
  }
}