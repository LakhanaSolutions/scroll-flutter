import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../theme/app_spacing.dart';
import '../../widgets/text/app_text.dart';

/// Loading screen with customizable message and animation
/// Supports both Lottie animations and traditional loading indicators
/// Follows app theme guidelines and is dark mode compatible
class LoadingScreen extends StatelessWidget {
  /// Creates a [LoadingScreen]
  const LoadingScreen({
    super.key,
    this.message = 'Loading...',
    this.showAppName = true,
    this.animationAsset,
    this.useCircularIndicator = false,
    this.backgroundColor,
    this.foregroundColor,
    this.onCancel,
    this.canCancel = false,
  });

  /// Loading message to display
  final String message;

  /// Whether to show the app name/logo
  final bool showAppName;

  /// Optional Lottie animation asset path
  final String? animationAsset;

  /// Whether to use circular progress indicator instead of animation
  final bool useCircularIndicator;

  /// Optional background color override
  final Color? backgroundColor;

  /// Optional foreground color override
  final Color? foregroundColor;

  /// Callback for cancel button press
  final VoidCallback? onCancel;

  /// Whether the loading can be cancelled
  final bool canCancel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: backgroundColor ?? colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            // Cancel button (if cancellable)
            if (canCancel && onCancel != null)
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.medium),
                  child: IconButton(
                    onPressed: onCancel,
                    icon: Icon(
                      Icons.close_rounded,
                      color: foregroundColor ?? colorScheme.onSurface,
                      size: AppSpacing.iconMedium,
                    ),
                  ),
                ),
              )
            else
              const SizedBox(height: AppSpacing.large),

            // Main content
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // App name/logo section
                  if (showAppName) ...[
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            colorScheme.primary,
                            colorScheme.primaryContainer,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
                        boxShadow: [
                          BoxShadow(
                            color: colorScheme.primary.withValues(alpha: 0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.menu_book_rounded,
                        color: colorScheme.onPrimary,
                        size: AppSpacing.iconLarge,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.medium),
                    AppTitleText(
                      'Scroll',
                      color: foregroundColor ?? colorScheme.onSurface,
                    ),
                    const SizedBox(height: AppSpacing.extraLarge),
                  ],

                  // Loading animation or indicator
                  _buildLoadingIndicator(context),

                  const SizedBox(height: AppSpacing.large),

                  // Loading message
                  AppBodyText(
                    message,
                    color: foregroundColor ?? colorScheme.onSurfaceVariant,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            // Bottom spacing
            const SizedBox(height: AppSpacing.extraLarge),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (animationAsset != null) {
      // Use Lottie animation
      return SizedBox(
        width: 120,
        height: 120,
        child: Lottie.asset(
          animationAsset!,
          fit: BoxFit.contain,
          repeat: true,
        ),
      );
    } else if (useCircularIndicator) {
      // Use circular progress indicator
      return SizedBox(
        width: 60,
        height: 60,
        child: CircularProgressIndicator(
          strokeWidth: 3,
          valueColor: AlwaysStoppedAnimation<Color>(
            foregroundColor ?? colorScheme.primary,
          ),
        ),
      );
    } else {
      // Use custom animated loading indicator
      return SizedBox(
        width: 120,
        height: 120,
        child: _AnimatedLoadingDots(
          color: foregroundColor ?? colorScheme.primary,
        ),
      );
    }
  }
}

/// Custom animated loading dots widget
class _AnimatedLoadingDots extends StatefulWidget {
  const _AnimatedLoadingDots({
    required this.color,
  });

  final Color color;

  @override
  State<_AnimatedLoadingDots> createState() => _AnimatedLoadingDotsState();
}

class _AnimatedLoadingDotsState extends State<_AnimatedLoadingDots>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    
    _controllers = List.generate(
      3,
      (index) => AnimationController(
        duration: const Duration(milliseconds: 600),
        vsync: this,
      ),
    );

    _animations = _controllers.map((controller) {
      return Tween<double>(begin: 0.3, end: 1.0).animate(
        CurvedAnimation(
          parent: controller,
          curve: Curves.easeInOut,
        ),
      );
    }).toList();

    // Start animations with staggered delays
    for (int i = 0; i < _controllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 200), () {
        if (mounted) {
          _controllers[i].repeat(reverse: true);
        }
      });
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        return AnimatedBuilder(
          animation: _animations[index],
          builder: (context, child) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: AppSpacing.small),
              child: Opacity(
                opacity: _animations[index].value,
                child: Transform.scale(
                  scale: _animations[index].value,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: widget.color,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}

/// Loading overlay that can be shown over existing content
class LoadingOverlay extends StatelessWidget {
  /// Creates a [LoadingOverlay]
  const LoadingOverlay({
    super.key,
    required this.isLoading,
    required this.child,
    this.message = 'Loading...',
    this.backgroundColor,
    this.useBlur = true,
  });

  /// Whether to show the loading overlay
  final bool isLoading;

  /// Child widget to show behind the overlay
  final Widget child;

  /// Loading message
  final String message;

  /// Optional background color for the overlay
  final Color? backgroundColor;

  /// Whether to use blur effect
  final bool useBlur;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Positioned.fill(
            child: Container(
              color: backgroundColor ?? 
                     Theme.of(context).colorScheme.surface.withValues(alpha: 0.8),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.large),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(
                        width: 40,
                        height: 40,
                        child: CircularProgressIndicator(strokeWidth: 3),
                      ),
                      const SizedBox(height: AppSpacing.medium),
                      AppBodyText(
                        message,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}