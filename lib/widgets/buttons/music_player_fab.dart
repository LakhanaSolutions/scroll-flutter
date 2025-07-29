import 'package:flutter/material.dart';
import '../../data/mock_data.dart';
import '../../screens/chapter_screen.dart';
import 'app_buttons.dart';

/// Floating action button for quick access to music player
/// Displays a headphones icon and navigates to chapter screen with mock playing content
class MusicPlayerFab extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return AppFloatingActionButton(
      onPressed: () => _openMusicPlayer(context),
      tooltip: 'Open Music Player',
      backgroundColor: theme.colorScheme.primary,
      foregroundColor: theme.colorScheme.onPrimary,
      heroTag: 'music-player-fab',
      child: Icon(
        Icons.headphones,
        size: 28,
      ),
    );
  }
}