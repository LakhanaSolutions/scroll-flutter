import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/social_stats_provider.dart';
import '../../theme/app_spacing.dart';
import '../text/app_text.dart';

/// Widget to display social listening statistics
class SocialListeningStats extends ConsumerWidget {
  final String? chapterId;
  final String contentId;
  final bool isCompact;
  final bool showBookmarks;
  final bool showMonthlyStats;

  const SocialListeningStats({
    super.key,
    this.chapterId,
    required this.contentId,
    this.isCompact = false,
    this.showBookmarks = true,
    this.showMonthlyStats = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Get appropriate stats based on whether this is for a chapter or playlist
    final stats = chapterId != null
        ? ref.watch(chapterSocialStatsProvider({
            'chapterId': chapterId!,
            'contentId': contentId,
          }))
        : ref.watch(playlistSocialStatsProvider(contentId));

    if (isCompact) {
      return _buildCompactView(context, stats, colorScheme);
    }

    return _buildFullView(context, stats, colorScheme);
  }

  Widget _buildCompactView(BuildContext context, SocialStats stats, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.medium,
        vertical: AppSpacing.small,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Live indicator
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.red.withValues(alpha: 0.5),
                  blurRadius: 4,
                  spreadRadius: 1,
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.small),
          // Listener count
          AppCaptionText(
            chapterId != null 
                ? '${stats.currentListeners} listening with you'
                : '${stats.monthlyListeners} listened this month',
            color: colorScheme.onSurfaceVariant,
          ),
        ],
      ),
    );
  }

  Widget _buildFullView(BuildContext context, SocialStats stats, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.medium),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(
                Icons.people_rounded,
                color: colorScheme.primary,
                size: AppSpacing.iconSmall,
              ),
              const SizedBox(width: AppSpacing.small),
              const AppSubtitleText('Community Activity'),
            ],
          ),
          const SizedBox(height: AppSpacing.medium),
          
          // Stats grid
          _buildStatsGrid(context, stats, colorScheme),
          
          // Recent listeners avatars
          if (stats.recentListenerAvatars.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.medium),
            _buildRecentListeners(context, stats, colorScheme),
          ],
        ],
      ),
    );
  }

  Widget _buildStatsGrid(BuildContext context, SocialStats stats, ColorScheme colorScheme) {
    final statsItems = <Map<String, dynamic>>[];

    // Current listeners (for chapters)
    if (chapterId != null && stats.currentListeners > 0) {
      statsItems.add({
        'icon': Icons.headphones_rounded,
        'value': stats.currentListeners,
        'label': stats.currentListeners == 1 ? 'person listening' : 'people listening',
        'color': Colors.red,
        'isLive': true,
      });
    }

    // Monthly listeners (for playlists or always show)
    if (chapterId == null || showMonthlyStats) {
      statsItems.add({
        'icon': Icons.trending_up_rounded,
        'value': stats.monthlyListeners,
        'label': 'listened this month',
        'color': colorScheme.primary,
        'isLive': false,
      });
    }

    // Bookmarks
    if (showBookmarks && stats.totalBookmarks > 0) {
      statsItems.add({
        'icon': Icons.bookmark_rounded,
        'value': stats.totalBookmarks,
        'label': stats.totalBookmarks == 1 ? 'bookmark' : 'bookmarks',
        'color': colorScheme.secondary,
        'isLive': false,
      });
    }

    return Wrap(
      spacing: AppSpacing.medium,
      runSpacing: AppSpacing.small,
      children: statsItems.map((item) => _buildStatItem(
        context,
        icon: item['icon'],
        value: item['value'],
        label: item['label'],
        color: item['color'],
        isLive: item['isLive'],
        colorScheme: colorScheme,
      )).toList(),
    );
  }

  Widget _buildStatItem(
    BuildContext context, {
    required IconData icon,
    required int value,
    required String label,
    required Color color,
    required bool isLive,
    required ColorScheme colorScheme,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Icon with live indicator
        Stack(
          children: [
            Icon(
              icon,
              color: color,
              size: AppSpacing.iconSmall,
            ),
            if (isLive)
              Positioned(
                right: -2,
                top: -2,
                child: Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.red.withValues(alpha: 0.5),
                        blurRadius: 2,
                        spreadRadius: 0.5,
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(width: AppSpacing.small),
        // Value and label
        RichText(
          text: TextSpan(
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            children: [
              TextSpan(
                text: _formatNumber(value),
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
              TextSpan(text: ' $label'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRecentListeners(BuildContext context, SocialStats stats, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(
          color: colorScheme.outline.withValues(alpha: 0.1),
          height: 1,
        ),
        const SizedBox(height: AppSpacing.medium),
        Row(
          children: [
            AppCaptionText(
              'Recent listeners',
              color: colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: AppSpacing.small),
            // Avatar stack
            SizedBox(
              height: 24,
              child: Stack(
                children: stats.recentListenerAvatars
                    .take(5)
                    .toList()
                    .asMap()
                    .entries
                    .map((entry) {
                  final index = entry.key;
                  final avatar = entry.value;
                  return Positioned(
                    left: index * 16.0,
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: colorScheme.primaryContainer,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: colorScheme.surface,
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          avatar,
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: colorScheme.onPrimaryContainer,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }
}