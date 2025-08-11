import 'package:flutter/material.dart';
import '../../theme/app_spacing.dart';
import '../../data/mock_data.dart';
import '../text/app_text.dart';
import '../cards/app_card.dart';

/// Individual review item widget
/// Shows reviewer name, rating, text, and upvote/downvote buttons
class ReviewItem extends StatelessWidget {
  final ReviewData review;
  final Function(String reviewId, bool isUpvote)? onVote;

   ReviewItem({
    super.key,
    required this.review,
    this.onVote,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isExpanded = _isExpanded ?? false;

    return AppCard(
      elevation: 0,
      // gradient: AppGradients.subtleSurfaceGradient(colorScheme),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with user info and rating
          Row(
            children: [
              // Simple user avatar
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
                              _buildAvatarFallback(review.userName),
                        ),
                      )
                    : _buildAvatarFallback(review.userName),
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
                        fontWeight: FontWeight.w500,
                        color: colorScheme.onSurface,
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
              
              // Simple rating stars
              Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(5, (index) {
                  final starValue = index + 1;
                  final isFilled = starValue <= review.rating;
                  
                  return Icon(
                    Icons.star_rounded,
                    color: isFilled 
                        ? colorScheme.primary
                        : colorScheme.outline.withValues(alpha: 0.3),
                    size: 16,
                  );
                }),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.medium),
          
          // Review text with read more functionality
          _buildReviewText(context, colorScheme),
          const SizedBox(height: AppSpacing.medium),
      
          // Simple vote buttons
          _buildHelpfulButtons(context, colorScheme, theme),
        ],
      ),
    );
  }

  bool? _isExpanded;
  
  Widget _buildReviewText(BuildContext context, ColorScheme colorScheme) {
    final theme = Theme.of(context);
    final isLongText = review.reviewText.length > 200;
    final shouldExpand = _isExpanded ?? false;
    
    return StatefulBuilder(
      builder: (context, setState) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppBodyText(
              review.reviewText,
              maxLines: shouldExpand ? null : 4,
              overflow: shouldExpand ? TextOverflow.visible : TextOverflow.ellipsis,
            ),
            if (isLongText)
              TextButton(
                onPressed: () {
                  setState(() {
                    _isExpanded = !shouldExpand;
                  });
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(shouldExpand ? 'Read Less' : 'Read More'),
                    Icon(
                      shouldExpand ? Icons.expand_less_rounded : Icons.expand_more_rounded,
                      size: 16,
                    ),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }
  
  Widget _buildHelpfulButtons(BuildContext context, ColorScheme colorScheme, ThemeData theme) {
    return StatefulBuilder(
      builder: (context, setState) {
        return Row(
          children: [
            AppCaptionText(
              'Was this helpful?',
              color: colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: AppSpacing.medium),
            
            // Simple upvote button
            TextButton.icon(
              onPressed: () {
                onVote?.call(review.id, true);
                setState(() {});
              },
              icon: Icon(
                Icons.thumb_up_rounded,
                size: 16,
                color: review.isUserUpvoted 
                    ? colorScheme.primary
                    : colorScheme.onSurfaceVariant,
              ),
              label: Text(
                '${review.upvotes}',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: review.isUserUpvoted 
                      ? colorScheme.primary
                      : colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            
            // Simple downvote button
            TextButton.icon(
              onPressed: () {
                onVote?.call(review.id, false);
                setState(() {});
              },
              icon: Icon(
                Icons.thumb_down_rounded,
                size: 16,
                color: review.isUserDownvoted 
                    ? colorScheme.error
                    : colorScheme.onSurfaceVariant,
              ),
              label: Text(
                '${review.downvotes}',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: review.isUserDownvoted 
                      ? colorScheme.error
                      : colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildAvatarFallback(String userName) {
    return Text(
      _getInitials(userName),
      style: TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    );
  }
  
  String _getInitials(String name) {
    final words = name.split(' ');
    if (words.length >= 2) {
      return '${words[0][0]}${words[1][0]}'.toUpperCase();
    } else {
      return name.substring(0, 1).toUpperCase();
    }
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