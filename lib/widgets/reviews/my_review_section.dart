import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scroll/theme/app_gradients.dart';
import '../../theme/app_spacing.dart';
import '../../data/mock_data.dart';
import '../text/app_text.dart';
import '../buttons/app_buttons.dart';
import '../cards/app_card.dart';
import '../inputs/app_text_field.dart';

/// "My Review" section at the top of reviews list
/// Shows user's existing review with edit option or input for new review
class MyReviewSection extends ConsumerStatefulWidget {
  final String contentId;
  final String contentType;
  final ReviewData? userReview;
  final VoidCallback? onReviewSubmitted;

  const MyReviewSection({
    super.key,
    required this.contentId,
    required this.contentType,
    this.userReview,
    this.onReviewSubmitted,
  });

  @override
  ConsumerState<MyReviewSection> createState() => _MyReviewSectionState();
}

class _MyReviewSectionState extends ConsumerState<MyReviewSection> {
  final TextEditingController _reviewController = TextEditingController();
  double _selectedRating = 0.0;
  bool _isEditing = false;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    if (widget.userReview != null) {
      _reviewController.text = widget.userReview!.reviewText;
      _selectedRating = widget.userReview!.rating;
    }
  }

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  void _startEditing() {
    setState(() {
      _isEditing = true;
      _isExpanded = true;
    });
  }

  void _cancelEditing() {
    setState(() {
      _isEditing = false;
      _isExpanded = false;
      if (widget.userReview != null) {
        _reviewController.text = widget.userReview!.reviewText;
        _selectedRating = widget.userReview!.rating;
      } else {
        _reviewController.clear();
        _selectedRating = 0.0;
      }
    });
  }

  void _submitReview() {
    if (_selectedRating == 0.0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a rating'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (_reviewController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please write a review'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Check if user can review (50% listening restriction)
    final listeningProgress = MockData.getListeningProgress(widget.contentId);
    if (!MockData.canUserReview(widget.contentId, listeningProgress)) {
      _showListeningRestrictionDialog();
      return;
    }

    // Mock submission - in real app this would call an API
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(widget.userReview != null ? 'Review updated!' : 'Review submitted!'),
        backgroundColor: Colors.green,
      ),
    );

    setState(() {
      _isEditing = false;
      _isExpanded = false;
    });

    widget.onReviewSubmitted?.call();
  }

  void _showListeningRestrictionDialog() {
    final listeningProgress = MockData.getListeningProgress(widget.contentId);
    final percentageListened = (listeningProgress * 100).toInt();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Unable to Review'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('You need to listen to more than 50% of the content before you can leave a review.'),
            const SizedBox(height: AppSpacing.medium),
            Row(
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  color: Theme.of(context).colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: AppSpacing.small),
                Text(
                  'Current progress: $percentageListened%',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final hasExistingReview = widget.userReview != null;

    return AppCard(
      elevation: 0,
      gradient: AppGradients.subtleSurfaceGradient(colorScheme),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(
                Icons.rate_review_rounded,
                color: colorScheme.primary,
                size: AppSpacing.iconMedium,
              ),
              const SizedBox(width: AppSpacing.medium),
              Expanded(
                child: AppSubtitleText(
                  hasExistingReview ? 'My Review' : 'Write a Review',
                ),
              ),
              if (hasExistingReview && !_isEditing)
                TextButton(
                  onPressed: _startEditing,
                  child: const Text('Edit'),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.medium),
          
          // Existing review display or edit form
          if (hasExistingReview && !_isEditing)
            _buildExistingReview(colorScheme)
          else
            _buildReviewForm(colorScheme),
        ],
      ),
    );
  }

  Widget _buildExistingReview(ColorScheme colorScheme) {
    final review = widget.userReview!;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Rating display
        Row(
          children: [
            AppBodyText('Your rating: '),
            ...List.generate(5, (index) {
              final starValue = index + 1;
              final isFilled = starValue <= review.rating;
              final isHalfFilled = starValue > review.rating && 
                                   starValue - 0.5 <= review.rating;
              
              return Icon(
                isHalfFilled ? Icons.star_half_rounded : Icons.star_rounded,
                color: isFilled || isHalfFilled 
                    ? Colors.amber.shade600 
                    : colorScheme.outline.withValues(alpha: 0.3),
                size: 20,
              );
            }),
            const SizedBox(width: AppSpacing.small),
            AppBodyText(
              '(${review.rating.toStringAsFixed(1)})',
              color: colorScheme.onSurfaceVariant,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.medium),
        
        // Review text
        AppBodyText(
          review.reviewText,
          maxLines: _isExpanded ? null : 3,
          overflow: _isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
        ),
        
        // Expand/collapse button for long reviews
        if (review.reviewText.length > 150)
          TextButton(
            onPressed: () => setState(() => _isExpanded = !_isExpanded),
            child: Text(_isExpanded ? 'Show less' : 'Show more'),
          ),
        
        const SizedBox(height: AppSpacing.small),
        
        // Review metadata
        AppCaptionText(
          'Posted ${_formatDate(review.createdAt)}',
          color: colorScheme.onSurfaceVariant,
        ),
      ],
    );
  }

  Widget _buildReviewForm(ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Rating selector
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppBodyText('Rating *'),
            const SizedBox(height: AppSpacing.small),
            Row(
              children: List.generate(5, (index) {
                final starValue = index + 1.0;
                final isFilled = starValue <= _selectedRating;
                
                return GestureDetector(
                  onTap: () => setState(() => _selectedRating = starValue),
                  child: Padding(
                    padding: const EdgeInsets.only(right: AppSpacing.small),
                    child: Icon(
                      Icons.star_rounded,
                      color: isFilled 
                          ? Colors.amber.shade600 
                          : colorScheme.outline.withValues(alpha: 0.3),
                      size: AppSpacing.iconLarge,
                    ),
                  ),
                );
              }),
            ),
            if (_selectedRating > 0)
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.small),
                child: AppCaptionText(
                  '${_selectedRating.toStringAsFixed(1)} ${_getRatingLabel(_selectedRating)}',
                  color: colorScheme.primary,
                ),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.large),
        
        // Review text input
        AppTextField(
          controller: _reviewController,
          labelText: 'Your Review *',
          hintText: 'Share your thoughts about this ${widget.contentType.toLowerCase()}...',
          maxLines: 4,
          fillColor: colorScheme.surfaceContainerLow,
        ),
        const SizedBox(height: AppSpacing.large),
        
        // Action buttons
        Row(
          children: [
            if (_isEditing) ...[
              Expanded(
                child: AppSecondaryButton(
                  onPressed: _cancelEditing,
                  child: const Text('Cancel'),
                ),
              ),
              const SizedBox(width: AppSpacing.medium),
            ],
            Expanded(
              child: AppPrimaryButton(
                onPressed: _submitReview,
                child: Text(widget.userReview != null ? 'Update Review' : 'Submit Review'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _getRatingLabel(double rating) {
    if (rating >= 4.5) return '★ Excellent';
    if (rating >= 3.5) return '★ Good';
    if (rating >= 2.5) return '★ Average';
    if (rating >= 1.5) return '★ Poor';
    return '★ Terrible';
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'today';
    } else if (difference.inDays == 1) {
      return 'yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks ${weeks == 1 ? 'week' : 'weeks'} ago';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return '$months ${months == 1 ? 'month' : 'months'} ago';
    } else {
      final years = (difference.inDays / 365).floor();
      return '$years ${years == 1 ? 'year' : 'years'} ago';
    }
  }
}