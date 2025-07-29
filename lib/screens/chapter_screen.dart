import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/mock_data.dart';
import '../theme/app_spacing.dart';
import '../widgets/text/app_text.dart';
import '../widgets/app_bar/app_app_bar.dart';
import '../widgets/buttons/app_buttons.dart';
import '../providers/audio_provider.dart';
import './home/library_tab.dart';
import 'narrator_screen.dart';
import 'note_screen.dart';

/// Chapter screen with audio player interface
/// Shows book cover, title, narrator, audio controls, and details functionality
class ChapterScreen extends ConsumerStatefulWidget {
  final ChapterData chapter;
  final ContentItemData content;

  const ChapterScreen({
    super.key,
    required this.chapter,
    required this.content,
  });

  @override
  ConsumerState<ChapterScreen> createState() => _ChapterScreenState();
}

class _ChapterScreenState extends ConsumerState<ChapterScreen>
    with TickerProviderStateMixin {
  bool _audioLoaded = false;
  bool _isDragging = false;
  double _dragValue = 0.0;
  late AnimationController _playPauseController;
  
  @override
  void initState() {
    super.initState();
    _playPauseController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    // Defer audio loading until after the widget tree is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadAudio();
    });
  }

  @override
  void dispose() {
    _playPauseController.dispose();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return duration.inHours > 0
        ? "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds"
        : "$twoDigitMinutes:$twoDigitSeconds";
  }

  Future<void> _loadAudio() async {
    if (mounted) {
      try {
        final audioPath = 'assets/audio/sample_audiobook.mp3';
        final currentMediaItem = ref.read(audioPlayerProvider).currentMediaItem;
        
        // Check if the same audio is already loaded
        if (currentMediaItem?.id == audioPath) {
          setState(() {
            _audioLoaded = true;
          });
          return; // Don't reload the same audio
        }

        debugPrint('Loading audio: $audioPath');
        
        await ref.read(audioPlayerProvider.notifier).loadAndPlay(
          audioPath: audioPath,
          title: widget.chapter.title,
          album: widget.content.title,
          artist: widget.content.type == ContentType.book 
              ? widget.content.narrators.first.name
              : 'Podcast',
        );
        
        // Wait a moment for state to update and verify audio is loaded
        await Future.delayed(const Duration(milliseconds: 500));
        
        if (mounted) {
          final audioState = ref.read(audioPlayerProvider);
          debugPrint('Audio load completed. Has audio: ${audioState.hasAudio}, Duration: ${audioState.duration}');
          
          setState(() {
            _audioLoaded = audioState.hasAudio;
          });
          
          // Force a state refresh if needed
          if (audioState.hasAudio && audioState.duration == null) {
            ref.read(audioPlayerProvider.notifier).refreshState();
          }
        }
      } catch (e) {
        debugPrint('Error loading audio: $e');
        // Handle error gracefully
        if (mounted) {
          setState(() {
            _audioLoaded = false;
          });
        }
      }
    }
  }

  void _togglePlayPause() {
    ref.read(audioPlayerProvider.notifier).togglePlayPause();
  }

  void _rewind() {
    ref.read(audioPlayerProvider.notifier).skipBackward();
  }

  void _forward() {
    ref.read(audioPlayerProvider.notifier).skipForward();
  }

  void _changeSpeed() {
    final currentSpeed = ref.read(audioPlayerProvider).speed;
    double newSpeed;
    if (currentSpeed == 1.0) {
      newSpeed = 1.25;
    } else if (currentSpeed == 1.25) {
      newSpeed = 1.5;
    } else if (currentSpeed == 1.5) {
      newSpeed = 2.0;
    } else {
      newSpeed = 1.0;
    }
    ref.read(audioPlayerProvider.notifier).setSpeed(newSpeed);
  }

  void _showDetailsBottomSheet() {
    final position = ref.read(audioPositionProvider);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _DetailsBottomSheet(
        chapter: widget.chapter,
        content: widget.content,
        currentPosition: position.inSeconds.toDouble(),
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
              Icons.more_vert_rounded,
              color: colorScheme.onSurfaceVariant,
            ),
            onPressed: _showDetailsBottomSheet,
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
          child: Consumer(
            builder: (context, ref, child) {
              final position = ref.watch(audioPositionProvider);
              final duration = ref.watch(audioDurationProvider);
              
              final maxValue = duration?.inSeconds.toDouble() ?? 1.0;
              final currentValue = _isDragging 
                  ? _dragValue 
                  : (duration != null 
                      ? position.inSeconds.toDouble().clamp(0.0, maxValue)
                      : 0.0);
              
              return Slider(
                value: currentValue,
                max: maxValue,
                onChanged: duration != null ? (value) {
                  setState(() {
                    _isDragging = true;
                    _dragValue = value;
                  });
                } : null,
                onChangeEnd: duration != null ? (value) {
                  setState(() {
                    _isDragging = false;
                  });
                  // Final seek when dragging ends
                  ref.read(audioPlayerProvider.notifier).seek(Duration(seconds: value.toInt()));
                } : null,
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.medium),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Consumer(
                builder: (context, ref, child) {
                  final position = ref.watch(audioPositionProvider);
                  return AppCaptionText(
                    _formatDuration(position),
                    color: colorScheme.onSurfaceVariant,
                  );
                },
              ),
              Consumer(
                builder: (context, ref, child) {
                  final duration = ref.watch(audioDurationProvider);
                  return AppCaptionText(
                    duration != null ? _formatDuration(duration) : '--:--',
                    color: colorScheme.onSurfaceVariant,
                  );
                },
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
        Hero(
          tag: 'music-player-fab',
          child: Container(
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
            child: Consumer(
              builder: (context, ref, child) {
                final isLoading = ref.watch(isLoadingProvider);
                final hasAudio = ref.watch(hasAudioProvider);
                final isPlaying = ref.watch(isPlayingProvider);

                // Update animation based on play state
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (isPlaying) {
                    _playPauseController.forward();
                  } else {
                    _playPauseController.reverse();
                  }
                });

                return isLoading
                  ? CircularProgressIndicator(
                      color: colorScheme.onPrimary,
                      strokeWidth: 2,
                    )
                  : IconButton(
                      onPressed: _togglePlayPause,
                      icon: AnimatedIcon(
                        icon: AnimatedIcons.play_pause,
                        progress: _playPauseController,
                        color: colorScheme.onPrimary,
                        size: 40,
                      ),
                    );
              },
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
        Consumer(
          builder: (context, ref, child) {
            final speed = ref.watch(audioSpeedProvider);
            return TextButton.icon(
              onPressed: _changeSpeed,
              icon: Icon(
                Icons.speed_rounded,
                color: colorScheme.onSurfaceVariant,
                size: AppSpacing.iconSmall,
              ),
              label: AppBodyText(
                '${speed}x',
                color: colorScheme.onSurfaceVariant,
              ),
            );
          },
        ),
        // Add Note button
        Consumer(
          builder: (context, ref, child) {
            final position = ref.watch(audioPositionProvider);
            return TextButton.icon(
              onPressed: () async {
                // Check if audio was playing before pausing
                final wasPlaying = ref.read(isPlayingProvider);
                
                // Pause audio if playing and remember state
                await ref.read(audioPlayerProvider.notifier).pauseForNavigation();
                
                final result = await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => NoteScreen(
                      chapter: widget.chapter,
                      content: widget.content,
                      currentPosition: position.inSeconds.toDouble(),
                      wasAudioPlaying: wasPlaying,
                    ),
                  ),
                );
                
                // Resume audio if it was playing before navigation
                await ref.read(audioPlayerProvider.notifier).resumeFromNavigation();
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
            );
          },
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
  final List<Map<String, String>> _timestamps = [
    {'index': '1', 'title': 'Introduction', 'duration': '5:30'},
    {'index': '2', 'title': 'Key Concepts', 'duration': '7:15'},
    {'index': '3', 'title': 'Practical Examples', 'duration': '6:25'},
    {'index': '4', 'title': 'Common Mistakes', 'duration': '5:50'},
    {'index': '5', 'title': 'Summary', 'duration': '4:50'},
  ];





  void _jumpToTimestamp(String timestamp, String title) {
    Navigator.of(context).pop();
    debugPrint('Jump to timestamp: $timestamp - $title');
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
                                    
                  // View Notes section
                  _buildViewNotesSection(context),
                  _buildSectionDivider(context),

                  // Description section
                  _buildDescriptionSection(context),
                  _buildSectionDivider(context),
                  
                  // Narrator section
                  _buildNarratorSection(context),
                  _buildSectionDivider(context),
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

  Widget _buildViewNotesSection(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.notes_rounded,
              color: colorScheme.primary,
              size: AppSpacing.iconSmall,
            ),
            const SizedBox(width: AppSpacing.small),
            const AppSubtitleText('My Notes'),
          ],
        ),
        const SizedBox(height: AppSpacing.medium),
        SizedBox(
          width: double.infinity,
          child: AppSecondaryButton(
            onPressed: () async {
              Navigator.of(context).pop(); // Close the bottom sheet first
              
              // Use ref from the parent widget context
              final parentContext = context;
              Navigator.of(parentContext).push(
                MaterialPageRoute(
                  builder: (context) => Scaffold(
                    appBar: AppBar(
                      title: const Text('My Notes'),
                      backgroundColor: colorScheme.surface,
                      foregroundColor: colorScheme.onSurface,
                    ),
                    body: const LibraryTab(initialTabIndex: 3), // Notes tab is at index 3
                  ),
                ),
              );
            },
            child: const Text('View All Notes'),
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