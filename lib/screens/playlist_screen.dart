import 'package:flutter/material.dart';
import 'package:siraaj/widgets/buttons/music_player_fab.dart';
import '../data/mock_data.dart';
import '../theme/app_spacing.dart';
import '../theme/theme_extensions.dart';
import '../widgets/text/app_text.dart';
import '../widgets/app_bar/app_app_bar.dart';
import '../widgets/cards/app_card.dart';
import '../widgets/buttons/app_buttons.dart';
import 'chapter_screen.dart';
import 'narrator_screen.dart';

/// Playlist screen that displays detailed information about a book or podcast
/// Shows description, actions, narrator selection, and chapters list
class PlaylistScreen extends StatefulWidget {
  final ContentItemData content;

  const PlaylistScreen({
    super.key,
    required this.content,
  });

  @override
  State<PlaylistScreen> createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen> {
  String _selectedNarratorId = '';
  bool _isBookmarked = false;

  @override
  void initState() {
    super.initState();
    _selectedNarratorId = widget.content.narrators.isNotEmpty 
        ? widget.content.narrators.first.id 
        : '';
    _isBookmarked = widget.content.isBookmarked;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      floatingActionButton: const MusicPlayerFab(),
      appBar: AppAppBar(
        title: widget.content.title,
        backgroundColor: colorScheme.surface,
        actions: [
          IconButton(
            icon: Icon(
              _isBookmarked ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
              color: _isBookmarked ? colorScheme.primary : colorScheme.onSurfaceVariant,
            ),
            onPressed: () {
              setState(() {
                _isBookmarked = !_isBookmarked;
              });
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
            // Actions section
            _buildActionsSection(context),
            // Narrator selection section
            _buildNarratorSection(context),
            // Chapters list section
            _buildChaptersSection(context),
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
          Container(
            width: 120,
            height: 160,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.shadow.withValues(alpha: 0.15),
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
                        widget.content.type == ContentType.book 
                            ? Icons.menu_book_rounded 
                            : Icons.podcasts_rounded,
                        color: colorScheme.onPrimary,
                        size: AppSpacing.iconLarge,
                      ),
                    ),
                  ),
                  // Availability badge
                  Positioned(
                    top: AppSpacing.small,
                    right: AppSpacing.small,
                    child: _buildAvailabilityBadge(context),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.large),
          // Content details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Content type indicator
                Row(
                  children: [
                    Icon(
                      widget.content.type == ContentType.book 
                          ? Icons.book_rounded 
                          : Icons.podcasts_rounded,
                      color: colorScheme.primary,
                      size: AppSpacing.iconSmall,
                    ),
                    const SizedBox(width: AppSpacing.extraSmall),
                    AppCaptionText(
                      widget.content.type == ContentType.book ? 'Book' : 'Podcast',
                      color: colorScheme.primary,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.small),
                // Title
                AppTitleText(
                  widget.content.title,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  color: colorScheme.onSurface,
                ),
                const SizedBox(height: AppSpacing.small),
                // Author
                AppSubtitleText(
                  'by ${widget.content.author}',
                  color: colorScheme.onSurfaceVariant,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.medium),
                // Rating, duration, chapters
                Wrap(
                  children: [
                    _buildInfoChip(
                      context,
                      Icons.star_rounded,
                      widget.content.rating.toString(),
                      colorScheme.primary,
                    ),
                    const SizedBox(width: AppSpacing.medium),
                    _buildInfoChip(
                      context,
                      Icons.access_time_rounded,
                      widget.content.duration,
                      colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: AppSpacing.medium),
                    _buildInfoChip(
                      context,
                      Icons.list_rounded,
                      '${widget.content.chapterCount} chapters',
                      colorScheme.onSurfaceVariant,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
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

  Widget _buildAvailabilityBadge(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    Color badgeColor;
    String badgeText;
    IconData badgeIcon;

    switch (widget.content.availability) {
      case AvailabilityType.free:
        badgeColor = colorScheme.tertiary;
        badgeText = 'FREE';
        badgeIcon = Icons.check_circle;
        break;
      case AvailabilityType.premium:
        badgeColor = colorScheme.secondary;
        badgeText = 'PRO';
        badgeIcon = Icons.star_rounded;
        break;
      case AvailabilityType.trial:
        badgeColor = colorScheme.error;
        badgeText = 'TRIAL';
        badgeIcon = Icons.access_time_rounded;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.small,
        vertical: AppSpacing.extraSmall,
      ),
      decoration: BoxDecoration(
        color: badgeColor,
        borderRadius: BorderRadius.circular(AppSpacing.radiusExtraSmall),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            badgeIcon,
            color: colorScheme.onSecondary,
            size: AppSpacing.iconExtraSmall,
          ),
          const SizedBox(width: AppSpacing.extraSmall),
          Text(
            badgeText,
            style: theme.textTheme.labelSmall?.copyWith(
              color: colorScheme.onSecondary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionsSection(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.all(AppSpacing.medium),
      child: AppCard(
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
              const SizedBox(height: AppSpacing.large),
              // Action buttons
              Row(
                children: [
                  Expanded(
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
                  const SizedBox(width: AppSpacing.medium),
                  Expanded(
                    child: AppSecondaryButton(
                      onPressed: () {
                        debugPrint('Download tapped for: ${widget.content.title}');
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
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.medium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.person_rounded,
                    color: colorScheme.primary,
                    size: AppSpacing.iconSmall,
                  ),
                  const SizedBox(width: AppSpacing.small),
                  AppSubtitleText(
                    widget.content.type == ContentType.book ? 'Narrator' : 'Speakers',
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

    return Row(
      children: [
        CircleAvatar(
          backgroundColor: colorScheme.primaryContainer,
          child: Icon(
            Icons.person_rounded,
            color: colorScheme.onPrimaryContainer,
          ),
        ),
        const SizedBox(width: AppSpacing.medium),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppSubtitleText(narrator.name),
              AppCaptionText(
                narrator.bio,
                color: colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
        IconButton(
          icon: const Icon(Icons.info_outline_rounded),
          color: colorScheme.primary,
          tooltip: 'View Narrator',
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => NarratorScreen(narrator: narrator),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildMultipleNarrators(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (widget.content.type == ContentType.podcast) {
      // For podcasts, show all speakers
      return Column(
        children: widget.content.narrators.map((narrator) {
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.small),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: colorScheme.primaryContainer,
                  child: Icon(
                    Icons.person_rounded,
                    color: colorScheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(width: AppSpacing.medium),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppSubtitleText(narrator.name),
                      AppCaptionText(
                        narrator.bio,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.info_outline_rounded),
                  color: colorScheme.primary,
                  tooltip: 'View Narrator',
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => NarratorScreen(narrator: narrator),
                      ),
                    );
                  },
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
            child: Container(
              margin: const EdgeInsets.only(bottom: AppSpacing.small),
              padding: const EdgeInsets.all(AppSpacing.medium),
              decoration: BoxDecoration(
                color: isSelected 
                    ? colorScheme.surfaceContainerHigh 
                    : colorScheme.surface,
                borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
                border: isSelected 
                    ? Border.all(color: colorScheme.outline, width: 1)
                    : Border.all(color: colorScheme.outline.withValues(alpha: 0.1), width: 1),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: colorScheme.surfaceContainerHighest,
                    child: Icon(
                      Icons.person_rounded,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.medium),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppSubtitleText(
                          narrator.name,
                          color: colorScheme.onSurface,
                        ),
                        AppCaptionText(
                          narrator.bio,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ],
                    ),
                  ),
                  if (isSelected)
                    Icon(
                      Icons.check_circle_rounded,
                      color: colorScheme.onSurfaceVariant,
                      size: AppSpacing.iconSmall,
                    ),
                  IconButton(
                    icon: const Icon(Icons.info_outline_rounded),
                    color: colorScheme.primary,
                    tooltip: 'View Narrator',
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => NarratorScreen(narrator: narrator),
                        ),
                      );
                    },
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
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ChapterScreen(
                              chapter: chapter,
                              content: widget.content,
                            ),
                          ),
                        );
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
}

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
                  // Progress bar
                  if (chapter.progress > 0)
                    Column(
                      children: [
                        LinearProgressIndicator(
                          value: chapter.progress,
                          backgroundColor: colorScheme.surfaceContainerHighest,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            chapter.status == ChapterStatus.completed
                                ? colorScheme.tertiary
                                : colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.extraSmall),
                      ],
                    ),
                  Row(
                    children: [
                      AppCaptionText(
                        'Chapter ${chapter.chapterNumber}',
                        color: colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: AppSpacing.medium),
                      Icon(
                        Icons.access_time_rounded,
                        size: AppSpacing.iconExtraSmall,
                        color: colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: AppSpacing.extraSmall),
                      AppCaptionText(
                        chapter.duration,
                        color: colorScheme.onSurfaceVariant,
                      ),
                      if (chapter.status == ChapterStatus.paused && chapter.pausedAt != null) ...[
                        const SizedBox(width: AppSpacing.medium),
                        AppCaptionText(
                          'Paused at ${chapter.pausedAt}',
                          color: colorScheme.primary,
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