import 'dart:async';
import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

/// Audio service that handles audio playback with platform native controls
class AudioPlayerService {
  static AudioPlayerService? _instance;
  static AudioPlayerService get instance {
    _instance ??= AudioPlayerService._internal();
    return _instance!;
  }

  AudioPlayerService._internal();

  AudioPlayer? _player;
  AudioHandler? _audioHandler;
  bool _initialized = false;
  MediaItem? _currentMediaItem;

  // Audio state streams
  Stream<bool> get playingStream => _player?.playingStream ?? Stream.value(false);
  Stream<Duration?> get positionStream => _player?.positionStream ?? Stream.value(Duration.zero);
  Stream<Duration?> get durationStream => _player?.durationStream ?? Stream.value(null);
  Stream<double> get speedStream => _player?.speedStream ?? Stream.value(1.0);
  Stream<ProcessingState> get processingStateStream => _player?.processingStateStream ?? Stream.value(ProcessingState.idle);

  // Current audio info
  MediaItem? get currentMediaItem => _currentMediaItem;
  bool get isPlaying => _player?.playing ?? false;
  Duration get position => _player?.position ?? Duration.zero;
  Duration? get duration => _player?.duration;
  double get speed => _player?.speed ?? 1.0;
  bool get hasAudio => _currentMediaItem != null;

  /// Initialize the audio service
  Future<void> initialize() async {
    if (_initialized) return;

    try {
      _player = AudioPlayer();
      _audioHandler = await AudioService.init(
        builder: () => AudioPlayerHandler(_player!),
        config: const AudioServiceConfig(
          androidNotificationChannelId: 'com.example.siraaj.audio',
          androidNotificationChannelName: 'Siraaj Audio Player',
          androidNotificationOngoing: true,
          androidNotificationClickStartsActivity: true,
        ),
      );

      _initialized = true;
      print('Audio service initialized successfully');
    } catch (e) {
      print('Error initializing audio service: $e');
      rethrow;
    }
  }

  /// Load and play audio from assets
  Future<void> loadAndPlay({
    required String audioPath,
    required String title,
    required String album,
    required String artist,
    String? artUri,
  }) async {
    await initialize();

    try {
      // Create media item
      _currentMediaItem = MediaItem(
        id: audioPath,
        title: title,
        album: album,
        artist: artist,
        artUri: artUri != null ? Uri.parse(artUri) : null,
        playable: true,
      );

      // Load audio
      await _player!.setAsset(audioPath);

      // Wait for duration to be available
      await _player!.load();

      // Auto-play
      await play();
    } catch (e) {
      throw Exception('Failed to load audio: $e');
    }
  }

  /// Play audio
  Future<void> play() async {
    await _player?.play();
  }

  /// Pause audio
  Future<void> pause() async {
    await _player?.pause();
  }

  /// Stop audio and clear media item
  Future<void> stop() async {
    await _player?.stop();
    _currentMediaItem = null;
  }

  /// Seek to position
  Future<void> seek(Duration position) async {
    await _player?.seek(position);
  }

  /// Set playback speed
  Future<void> setSpeed(double speed) async {
    await _player?.setSpeed(speed);
  }

  /// Skip forward by duration
  Future<void> skipForward(Duration duration) async {
    final newPosition = position + duration;
    final maxPosition = this.duration ?? Duration.zero;
    await seek(newPosition > maxPosition ? maxPosition : newPosition);
  }

  /// Skip backward by duration
  Future<void> skipBackward(Duration duration) async {
    final newPosition = position - duration;
    await seek(newPosition < Duration.zero ? Duration.zero : newPosition);
  }

  /// Dispose resources
  void dispose() {
    _player?.dispose();
    _initialized = false;
  }
}

/// Audio handler for platform native controls
class AudioPlayerHandler extends BaseAudioHandler with QueueHandler, SeekHandler {
  final AudioPlayer _player;

  AudioPlayerHandler(this._player) {
    // Initialize with empty playback state
    playbackState.add(PlaybackState(
      controls: [
        MediaControl.skipToPrevious,
        MediaControl.play,
        MediaControl.skipToNext,
      ],
      processingState: AudioProcessingState.idle,
      playing: false,
      updatePosition: Duration.zero,
    ));

    // Listen to player state changes
    _player.playingStream.listen((playing) {
      playbackState.add(playbackState.value.copyWith(
        playing: playing,
        controls: [
          MediaControl.skipToPrevious,
          if (playing) MediaControl.pause else MediaControl.play,
          MediaControl.skipToNext,
        ],
      ));
    });

    _player.positionStream.listen((position) {
      playbackState.add(playbackState.value.copyWith(
        updatePosition: position,
      ));
    });

    _player.processingStateStream.listen((state) {
      AudioProcessingState audioState;
      switch (state) {
        case ProcessingState.loading:
          audioState = AudioProcessingState.loading;
          break;
        case ProcessingState.buffering:
          audioState = AudioProcessingState.buffering;
          break;
        case ProcessingState.ready:
          audioState = AudioProcessingState.ready;
          break;
        case ProcessingState.completed:
          audioState = AudioProcessingState.completed;
          break;
        case ProcessingState.idle:
        default:
          audioState = AudioProcessingState.idle;
          break;
      }

      playbackState.add(playbackState.value.copyWith(
        processingState: audioState,
      ));
    });
  }

  @override
  Future<void> play() => _player.play();

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> stop() async {
    await _player.stop();
    await super.stop();
  }

  @override
  Future<void> seek(Duration position) => _player.seek(position);

  @override
  Future<void> skipToNext() async {
    // Skip forward 10 seconds
    final newPosition = _player.position + const Duration(seconds: 10);
    final maxPosition = _player.duration ?? Duration.zero;
    await _player.seek(newPosition > maxPosition ? maxPosition : newPosition);
  }

  @override
  Future<void> skipToPrevious() async {
    // Skip backward 10 seconds
    final newPosition = _player.position - const Duration(seconds: 10);
    await _player.seek(newPosition < Duration.zero ? Duration.zero : newPosition);
  }
} 