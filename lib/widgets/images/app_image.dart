import 'package:flutter/material.dart';
import '../../theme/app_spacing.dart';

/// App image widget that displays images with fallback to icons
/// Supports both network and asset images with proper error handling
class AppImage extends StatelessWidget {
  final String? imageUrl;
  final IconData fallbackIcon;
  final double width;
  final double height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final Color? iconColor;
  final Color? backgroundColor;
  final double? iconSize;

  const AppImage({
    super.key,
    this.imageUrl,
    required this.fallbackIcon,
    required this.width,
    required this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.iconColor,
    this.backgroundColor,
    this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final effectiveBorderRadius = borderRadius ?? BorderRadius.circular(AppSpacing.radiusMedium);

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor ?? colorScheme.surfaceContainer,
        borderRadius: effectiveBorderRadius,
      ),
      child: ClipRRect(
        borderRadius: effectiveBorderRadius,
        child: imageUrl != null && imageUrl!.isNotEmpty
            ? Image.network(
                imageUrl!,
                width: width,
                height: height,
                fit: fit,
                errorBuilder: (context, error, stackTrace) {
                  return _buildFallbackIcon(context, colorScheme);
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  }
                  return _buildLoadingWidget(context, colorScheme);
                },
              )
            : _buildFallbackIcon(context, colorScheme),
      ),
    );
  }

  Widget _buildFallbackIcon(BuildContext context, ColorScheme colorScheme) {
    return Container(
      width: width,
      height: height,
      color: backgroundColor ?? colorScheme.surfaceContainer,
      child: Center(
        child: Icon(
          fallbackIcon,
          color: iconColor ?? colorScheme.onSurfaceVariant,
          size: iconSize ?? (width * 0.4),
        ),
      ),
    );
  }

  Widget _buildLoadingWidget(BuildContext context, ColorScheme colorScheme) {
    return Container(
      width: width,
      height: height,
      color: backgroundColor ?? colorScheme.surfaceContainer,
      child: Center(
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(
              colorScheme.primary,
            ),
          ),
        ),
      ),
    );
  }
}

/// Circular app image variant for avatars
class AppCircularImage extends StatelessWidget {
  final String? imageUrl;
  final IconData fallbackIcon;
  final double size;
  final Color? iconColor;
  final Color? backgroundColor;
  final double? iconSize;

  const AppCircularImage({
    super.key,
    this.imageUrl,
    required this.fallbackIcon,
    required this.size,
    this.iconColor,
    this.backgroundColor,
    this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    return AppImage(
      imageUrl: imageUrl,
      fallbackIcon: fallbackIcon,
      width: size,
      height: size,
      borderRadius: BorderRadius.circular(size / 2),
      iconColor: iconColor,
      backgroundColor: backgroundColor,
      iconSize: iconSize,
    );
  }
}

/// Square app image variant for book covers
class AppBookCover extends StatelessWidget {
  final String? imageUrl;
  final double width;
  final double height;
  final Color? backgroundColor;

  const AppBookCover({
    super.key,
    this.imageUrl,
    required this.width,
    required this.height,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AppImage(
      imageUrl: imageUrl,
      fallbackIcon: Icons.menu_book_rounded,
      width: width,
      height: height,
      borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
      backgroundColor: backgroundColor ?? colorScheme.primaryContainer,
      iconColor: colorScheme.onPrimaryContainer,
    );
  }
}