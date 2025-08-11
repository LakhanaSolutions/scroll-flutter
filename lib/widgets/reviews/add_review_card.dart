import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_spacing.dart';
import '../../data/mock_data.dart';
import '../text/app_text.dart';
import '../buttons/app_buttons.dart';
import '../cards/app_card.dart';

/// Reusable "Add a review" card widget
/// Used on Playlist, Author, and Narrator pages
class AddReviewCard extends ConsumerWidget {
  final String contentId;
  final String contentType; // 'playlist', 'author', 'narrator'
  final String contentTitle;
  final ReviewSummaryData reviewSummary;
  final VoidCallback? onReviewTap;

  const AddReviewCard({
    super.key,
    required this.contentId,
    required this.contentType,
    required this.contentTitle,
    required this.reviewSummary,
    this.onReviewTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AppCard(
      elevation: 0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with star icon and title
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.small),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
                ),
                child: Icon(
                  Icons.star_rounded,
                  color: colorScheme.onPrimaryContainer,
                  size: AppSpacing.iconMedium,
                ),
              ),
              const SizedBox(width: AppSpacing.medium),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppSubtitleText(
                      'Reviews & Ratings',
                      color: colorScheme.onSurface,
                    ),
                    const SizedBox(height: AppSpacing.extraSmall),
                    AppCaptionText(
                      'Share your thoughts about this ${contentType.toLowerCase()}',
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.large),
          
          // Rating summary
          _buildRatingSummary(context, colorScheme),
          
        ],
      ),
    );
  }

  Widget _buildRatingSummary(BuildContext context, ColorScheme colorScheme) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(AppSpacing.large),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFFFFD700).withValues(alpha: 0.1), // Gold
            const Color(0xFFFFA000).withValues(alpha: 0.05), // Amber
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
        border: Border.all(
          color: const Color(0xFFFFD700).withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Hero Rating Number - Clickable
          GestureDetector(
            onTap: () {
              if (onReviewTap != null) {
                onReviewTap!();
              } else {
                context.push('/home/reviews/$contentType/$contentId');
              }
            },
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFFFFD700), // Gold
                    Color(0xFFFFA000), // Amber
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFFD700).withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    reviewSummary.averageRating.toStringAsFixed(1),
                    style: theme.textTheme.headlineLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 28,
                    ),
                  ),
                  Text(
                    '/5',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.large),
          
          // Stars and Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Animated Stars
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 800),
                  curve: Curves.easeOutBack,
                  builder: (context, value, child) {
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(5, (index) {
                        final starValue = index + 1;
                        final isFilled = starValue <= reviewSummary.averageRating;
                        final isHalfFilled = starValue > reviewSummary.averageRating && 
                                             starValue - 0.5 <= reviewSummary.averageRating;
                        
                        return Transform.scale(
                          scale: value,
                          child: Container(
                            margin: const EdgeInsets.only(right: 2),
                            child: Icon(
                              isHalfFilled ? Icons.star_half_rounded : Icons.star_rounded,
                              color: isFilled || isHalfFilled
                                  ? const Color(0xFFFFD700)
                                  : colorScheme.outline.withValues(alpha: 0.3),
                              size: 24,
                            ),
                          ),
                        );
                      }),
                    );
                  },
                ),
                const SizedBox(height: AppSpacing.small),
                
                // Review Count
                Text(
                  '${reviewSummary.totalReviews} ${reviewSummary.totalReviews == 1 ? 'review' : 'reviews'}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: AppSpacing.medium),
                
                // Circular Progress for Rating Distribution
                GestureDetector(
                  onTap: () {
                    if (onReviewTap != null) {
                      onReviewTap!();
                    } else {
                      context.push('/home/reviews/$contentType/$contentId');
                    }
                  },
                  child: _buildRatingDistribution(context, colorScheme),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildRatingDistribution(BuildContext context, ColorScheme colorScheme) {
    final theme = Theme.of(context);
    
    return Column(
      children: [
        for (int i = 5; i >= 1; i--)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.extraSmall),
            child: Row(
              children: [
                Text(
                  '$i',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(width: AppSpacing.extraSmall),
                Icon(
                  Icons.star_rounded,
                  size: 12,
                  color: const Color(0xFFFFD700),
                ),
                const SizedBox(width: AppSpacing.small),
                Expanded(
                  child: Container(
                    height: 4,
                    decoration: BoxDecoration(
                      color: colorScheme.outline.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: _getRatingPercentage(i) / 100,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFFFFD700),
                              Color(0xFFFFA000),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.small),
                Text(
                  '${_getRatingPercentage(i).toInt()}%',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
  
  double _getRatingPercentage(int rating) {
    // Mock data for rating distribution
    switch (rating) {
      case 5: return 45.0;
      case 4: return 30.0;
      case 3: return 15.0;
      case 2: return 7.0;
      case 1: return 3.0;
      default: return 0.0;
    }
  }
}