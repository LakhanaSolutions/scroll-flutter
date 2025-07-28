import 'package:flutter/material.dart';
import '../../data/mock_data.dart';
import '../../theme/app_spacing.dart';
import '../../widgets/text/app_text.dart';
import '../../widgets/cards/app_card.dart';
import '../category_view_screen.dart';

/// Categories tab content widget
/// Displays Islamic categories with icons, item count, listening hours and arrow icons
class CategoriesTab extends StatelessWidget {
  const CategoriesTab({super.key});

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