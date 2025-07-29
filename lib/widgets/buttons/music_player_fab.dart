import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/mock_data.dart';
import '../../screens/chapter_screen.dart';
import '../../providers/audio_provider.dart';
import 'app_buttons.dart';

/// Floating action button for quick access to music player
/// Only displays when there is audio loaded and navigates to chapter screen
class MusicPlayerFab extends ConsumerWidget {
  const MusicPlayerFab({super.key});

  void _openMusicPlayer(BuildContext context) {
    // Get mock content for demo purposes
    final mockContent = MockData.getCategoryContent('1').first;
    final mockChapter = mockContent.chapters.first;
    
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ChapterScreen(
          chapter: mockChapter,
          content: mockContent,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasAudio = ref.watch(hasAudioProvider);
    final isPlaying = ref.watch(isPlayingProvider);
    
    // Only show FAB if there is audio loaded
    if (!hasAudio) {
      return const SizedBox.shrink();
    }
    
    final theme = Theme.of(context);
    
    return AppFloatingActionButton(
      onPressed: () => _openMusicPlayer(context),
      tooltip: 'Open Music Player',
      backgroundColor: theme.colorScheme.primary,
      foregroundColor: theme.colorScheme.onPrimary,
      heroTag: 'music-player-fab',
      child: Icon(
        isPlaying ? Icons.pause : Icons.play_arrow,
        size: 28,
      ),
    );
  }
}