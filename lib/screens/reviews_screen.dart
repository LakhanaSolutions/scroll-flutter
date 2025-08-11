import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scroll/theme/app_gradients.dart';
import '../data/mock_data.dart';
import '../theme/app_spacing.dart';
import '../widgets/text/app_text.dart';
import '../widgets/app_bar/app_app_bar.dart';
import '../widgets/cards/app_card.dart';
import '../widgets/reviews/review_item.dart';
import '../widgets/reviews/my_review_section.dart';

/// Dedicated Reviews page showing all reviews for content
/// Can be accessed from Playlist, Author, or Narrator pages
class ReviewsScreen extends ConsumerStatefulWidget {
  final String contentType; // 'playlist', 'author', 'narrator'
  final String contentId;
  final String contentTitle;

  const ReviewsScreen({
    super.key,
    required this.contentType,
    required this.contentId,
    required this.contentTitle,
  });

  @override
  ConsumerState<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends ConsumerState<ReviewsScreen> {
  late ReviewSummaryData reviewSummary;
  late List<ReviewData> reviews;
  String sortBy = 'newest'; // 'newest', 'oldest', 'highest', 'lowest', 'helpful'

  @override
  void initState() {
    super.initState();
    _loadReviews();
  }

  void _loadReviews() {
    reviewSummary = MockData.getReviewSummary(widget.contentId);
    reviews = MockData.getMockReviews(widget.contentId);
    _sortReviews();
  }

  void _sortReviews() {
    switch (sortBy) {
      case 'newest':
        reviews.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case 'oldest':
        reviews.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        break;
      case 'highest':
        reviews.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case 'lowest':
        reviews.sort((a, b) => a.rating.compareTo(b.rating));
        break;
      case 'helpful':
        reviews.sort((a, b) => (b.upvotes - b.downvotes).compareTo(a.upvotes - a.downvotes));
        break;
    }
  }

  void _changeSortOrder(String newSortBy) {
    setState(() {
      sortBy = newSortBy;
      _sortReviews();
    });
  }

  void _onReviewVote(String reviewId, bool isUpvote) {
    setState(() {
      final reviewIndex = reviews.indexWhere((r) => r.id == reviewId);
      if (reviewIndex != -1) {
        final review = reviews[reviewIndex];
        // Update vote counts (mock implementation)
        if (isUpvote && !review.isUserUpvoted) {
          reviews[reviewIndex] = ReviewData(
            id: review.id,
            userId: review.userId,
            userName: review.userName,
            userAvatar: review.userAvatar,
            rating: review.rating,
            reviewText: review.reviewText,
            createdAt: review.createdAt,
            upvotes: review.upvotes + 1,
            downvotes: review.isUserDownvoted ? review.downvotes - 1 : review.downvotes,
            isUserUpvoted: true,
            isUserDownvoted: false,
            isOwnReview: review.isOwnReview,
          );
        } else if (!isUpvote && !review.isUserDownvoted) {
          reviews[reviewIndex] = ReviewData(
            id: review.id,
            userId: review.userId,
            userName: review.userName,
            userAvatar: review.userAvatar,
            rating: review.rating,
            reviewText: review.reviewText,
            createdAt: review.createdAt,
            upvotes: review.isUserUpvoted ? review.upvotes - 1 : review.upvotes,
            downvotes: review.downvotes + 1,
            isUserUpvoted: false,
            isUserDownvoted: true,
            isOwnReview: review.isOwnReview,
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppAppBar(
        title: 'Reviews',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.medium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Content info header
            _buildContentHeader(context, colorScheme),
            const SizedBox(height: AppSpacing.large),
            
            // Rating summary
            _buildRatingSummary(context, colorScheme),
            const SizedBox(height: AppSpacing.large),
            
            // My Review section
            MyReviewSection(
              contentId: widget.contentId,
              contentType: widget.contentType,
              userReview: reviewSummary.userReview,
              onReviewSubmitted: () {
                // Refresh reviews when user submits/edits a review
                _loadReviews();
                setState(() {});
              },
            ),
            const SizedBox(height: AppSpacing.large),
            
            // All Reviews section
            _buildAllReviewsSection(context, colorScheme),
          ],
        ),
      ),
    );
  }

  Widget _buildContentHeader(BuildContext context, ColorScheme colorScheme) {
    return AppCard(
      elevation: 0,
      gradient: AppGradients.subtleSurfaceGradient(colorScheme),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.medium),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
            ),
            child: Icon(
              _getContentIcon(),
              color: colorScheme.onPrimaryContainer,
              size: AppSpacing.iconLarge,
            ),
          ),
          const SizedBox(width: AppSpacing.medium),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppSubtitleText(
                  widget.contentTitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.extraSmall),
                AppCaptionText(
                  'Reviews for this ${widget.contentType.toLowerCase()}',
                  color: colorScheme.onSurfaceVariant,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getContentIcon() {
    switch (widget.contentType.toLowerCase()) {
      case 'playlist':
        return Icons.playlist_play_rounded;
      case 'author':
        return Icons.person_rounded;
      case 'narrator':
        return Icons.record_voice_over_rounded;
      default:
        return Icons.book_rounded;
    }
  }

  Widget _buildRatingSummary(BuildContext context, ColorScheme colorScheme) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppSubtitleText('Overall Rating'),
          const SizedBox(height: AppSpacing.medium),
          
          Row(
            children: [
              // Large rating display
              Column(
                children: [
                  AppTitleText(
                    reviewSummary.averageRating.toStringAsFixed(1),
                    color: colorScheme.primary,
                  ),
                  const SizedBox(height: AppSpacing.small),
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
                  const SizedBox(height: AppSpacing.small),
                  AppCaptionText(
                    '${reviewSummary.totalReviews} ${reviewSummary.totalReviews == 1 ? 'review' : 'reviews'}',
                    color: colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
              const SizedBox(width: AppSpacing.large),
              
              // Rating distribution
              Expanded(
                child: Column(
                  children: List.generate(5, (index) {
                    final rating = 5 - index; // 5, 4, 3, 2, 1
                    final count = reviewSummary.ratingDistribution[rating] ?? 0;
                    final percentage = reviewSummary.totalReviews > 0 
                        ? count / reviewSummary.totalReviews 
                        : 0.0;
                    
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Row(
                        children: [
                          AppCaptionText(
                            '$rating',
                            color: colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(width: AppSpacing.small),
                          Icon(
                            Icons.star_rounded,
                            color: Colors.amber.shade600,
                            size: 16,
                          ),
                          const SizedBox(width: AppSpacing.small),
                          Expanded(
                            child: LinearProgressIndicator(
                              value: percentage,
                              backgroundColor: colorScheme.surfaceContainerHighest,
                              valueColor: AlwaysStoppedAnimation(Colors.amber.shade600),
                              minHeight: 6,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.small),
                          SizedBox(
                            width: 30,
                            child: AppCaptionText(
                              '$count',
                              color: colorScheme.onSurfaceVariant,
                              textAlign: TextAlign.end,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAllReviewsSection(BuildContext context, ColorScheme colorScheme) {
    // Filter out user's own review as it's shown in MyReviewSection
    final otherReviews = reviews.where((r) => !r.isOwnReview).toList();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppSubtitleText('All Reviews (${otherReviews.length})'),
            TextButton.icon(
              onPressed: () => _showSortDialog(context),
              icon: Icon(
                Icons.sort_rounded,
                size: AppSpacing.iconSmall,
                color: colorScheme.primary,
              ),
              label: Text(
                _getSortLabel(),
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: colorScheme.primary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.medium),
        
        // Reviews list
        if (otherReviews.isEmpty)
          AppCard(
            elevation: 0,
            child: Center(
              child: Column(
                children: [
                  Icon(
                    Icons.rate_review_outlined,
                    size: AppSpacing.iconExtraLarge,
                    color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                  ),
                  const SizedBox(height: AppSpacing.medium),
                  AppBodyText(
                    'No reviews yet',
                    color: colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(height: AppSpacing.small),
                  AppCaptionText(
                    'Be the first to share your thoughts!',
                    color: colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
            ),
          )
        else
          ...otherReviews.map((review) => Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.medium),
            child: ReviewItem(
              review: review,
              onVote: _onReviewVote,
            ),
          )),
      ],
    );
  }

  void _showSortDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sort Reviews'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildSortOption('newest', 'Newest First'),
            _buildSortOption('oldest', 'Oldest First'),
            _buildSortOption('highest', 'Highest Rated'),
            _buildSortOption('lowest', 'Lowest Rated'),
            _buildSortOption('helpful', 'Most Helpful'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  Widget _buildSortOption(String value, String label) {
    return RadioListTile<String>(
      title: Text(label),
      value: value,
      groupValue: sortBy,
      onChanged: (newValue) {
        if (newValue != null) {
          Navigator.of(context).pop();
          _changeSortOrder(newValue);
        }
      },
    );
  }

  String _getSortLabel() {
    switch (sortBy) {
      case 'newest':
        return 'Newest';
      case 'oldest':
        return 'Oldest';
      case 'highest':
        return 'Highest Rated';
      case 'lowest':
        return 'Lowest Rated';
      case 'helpful':
        return 'Most Helpful';
      default:
        return 'Sort';
    }
  }
}