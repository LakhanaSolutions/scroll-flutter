import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Social statistics data model
class SocialStats {
  final int currentListeners;
  final int totalBookmarks;
  final int monthlyListeners;
  final int dailyListeners;
  final List<String> recentListenerAvatars;

  const SocialStats({
    required this.currentListeners,
    required this.totalBookmarks,
    required this.monthlyListeners,
    required this.dailyListeners,
    required this.recentListenerAvatars,
  });
}

/// Provider for social listening statistics
class SocialStatsNotifier extends StateNotifier<SocialStats> {
  SocialStatsNotifier() : super(const SocialStats(
    currentListeners: 0,
    totalBookmarks: 0,
    monthlyListeners: 0,
    dailyListeners: 0,
    recentListenerAvatars: [],
  ));

  /// Generate real-time social stats for a chapter (without modifying state)
  SocialStats generateChapterStats(String chapterId, String contentId) {
    // Mock data - in real app this would come from API
    return SocialStats(
      currentListeners: _generateRandomListeners(),
      totalBookmarks: _generateRandomBookmarks(),
      monthlyListeners: _generateRandomMonthlyListeners(),
      dailyListeners: _generateRandomDailyListeners(),
      recentListenerAvatars: _generateMockAvatars(),
    );
  }

  /// Generate social stats for a playlist/content (without modifying state)
  SocialStats generatePlaylistStats(String contentId) {
    // Mock data - in real app this would come from API
    return SocialStats(
      currentListeners: _generateRandomListeners(isPlaylist: true),
      totalBookmarks: _generateRandomBookmarks(isPlaylist: true),
      monthlyListeners: _generateRandomMonthlyListeners(isPlaylist: true),
      dailyListeners: _generateRandomDailyListeners(isPlaylist: true),
      recentListenerAvatars: _generateMockAvatars(),
    );
  }

  int _generateRandomListeners({bool isPlaylist = false}) {
    // Generate realistic listener counts
    final base = isPlaylist ? 50 : 8;
    final variance = isPlaylist ? 200 : 25;
    return base + DateTime.now().millisecond % variance;
  }

  int _generateRandomBookmarks({bool isPlaylist = false}) {
    // Generate realistic bookmark counts
    final base = isPlaylist ? 1200 : 150;
    final variance = isPlaylist ? 3000 : 500;
    return base + DateTime.now().microsecond % variance;
  }

  int _generateRandomMonthlyListeners({bool isPlaylist = false}) {
    // Generate realistic monthly listener counts
    final base = isPlaylist ? 5000 : 800;
    final variance = isPlaylist ? 15000 : 3000;
    return base + DateTime.now().microsecond % variance;
  }

  int _generateRandomDailyListeners({bool isPlaylist = false}) {
    // Generate realistic daily listener counts
    final base = isPlaylist ? 200 : 50;
    final variance = isPlaylist ? 800 : 200;
    return base + DateTime.now().microsecond % variance;
  }

  List<String> _generateMockAvatars() {
    // Return mock avatar URLs or initials
    return [
      'A', 'M', 'S', 'K', 'F', 'R', 'N', 'H'
    ];
  }
}

/// Provider instance for social stats
final socialStatsProvider = StateNotifierProvider<SocialStatsNotifier, SocialStats>((ref) {
  return SocialStatsNotifier();
});

/// Provider for chapter-specific social stats
final chapterSocialStatsProvider = Provider.family<SocialStats, Map<String, String>>((ref, params) {
  final notifier = ref.read(socialStatsProvider.notifier);
  return notifier.generateChapterStats(params['chapterId']!, params['contentId']!);
});

/// Provider for playlist-specific social stats
final playlistSocialStatsProvider = Provider.family<SocialStats, String>((ref, contentId) {
  final notifier = ref.read(socialStatsProvider.notifier);
  return notifier.generatePlaylistStats(contentId);
});