import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:siraaj/widgets/buttons/music_player_fab.dart';
import '../data/mock_data.dart';
import '../theme/app_spacing.dart';
import '../theme/theme_extensions.dart';
import '../widgets/books/content_tile.dart';
import '../widgets/cards/app_card.dart';
import '../widgets/app_bar/app_app_bar.dart';
import '../widgets/states/app_empty_state.dart';
import '../widgets/buttons/app_buttons.dart';
import '../widgets/text/app_text.dart';

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
  
  // Filter state variables
  String _selectedLanguage = '';
  String _selectedVoiceType = '';
  
  // Filter options
  final List<String> _languages = ['Arabic', 'English', 'Urdu'];
  final List<String> _voiceTypes = ['Female voice', 'Male voice', 'Kid voice', 'AI voice'];

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
    final allContent = MockData.getCategoryContent(widget.category.id);
    _allContent = _applyFilters(allContent);
    _books = _allContent.where((item) => item.type == ContentType.book).toList();
    _podcasts = _allContent.where((item) => item.type == ContentType.podcast).toList();
  }
  
  List<ContentItemData> _applyFilters(List<ContentItemData> content) {
    List<ContentItemData> filteredContent = content;
    
    // Apply language filter
    if (_selectedLanguage.isNotEmpty) {
      filteredContent = filteredContent.where((item) {
        return item.language.toLowerCase() == _selectedLanguage.toLowerCase();
      }).toList();
    }
    
    // Apply voice type filter - check if any narrator has the selected voice type
    if (_selectedVoiceType.isNotEmpty) {
      filteredContent = filteredContent.where((item) {
        // For simplicity, we'll use the voice type from custom stats if available
        // In a real app, this would be a proper field in the narrator data
        return item.narrators.any((narrator) => 
          narrator.voiceDescription.toLowerCase().contains(_selectedVoiceType.toLowerCase()) ||
          _selectedVoiceType.toLowerCase().contains('voice') // Simple matching for demo
        );
      }).toList();
    }
    
    return filteredContent;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      floatingActionButton: const MusicPlayerFab(),
      appBar: AppAppBarExtensions.withTabBar(
        title: widget.category.name,
        tabController: _tabController,
        tabs: [
          'All (${_allContent.length})',
          'Books (${_books.length})',
          'Podcasts (${_podcasts.length})',
        ],
        actions: [
          _buildFilterButton(context),
        ],
        onBackPressed: () => Navigator.of(context).pop(),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category description card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.medium),
            child: AppCard(
              elevation: 0,
              gradient: context.surfaceGradient,
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.medium),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category icon
                    Container(
                      width: AppSpacing.iconLarge,
                      height: AppSpacing.iconLarge,
                      decoration: BoxDecoration(
                        color: colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
                      ),
                      child: widget.category.iconPath != null
                        ? Image.asset(
                            widget.category.iconPath!,
                            width: AppSpacing.iconMedium,
                            height: AppSpacing.iconMedium,
                            color: colorScheme.onPrimaryContainer,
                          )
                        : Icon(
                            // Previous icon: widget.category.icon (when using IconData)
                            widget.category.icon,
                            color: colorScheme.onPrimaryContainer,
                            size: AppSpacing.iconMedium,
                          ),
                    ),
                    const SizedBox(width: AppSpacing.medium),
                    // Description text
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'About ${widget.category.name}',
                            style: theme.textTheme.titleSmall?.copyWith(
                              color: colorScheme.onSurface,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.small),
                          Text(
                            widget.category.description,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                              fontSize: 13,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
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
      return const AppEmptyState.content();
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.medium),
      itemCount: content.length,
      itemBuilder: (context, index) {
        final item = content[index];
        return ContentTile(
          content: item,
          onTap: () {
            context.push('/home/playlist/${item.id}');
          },
        );
      },
    );
  }

  Widget _buildFilterButton(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final hasActiveFilters = _selectedLanguage.isNotEmpty || _selectedVoiceType.isNotEmpty;

    return Stack(
      children: [
        AppIconButton(
          icon: Icons.tune_rounded,
          onPressed: () => _showFiltersBottomSheet(context),
          tooltip: 'Filters',
        ),
        if (hasActiveFilters)
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                color: colorScheme.primary,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '${(_selectedLanguage.isNotEmpty ? 1 : 0) + (_selectedVoiceType.isNotEmpty ? 1 : 0)}',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 9,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  void _showFiltersBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppSpacing.radiusLarge),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle
              Container(
                margin: const EdgeInsets.only(top: AppSpacing.medium),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Content
              Padding(
                padding: const EdgeInsets.all(AppSpacing.large),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    const AppTitleText('Filters'),
                    const SizedBox(height: AppSpacing.large),
                    
                    // Languages section
                    _buildFilterSection(
                      context,
                      title: 'Languages',
                      icon: Icons.language_rounded,
                      items: _languages,
                      selectedItem: _selectedLanguage,
                      onItemSelected: (language) {
                        setState(() {
                          _selectedLanguage = _selectedLanguage == language ? '' : language;
                          _loadContent(); // Reload content with new filters
                        });
                        setModalState(() {});
                      },
                    ),
                    
                    const SizedBox(height: AppSpacing.large),
                    
                    // Voice types section
                    _buildFilterSection(
                      context,
                      title: 'Voice Type',
                      icon: Icons.record_voice_over_rounded,
                      items: _voiceTypes,
                      selectedItem: _selectedVoiceType,
                      onItemSelected: (voiceType) {
                        setState(() {
                          _selectedVoiceType = _selectedVoiceType == voiceType ? '' : voiceType;
                          _loadContent(); // Reload content with new filters
                        });
                        setModalState(() {});
                      },
                    ),
                    
                    const SizedBox(height: AppSpacing.large),
                    
                    // Clear filters button
                    if (_selectedLanguage.isNotEmpty || _selectedVoiceType.isNotEmpty)
                      Center(
                        child: AppSecondaryButton(
                          onPressed: () {
                            setState(() {
                              _selectedLanguage = '';
                              _selectedVoiceType = '';
                              _loadContent(); // Reload content with cleared filters
                            });
                            setModalState(() {});
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.clear_rounded,
                                size: AppSpacing.iconSmall,
                              ),
                              const SizedBox(width: AppSpacing.small),
                              const Text('Clear Filters'),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterSection(
    BuildContext context, {
    required String title,
    required IconData icon,
    required List<String> items,
    required String selectedItem,
    required Function(String) onItemSelected,
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
            Text(
              title,
              style: theme.textTheme.labelLarge?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.medium),
        Wrap(
          spacing: AppSpacing.small,
          runSpacing: AppSpacing.small,
          children: items.map((item) {
            final isSelected = selectedItem == item;
            return _FilterChip(
              label: item,
              isSelected: isSelected,
              onTap: () => onItemSelected(item),
            );
          }).toList(),
        ),
      ],
    );
  }
}

/// Beautiful modern filter chip widget
class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.medium,
          vertical: AppSpacing.small,
        ),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  colors: [
                    colorScheme.primary,
                    colorScheme.primaryContainer,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isSelected ? null : colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
          border: Border.all(
            color: isSelected 
                ? Colors.transparent 
                : colorScheme.outline.withValues(alpha: 0.3),
            width: 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: colorScheme.primary.withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isSelected)
              Icon(
                Icons.check_rounded,
                color: colorScheme.onPrimary,
                size: AppSpacing.iconExtraSmall,
              ),
            if (isSelected)
              const SizedBox(width: AppSpacing.extraSmall),
            Text(
              label,
              style: theme.textTheme.labelMedium?.copyWith(
                color: isSelected 
                    ? colorScheme.onPrimary 
                    : colorScheme.onSurfaceVariant,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}