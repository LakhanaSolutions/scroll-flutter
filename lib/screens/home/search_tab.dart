import 'package:flutter/material.dart';
import '../../data/mock_data.dart';
import '../../theme/app_spacing.dart';
import '../../theme/theme_extensions.dart';
import '../../widgets/text/app_text.dart';
import '../../widgets/books/book_shelf.dart';

/// Search tab content widget
/// Provides search functionality for books and audiobooks
class SearchTab extends StatefulWidget {
  const SearchTab({super.key});

  @override
  State<SearchTab> createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  List<BookData> _searchResults = [];
  bool _isSearching = false;
  bool _hasSearched = false;

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _performSearch(String query) {
    setState(() {
      _isSearching = true;
    });

    // Simulate search delay
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        final allBooks = [
          ...MockData.getShelfBooks(),
          MockData.getAudiobookOfTheWeek(),
          ...MockData.getMoodCategories().expand((cat) => cat.books),
        ];

        final results = allBooks.where((book) {
          final searchLower = query.toLowerCase();
          return book.title.toLowerCase().contains(searchLower) ||
                 book.author.toLowerCase().contains(searchLower) ||
                 book.categories.any((cat) => cat.toLowerCase().contains(searchLower));
        }).toList();

        setState(() {
          _searchResults = results;
          _isSearching = false;
          _hasSearched = true;
        });
      }
    });
  }

  void _clearSearch() {
    setState(() {
      _searchController.clear();
      _searchResults.clear();
      _hasSearched = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      children: [
        // Search header
        Container(
          padding: const EdgeInsets.all(AppSpacing.medium),
          decoration: BoxDecoration(
            color: context.appTheme.iosSystemBackground, // iOS background
            border: Border(
              bottom: BorderSide(
                color: colorScheme.outline.withValues(alpha: 0.1),
                width: 1,
              ),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.search_rounded,
                    color: colorScheme.primary,
                    size: AppSpacing.iconMedium,
                  ),
                  const SizedBox(width: AppSpacing.small),
                  const AppTitleText('Search'),
                ],
              ),
              const SizedBox(height: AppSpacing.medium),
              // Search bar
              TextField(
                controller: _searchController,
                focusNode: _searchFocusNode,
                onChanged: (query) {
                  if (query.trim().isNotEmpty) {
                    _performSearch(query.trim());
                  } else {
                    _clearSearch();
                  }
                },
                decoration: InputDecoration(
                  hintText: 'Search books, authors, categories...',
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: Icon(
                            Icons.clear_rounded,
                            color: colorScheme.onSurfaceVariant,
                          ),
                          onPressed: _clearSearch,
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
                    borderSide: BorderSide(
                      color: colorScheme.outline.withValues(alpha: 0.2),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
                    borderSide: BorderSide(
                      color: colorScheme.outline.withValues(alpha: 0.2),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
                    borderSide: BorderSide(
                      color: colorScheme.primary,
                      width: 2,
                    ),
                  ),
                  filled: true,
                  fillColor: colorScheme.surfaceContainer,
                ),
              ),
            ],
          ),
        ),
        
        // Search content
        Expanded(
          child: _buildSearchContent(),
        ),
      ],
    );
  }

  Widget _buildSearchContent() {
    if (_isSearching) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (!_hasSearched) {
      return _buildSearchSuggestions();
    }

    if (_searchResults.isEmpty) {
      return _buildNoResults();
    }

    return _buildSearchResults();
  }

  Widget _buildSearchSuggestions() {
    final categories = MockData.getMoodCategories();
    final recentBooks = MockData.getShelfBooks().take(3).toList();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSpacing.medium),
          
          // Popular searches
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.medium),
            child: const AppSubtitleText('Popular Categories'),
          ),
          const SizedBox(height: AppSpacing.medium),
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.medium),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return Container(
                  margin: const EdgeInsets.only(right: AppSpacing.small),
                  child: ActionChip(
                    label: Text(category.name),
                    avatar: Text(category.emoji),
                    onPressed: () {
                      _searchController.text = category.name;
                      _performSearch(category.name);
                    },
                  ),
                );
              },
            ),
          ),
          
          const SizedBox(height: AppSpacing.section),
          
          // Recent books
          BookShelf(
            title: 'Recently Added',
            books: recentBooks,
            onBookTap: (book) {
              debugPrint('Book tapped: ${book.title}');
            },
          ),
          
          const SizedBox(height: AppSpacing.large),
        ],
      ),
    );
  }

  Widget _buildNoResults() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off_rounded,
            size: AppSpacing.iconHero,
            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
          ),
          const SizedBox(height: AppSpacing.large),
          const AppTitleText('No results found'),
          const SizedBox(height: AppSpacing.small),
          AppBodyText(
            'Try searching with different keywords',
            color: colorScheme.onSurfaceVariant,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSpacing.medium),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.medium),
            child: AppSubtitleText(
              '${_searchResults.length} result${_searchResults.length != 1 ? 's' : ''} found',
            ),
          ),
          const SizedBox(height: AppSpacing.medium),
          BookShelf(
            title: 'Search Results',
            books: _searchResults,
            onBookTap: (book) {
              debugPrint('Search result tapped: ${book.title}');
            },
          ),
          const SizedBox(height: AppSpacing.large),
        ],
      ),
    );
  }
}