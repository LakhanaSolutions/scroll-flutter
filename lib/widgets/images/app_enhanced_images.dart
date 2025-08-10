import 'package:flutter/material.dart';
import '../../data/mock_data.dart';
import '../../theme/app_spacing.dart';
import '../indicators/app_badges.dart';
import 'app_image.dart';

/// Enhanced image widgets with specialized patterns and fallbacks

/// Book cover with gradient background fallback and availability badge
class AppBookCoverWithBadge extends StatelessWidget {
  final String? imageUrl;
  final double width;
  final double height;
  final AvailabilityType? availability;
  final bool showAvailabilityBadge;
  final Color? backgroundColor;
  final Gradient? gradient;
  final Widget? overlay;
  final VoidCallback? onTap;

  const AppBookCoverWithBadge({
    super.key,
    this.imageUrl,
    required this.width,
    required this.height,
    this.availability,
    this.showAvailabilityBadge = true,
    this.backgroundColor,
    this.gradient,
    this.overlay,
    this.onTap,
  });

  /// Creates a book cover from ContentItemData
  factory AppBookCoverWithBadge.fromContent({
    Key? key,
    required ContentItemData content,
    required double width,
    required double height,
    bool showAvailabilityBadge = true,
    Widget? overlay,
    VoidCallback? onTap,
  }) {
    return AppBookCoverWithBadge(
      key: key,
      imageUrl: content.coverUrl,
      width: width,
      height: height,
      availability: content.availability,
      showAvailabilityBadge: showAvailabilityBadge,
      overlay: overlay,
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    Widget bookCover = Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: gradient ?? LinearGradient(
          colors: [
            colorScheme.primary,
            colorScheme.primaryContainer,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
      ),
      child: imageUrl != null && imageUrl!.isNotEmpty
          ? ClipRRect(
              borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
              child: Image.network(
                imageUrl!,
                width: width,
                height: height,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return _buildGradientFallback(context);
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return _buildLoadingFallback(context);
                },
              ),
            )
          : _buildGradientFallback(context),
    );

    // Add overlay if provided
    if (overlay != null) {
      bookCover = Stack(
        children: [
          bookCover,
          Positioned.fill(child: overlay!),
        ],
      );
    }

    // Add availability badge
    if (showAvailabilityBadge && availability != null) {
      bookCover = Stack(
        children: [
          bookCover,
          Positioned(
            top: AppSpacing.small,
            right: AppSpacing.small,
            child: AppAvailabilityBadge(availability: availability!),
          ),
        ],
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: bookCover,
    );
  }

  Widget _buildGradientFallback(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: gradient ?? LinearGradient(
          colors: [
            colorScheme.primary,
            colorScheme.primaryContainer,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
      ),
      child: Center(
        child: Icon(
          Icons.menu_book_rounded,
          color: colorScheme.onPrimary,
          size: width * 0.4,
        ),
      ),
    );
  }

  Widget _buildLoadingFallback(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
      ),
      child: Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
        ),
      ),
    );
  }
}

/// Avatar with status indicator (online, following, etc.)
class AppAvatarWithStatus extends StatelessWidget {
  final String? imageUrl;
  final IconData fallbackIcon;
  final double size;
  final Color? backgroundColor;
  final Color? iconColor;
  final bool showOnlineStatus;
  final bool isOnline;
  final bool showFollowingStatus;
  final bool isFollowing;
  final VoidCallback? onTap;

  const AppAvatarWithStatus({
    super.key,
    this.imageUrl,
    required this.fallbackIcon,
    required this.size,
    this.backgroundColor,
    this.iconColor,
    this.showOnlineStatus = false,
    this.isOnline = false,
    this.showFollowingStatus = false,
    this.isFollowing = false,
    this.onTap,
  });

  /// Creates an avatar for an author with following status
  factory AppAvatarWithStatus.author({
    Key? key,
    required AuthorData author,
    required double size,
    bool showFollowingStatus = true,
    VoidCallback? onTap,
  }) {
    return AppAvatarWithStatus(
      key: key,
      imageUrl: author.imageUrl,
      fallbackIcon: Icons.person_rounded,
      size: size,
      showFollowingStatus: showFollowingStatus,
      isFollowing: author.isFollowing,
      onTap: onTap,
    );
  }

  /// Creates an avatar for a narrator with following status
  factory AppAvatarWithStatus.narrator({
    Key? key,
    required NarratorData narrator,
    required double size,
    bool showFollowingStatus = true,
    VoidCallback? onTap,
  }) {
    return AppAvatarWithStatus(
      key: key,
      imageUrl: narrator.imageUrl,
      fallbackIcon: Icons.mic_rounded,
      size: size,
      showFollowingStatus: showFollowingStatus,
      isFollowing: narrator.isFollowing,
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    Widget avatar = AppCircularImage(
      imageUrl: imageUrl,
      fallbackIcon: fallbackIcon,
      size: size,
      backgroundColor: backgroundColor,
      iconColor: iconColor,
    );

    // Add status indicators
    if (showOnlineStatus || showFollowingStatus) {
      avatar = Stack(
        children: [
          avatar,
          if (showOnlineStatus)
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: size * 0.25,
                height: size * 0.25,
                decoration: BoxDecoration(
                  color: isOnline ? Colors.green : colorScheme.surfaceContainerHighest,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: colorScheme.surface,
                    width: 2,
                  ),
                ),
              ),
            ),
          if (showFollowingStatus && isFollowing)
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                width: size * 0.3,
                height: size * 0.3,
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: colorScheme.surface,
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.check_rounded,
                    color: colorScheme.onPrimary,
                    size: size * 0.15,
                  ),
                ),
              ),
            ),
        ],
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: avatar,
    );
  }
}

/// Podcast/content thumbnail with play overlay
class AppContentThumbnail extends StatelessWidget {
  final String? imageUrl;
  final double width;
  final double height;
  final ContentType contentType;
  final bool showPlayOverlay;
  final bool isPlaying;
  final VoidCallback? onPlayPressed;
  final Widget? statusWidget;

  const AppContentThumbnail({
    super.key,
    this.imageUrl,
    required this.width,
    required this.height,
    required this.contentType,
    this.showPlayOverlay = true,
    this.isPlaying = false,
    this.onPlayPressed,
    this.statusWidget,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    IconData fallbackIcon;
    switch (contentType) {
      case ContentType.book:
        fallbackIcon = Icons.menu_book_rounded;
        break;
      case ContentType.podcast:
        fallbackIcon = Icons.podcasts_rounded;
        break;
    }

    Widget thumbnail = AppImage(
      imageUrl: imageUrl,
      fallbackIcon: fallbackIcon,
      width: width,
      height: height,
      borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
    );

    // Add overlays
    List<Widget> overlayWidgets = [thumbnail];

    // Play overlay
    if (showPlayOverlay) {
      overlayWidgets.add(
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
            ),
            child: Center(
              child: GestureDetector(
                onTap: onPlayPressed,
                child: Container(
                  width: width * 0.25,
                  height: width * 0.25,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.9),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                    color: colorScheme.primary,
                    size: width * 0.15,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }

    // Status widget (progress, download status, etc.)
    if (statusWidget != null) {
      overlayWidgets.add(
        Positioned(
          bottom: AppSpacing.small,
          left: AppSpacing.small,
          right: AppSpacing.small,
          child: statusWidget!,
        ),
      );
    }

    return Stack(children: overlayWidgets);
  }
}

/// Category icon with gradient background
class AppCategoryIcon extends StatelessWidget {
  final String? iconPath;
  final IconData? iconData;
  final double size;
  final Color? backgroundColor;
  final Color? iconColor;
  final Gradient? gradient;

  const AppCategoryIcon({
    super.key,
    this.iconPath,
    this.iconData,
    required this.size,
    this.backgroundColor,
    this.iconColor,
    this.gradient,
  });

  /// Creates a category icon from CategoryData
  factory AppCategoryIcon.fromCategory({
    Key? key,
    required CategoryData category,
    required double size,
    Color? backgroundColor,
    Color? iconColor,
    Gradient? gradient,
  }) {
    return AppCategoryIcon(
      key: key,
      iconPath: category.iconPath,
      iconData: category.icon,
      size: size,
      backgroundColor: backgroundColor,
      iconColor: iconColor,
      gradient: gradient,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: gradient,
        color: backgroundColor ?? colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
      ),
      child: Center(
        child: iconPath != null
            ? Image.asset(
                iconPath!,
                width: size * 0.6,
                height: size * 0.6,
                color: iconColor ?? colorScheme.onPrimaryContainer,
              )
            : Icon(
                iconData ?? Icons.category_rounded,
                color: iconColor ?? colorScheme.onPrimaryContainer,
                size: size * 0.6,
              ),
      ),
    );
  }
}