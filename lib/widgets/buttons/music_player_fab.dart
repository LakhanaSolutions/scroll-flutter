import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../data/mock_data.dart';
import '../../providers/audio_provider.dart';
import '../../providers/subscription_provider.dart';
import '../trial/glimpse_into_premium_stats.dart';
import 'app_buttons.dart';

/// Floating action button for quick access to music player
/// Shows GlimpseIntoPremium widget for trial users on premium content
class MusicPlayerFab extends ConsumerWidget {
  const MusicPlayerFab({super.key});

  void _openMusicPlayer(BuildContext context) {
    // Get mock content for demo purposes
    final mockContent = MockData.getCategoryContent('1').first;
    final mockChapter = mockContent.chapters.first;
    
    context.push('/home/chapter/${mockChapter.id}/${mockContent.id}');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasAudio = ref.watch(hasAudioProvider);
    final isPlaying = ref.watch(isPlayingProvider);
    final isFreeTrial = ref.watch(isFreeTrialProvider);
    final canAccessPremiumContent = ref.watch(canAccessPremiumContentProvider);
    
    // Only show FAB if there is audio loaded
    if (!hasAudio) {
      return const SizedBox.shrink();
    }
    
    // Get current content (using mock data for now)
    final mockContent = MockData.getCategoryContent('1').first;
    final isPremiumContent = mockContent.availability == AvailabilityType.premium;
    final shouldShowTrialWidget = isFreeTrial && isPremiumContent && !canAccessPremiumContent;
    
    if (shouldShowTrialWidget) {
      return GlimpseIntoPremiumStatsFAB(
        onPressed: () => context.push('/home/subscription'),
      );
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