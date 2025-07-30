import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../data/mock_data.dart';
import '../theme/app_spacing.dart';
import '../widgets/text/app_text.dart';
import '../widgets/app_bar/app_app_bar.dart';
import '../widgets/buttons/app_buttons.dart';
import '../widgets/waveform/audio_waveform.dart';
import '../providers/audio_provider.dart';
import '../providers/subscription_provider.dart';
import '../widgets/trial/glimpse_into_premium_stats.dart';
import './home/library_tab.dart';

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
  late AnimationController _playPauseController;
  bool _isDragging = false;
  double _dragValue = 0.0;
  
  // Demo toggle for testing waveform vs seekbar
  bool _useWaveform = true;
  
  // Mock waveform data from API sample
  final List<double> _mockWaveformData = [
    0.12, 0.25, 0.19, 0.45, 0.33, 0.28, 0.60, 0.55, 0.42, 0.30,
    0.22, 0.26, 0.21, 0.35, 0.41, 0.38, 0.47, 0.50, 0.43, 0.37,
    0.18, 0.20, 0.16, 0.22, 0.27, 0.25, 0.33, 0.29, 0.24, 0.19,
    0.14, 0.17, 0.13, 0.12, 0.18, 0.22, 0.20, 0.26, 0.24, 0.21,
    0.35, 0.40, 0.32, 0.39, 0.44, 0.46, 0.50, 0.48, 0.45, 0.43,
    0.30, 0.33, 0.29, 0.34, 0.36, 0.38, 0.42, 0.41, 0.40, 0.37,
    0.20, 0.23, 0.19, 0.22, 0.27, 0.24, 0.30, 0.32, 0.29, 0.25,
    0.18, 0.15, 0.16, 0.13, 0.14, 0.17, 0.19, 0.21, 0.18, 0.20,
    0.26, 0.29, 0.25, 0.28, 0.32, 0.34, 0.36, 0.31, 0.28, 0.26,
    0.12, 0.10, 0.11, 0.09, 0.08, 0.07, 0.06, 0.08, 0.09, 0.10
  ];
  
  // Get effective waveform data - returns empty list if waveform should not be used
  List<double> get _effectiveWaveformData {
    if (!_useWaveform) return [];
    
    // In real implementation, you would check if waveform data exists for this audio file
    // For demo, we simulate missing waveform data when toggle is off
    return _mockWaveformData;
  }
  
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return duration.inHours > 0
        ? "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds"
        : "$twoDigitMinutes:$twoDigitSeconds";
  }
  
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


  Future<void> _loadAudio() async {
    if (mounted) {
      try {
        final audioPath = 'assets/audio/sample_audiobook.mp3';
        final currentMediaItem = ref.read(audioPlayerProvider).currentMediaItem;
        
        // Check if the same audio is already loaded
        if (currentMediaItem?.id == audioPath) {
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
          
          // Force a state refresh if needed
          if (audioState.hasAudio && audioState.duration == null) {
            ref.read(audioPlayerProvider.notifier).refreshState();
          }
        }
      } catch (e) {
        debugPrint('Error loading audio: $e');
        // Handle error gracefully
        debugPrint('Audio loading failed, but UI will show loading state until providers update');
      }
    }
  }

  void _togglePlayPause() {
    ref.read(audioPlayerProvider.notifier).togglePlayPause();
  }

  void _rewind() {
    // Check if user can access premium content controls
    final isFreeTrial = ref.read(isFreeTrialProvider);
    final canAccessPremiumContent = ref.read(canAccessPremiumContentProvider);
    
    if (widget.content.availability == AvailabilityType.premium && isFreeTrial && !canAccessPremiumContent) {
      // Show upgrade dialog or message
      return;
    }
    
    ref.read(audioPlayerProvider.notifier).skipBackward();
  }

  void _forward() {
    // Check if user can access premium content controls
    final isFreeTrial = ref.read(isFreeTrialProvider);
    final canAccessPremiumContent = ref.read(canAccessPremiumContentProvider);
    
    if (widget.content.availability == AvailabilityType.premium && isFreeTrial && !canAccessPremiumContent) {
      // Show upgrade dialog or message
      return;
    }
    
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
      floatingActionButton: _buildFloatingActionButton(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: AppAppBar(
        title: widget.chapter.title,
        actions: [
          // Demo toggle button for waveform/seekbar
          IconButton(
            icon: Icon(
              _useWaveform ? Icons.graphic_eq_rounded : Icons.linear_scale_rounded,
              color: colorScheme.primary,
            ),
            onPressed: () {
              setState(() {
                _useWaveform = !_useWaveform;
              });
            },
            tooltip: _useWaveform ? 'Switch to Seekbar' : 'Switch to Waveform',
          ),
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
    return Consumer(
      builder: (context, ref, child) {
        final position = ref.watch(audioPositionProvider);
        final duration = ref.watch(audioDurationProvider);
        final isLoading = ref.watch(isLoadingProvider);
        final waveformData = _effectiveWaveformData;
        final isFreeTrial = ref.watch(isFreeTrialProvider);
        final canAccessPremiumContent = ref.watch(canAccessPremiumContentProvider);
        
        // Determine if seeking should be disabled
        final isSeekDisabled = widget.content.availability == AvailabilityType.premium && isFreeTrial && !canAccessPremiumContent;
        
        // Use waveform if data is available, otherwise fallback to traditional seekbar
        if (waveformData.isNotEmpty) {
          return AudioWaveform(
            waveformData: waveformData,
            duration: duration,
            currentPosition: position,
            isLoading: isLoading,
            onSeek: isSeekDisabled ? null : (seekPosition) {
              ref.read(audioPlayerProvider.notifier).seek(seekPosition);
            },
          );
        } else {
          return _buildTraditionalSeekbar(context, ref, position, duration, isLoading, isSeekDisabled);
        }
      },
    );
  }

  Widget _buildTraditionalSeekbar(BuildContext context, WidgetRef ref, Duration position, Duration? duration, bool isLoading, bool isSeekDisabled) {
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
          child: Builder(
            builder: (context) {
              final maxValue = duration?.inSeconds.toDouble() ?? 1.0;
              final currentValue = _isDragging 
                  ? _dragValue 
                  : (duration != null 
                      ? position.inSeconds.toDouble().clamp(0.0, maxValue)
                      : 0.0);
              
              return Slider(
                value: currentValue,
                max: maxValue,
                onChanged: duration != null && !isSeekDisabled ? (value) {
                  setState(() {
                    _isDragging = true;
                    _dragValue = value;
                  });
                } : null,
                onChangeEnd: duration != null && !isSeekDisabled ? (value) {
                  setState(() {
                    _isDragging = false;
                  });
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
              Text(
                _formatDuration(position),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                duration != null ? _formatDuration(duration) : '--:--',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
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

    return Consumer(
      builder: (context, ref, child) {
        final isFreeTrial = ref.watch(isFreeTrialProvider);
        final canAccessPremiumContent = ref.watch(canAccessPremiumContentProvider);
        final isControlsDisabled = widget.content.availability == AvailabilityType.premium && isFreeTrial && !canAccessPremiumContent;

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Rewind 10s
            IconButton(
              onPressed: isControlsDisabled ? null : _rewind,
              icon: Icon(
                Icons.replay_10_rounded,
                color: isControlsDisabled ? colorScheme.onSurfaceVariant.withValues(alpha: 0.3) : colorScheme.onSurfaceVariant,
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
              onPressed: isControlsDisabled ? null : _forward,
              icon: Icon(
                Icons.forward_10_rounded,
                color: isControlsDisabled ? colorScheme.onSurfaceVariant.withValues(alpha: 0.3) : colorScheme.onSurfaceVariant,
                size: AppSpacing.iconLarge,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildAdditionalControls(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Consumer(
      builder: (context, ref, child) {
        final isFreeTrial = ref.watch(isFreeTrialProvider);
        final canAccessPremiumContent = ref.watch(canAccessPremiumContentProvider);
        final isControlsDisabled = widget.content.availability == AvailabilityType.premium && isFreeTrial && !canAccessPremiumContent;

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
                  onPressed: isControlsDisabled ? null : () async {
                    // Check if audio was playing before pausing
                    final wasPlaying = ref.read(isPlayingProvider);
                    final router = GoRouter.of(context);
                    
                    // Pause audio if playing and remember state
                    await ref.read(audioPlayerProvider.notifier).pauseForNavigation();
                    
                    if (mounted) {
                      router.push('/home/note/${widget.chapter.id}/${widget.content.id}?position=${position.inSeconds.toDouble()}&wasPlaying=$wasPlaying');
                    }
                    
                    // Resume audio if it was playing before navigation
                    await ref.read(audioPlayerProvider.notifier).resumeFromNavigation();
                  },
                  icon: Icon(
                    Icons.note_add_rounded,
                    color: isControlsDisabled ? colorScheme.primary.withValues(alpha: 0.3) : colorScheme.primary,
                    size: AppSpacing.iconSmall,
                  ),
                  label: AppBodyText(
                    'Add Note',
                    color: isControlsDisabled ? colorScheme.primary.withValues(alpha: 0.3) : colorScheme.primary,
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final isFreeTrial = ref.watch(isFreeTrialProvider);
        
        // Only show for trial users on premium content
        if (!isFreeTrial || widget.content.availability != AvailabilityType.premium) {
          return const SizedBox.shrink();
        }

        return GlimpseIntoPremiumStatsFAB(
          onPressed: () {
            _showTrialStatsBottomSheet(context);
          },
        );
      },
    );
  }

  void _showTrialStatsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.6,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
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
                color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Content
            const Flexible(
              child: SingleChildScrollView(
                child: GlimpseIntoPremiumStats(
                  margin: EdgeInsets.all(AppSpacing.large),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Details bottom sheet with timestamps, bookmarks, notes, and narrator info
class _DetailsBottomSheet extends ConsumerStatefulWidget {
  final ChapterData chapter;
  final ContentItemData content;
  final double currentPosition;

  const _DetailsBottomSheet({
    required this.chapter,
    required this.content,
    required this.currentPosition,
  });

  @override
  ConsumerState<_DetailsBottomSheet> createState() => _DetailsBottomSheetState();
}

class _DetailsBottomSheetState extends ConsumerState<_DetailsBottomSheet> {
  final List<Map<String, String>> _timestamps = [
    {'index': '1', 'title': 'Introduction', 'duration': '5:30'},
    {'index': '2', 'title': 'Key Concepts', 'duration': '7:15'},
    {'index': '3', 'title': 'Practical Examples', 'duration': '6:25'},
    {'index': '4', 'title': 'Common Mistakes', 'duration': '5:50'},
    {'index': '5', 'title': 'Summary', 'duration': '4:50'},
  ];





  void _jumpToTimestamp(String timestamp, String title) {
    Navigator.of(context).pop();
    
    // Parse the timestamp string (e.g., "5:30" or "1:23:45") to Duration
    final parts = timestamp.split(':');
    Duration seekPosition;
    
    if (parts.length == 2) {
      // Format: MM:SS
      final minutes = int.tryParse(parts[0]) ?? 0;
      final seconds = int.tryParse(parts[1]) ?? 0;
      seekPosition = Duration(minutes: minutes, seconds: seconds);
    } else if (parts.length == 3) {
      // Format: HH:MM:SS
      final hours = int.tryParse(parts[0]) ?? 0;
      final minutes = int.tryParse(parts[1]) ?? 0;
      final seconds = int.tryParse(parts[2]) ?? 0;
      seekPosition = Duration(hours: hours, minutes: minutes, seconds: seconds);
    } else {
      debugPrint('Invalid timestamp format: $timestamp');
      return;
    }
    
    // Validate timestamp is within audio duration
    final duration = ref.read(audioDurationProvider);
    if (duration != null && seekPosition <= duration) {
      ref.read(audioPlayerProvider.notifier).seek(seekPosition);
      debugPrint('Seeking to timestamp: $timestamp ($seekPosition) - $title');
    } else {
      debugPrint('Timestamp $timestamp exceeds audio duration ${duration?.toString() ?? 'unknown'}');
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
    context.push('/home/narrator/${narrator.id}');
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
    final isFreeTrial = ref.read(isFreeTrialProvider);
    final canAccessPremiumContent = ref.read(canAccessPremiumContentProvider);
    final isControlsDisabled = widget.content.availability == AvailabilityType.premium && isFreeTrial && !canAccessPremiumContent;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.access_time_rounded,
              color: isControlsDisabled ? colorScheme.primary.withValues(alpha: 0.3) : colorScheme.primary,
              size: AppSpacing.iconSmall,
            ),
            const SizedBox(width: AppSpacing.small),
            AppSubtitleText(
              'Timestamps',
              color: isControlsDisabled ? colorScheme.onSurface.withValues(alpha: 0.3) : null,
            ),
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
                  color: colorScheme.surfaceContainerHighest.withValues(alpha: isControlsDisabled ? 0.1 : 0.3),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
                ),
                child: InkWell(
                  onTap: isControlsDisabled ? null : () {
                    _jumpToTimestamp(timestamp['duration']!, timestamp['title']!);
                  },
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
                                color: isControlsDisabled ? colorScheme.onSurface.withValues(alpha: 0.3) : colorScheme.onSurface,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.extraSmall),
                            Text(
                              timestamp['duration']!,
                              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                color: isControlsDisabled ? colorScheme.primary.withValues(alpha: 0.3) : colorScheme.primary,
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
                        color: isControlsDisabled ? colorScheme.primary.withValues(alpha: 0.3) : colorScheme.primary,
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
                      context.push('/home/narrator/${speaker.id}');
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