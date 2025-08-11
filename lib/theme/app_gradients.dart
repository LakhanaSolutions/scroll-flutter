import 'package:flutter/material.dart';

/// Reusable gradient configurations for the Scroll app
/// Provides consistent gradient patterns across the application
class AppGradients {
  // Prevent instantiation
  AppGradients._();

  /// Standard surface gradient from low to highest container
  /// Used for cards, containers, and elevated surfaces
  static LinearGradient surfaceGradient(ColorScheme colorScheme) {
    return LinearGradient(
      colors: [
        colorScheme.surfaceContainerLow,
        colorScheme.surfaceContainerHighest,
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  /// Subtle surface gradient with transparency
  /// Used for cards with subtle elevation effect
  static LinearGradient subtleSurfaceGradient(ColorScheme colorScheme) {
    return LinearGradient(
      colors: [
        colorScheme.surfaceContainer.withValues(alpha: 0.8),
        colorScheme.surfaceContainerHigh.withValues(alpha: 0.8),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  /// Primary gradient using primary colors
  /// Used for primary buttons and important elements
  static LinearGradient primaryGradient(ColorScheme colorScheme) {
    return LinearGradient(
      colors: [
        colorScheme.primary,
        colorScheme.primaryContainer,
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  /// Secondary gradient using secondary colors
  /// Used for secondary buttons and accent elements
  static LinearGradient secondaryGradient(ColorScheme colorScheme) {
    return LinearGradient(
      colors: [
        colorScheme.secondary,
        colorScheme.secondaryContainer,
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  /// Tertiary gradient using tertiary colors
  /// Used for tertiary elements and special highlights
  static LinearGradient tertiaryGradient(ColorScheme colorScheme) {
    return LinearGradient(
      colors: [
        colorScheme.tertiary,
        colorScheme.tertiaryContainer,
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  /// Error gradient using error colors
  /// Used for error states and warnings
  static LinearGradient errorGradient(ColorScheme colorScheme) {
    return LinearGradient(
      colors: [
        colorScheme.error,
        colorScheme.errorContainer,
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  /// Success gradient using green tones
  /// Used for success states and positive feedback
  static LinearGradient successGradient(ColorScheme colorScheme) {
    return LinearGradient(
      colors: [
        Colors.green.shade600,
        Colors.green.shade100,
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  /// Warning gradient using orange tones
  /// Used for warning states and caution indicators
  static LinearGradient warningGradient(ColorScheme colorScheme) {
    return LinearGradient(
      colors: [
        Colors.orange.shade600,
        Colors.orange.shade100,
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  /// Premium gradient with gold tones
  /// Used for premium features and special content
  static LinearGradient premiumGradient(ColorScheme colorScheme) {
    return LinearGradient(
      colors: [
        Colors.amber.shade600,
        Colors.amber.shade200,
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  /// Glass morphism gradient with transparency
  /// Used for modern glass-like effects
  static LinearGradient glassGradient(ColorScheme colorScheme) {
    return LinearGradient(
      colors: [
        colorScheme.surface.withValues(alpha: 0.1),
        colorScheme.surface.withValues(alpha: 0.05),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  /// Radial gradient for spotlight effects
  /// Used for focused content and highlights
  static RadialGradient spotlightGradient(ColorScheme colorScheme) {
    return RadialGradient(
      colors: [
        colorScheme.primaryContainer.withValues(alpha: 0.3),
        colorScheme.surface.withValues(alpha: 0.0),
      ],
      center: Alignment.center,
      radius: 0.8,
    );
  }

  /// Sweep gradient for circular elements
  /// Used for progress indicators and circular content
  static SweepGradient sweepGradient(ColorScheme colorScheme) {
    return SweepGradient(
      colors: [
        colorScheme.primary,
        colorScheme.secondary,
        colorScheme.tertiary,
        colorScheme.primary,
      ],
      center: Alignment.center,
    );
  }

  /// Gets the appropriate gradient for a subscription plan
  /// Used for plan cards and related UI elements based on plan type
  static LinearGradient planGradient(ColorScheme colorScheme, String planName) {
    if (planName.contains('Glimpse')) {
      // Free plan - subtle gradient
      return LinearGradient(
        colors: [
          colorScheme.surfaceContainer.withValues(alpha: 0.6),
          colorScheme.surfaceContainerHigh.withValues(alpha: 0.6),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    } else if (planName.contains('Premium')) {
      // Premium plan - vibrant gradient
      return LinearGradient(
        colors: [
          const Color(0xFF4CAF50).withValues(alpha: 0.1),
          const Color(0xFF4CAF50).withValues(alpha: 0.05),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    } else if (planName.contains('Scholar')) {
      // Scholar plan - premium gradient
      return LinearGradient(
        colors: [
          const Color(0xFF1976D2).withValues(alpha: 0.1),
          const Color(0xFF42A5F5).withValues(alpha: 0.05),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    } else {
      // Default gradient
      return surfaceGradient(colorScheme);
    }
  }
} 