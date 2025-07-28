import 'package:flutter/material.dart';
import '../../data/mock_data.dart';
import '../../theme/app_spacing.dart';
import '../text/app_text.dart';

/// Mood selector widget with horizontally scrollable tiles
/// Shows different mood categories that users can select to find matching content
class MoodSelector extends StatelessWidget {
  final String title;
  final List<MoodCategory> categories;
  final Function(MoodCategory)? onMoodTap;
  final EdgeInsets? padding;

  const MoodSelector({
    super.key,
    this.title = 'Listen what you feel',
    required this.categories,
    this.onMoodTap,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(vertical: AppSpacing.medium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.medium),
            child: AppSubtitleText(title),
          ),
          const SizedBox(height: AppSpacing.medium),
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.medium),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return _MoodTile(
                  category: category,
                  onTap: () => onMoodTap?.call(category),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Individual mood tile widget
class _MoodTile extends StatelessWidget {
  final MoodCategory category;
  final VoidCallback? onTap;

  const _MoodTile({
    required this.category,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: AppSpacing.medium),
      child: Material(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
        elevation: AppSpacing.elevationSmall,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.medium),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
              gradient: LinearGradient(
                colors: [
                  colorScheme.surfaceContainer,
                  colorScheme.surfaceContainer.withValues(alpha: 0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Emoji icon
                Container(
                  width: AppSpacing.iconLarge,
                  height: AppSpacing.iconLarge,
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
                  ),
                  child: Center(
                    child: Text(
                      category.emoji,
                      style: theme.textTheme.headlineSmall,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.small),
                // Category name
                AppCaptionText(
                  category.name,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  color: colorScheme.onSurface,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}