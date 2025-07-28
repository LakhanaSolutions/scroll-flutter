import 'package:flutter/material.dart';

/// Comprehensive spacing system for the Siraaj app
/// Implements consistent spacing values following 8px grid system
class AppSpacing {
  // Prevent instantiation
  AppSpacing._();

  // ====== Base Spacing Unit ======
  
  /// Base spacing unit (8px) - all spacing should be multiples of this
  static const double baseUnit = 8.0;

  // ====== Spacing Constants ======
  
  /// Extra small spacing - 4px
  static const double extraSmall = baseUnit * 0.5;
  
  /// Small spacing - 8px
  static const double small = baseUnit;
  
  /// Medium spacing - 16px
  static const double medium = baseUnit * 2;
  
  /// Large spacing - 24px
  static const double large = baseUnit * 3;
  
  /// Extra large spacing - 32px
  static const double extraLarge = baseUnit * 4;
  
  /// Double extra large spacing - 40px
  static const double doubleExtraLarge = baseUnit * 5;
  
  /// Triple extra large spacing - 48px
  static const double tripleExtraLarge = baseUnit * 6;

  // ====== Semantic Spacing ======
  
  /// Spacing between closely related elements
  static const double related = small;
  
  /// Spacing between unrelated elements
  static const double unrelated = medium;
  
  /// Spacing between sections
  static const double section = large;
  
  /// Spacing between major layout blocks
  static const double block = extraLarge;
  
  /// Spacing for page margins
  static const double pageMargin = medium;
  
  /// Spacing for card padding
  static const double cardPadding = medium;
  
  /// Spacing for dialog padding
  static const double dialogPadding = large;
  
  /// Spacing for button padding horizontal
  static const double buttonPaddingHorizontal = large;
  
  /// Spacing for button padding vertical
  static const double buttonPaddingVertical = medium;
  
  /// Spacing for list item padding
  static const double listItemPadding = medium;
  
  /// Spacing for form field gap
  static const double formFieldGap = medium;

  // ====== Border Radius Constants ======
  
  /// Extra small border radius - 4px
  static const double radiusExtraSmall = baseUnit * 0.5;
  
  /// Small border radius - 8px
  static const double radiusSmall = baseUnit;
  
  /// Medium border radius - 12px
  static const double radiusMedium = baseUnit * 1.5;
  
  /// Large border radius - 16px
  static const double radiusLarge = baseUnit * 3;
  
  /// Extra large border radius - 24px
  static const double radiusExtraLarge = baseUnit * 3;
  
  /// Circular border radius - 999px (for circular elements)
  static const double radiusCircular = 999.0;

  // ====== Elevation Constants ======
  
  /// No elevation
  static const double elevationNone = 0.0;
  
  /// Small elevation - 1dp
  static const double elevationSmall = 1.0;
  
  /// Medium elevation - 2dp
  static const double elevationMedium = 2.0;
  
  /// Large elevation - 4dp
  static const double elevationLarge = 4.0;
  
  /// Extra large elevation - 8dp
  static const double elevationExtraLarge = 8.0;
  
  /// Maximum elevation - 16dp
  static const double elevationMax = 16.0;

  // ====== Layout Constants ======
  
  /// Maximum content width for readability
  static const double maxContentWidth = 1200.0;
  
  /// Maximum card width
  static const double maxCardWidth = 400.0;
  
  /// Maximum dialog width
  static const double maxDialogWidth = 560.0;
  
  /// Maximum form width
  static const double maxFormWidth = 480.0;
  
  /// Minimum touch target size (44px for iOS, 48px for Android)
  static const double minTouchTarget = 44.0;
  
  /// Recommended touch target size
  static const double touchTarget = 48.0;
  
  /// App bar height
  static const double appBarHeight = 56.0;
  
  /// Bottom navigation bar height
  static const double bottomNavHeight = 80.0;
  
  /// Tab bar height
  static const double tabBarHeight = 48.0;
  
  /// Floating action button size
  static const double fabSize = 56.0;
  
  /// Small floating action button size
  static const double fabSizeSmall = 40.0;
  
  /// Large floating action button size
  static const double fabSizeLarge = 64.0;

  // ====== Icon Sizes ======
  
  /// Extra small icon size - 12px
  static const double iconExtraSmall = 12.0;
  
  /// Small icon size - 16px
  static const double iconSmall = 16.0;
  
  /// Medium icon size - 24px
  static const double iconMedium = 24.0;
  
  /// Large icon size - 32px
  static const double iconLarge = 32.0;
  
  /// Extra large icon size - 48px
  static const double iconExtraLarge = 48.0;
  
  /// Hero icon size - 64px
  static const double iconHero = 64.0;

  // ====== Helper Methods ======
  
  /// Get spacing value based on multiplier
  static double spacing(double multiplier) => baseUnit * multiplier;
  
  /// Get horizontal spacing EdgeInsets
  static EdgeInsets horizontalPadding(double value) => EdgeInsets.symmetric(horizontal: value);
  
  /// Get vertical spacing EdgeInsets
  static EdgeInsets verticalPadding(double value) => EdgeInsets.symmetric(vertical: value);
  
  /// Get symmetric spacing EdgeInsets
  static EdgeInsets symmetricPadding({double horizontal = 0, double vertical = 0}) {
    return EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical);
  }
  
  /// Get all-around spacing EdgeInsets
  static EdgeInsets allPadding(double value) => EdgeInsets.all(value);
  
  /// Get custom spacing EdgeInsets
  static EdgeInsets customPadding({
    double top = 0,
    double right = 0,
    double bottom = 0,
    double left = 0,
  }) {
    return EdgeInsets.only(top: top, right: right, bottom: bottom, left: left);
  }
  
  /// Get SizedBox with horizontal spacing
  static Widget horizontalSpace(double width) => SizedBox(width: width);
  
  /// Get SizedBox with vertical spacing
  static Widget verticalSpace(double height) => SizedBox(height: height);
  
  /// Get responsive spacing based on screen size
  static double responsiveSpacing(double screenWidth, double baseSpacing) {
    if (screenWidth < 600) {
      return baseSpacing * 0.8; // 20% smaller on small screens
    } else if (screenWidth > 1200) {
      return baseSpacing * 1.2; // 20% larger on large screens
    }
    return baseSpacing;
  }
  
  /// Get responsive padding based on screen size
  static EdgeInsets responsivePadding(double screenWidth, EdgeInsets basePadding) {
    final factor = screenWidth < 600 ? 0.8 : (screenWidth > 1200 ? 1.2 : 1.0);
    return EdgeInsets.fromLTRB(
      basePadding.left * factor,
      basePadding.top * factor,
      basePadding.right * factor,
      basePadding.bottom * factor,
    );
  }
}

/// Extension to add spacing utilities to Widget
extension SpacingExtensions on Widget {
  /// Add padding around the widget
  Widget paddingAll(double value) => Padding(
    padding: EdgeInsets.all(value),
    child: this,
  );
  
  /// Add horizontal padding to the widget
  Widget paddingHorizontal(double value) => Padding(
    padding: EdgeInsets.symmetric(horizontal: value),
    child: this,
  );
  
  /// Add vertical padding to the widget
  Widget paddingVertical(double value) => Padding(
    padding: EdgeInsets.symmetric(vertical: value),
    child: this,
  );
  
  /// Add custom padding to the widget
  Widget paddingOnly({
    double top = 0,
    double right = 0,
    double bottom = 0,
    double left = 0,
  }) => Padding(
    padding: EdgeInsets.only(top: top, right: right, bottom: bottom, left: left),
    child: this,
  );
  
  /// Add symmetric padding to the widget
  Widget paddingSymmetric({double horizontal = 0, double vertical = 0}) => Padding(
    padding: EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical),
    child: this,
  );
}