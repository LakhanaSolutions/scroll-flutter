import 'package:flutter/material.dart';
import '../../data/mock_data.dart';
import '../../theme/app_spacing.dart';
import '../../widgets/text/app_text.dart';
import '../../widgets/cards/app_card.dart';
import '../category_view_screen.dart';

/// Categories tab content widget
/// Displays Islamic categories with icons, item count, listening hours and arrow icons
class CategoriesTab extends StatefulWidget {
  const CategoriesTab({super.key});

  @override
  State<CategoriesTab> createState() => _CategoriesTabState();
}

class _CategoriesTabState extends State<CategoriesTab> {
  String _selectedLanguage = '';
  String _selectedVoiceType = '';
  bool _isFiltersExpanded = false;
  
  final List<String> _languages = ['Arabic', 'English', 'Urdu'];
  final List<String> _voiceTypes = ['Female voice', 'Male voice', 'Kid voice', 'AI voice'];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final categories = MockData.getIslamicCategories();

    return Column(
      children: [
        // Header/AppBar area
        Container(
          padding: const EdgeInsets.all(AppSpacing.medium),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            border: Border(
              bottom: BorderSide(
                color: colorScheme.outline.withValues(alpha: 0.1),
                width: 1,
              ),
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.category_rounded,
                color: colorScheme.primary,
                size: AppSpacing.iconMedium,
              ),
              const SizedBox(width: AppSpacing.small),
              const Expanded(
                child: AppTitleText('Categories'),
              ),
            ],
          ),
        ),
        // Filters section
        _buildFiltersSection(context),
        // Content
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(AppSpacing.medium),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return _CategoryTile(
                category: category,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => CategoryViewScreen(category: category),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFiltersSection(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final hasActiveFilters = _selectedLanguage.isNotEmpty || _selectedVoiceType.isNotEmpty;

    return Container(
      margin: const EdgeInsets.all(AppSpacing.medium),
      child: AppCard(
        child: Column(
          children: [
            // Header with expand/collapse functionality
            InkWell(
              onTap: () {
                setState(() {
                  _isFiltersExpanded = !_isFiltersExpanded;
                });
              },
              borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.medium),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.small),
                      decoration: BoxDecoration(
                        color: colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
                      ),
                      child: Icon(
                        Icons.tune_rounded,
                        color: colorScheme.onPrimaryContainer,
                        size: AppSpacing.iconSmall,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.medium),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const AppSubtitleText('Filters'),
                          if (hasActiveFilters)
                            AppCaptionText(
                              '${_selectedLanguage.isNotEmpty ? _selectedLanguage : ''}${_selectedLanguage.isNotEmpty && _selectedVoiceType.isNotEmpty ? ', ' : ''}${_selectedVoiceType.isNotEmpty ? _selectedVoiceType : ''}',
                              color: colorScheme.primary,
                            ),
                        ],
                      ),
                    ),
                    if (hasActiveFilters && !_isFiltersExpanded)
                      Container(
                        width: 20,
                        height: 20,
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
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ),
                    const SizedBox(width: AppSpacing.small),
                    AnimatedRotation(
                      turns: _isFiltersExpanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 200),
                      child: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: colorScheme.onSurfaceVariant,
                        size: AppSpacing.iconMedium,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Expandable content
            AnimatedCrossFade(
              firstChild: const SizedBox.shrink(),
              secondChild: Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.medium,
                  0,
                  AppSpacing.medium,
                  AppSpacing.medium,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHigh.withValues(alpha: 0.5),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(AppSpacing.radiusSmall),
                    bottomRight: Radius.circular(AppSpacing.radiusSmall),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: AppSpacing.medium),
                    
                    // Languages section
                    Row(
                      children: [
                        Icon(
                          Icons.language_rounded,
                          color: colorScheme.primary,
                          size: AppSpacing.iconSmall,
                        ),
                        const SizedBox(width: AppSpacing.small),
                        const AppSubtitleText('Languages'),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.medium),
                    SizedBox(
                      height: 40,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: _languages.length,
                        separatorBuilder: (context, index) => const SizedBox(width: AppSpacing.small),
                        itemBuilder: (context, index) {
                          final language = _languages[index];
                          final isSelected = _selectedLanguage == language;
                          return _FilterChip(
                            label: language,
                            isSelected: isSelected,
                            onTap: () {
                              setState(() {
                                _selectedLanguage = isSelected ? '' : language;
                              });
                            },
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: AppSpacing.large),
                    
                    // Voice types section
                    Row(
                      children: [
                        Icon(
                          Icons.record_voice_over_rounded,
                          color: colorScheme.primary,
                          size: AppSpacing.iconSmall,
                        ),
                        const SizedBox(width: AppSpacing.small),
                        const AppSubtitleText('Voice Type'),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.medium),
                    SizedBox(
                      height: 40,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: _voiceTypes.length,
                        separatorBuilder: (context, index) => const SizedBox(width: AppSpacing.small),
                        itemBuilder: (context, index) {
                          final voiceType = _voiceTypes[index];
                          final isSelected = _selectedVoiceType == voiceType;
                          return _FilterChip(
                            label: voiceType,
                            isSelected: isSelected,
                            onTap: () {
                              setState(() {
                                _selectedVoiceType = isSelected ? '' : voiceType;
                              });
                            },
                          );
                        },
                      ),
                    ),
                    
                    // Clear filters button (only show if filters are active)
                    if (hasActiveFilters) ...[
                      const SizedBox(height: AppSpacing.large),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedLanguage = '';
                            _selectedVoiceType = '';
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.medium,
                            vertical: AppSpacing.small,
                          ),
                          decoration: BoxDecoration(
                            color: colorScheme.surfaceContainerHighest,
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
                                Icons.clear_rounded,
                                color: colorScheme.onSurfaceVariant,
                                size: AppSpacing.iconExtraSmall,
                              ),
                              const SizedBox(width: AppSpacing.extraSmall),
                              AppCaptionText(
                                'Clear filters',
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              crossFadeState: _isFiltersExpanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 300),
            ),
          ],
        ),
      ),
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

/// Individual category tile widget with icon, title, item count, listening hours and arrow
class _CategoryTile extends StatelessWidget {
  final CategoryData category;
  final VoidCallback? onTap;

  const _CategoryTile({
    required this.category,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AppCard(
      margin: const EdgeInsets.only(bottom: AppSpacing.small),
      onTap: onTap,
      child: Row(
        children: [
          // Category icon
          Container(
            width: AppSpacing.iconLarge + AppSpacing.small,
            height: AppSpacing.iconLarge + AppSpacing.small,
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
            ),
            child: Icon(
              category.icon,
              color: colorScheme.onPrimaryContainer,
              size: AppSpacing.iconMedium,
            ),
          ),
          const SizedBox(width: AppSpacing.medium),
          // Category info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppSubtitleText(
                  category.name,
                  color: colorScheme.onSurface,
                ),
                const SizedBox(height: AppSpacing.extraSmall),
                Row(
                  children: [
                    AppCaptionText(
                      '${category.itemCount} items',
                      color: colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: AppSpacing.medium),
                    Icon(
                      Icons.access_time_rounded,
                      size: AppSpacing.iconExtraSmall,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: AppSpacing.extraSmall),
                    AppCaptionText(
                      category.listeningHours,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Arrow icon
          Icon(
            Icons.chevron_right_rounded,
            color: colorScheme.onSurfaceVariant,
            size: AppSpacing.iconMedium,
          ),
        ],
      ),
    );
  }
}