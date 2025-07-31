import 'package:flutter/material.dart';
import 'package:siraaj/theme/app_gradients.dart';
import '../../theme/app_spacing.dart';
import '../../data/mock_data.dart';
import '../text/app_text.dart';
import '../cards/app_card.dart';

/// Individual review item widget
/// Shows reviewer name, rating, text, and upvote/downvote buttons
class ReviewItem extends StatelessWidget {
  final ReviewData review;
  final Function(String reviewId, bool isUpvote)? onVote;

  const ReviewItem({
    super.key,
    required this.review,
    this.onVote,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AppCard(
      elevation: 0,
      // gradient: AppGradients.subtleSurfaceGradient(colorScheme),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with user info and rating
          Row(
            children: [
              // User avatar
              CircleAvatar(
                backgroundColor: colorScheme.primaryContainer,
                radius: 20,
                child: review.userAvatar.isNotEmpty
                    ? ClipOval(
                        child: Image.network(
                          review.userAvatar,
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              _buildAvatarFallback(colorScheme),
                        ),
                      )
                    : _buildAvatarFallback(colorScheme),
              ),
              const SizedBox(width: AppSpacing.medium),
              
              // User name and date
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.userName,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.extraSmall),
                    AppCaptionText(
                      _formatDate(review.createdAt),
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ],
                ),
              ),
              
              // Rating stars
              Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(5, (index) {
                  final starValue = index + 1;
                  final isFilled = starValue <= review.rating;
                  final isHalfFilled = starValue > review.rating && 
                                       starValue - 0.5 <= review.rating;
                  
                  return Icon(
                    isHalfFilled ? Icons.star_half_rounded : Icons.star_rounded,
                    color: isFilled || isHalfFilled 
                        ? Colors.amber.shade600 
                        : colorScheme.outline.withValues(alpha: 0.3),
                    size: 16,
                  );
                }),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.medium),
          
          // Review text
          AppBodyText(
            review.reviewText,
            maxLines: null, // Allow unlimited lines for full text
          ),
          const SizedBox(height: AppSpacing.medium),
          
          // Vote buttons and helpfulness
          Row(
            children: [
              AppCaptionText(
                'Was this helpful?',
                color: colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: AppSpacing.medium),
              
              // Upvote button
              InkWell(
                onTap: () => onVote?.call(review.id, true),
                borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.small,
                    vertical: AppSpacing.extraSmall,
                  ),
                  decoration: BoxDecoration(
                    color: review.isUserUpvoted 
                        ? colorScheme.primaryContainer
                        : colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.thumb_up_rounded,
                        size: 16,
                        color: review.isUserUpvoted 
                            ? colorScheme.primary
                            : colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: AppSpacing.extraSmall),
                      Text(
                        '${review.upvotes}',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: review.isUserUpvoted 
                              ? colorScheme.primary
                              : colorScheme.onSurfaceVariant,
                          fontWeight: review.isUserUpvoted 
                              ? FontWeight.w600 
                              : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.small),
              
              // Downvote button
              InkWell(
                onTap: () => onVote?.call(review.id, false),
                borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.small,
                    vertical: AppSpacing.extraSmall,
                  ),
                  decoration: BoxDecoration(
                    color: review.isUserDownvoted 
                        ? colorScheme.errorContainer
                        : colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.thumb_down_rounded,
                        size: 16,
                        color: review.isUserDownvoted 
                            ? colorScheme.error
                            : colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: AppSpacing.extraSmall),
                      Text(
                        '${review.downvotes}',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: review.isUserDownvoted 
                              ? colorScheme.error
                              : colorScheme.onSurfaceVariant,
                          fontWeight: review.isUserDownvoted 
                              ? FontWeight.w600 
                              : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarFallback(ColorScheme colorScheme) {
    return Icon(
      Icons.person_rounded,
      color: colorScheme.onPrimaryContainer,
      size: 20,
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        if (difference.inMinutes == 0) {
          return 'Just now';
        } else {
          return '${difference.inMinutes}m ago';
        }
      } else {
        return '${difference.inHours}h ago';
      }
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '${weeks}w ago';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return '${months}mo ago';
    } else {
      final years = (difference.inDays / 365).floor();
      return '${years}y ago';
    }
  }
}