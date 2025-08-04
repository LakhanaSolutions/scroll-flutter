import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/mock_data.dart';

/// Provider for managing bookmarked content
class BookmarksNotifier extends StateNotifier<Set<String>> {
  BookmarksNotifier() : super(_getInitialBookmarks());

  /// Get initial bookmarks (in real app, this would load from storage/API)
  static Set<String> _getInitialBookmarks() {
    // Mock initial bookmarks
    return {'fiqh_1', 'aqeedah_1', 'quran_1'};
  }

  /// Check if content is bookmarked
  bool isBookmarked(String contentId) {
    return state.contains(contentId);
  }

  /// Toggle bookmark status for content
  void toggleBookmark(String contentId) {
    if (state.contains(contentId)) {
      // Remove bookmark
      state = Set.from(state)..remove(contentId);
    } else {
      // Add bookmark
      state = Set.from(state)..add(contentId);
    }
    
    // In a real app, you would also persist this change to storage/API
    _persistBookmarks();
  }

  /// Add a bookmark
  void addBookmark(String contentId) {
    if (!state.contains(contentId)) {
      state = Set.from(state)..add(contentId);
      _persistBookmarks();
    }
  }

  /// Remove a bookmark
  void removeBookmark(String contentId) {
    if (state.contains(contentId)) {
      state = Set.from(state)..remove(contentId);
      _persistBookmarks();
    }
  }

  /// Get all bookmarked content
  List<ContentItemData> getBookmarkedContent() {
    // Get all content from different categories
    final allContent = <ContentItemData>[];
    
    // Add content from different categories
    allContent.addAll(MockData.getCategoryContent('1')); // Fiqh
    allContent.addAll(MockData.getCategoryContent('2')); // Aqeedah
    allContent.addAll(MockData.getCategoryContent('3')); // Quran
    
    // Filter and return only bookmarked content
    return allContent.where((content) => state.contains(content.id)).map((content) {
      // Create a copy with isBookmarked set to true
      return ContentItemData(
        id: content.id,
        title: content.title,
        author: content.author,
        authorData: content.authorData,
        coverUrl: content.coverUrl,
        type: content.type,
        availability: content.availability,
        rating: content.rating,
        duration: content.duration,
        chapterCount: content.chapterCount,
        description: content.description,
        narrators: content.narrators,
        chapters: content.chapters,
        isBookmarked: true,
      );
    }).toList();
  }

  /// Clear all bookmarks
  void clearAllBookmarks() {
    state = <String>{};
    _persistBookmarks();
  }

  /// Persist bookmarks to storage (mock implementation)
  void _persistBookmarks() {
    // In a real app, you would save to SharedPreferences, database, or API
    // For now, this is just a placeholder
    print('Bookmarks persisted: ${state.toList()}');
  }
}

/// Provider instance for bookmarks
final bookmarksProvider = StateNotifierProvider<BookmarksNotifier, Set<String>>((ref) {
  return BookmarksNotifier();
});

/// Convenience provider to get bookmarked content list
final bookmarkedContentProvider = Provider<List<ContentItemData>>((ref) {
  final bookmarksNotifier = ref.read(bookmarksProvider.notifier);
  return bookmarksNotifier.getBookmarkedContent();
});

/// Provider to check if specific content is bookmarked
final isBookmarkedProvider = Provider.family<bool, String>((ref, contentId) {
  final bookmarks = ref.watch(bookmarksProvider);
  return bookmarks.contains(contentId);
});