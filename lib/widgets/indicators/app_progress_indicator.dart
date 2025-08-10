import 'package:flutter/material.dart';
import '../../theme/app_spacing.dart';

/// Reusable progress indicator components for consistent progress displays
/// Handles various progress states: download progress, playback progress, completion status

/// Linear progress indicator with optional text
class AppLinearProgressIndicator extends StatelessWidget {
  final double progress; // 0.0 to 1.0
  final String? label;
  final String? description;
  final Color? progressColor;
  final Color? backgroundColor;
  final double height;
  final bool showPercentage;
  final EdgeInsets? padding;

  const AppLinearProgressIndicator({
    super.key,
    required this.progress,
    this.label,
    this.description,
    this.progressColor,
    this.backgroundColor,
    this.height = 4,
    this.showPercentage = false,
    this.padding,
  });

  /// Creates a progress indicator for download progress
  const AppLinearProgressIndicator.download({
    super.key,
    required this.progress,
    this.label,
    this.description,
    this.progressColor,
    this.backgroundColor,
    this.height = 4,
    this.showPercentage = true,
    this.padding,
  });

  /// Creates a progress indicator for playback progress
  const AppLinearProgressIndicator.playback({
    super.key,
    required this.progress,
    this.label,
    this.description,
    this.progressColor,
    this.backgroundColor,
    this.height = 6,
    this.showPercentage = false,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (label != null) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  label!,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (showPercentage)
                  Text(
                    '${(progress * 100).toInt()}%',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.extraSmall),
          ],
          ClipRRect(
            borderRadius: BorderRadius.circular(height / 2),
            child: LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              backgroundColor: backgroundColor ?? colorScheme.surfaceContainer,
              valueColor: AlwaysStoppedAnimation<Color>(
                progressColor ?? colorScheme.primary,
              ),
              minHeight: height,
            ),
          ),
          if (description != null) ...[
            const SizedBox(height: AppSpacing.extraSmall),
            Text(
              description!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontSize: 12,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Circular progress indicator with optional text in center
class AppCircularProgressIndicator extends StatelessWidget {
  final double? progress; // null for indeterminate, 0.0-1.0 for determinate
  final String? centerText;
  final double size;
  final double strokeWidth;
  final Color? progressColor;
  final Color? backgroundColor;
  final Widget? child;

  const AppCircularProgressIndicator({
    super.key,
    this.progress,
    this.centerText,
    this.size = 40,
    this.strokeWidth = 4,
    this.progressColor,
    this.backgroundColor,
    this.child,
  });

  /// Creates a circular progress indicator for downloads
  const AppCircularProgressIndicator.download({
    super.key,
    required this.progress,
    this.centerText,
    this.size = 40,
    this.strokeWidth = 4,
    this.progressColor,
    this.backgroundColor,
    this.child,
  });

  /// Creates an indeterminate circular progress indicator for loading
  const AppCircularProgressIndicator.loading({
    super.key,
    this.centerText,
    this.size = 40,
    this.strokeWidth = 4,
    this.progressColor,
    this.backgroundColor,
    this.child,
  }) : progress = null;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: progress,
            strokeWidth: strokeWidth,
            backgroundColor: backgroundColor ?? colorScheme.surfaceContainer,
            valueColor: AlwaysStoppedAnimation<Color>(
              progressColor ?? colorScheme.primary,
            ),
          ),
          if (child != null)
            child!
          else if (centerText != null)
            Text(
              centerText!,
              style: theme.textTheme.labelSmall?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.bold,
                fontSize: 10,
              ),
              textAlign: TextAlign.center,
            ),
        ],
      ),
    );
  }
}

/// Progress indicator specifically for completion status
class AppCompletionIndicator extends StatelessWidget {
  final double progress; // 0.0 to 1.0
  final bool isCompleted;
  final String? label;
  final IconData? completedIcon;
  final double size;

  const AppCompletionIndicator({
    super.key,
    required this.progress,
    this.isCompleted = false,
    this.label,
    this.completedIcon,
    this.size = 24,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (isCompleted) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            completedIcon ?? Icons.check_circle_rounded,
            color: Colors.green,
            size: size,
          ),
          if (label != null) ...[
            const SizedBox(width: AppSpacing.extraSmall),
            Text(
              label!,
              style: theme.textTheme.labelMedium?.copyWith(
                color: Colors.green,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      );
    }

    if (progress > 0) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppCircularProgressIndicator(
            progress: progress,
            size: size,
            strokeWidth: 3,
            centerText: '${(progress * 100).toInt()}%',
          ),
          if (label != null) ...[
            const SizedBox(width: AppSpacing.extraSmall),
            Text(
              label!,
              style: theme.textTheme.labelMedium?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      );
    }

    // Not started
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.play_circle_outline_rounded,
          color: colorScheme.onSurfaceVariant,
          size: size,
        ),
        if (label != null) ...[
          const SizedBox(width: AppSpacing.extraSmall),
          Text(
            label!,
            style: theme.textTheme.labelMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ],
    );
  }
}

/// Download progress indicator with pause/resume functionality
class AppDownloadProgress extends StatelessWidget {
  final double progress; // 0.0 to 1.0
  final bool isPaused;
  final VoidCallback? onPause;
  final VoidCallback? onResume;
  final VoidCallback? onCancel;
  final String? downloadedSize;
  final String? totalSize;

  const AppDownloadProgress({
    super.key,
    required this.progress,
    this.isPaused = false,
    this.onPause,
    this.onResume,
    this.onCancel,
    this.downloadedSize,
    this.totalSize,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(
              child: AppLinearProgressIndicator.download(
                progress: progress,
                label: isPaused ? 'Paused' : 'Downloading...',
                showPercentage: true,
              ),
            ),
            const SizedBox(width: AppSpacing.small),
            if (isPaused && onResume != null)
              IconButton(
                icon: Icon(Icons.play_arrow_rounded, color: colorScheme.primary),
                onPressed: onResume,
                iconSize: 20,
                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
              )
            else if (!isPaused && onPause != null)
              IconButton(
                icon: Icon(Icons.pause_rounded, color: colorScheme.primary),
                onPressed: onPause,
                iconSize: 20,
                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
              ),
            if (onCancel != null)
              IconButton(
                icon: Icon(Icons.close_rounded, color: colorScheme.error),
                onPressed: onCancel,
                iconSize: 20,
                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
              ),
          ],
        ),
        if (downloadedSize != null && totalSize != null) ...[
          const SizedBox(height: AppSpacing.extraSmall),
          Text(
            '$downloadedSize / $totalSize',
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontSize: 11,
            ),
          ),
        ],
      ],
    );
  }
}