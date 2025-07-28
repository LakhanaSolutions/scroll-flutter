import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../theme/app_spacing.dart';
import '../widgets/text/app_text.dart';
import '../widgets/books/content_tile.dart';
import '../widgets/cards/app_card.dart';
import 'playlist_screen.dart';

/// Category view screen that displays books and podcasts for a specific category
/// Shows content grouped by type (Books and Podcasts) with filtering options
class CategoryViewScreen extends StatefulWidget {
  final CategoryData category;

  const CategoryViewScreen({
    super.key,
    required this.category,
  });

  @override
  State<CategoryViewScreen> createState() => _CategoryViewScreenState();
}

class _CategoryViewScreenState extends State<CategoryViewScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  List<ContentItemData> _allContent = [];
  List<ContentItemData> _books = [];
  List<ContentItemData> _podcasts = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadContent();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _loadContent() {
    _allContent = MockData.getCategoryContent(widget.category.id);
    _books = _allContent.where((item) => item.type == ContentType.book).toList();
    _podcasts = _allContent.where((item) => item.type == ContentType.podcast).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F7), // iOS background
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_rounded,
            color: colorScheme.onSurface,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(
          children: [
            Container(
              width: AppSpacing.iconLarge,
              height: AppSpacing.iconLarge,
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
              ),
              child: Icon(
                widget.category.icon,
                color: colorScheme.onPrimaryContainer,
                size: AppSpacing.iconMedium,
              ),
            ),
            const SizedBox(width: AppSpacing.small),
            AppTitleText(widget.category.name),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: colorScheme.primary,
          unselectedLabelColor: colorScheme.onSurfaceVariant,
          indicatorColor: colorScheme.primary,
          tabs: [
            Tab(text: 'All (${_allContent.length})'),
            Tab(text: 'Books (${_books.length})'),
            Tab(text: 'Podcasts (${_podcasts.length})'),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category description card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.medium),
            child: AppCard(
              child: Text(
                widget.category.description,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontSize: 13,
                ),
              ),
            ),
          ),
          // Content tabs
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildContentList(_allContent),
                _buildContentList(_books),
                _buildContentList(_podcasts),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentList(List<ContentItemData> content) {
    if (content.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.medium),
      itemCount: content.length,
      itemBuilder: (context, index) {
        final item = content[index];
        return ContentTile(
          content: item,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => PlaylistScreen(content: item),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildEmptyState() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.large),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.library_books_outlined,
              size: AppSpacing.iconHero,
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            ),
            const SizedBox(height: AppSpacing.large),
            const AppTitleText('No Content Available'),
            const SizedBox(height: AppSpacing.small),
            AppBodyText(
              'Content for this category will be added soon.',
              textAlign: TextAlign.center,
              color: colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}