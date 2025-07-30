import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:audio_service/audio_service.dart';
import '../services/audio_service.dart';
import '../data/mock_data.dart';

/// Audio player state
class AudioPlayerState {
  final bool isPlaying;
  final Duration position;
  final Duration? duration;
  final double speed;
  final MediaItem? currentMediaItem;
  final bool isLoading;
  final String? error;
  final ContentItemData? currentContent;
  final ChapterData? currentChapter;

  const AudioPlayerState({
    this.isPlaying = false,
    this.position = Duration.zero,
    this.duration,
    this.speed = 1.0,
    this.currentMediaItem,
    this.isLoading = false,
    this.error,
    this.currentContent,
    this.currentChapter,
  });

  AudioPlayerState copyWith({
    bool? isPlaying,
    Duration? position,
    Duration? duration,
    double? speed,
    MediaItem? currentMediaItem,
    bool? isLoading,
    String? error,
    ContentItemData? currentContent,
    ChapterData? currentChapter,
  }) {
    return AudioPlayerState(
      isPlaying: isPlaying ?? this.isPlaying,
      position: position ?? this.position,
      duration: duration ?? this.duration,
      speed: speed ?? this.speed,
      currentMediaItem: currentMediaItem ?? this.currentMediaItem,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      currentContent: currentContent ?? this.currentContent,
      currentChapter: currentChapter ?? this.currentChapter,
    );
  }

  bool get hasAudio => currentMediaItem != null;
  
  double get progress {
    if (duration == null || duration!.inMilliseconds == 0) return 0.0;
    return position.inMilliseconds / duration!.inMilliseconds;
  }

  String get positionText {
    return _formatDuration(position);
  }

  String get durationText {
    return _formatDuration(duration ?? Duration.zero);
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return duration.inHours > 0
        ? "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds"
        : "$twoDigitMinutes:$twoDigitSeconds";
  }
}

/// Audio player notifier
class AudioPlayerNotifier extends StateNotifier<AudioPlayerState> {
  AudioPlayerNotifier() : super(const AudioPlayerState()) {
    // Don't initialize streams immediately - wait for first audio load
  }

  final AudioPlayerService _audioService = AudioPlayerService.instance;
  StreamSubscription<bool>? _playingSubscription;
  StreamSubscription<Duration?>? _positionSubscription;
  StreamSubscription<Duration?>? _durationSubscription;
  StreamSubscription<double>? _speedSubscription;
  Timer? _positionTimer;

  void _initialize() {
    debugPrint('Initializing audio streams...');
    
    // Listen to audio service streams with optimized updates
    _playingSubscription = _audioService.playingStream.listen((isPlaying) {
      debugPrint('Playing state changed: $isPlaying');
      state = state.copyWith(
        isPlaying: isPlaying,
        isLoading: false, // Clear loading when play state changes
        currentMediaItem: _audioService.currentMediaItem,
      );
    });

    _positionSubscription = _audioService.positionStream.listen((position) {
      if (position != null) {
        state = state.copyWith(position: position);
      }
    });

    _durationSubscription = _audioService.durationStream.listen((duration) {
      if (duration != null) {
        debugPrint('Duration available: $duration');
        state = state.copyWith(
          duration: duration,
          isLoading: false, // Clear loading when duration is available
          currentMediaItem: _audioService.currentMediaItem,
        );
      }
    });

    _speedSubscription = _audioService.speedStream.listen((speed) {
      state = state.copyWith(speed: speed);
    });

    // Add position timer as fallback to ensure UI updates
    _positionTimer?.cancel(); // Cancel any existing timer
    _positionTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (_audioService.isPlaying && _audioService.currentMediaItem != null) {
        final currentPosition = _audioService.position;
        if (state.position != currentPosition) {
          state = state.copyWith(position: currentPosition);
        }
      }
    });
  }

  /// Load and play audio
  Future<void> loadAndPlay({
    required String audioPath,
    required String title,
    required String album,
    required String artist,
    String? artUri,
    ContentItemData? content,
    ChapterData? chapter,
  }) async {
    try {
      // Check if same audio is already loaded
      if (state.currentMediaItem?.id == audioPath) {
        return; // Don't reload the same audio
      }

      state = state.copyWith(isLoading: true, error: null);
      
      // Initialize audio service and streams if not done yet
      await _audioService.initialize();
      
      // Initialize streams after audio service is ready
      if (_playingSubscription == null) {
        _initialize();
      }
      
      await _audioService.loadAndPlay(
        audioPath: audioPath,
        title: title,
        album: album,
        artist: artist,
        artUri: artUri,
      );
      
      // Wait for audio to be ready with better retry logic
      int attempts = 0;
      bool audioReady = false;
      
      while (attempts < 20 && !audioReady) {
        await Future.delayed(const Duration(milliseconds: 200));
        
        // Check if audio is properly loaded
        if (_audioService.duration != null && 
            _audioService.currentMediaItem != null) {
          audioReady = true;
          break;
        }
        attempts++;
      }
      
      // Force complete state update
      final newState = AudioPlayerState(
        isLoading: false,
        currentMediaItem: _audioService.currentMediaItem,
        isPlaying: _audioService.isPlaying,
        duration: _audioService.duration,
        position: _audioService.position,
        speed: _audioService.speed,
        error: null,
        currentContent: content,
        currentChapter: chapter,
      );
      
      state = newState;
      
      // Debug info
      debugPrint('Audio loaded: duration=${_audioService.duration}, playing=${_audioService.isPlaying}, ready=$audioReady');
    } catch (e) {
      debugPrint('Error loading audio: $e');
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Play/pause toggle
  Future<void> togglePlayPause() async {
    try {
      // Check if we have audio loaded
      if (state.currentMediaItem == null) {
        debugPrint('No audio loaded for play/pause');
        return;
      }
      
      // Optimistically update UI immediately
      state = state.copyWith(isPlaying: !state.isPlaying);
      
      if (_audioService.isPlaying) {
        await _audioService.pause();
      } else {
        await _audioService.play();
      }
    } catch (e) {
      debugPrint('Error in togglePlayPause: $e');
      // Revert on error
      state = state.copyWith(
        isPlaying: _audioService.isPlaying,
        error: e.toString(),
      );
    }
  }

  /// Play audio
  Future<void> play() async {
    try {
      await _audioService.play();
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  /// Pause audio
  Future<void> pause() async {
    try {
      await _audioService.pause();
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  /// Stop audio
  Future<void> stop() async {
    try {
      await _audioService.stop();
      state = state.copyWith(
        isPlaying: false,
        position: Duration.zero,
        currentMediaItem: null,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Timer? _seekDebouncer;

  /// Seek to position with debouncing for smooth slider dragging
  Future<void> seek(Duration position) async {
    try {
      // Update UI immediately for responsiveness
      state = state.copyWith(position: position);
      
      // Debounce the actual seeking to avoid too many calls
      _seekDebouncer?.cancel();
      _seekDebouncer = Timer(const Duration(milliseconds: 200), () async {
        await _audioService.seek(position);
      });
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  /// Set playback speed
  Future<void> setSpeed(double speed) async {
    try {
      await _audioService.setSpeed(speed);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  /// Skip forward 10 seconds
  Future<void> skipForward() async {
    try {
      await _audioService.skipForward(const Duration(seconds: 10));
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  /// Skip backward 10 seconds
  Future<void> skipBackward() async {
    try {
      await _audioService.skipBackward(const Duration(seconds: 10));
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  /// Clear error
  void clearError() {
    state = state.copyWith(error: null);
  }

  bool _wasPlayingBeforePause = false;

  /// Pause and remember playing state for navigation
  Future<void> pauseForNavigation() async {
    _wasPlayingBeforePause = _audioService.isPlaying;
    if (_wasPlayingBeforePause) {
      await pause();
    }
  }

  /// Resume if was playing before navigation
  Future<void> resumeFromNavigation() async {
    if (_wasPlayingBeforePause) {
      await play();
      _wasPlayingBeforePause = false;
    }
  }

  /// Refresh state from audio service (used sparingly)
  void refreshState() {
    if (_audioService.currentMediaItem != null) {
      state = state.copyWith(
        currentMediaItem: _audioService.currentMediaItem,
        isLoading: false,
        isPlaying: _audioService.isPlaying,
        duration: _audioService.duration,
        position: _audioService.position,
        speed: _audioService.speed,
      );
    }
  }

  @override
  void dispose() {
    _playingSubscription?.cancel();
    _positionSubscription?.cancel();
    _durationSubscription?.cancel();
    _speedSubscription?.cancel();
    _positionTimer?.cancel();
    _seekDebouncer?.cancel();
    super.dispose();
  }
}

/// Audio player provider
final audioPlayerProvider = StateNotifierProvider<AudioPlayerNotifier, AudioPlayerState>((ref) {
  return AudioPlayerNotifier();
});

/// Granular providers for optimized rebuilds
final hasAudioProvider = Provider<bool>((ref) {
  return ref.watch(audioPlayerProvider.select((state) => state.hasAudio));
});

final isPlayingProvider = Provider<bool>((ref) {
  return ref.watch(audioPlayerProvider.select((state) => state.isPlaying));
});

final isLoadingProvider = Provider<bool>((ref) {
  return ref.watch(audioPlayerProvider.select((state) => state.isLoading));
});

final currentMediaItemProvider = Provider<MediaItem?>((ref) {
  return ref.watch(audioPlayerProvider.select((state) => state.currentMediaItem));
});

final audioPositionProvider = Provider<Duration>((ref) {
  return ref.watch(audioPlayerProvider.select((state) => state.position));
});

final audioDurationProvider = Provider<Duration?>((ref) {
  return ref.watch(audioPlayerProvider.select((state) => state.duration));
});

final audioSpeedProvider = Provider<double>((ref) {
  return ref.watch(audioPlayerProvider.select((state) => state.speed));
});

final audioProgressProvider = Provider<double>((ref) {
  return ref.watch(audioPlayerProvider.select((state) => state.progress));
});

final currentContentProvider = Provider<ContentItemData?>((ref) {
  return ref.watch(audioPlayerProvider.select((state) => state.currentContent));
});

final currentChapterProvider = Provider<ChapterData?>((ref) {
  return ref.watch(audioPlayerProvider.select((state) => state.currentChapter));
}); 