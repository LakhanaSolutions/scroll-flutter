import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../theme/app_spacing.dart';
import '../widgets/text/app_text.dart';
import '../widgets/inputs/app_text_field.dart';
import '../widgets/books/content_tile.dart';
import '../widgets/search/author_result_tile.dart';
import '../widgets/search/narrator_result_tile.dart';
import '../widgets/search/chapter_result_tile.dart';
import 'author_screen.dart';
import 'narrator_screen.dart';

/// Search screen with comprehensive search functionality
/// Shows recently searched, trending topics, tags, and categorized search results
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  Map<String, List<dynamic>> _searchResults = {};
  bool _isSearching = false;
  bool _hasSearched = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch(String query) {
    if (query.trim().isEmpty) {
      setState(() {
        _searchResults = {};
        _hasSearched = false;
        _isSearching = false;
      });
      return;
    }

    setState(() {
      _isSearching = true;
    });

    // Simulate API delay
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _searchResults = MockData.performSearch(query);
          _hasSearched = true;
          _isSearching = false;
        });
      }
    });
  }

  void _onTagTapped(String tag) {
    _searchController.text = tag;
    _performSearch(tag);
  }

  void _onRecentSearchTapped(String search) {
    _searchController.text = search;
    _performSearch(search);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F7), // iOS background
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_rounded,
            color: colorScheme.onSurface,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const AppTitleText('Search'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Search input
          Container(
            padding: const EdgeInsets.all(AppSpacing.medium),
            color: colorScheme.surface,
            child: AppTextField(
              controller: _searchController,
              hintText: 'Search books, podcasts, authors...',
              prefixIcon: Icon(
                Icons.search_rounded,
                color: colorScheme.onSurfaceVariant,
              ),
              onChanged: _performSearch,
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: Icon(
                        Icons.clear_rounded,
                        color: colorScheme.onSurfaceVariant,
                      ),
                      onPressed: () {
                        _searchController.clear();
                        _performSearch('');
                      },
                    )
                  : null,
            ),
          ),
          
          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.medium),
              child: _isSearching
                  ? _buildLoadingState(context)
                  : _hasSearched
                      ? _buildSearchResults(context)
                      : _buildInitialState(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Center(
      child: Column(
        children: [
          const SizedBox(height: AppSpacing.section),
          CircularProgressIndicator(
            color: colorScheme.primary,
          ),
          const SizedBox(height: AppSpacing.large),
          AppBodyText(
            'Searching...',
            color: colorScheme.onSurfaceVariant,
          ),
        ],
      ),
    );
  }

  Widget _buildInitialState(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Recently searched
        _buildRecentSearchesSection(context),
        const SizedBox(height: AppSpacing.large),
        // Trending topics
        _buildTrendingTopicsSection(context),
        const SizedBox(height: AppSpacing.large),
        // Popular tags
        _buildPopularTagsSection(context),
      ],
    );
  }

  Widget _buildRecentSearchesSection(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final recentSearches = MockData.getRecentSearches();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.history_rounded,
              color: colorScheme.primary,
              size: AppSpacing.iconSmall,
            ),
            const SizedBox(width: AppSpacing.small),
            const AppSubtitleText('Recently Searched'),
          ],
        ),
        const SizedBox(height: AppSpacing.medium),
        ...recentSearches.map((search) {
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.medium,
              vertical: AppSpacing.extraSmall,
            ),
            leading: Icon(
              Icons.history_rounded,
              color: colorScheme.onSurfaceVariant,
              size: AppSpacing.iconSmall,
            ),
            title: AppBodyText(search),
            trailing: Icon(
              Icons.north_west_rounded,
              color: colorScheme.onSurfaceVariant,
              size: AppSpacing.iconSmall,
            ),
            onTap: () => _onRecentSearchTapped(search),
          );
        }),
      ],
    );
  }

  Widget _buildTrendingTopicsSection(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final trendingTopics = MockData.getTrendingTopics();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.trending_up_rounded,
              color: colorScheme.primary,
              size: AppSpacing.iconSmall,
            ),
            const SizedBox(width: AppSpacing.small),
            const AppSubtitleText('Trending Now'),
          ],
        ),
        const SizedBox(height: AppSpacing.medium),
        ...trendingTopics.map((topic) {
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.medium,
              vertical: AppSpacing.extraSmall,
            ),
            leading: Icon(
              Icons.whatshot_rounded,
              color: colorScheme.secondary,
              size: AppSpacing.iconSmall,
            ),
            title: AppBodyText(topic),
            trailing: Icon(
              Icons.north_west_rounded,
              color: colorScheme.onSurfaceVariant,
              size: AppSpacing.iconSmall,
            ),
            onTap: () => _onRecentSearchTapped(topic),
          );
        }),
      ],
    );
  }

  Widget _buildPopularTagsSection(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final popularTags = MockData.getPopularTags();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.label_rounded,
              color: colorScheme.primary,
              size: AppSpacing.iconSmall,
            ),
            const SizedBox(width: AppSpacing.small),
            const AppSubtitleText('Popular Tags'),
          ],
        ),
        const SizedBox(height: AppSpacing.medium),
        Wrap(
          spacing: AppSpacing.small,
          runSpacing: AppSpacing.small,
          children: popularTags.map((tag) {
            return GestureDetector(
              onTap: () => _onTagTapped(tag),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.medium,
                  vertical: AppSpacing.small,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
                  border: Border.all(
                    color: colorScheme.outline.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.tag_rounded,
                      color: colorScheme.primary,
                      size: AppSpacing.iconExtraSmall,
                    ),
                    const SizedBox(width: AppSpacing.extraSmall),
                    AppCaptionText(
                      tag,
                      color: colorScheme.onSurface,
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildSearchResults(BuildContext context) {
    final authors = _searchResults['authors'] as List<AuthorData>? ?? [];
    final narrators = _searchResults['narrators'] as List<NarratorData>? ?? [];
    final content = _searchResults['content'] as List<ContentItemData>? ?? [];
    final chapters = _searchResults['chapters'] as List<Map<String, dynamic>>? ?? [];

    if (authors.isEmpty && narrators.isEmpty && content.isEmpty && chapters.isEmpty) {
      return _buildNoResults(context);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Authors section
        if (authors.isNotEmpty) ...[
          _buildResultsSection(
            context,
            title: 'Authors',
            count: authors.length,
            icon: Icons.edit_rounded,
            children: authors.map((author) {
              return AuthorResultTile(
                author: author,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => AuthorScreen(author: author),
                    ),
                  );
                },
              );
            }).toList(),
          ),
          const SizedBox(height: AppSpacing.large),
        ],

        // Narrators section
        if (narrators.isNotEmpty) ...[
          _buildResultsSection(
            context,
            title: 'Narrators',
            count: narrators.length,
            icon: Icons.mic_rounded,
            children: narrators.map((narrator) {
              return NarratorResultTile(
                narrator: narrator,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => NarratorScreen(narrator: narrator),
                    ),
                  );
                },
              );
            }).toList(),
          ),
          const SizedBox(height: AppSpacing.large),
        ],

        // Content section
        if (content.isNotEmpty) ...[
          _buildResultsSection(
            context,
            title: 'Books & Podcasts',
            count: content.length,
            icon: Icons.library_books_rounded,
            children: content.map((item) {
              return ContentTile(
                content: item,
                onTap: () {
                  debugPrint('Navigate to content: ${item.title}');
                },
              );
            }).toList(),
          ),
          const SizedBox(height: AppSpacing.large),
        ],

        // Chapters section
        if (chapters.isNotEmpty) ...[
          _buildResultsSection(
            context,
            title: 'Chapters & Episodes',
            count: chapters.length,
            icon: Icons.play_circle_outline_rounded,
            children: chapters.map((chapterData) {
              final chapter = chapterData['chapter'] as ChapterData;
              final parent = chapterData['parent'] as ContentItemData;
              return ChapterResultTile(
                chapter: chapter,
                parentContent: parent,
                onTap: () {
                  debugPrint('Navigate to chapter: ${chapter.title}');
                },
              );
            }).toList(),
          ),
        ],
      ],
    );
  }

  Widget _buildResultsSection(
    BuildContext context, {
    required String title,
    required int count,
    required IconData icon,
    required List<Widget> children,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              color: colorScheme.primary,
              size: AppSpacing.iconSmall,
            ),
            const SizedBox(width: AppSpacing.small),
            AppSubtitleText(title),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.small,
                vertical: AppSpacing.extraSmall,
              ),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(AppSpacing.radiusExtraSmall),
              ),
              child: Text(
                count.toString(),
                style: theme.textTheme.labelSmall?.copyWith(
                  color: colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.medium),
        ...children,
      ],
    );
  }

  Widget _buildNoResults(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Column(
        children: [
          const SizedBox(height: AppSpacing.section),
          Icon(
            Icons.search_off_rounded,
            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            size: 80,
          ),
          const SizedBox(height: AppSpacing.large),
          AppTitleText(
            'No Results Found',
            color: colorScheme.onSurfaceVariant,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.small),
          AppBodyText(
            'Try searching with different keywords or check spelling',
            color: colorScheme.onSurfaceVariant,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.large),
          Text(
            'Suggestions:',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.small),
          const AppCaptionText('• Use broader terms'),
          const AppCaptionText('• Check for typos'),
          const AppCaptionText('• Try different keywords'),
        ],
      ),
    );
  }
}