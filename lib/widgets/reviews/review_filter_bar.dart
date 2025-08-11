import 'package:flutter/material.dart';
import '../../theme/app_spacing.dart';

enum ReviewSortType { newest, oldest, highest, lowest, mostHelpful }
enum ReviewFilterType { all, fiveStar, fourStar, threeStar, twoStar, oneStar }

/// Review filter and sorting bar
/// Provides sorting and filtering options for reviews
class ReviewFilterBar extends StatelessWidget {
  final ReviewSortType selectedSort;
  final ReviewFilterType selectedFilter;
  final Function(ReviewSortType) onSortChanged;
  final Function(ReviewFilterType) onFilterChanged;

  const ReviewFilterBar({
    super.key,
    required this.selectedSort,
    required this.selectedFilter,
    required this.onSortChanged,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.medium),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorScheme.surface,
            colorScheme.surfaceContainer.withValues(alpha: 0.3),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sort options
          Row(
            children: [
              Icon(
                Icons.sort_rounded,
                color: colorScheme.primary,
                size: AppSpacing.iconSmall,
              ),
              const SizedBox(width: AppSpacing.small),
              Text(
                'Sort by:',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.small),
          
          // Sort chips
          Wrap(
            spacing: AppSpacing.small,
            runSpacing: AppSpacing.extraSmall,
            children: ReviewSortType.values.map((sort) {
              return _SortChip(
                label: _getSortLabel(sort),
                isSelected: selectedSort == sort,
                onTap: () => onSortChanged(sort),
              );
            }).toList(),
          ),
          
          const SizedBox(height: AppSpacing.medium),
          
          // Filter options
          Row(
            children: [
              Icon(
                Icons.filter_list_rounded,
                color: colorScheme.primary,
                size: AppSpacing.iconSmall,
              ),
              const SizedBox(width: AppSpacing.small),
              Text(
                'Filter by rating:',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.small),
          
          // Filter chips
          Wrap(
            spacing: AppSpacing.small,
            runSpacing: AppSpacing.extraSmall,
            children: ReviewFilterType.values.map((filter) {
              return _FilterChip(
                label: _getFilterLabel(filter),
                isSelected: selectedFilter == filter,
                onTap: () => onFilterChanged(filter),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  String _getSortLabel(ReviewSortType sort) {
    switch (sort) {
      case ReviewSortType.newest:
        return 'Newest';
      case ReviewSortType.oldest:
        return 'Oldest';
      case ReviewSortType.highest:
        return 'Highest';
      case ReviewSortType.lowest:
        return 'Lowest';
      case ReviewSortType.mostHelpful:
        return 'Most Helpful';
    }
  }

  String _getFilterLabel(ReviewFilterType filter) {
    switch (filter) {
      case ReviewFilterType.all:
        return 'All';
      case ReviewFilterType.fiveStar:
        return '5 Stars';
      case ReviewFilterType.fourStar:
        return '4 Stars';
      case ReviewFilterType.threeStar:
        return '3 Stars';
      case ReviewFilterType.twoStar:
        return '2 Stars';
      case ReviewFilterType.oneStar:
        return '1 Star';
    }
  }
}

/// Sort chip widget
class _SortChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _SortChip({
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
                    const Color(0xFF2196F3), // Blue
                    const Color(0xFF1976D2), // Darker blue
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
                    color: const Color(0xFF2196F3).withValues(alpha: 0.3),
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
                color: Colors.white,
                size: AppSpacing.iconExtraSmall,
              ),
            if (isSelected)
              const SizedBox(width: AppSpacing.extraSmall),
            Text(
              label,
              style: theme.textTheme.labelMedium?.copyWith(
                color: isSelected 
                    ? Colors.white 
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

/// Filter chip widget
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
                    const Color(0xFFFFD700), // Gold
                    const Color(0xFFFFA000), // Amber
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
                    color: const Color(0xFFFFD700).withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isSelected && label != 'All')
              Icon(
                Icons.star_rounded,
                color: Colors.white,
                size: AppSpacing.iconExtraSmall,
              ),
            if (isSelected && label == 'All')
              Icon(
                Icons.check_rounded,
                color: Colors.white,
                size: AppSpacing.iconExtraSmall,
              ),
            if (isSelected)
              const SizedBox(width: AppSpacing.extraSmall),
            Text(
              label,
              style: theme.textTheme.labelMedium?.copyWith(
                color: isSelected 
                    ? Colors.white 
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