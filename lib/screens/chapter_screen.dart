import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../theme/app_spacing.dart';
import '../theme/theme_extensions.dart';
import '../widgets/text/app_text.dart';
import '../widgets/app_bar/app_app_bar.dart';
import '../widgets/buttons/app_buttons.dart';
import 'narrator_screen.dart';
import 'note_screen.dart';

/// Chapter screen with audio player interface
/// Shows book cover, title, narrator, audio controls, and details functionality
class ChapterScreen extends StatefulWidget {
  final ChapterData chapter;
  final ContentItemData content;

  const ChapterScreen({
    super.key,
    required this.chapter,
    required this.content,
  });

  @override
  State<ChapterScreen> createState() => _ChapterScreenState();
}

class _ChapterScreenState extends State<ChapterScreen> {
  bool _isPlaying = false;
  double _currentPosition = 0.0; // Current position in seconds
  double _totalDuration = 0.0; // Total duration in seconds
  double _playbackSpeed = 1.0;
  
  @override
  void initState() {
    super.initState();
    _isPlaying = widget.chapter.status == ChapterStatus.playing;
    _totalDuration = _parseDuration(widget.chapter.duration);
    _currentPosition = widget.chapter.progress * _totalDuration;
  }

  double _parseDuration(String duration) {
    // Parse duration like "45m" or "1h 20m" to seconds
    final parts = duration.toLowerCase().replaceAll(' ', '');
    double seconds = 0;
    
    if (parts.contains('h')) {
      final hourPart = parts.split('h')[0];
      seconds += double.tryParse(hourPart)! * 3600;
      if (parts.contains('m')) {
        final minutePart = parts.split('h')[1].replaceAll('m', '');
        if (minutePart.isNotEmpty) {
          seconds += double.tryParse(minutePart)! * 60;
        }
      }
    } else if (parts.contains('m')) {
      final minutePart = parts.replaceAll('m', '');
      seconds += double.tryParse(minutePart)! * 60;
    }
    
    return seconds;
  }

  String _formatTime(double seconds) {
    final hours = (seconds / 3600).floor();
    final minutes = ((seconds % 3600) / 60).floor();
    final secs = (seconds % 60).floor();
    
    if (hours > 0) {
      return '${hours.toString().padLeft(1, '0')}:${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
    } else {
      return '${minutes.toString().padLeft(1, '0')}:${secs.toString().padLeft(2, '0')}';
    }
  }

  void _togglePlayPause() {
    setState(() {
      _isPlaying = !_isPlaying;
    });
    debugPrint('Play/Pause toggled: $_isPlaying');
  }

  void _rewind() {
    setState(() {
      _currentPosition = (_currentPosition - 10).clamp(0, _totalDuration);
    });
    debugPrint('Rewound 10 seconds');
  }

  void _forward() {
    setState(() {
      _currentPosition = (_currentPosition + 10).clamp(0, _totalDuration);
    });
    debugPrint('Forwarded 10 seconds');
  }

  void _changeSpeed() {
    setState(() {
      if (_playbackSpeed == 1.0) {
        _playbackSpeed = 1.25;
      } else if (_playbackSpeed == 1.25) {
        _playbackSpeed = 1.5;
      } else if (_playbackSpeed == 1.5) {
        _playbackSpeed = 2.0;
      } else {
        _playbackSpeed = 1.0;
      }
    });
    debugPrint('Speed changed to: ${_playbackSpeed}x');
  }

  void _showDetailsBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _DetailsBottomSheet(
        chapter: widget.chapter,
        content: widget.content,
        currentPosition: _currentPosition,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppAppBar(
        title: widget.chapter.title,
        actions: [
          IconButton(
            icon: Icon(
              Icons.bookmark_border_rounded,
              color: colorScheme.onSurfaceVariant,
            ),
            onPressed: () {
              debugPrint('Bookmark chapter: ${widget.chapter.title}');
            },
          ),
          IconButton(
            icon: Icon(
              Icons.share_rounded,
              color: colorScheme.onSurfaceVariant,
            ),
            onPressed: () {
              debugPrint('Share chapter: ${widget.chapter.title}');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.large),
        child: Column(
          children: [
            // Book cover
            _buildBookCover(context),
            const SizedBox(height: AppSpacing.large),
            // Chapter info
            _buildChapterInfo(context),
            const SizedBox(height: AppSpacing.large),
            // Progress bar
            _buildProgressBar(context),
            const SizedBox(height: AppSpacing.large),
            // Audio controls
            _buildAudioControls(context),
            const SizedBox(height: AppSpacing.large),
            // Additional controls
            _buildAdditionalControls(context),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  Widget _buildBookCover(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Container(
        width: 250,
        height: 250,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withValues(alpha: 0.2),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
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
                widget.content.type == ContentType.book 
                    ? Icons.menu_book_rounded 
                    : Icons.podcasts_rounded,
                color: colorScheme.onPrimary,
                size: 80,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChapterInfo(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final narrator = widget.content.narrators.firstWhere(
      (n) => n.id == widget.chapter.narratorId,
      orElse: () => widget.content.narrators.first,
    );

    return Column(
      children: [
        AppTitleText(
          widget.chapter.title,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: AppSpacing.small),
        AppSubtitleText(
          widget.content.title,
          textAlign: TextAlign.center,
          color: colorScheme.onSurfaceVariant,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: AppSpacing.small),
        AppBodyText(
          widget.content.type == ContentType.book 
              ? 'Narrated by ${narrator.name}'
              : widget.chapter.description,
          textAlign: TextAlign.center,
          color: colorScheme.onSurfaceVariant,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildProgressBar(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      children: [
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: colorScheme.primary,
            inactiveTrackColor: colorScheme.surfaceContainerHighest,
            thumbColor: colorScheme.primary,
            overlayColor: colorScheme.primary.withValues(alpha: 0.1),
            trackHeight: 4,
          ),
          child: Slider(
            value: _currentPosition,
            max: _totalDuration,
            onChanged: (value) {
              setState(() {
                _currentPosition = value;
              });
            },
            onChangeEnd: (value) {
              debugPrint('Seeked to: ${_formatTime(value)}');
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.medium),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppCaptionText(
                _formatTime(_currentPosition),
                color: colorScheme.onSurfaceVariant,
              ),
              AppCaptionText(
                _formatTime(_totalDuration),
                color: colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAudioControls(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Rewind 10s
        IconButton(
          onPressed: _rewind,
          icon: Icon(
            Icons.replay_10_rounded,
            color: colorScheme.onSurfaceVariant,
            size: AppSpacing.iconLarge,
          ),
        ),
        // Play/Pause
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: colorScheme.primary,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: colorScheme.primary.withValues(alpha: 0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: IconButton(
            onPressed: _togglePlayPause,
            icon: Icon(
              _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
              color: colorScheme.onPrimary,
              size: 40,
            ),
          ),
        ),
        // Forward 10s
        IconButton(
          onPressed: _forward,
          icon: Icon(
            Icons.forward_10_rounded,
            color: colorScheme.onSurfaceVariant,
            size: AppSpacing.iconLarge,
          ),
        ),
      ],
    );
  }

  Widget _buildAdditionalControls(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Speed control
        TextButton.icon(
          onPressed: _changeSpeed,
          icon: Icon(
            Icons.speed_rounded,
            color: colorScheme.onSurfaceVariant,
            size: AppSpacing.iconSmall,
          ),
          label: AppBodyText(
            '${_playbackSpeed}x',
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        // Add Note button
        TextButton.icon(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => NoteScreen(
                  chapter: widget.chapter,
                  content: widget.content,
                  currentPosition: _currentPosition,
                ),
              ),
            );
          },
          icon: Icon(
            Icons.note_add_rounded,
            color: colorScheme.primary,
            size: AppSpacing.iconSmall,
          ),
          label: AppBodyText(
            'Add Note',
            color: colorScheme.primary,
          ),
        ),
        // Details button
        TextButton.icon(
          onPressed: _showDetailsBottomSheet,
          icon: Icon(
            Icons.info_outline_rounded,
            color: colorScheme.onSurfaceVariant,
            size: AppSpacing.iconSmall,
          ),
          label: AppBodyText(
            'Details',
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

/// Details bottom sheet with timestamps, bookmarks, notes, and narrator info
class _DetailsBottomSheet extends StatefulWidget {
  final ChapterData chapter;
  final ContentItemData content;
  final double currentPosition;

  const _DetailsBottomSheet({
    required this.chapter,
    required this.content,
    required this.currentPosition,
  });

  @override
  State<_DetailsBottomSheet> createState() => _DetailsBottomSheetState();
}

class _DetailsBottomSheetState extends State<_DetailsBottomSheet> {
  final TextEditingController _noteController = TextEditingController();
  final List<Map<String, String>> _timestamps = [
    {'index': '1', 'title': 'Introduction', 'duration': '5:30'},
    {'index': '2', 'title': 'Key Concepts', 'duration': '7:15'},
    {'index': '3', 'title': 'Practical Examples', 'duration': '6:25'},
    {'index': '4', 'title': 'Common Mistakes', 'duration': '5:50'},
    {'index': '5', 'title': 'Summary', 'duration': '4:50'},
  ];

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  String _formatCurrentTime(double seconds) {
    final minutes = (seconds / 60).floor();
    final secs = (seconds % 60).floor();
    return '${minutes.toString().padLeft(1, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  void _jumpToTimestamp(String timestamp, String title) {
    Navigator.of(context).pop();
    debugPrint('Jump to timestamp: $timestamp - $title');
  }

  void _bookmarkCurrentPosition() {
    debugPrint('Bookmarked at: ${_formatCurrentTime(widget.currentPosition)}');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Bookmarked at ${_formatCurrentTime(widget.currentPosition)}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _addNote() {
    if (_noteController.text.isNotEmpty) {
      debugPrint('Note added at ${_formatCurrentTime(widget.currentPosition)}: ${_noteController.text}');
      _noteController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Note added successfully'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _showNarratorInfo() {
    final narrator = widget.content.narrators.firstWhere(
      (n) => n.id == widget.chapter.narratorId,
      orElse: () => widget.content.narrators.first,
    );
    
    if (widget.content.type == ContentType.podcast && widget.content.narrators.length > 1) {
      _showSpeakersBottomSheet();
    } else {
      _showSingleNarratorInfo(narrator);
    }
  }

  void _showSpeakersBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _SpeakersBottomSheet(content: widget.content),
    );
  }

  void _showSingleNarratorInfo(NarratorData narrator) {
    Navigator.of(context).pop(); // Close the bottom sheet first
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => NarratorScreen(narrator: narrator),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.8,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusLarge),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: AppSpacing.medium),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Content
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.large),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  AppTitleText('Chapter Details'),
                  const SizedBox(height: AppSpacing.large),
                  
                  // Timestamps section
                  _buildTimestampsSection(context),
                  _buildSectionDivider(context),
                  
                  // Bookmark & Notes section (combined)
                  _buildBookmarkNotesSection(context),
                  _buildSectionDivider(context),
                  
                  // Description section
                  _buildDescriptionSection(context),
                  _buildSectionDivider(context),
                  
                  // Narrator section
                  _buildNarratorSection(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionDivider(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        const SizedBox(height: AppSpacing.large),
        Divider(
          color: colorScheme.outline.withValues(alpha: 0.2),
          thickness: 1,
          height: 1,
        ),
        const SizedBox(height: AppSpacing.large),
      ],
    );
  }

  Widget _buildTimestampsSection(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.access_time_rounded,
              color: colorScheme.primary,
              size: AppSpacing.iconSmall,
            ),
            const SizedBox(width: AppSpacing.small),
            const AppSubtitleText('Timestamps'),
          ],
        ),
        const SizedBox(height: AppSpacing.medium),
        ..._timestamps.asMap().entries.map((entry) {
          final timestamp = entry.value;
          final isLast = entry.key == _timestamps.length - 1;
          return Column(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.medium),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
                ),
                child: InkWell(
                  onTap: () => _jumpToTimestamp(timestamp['duration']!, timestamp['title']!),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
                  child: Row(
                    children: [
                      // Index
                      Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: colorScheme.primaryContainer,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            timestamp['index']!,
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: colorScheme.onPrimaryContainer,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.medium),
                      // Title and duration
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              timestamp['title']!,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurface,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.extraSmall),
                            Text(
                              timestamp['duration']!,
                              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                color: colorScheme.primary,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Play icon
                      Icon(
                        Icons.play_arrow_rounded,
                        color: colorScheme.primary,
                        size: AppSpacing.iconMedium,
                      ),
                    ],
                  ),
                ),
              ),
              if (!isLast)
                const SizedBox(height: AppSpacing.small),
            ],
          );
        }),
      ],
    );
  }

  Widget _buildBookmarkNotesSection(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.bookmark_add_rounded,
              color: colorScheme.primary,
              size: AppSpacing.iconSmall,
            ),
            const SizedBox(width: AppSpacing.small),
            const AppSubtitleText('Bookmark & Notes'),
          ],
        ),
        const SizedBox(height: AppSpacing.medium),
        // Bookmark button
        SizedBox(
          width: double.infinity,
          child: AppSecondaryButton(
            onPressed: _bookmarkCurrentPosition,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.bookmark_rounded,
                  size: AppSpacing.iconSmall,
                ),
                const SizedBox(width: AppSpacing.small),
                Text('Bookmark at ${_formatCurrentTime(widget.currentPosition)}'),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.medium),
        // Notes field
        TextField(
          controller: _noteController,
          decoration: InputDecoration(
            hintText: 'Add a note at ${_formatCurrentTime(widget.currentPosition)}...',
            filled: true,
            fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
              borderSide: BorderSide(
                color: colorScheme.primary.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            suffixIcon: IconButton(
              onPressed: _addNote,
              icon: Icon(
                Icons.send_rounded,
                color: colorScheme.primary,
              ),
            ),
          ),
          maxLines: 3,
        ),
      ],
    );
  }

  Widget _buildDescriptionSection(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.description_rounded,
              color: colorScheme.primary,
              size: AppSpacing.iconSmall,
            ),
            const SizedBox(width: AppSpacing.small),
            AppSubtitleText(
              widget.content.type == ContentType.book ? 'Chapter Description' : 'Episode Description',
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.medium),
        AppBodyText(
          widget.chapter.description,
          color: colorScheme.onSurfaceVariant,
        ),
      ],
    );
  }

  Widget _buildNarratorSection(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
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
              widget.content.type == ContentType.book ? 'About Narrator' : 'About Speakers',
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.medium),
        SizedBox(
          width: double.infinity,
          child: AppSecondaryButton(
            onPressed: _showNarratorInfo,
            child: Text(
              widget.content.type == ContentType.book 
                  ? 'View Narrator Details' 
                  : 'View All Speakers',
            ),
          ),
        ),
      ],
    );
  }
}

/// Speakers bottom sheet for podcasts with multiple speakers
class _SpeakersBottomSheet extends StatelessWidget {
  final ContentItemData content;

  const _SpeakersBottomSheet({
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusLarge),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: AppSpacing.medium),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(AppSpacing.large),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppTitleText('Speakers'),
                const SizedBox(height: AppSpacing.large),
                ...content.narrators.map((speaker) {
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      backgroundColor: colorScheme.primaryContainer,
                      child: Icon(
                        Icons.person_rounded,
                        color: colorScheme.onPrimaryContainer,
                      ),
                    ),
                    title: AppSubtitleText(speaker.name),
                    subtitle: AppCaptionText(
                      speaker.bio,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    trailing: Icon(
                      Icons.chevron_right_rounded,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => NarratorScreen(narrator: speaker),
                        ),
                      );
                    },
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}