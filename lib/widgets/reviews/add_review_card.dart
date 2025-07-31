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
          
          const SizedBox(height: AppSpacing.large),
          
          // Action buttons
          Row(
            children: [
              Expanded(
                child: AppSecondaryButton(
                  onPressed: () {
                    if (onReviewTap != null) {
                      onReviewTap!();
                    } else {
                      context.push('/home/reviews/$contentType/$contentId');
                    }
                  },
                  child: const Text('All Reviews'),
                ),
              ),
              const SizedBox(width: AppSpacing.medium),
              Expanded(
                child: AppPrimaryButton(
                  onPressed: () {
                    // Navigate to write review or edit existing review
                    if (reviewSummary.userReview != null) {
                      context.push('/home/reviews/$contentType/$contentId/edit');
                    } else {
                      context.push('/home/reviews/$contentType/$contentId/write');
                    }
                  },
                  child: Text(
                    reviewSummary.userReview != null ? 'Edit Review' : 'Write Review',
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRatingSummary(BuildContext context, ColorScheme colorScheme) {
    return Row(
      children: [
        // Star rating display
        Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(5, (index) {
            final starValue = index + 1;
            final isFilled = starValue <= reviewSummary.averageRating;
            final isHalfFilled = starValue > reviewSummary.averageRating && 
                                 starValue - 0.5 <= reviewSummary.averageRating;
            
            return Icon(
              isHalfFilled ? Icons.star_half_rounded : Icons.star_rounded,
              color: isFilled || isHalfFilled 
                  ? Colors.amber.shade600 
                  : colorScheme.outline.withValues(alpha: 0.3),
              size: AppSpacing.iconMedium,
            );
          }),
        ),
        const SizedBox(width: AppSpacing.small),
        
        // Rating text
        AppBodyText(
          '${reviewSummary.averageRating.toStringAsFixed(1)} (${reviewSummary.totalReviews} ${reviewSummary.totalReviews == 1 ? 'review' : 'reviews'})',
          color: colorScheme.onSurfaceVariant,
        ),
      ],
    );
  }
}