import 'package:flutter/material.dart';
import 'package:siraaj/screens/narrators_list_screen.dart';
import '../../data/mock_data.dart';
import '../../theme/app_spacing.dart';
import '../../theme/theme_extensions.dart';
import '../../widgets/text/app_text.dart';
import '../../widgets/cards/app_card.dart';
import '../../widgets/buttons/app_buttons.dart';
import '../../widgets/images/app_image.dart';
import '../category_view_screen.dart';
import '../authors_list_screen.dart';

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
              _buildFilterButton(context),
            ],
          ),
        ),
        // Content
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.medium),
            children: [
              // Explore cards
              Row(
                children: [
                  Expanded(
                    child: _ExploreCard(
                      title: 'Explore Authors',
                      subtitle: 'Discover amazing writers',
                      icon: Icons.edit_rounded,
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF2196F3), // Blue
                          Color(0xFF1976D2), // Darker blue
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const AuthorsListScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: AppSpacing.medium),
                  Expanded(
                    child: _ExploreCard(
                      title: 'Explore Narrators',
                      subtitle: 'Find amazing voices',
                      icon: Icons.mic_rounded,
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF00BCD4), // Cyan
                          Color(0xFF0097A7), // Darker cyan
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                       onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const NarratorsListScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.medium),
              // Third explore card for Languages
              // _ExploreCard(
              //   title: 'Explore Languages',
              //   subtitle: 'Browse content by language',
              //   icon: Icons.language_rounded,
              //   gradient: LinearGradient(
              //     colors: [
              //       colorScheme.tertiary,
              //       colorScheme.tertiaryContainer,
              //     ],
              //     begin: Alignment.topLeft,
              //     end: Alignment.bottomRight,
              //   ),
              //   onTap: () {
              //     debugPrint('Explore Languages tapped');
              //   },
              // ),
              const SizedBox(height: AppSpacing.large),
              // Categories
              ...categories.map((category) {
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
              }),
            ],
          ),
        ),
      ],
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
      gradient: context.surfaceGradient,
      elevation: AppSpacing.elevationNone,
      onTap: onTap,
      child: Stack(
        children: [
          // Background faded icon
          Positioned(
            right: 20,
            top: -5,
            child: Opacity(
              opacity: 0.03,
              child: Icon(
                category.icon,
                size: 60,
                color: colorScheme.onSurface,
              ),
            ),
          ),
          // Main content
          Row(
            children: [
              // Category icon/image
              AppImage(
                imageUrl: category.imageUrl,
                fallbackIcon: category.icon,
                width: AppSpacing.iconLarge + AppSpacing.medium,
                height: AppSpacing.iconLarge + AppSpacing.medium,
                borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
                backgroundColor: colorScheme.primaryContainer,
                iconColor: colorScheme.onPrimaryContainer,
                iconSize: AppSpacing.iconLarge,
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
        ],
      ),
    );
  }
}

/// Explore card widget for Authors and Narrators
class _ExploreCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Gradient gradient;
  final VoidCallback? onTap;

  const _ExploreCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.gradient,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
          boxShadow: [
            BoxShadow(
              color: colorScheme.primary.withValues(alpha: 0.2),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Background pattern
            Positioned(
              right: -20,
              top: -10,
              child: Opacity(
                opacity: 0.1,
                child: Icon(
                  icon,
                  size: 80,
                  color: Colors.white,
                ),
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(AppSpacing.medium),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Icon
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
                    ),
                    child: Icon(
                      icon,
                      color: Colors.white,
                      size: AppSpacing.iconMedium,
                    ),
                  ),
                  // Text
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.white.withValues(alpha: 0.8),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Arrow indicator
            Positioned(
              right: AppSpacing.medium,
              bottom: AppSpacing.medium,
              child: Icon(
                Icons.arrow_forward_rounded,
                color: Colors.white.withValues(alpha: 0.8),
                size: AppSpacing.iconSmall,
              ),
            ),
          ],
        ),
      ),
    );
  }
}