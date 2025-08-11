import 'package:flutter/material.dart';
import '../../data/mock_data.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_gradients.dart';
import '../cards/app_card.dart';
import '../indicators/app_badges.dart';

/// Reusable content cover widget with availability badge
/// Extracted from playlist screen to follow DRY principles
class ContentCover extends StatelessWidget {
  final ContentItemData content;
  final double width;
  final double height;
  final double? elevation;
  final double? borderRadius;
  final bool showAvailabilityBadge;

  const ContentCover({
    super.key,
    required this.content,
    required this.width,
    required this.height,
    this.elevation,
    this.borderRadius,
    this.showAvailabilityBadge = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SizedBox(
      width: width,
      height: height,
      child: AppCard(
        padding: EdgeInsets.zero,
        elevation: elevation,
        borderRadius: BorderRadius.circular(borderRadius ?? AppSpacing.radiusMedium),
        gradient: content.type == ContentType.book 
            ? AppGradients.primaryGradient(colorScheme)
            : AppGradients.warningGradient(colorScheme),
        child: Stack(
          children: [
            // Centered icon
            Center(
              child: Icon(
                _getContentTypeIcon(content.type),
                color: Colors.white,
                size: _getIconSize(),
              ),
            ),
            // Availability badge
            if (showAvailabilityBadge)
              Positioned(
                top: AppSpacing.elevationNone,
                left: 0,
                right: 0,
                child: Center(
                  child: AppAvailabilityBadge(
                    availability: content.availability,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  IconData _getContentTypeIcon(ContentType type) {
    switch (type) {
      case ContentType.book:
        return Icons.menu_book_rounded;
      case ContentType.podcast:
        return Icons.podcasts_rounded;
    }
  }

  double _getIconSize() {
    // Scale icon size based on cover dimensions
    final minDimension = width < height ? width : height;
    if (minDimension <= 60) return AppSpacing.iconSmall;
    if (minDimension <= 100) return AppSpacing.iconMedium;
    return AppSpacing.iconLarge;
  }
}