import 'package:flutter/material.dart';
import 'package:scroll/theme/app_colors.dart';
import '../../theme/theme_extensions.dart';

/// Reusable AppBar widget for consistent navigation across the app
/// Follows platform conventions and design system guidelines
class AppAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// Creates an [AppAppBar]
  const AppAppBar({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.actions,
    this.backgroundColor,
    this.elevation = 0,
    this.centerTitle = false,
    this.automaticallyImplyLeading = true,
    this.onLeadingPressed,
    this.bottom,
  });

  /// The title text to display
  final String title;
  
  /// Optional subtitle text
  final String? subtitle;
  
  /// Custom leading widget (usually back button)
  final Widget? leading;
  
  /// List of action buttons on the right side
  final List<Widget>? actions;
  
  /// Background color of the AppBar
  final Color? backgroundColor;
  
  /// Elevation of the AppBar
  final double elevation;
  
  /// Whether to center the title
  final bool centerTitle;
  
  /// Whether to automatically show a back button
  final bool automaticallyImplyLeading;
  
  /// Callback for leading button press
  final VoidCallback? onLeadingPressed;

  /// Bottom widget (e.g., TabBar)
  final PreferredSizeWidget? bottom;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return AppBar(
      backgroundColor: backgroundColor ?? colorScheme.iosBackground,
      elevation: elevation,
      centerTitle: centerTitle,
      automaticallyImplyLeading: automaticallyImplyLeading,
      leading: leading ?? (automaticallyImplyLeading ? _buildBackButton(context) : null),
      title: _buildTitle(context),
      actions: actions,
      bottom: bottom,
      surfaceTintColor: Colors.transparent,
      scrolledUnderElevation: 0,
    );
  }

  /// Builds the title widget with proper text styling
  Widget _buildTitle(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (subtitle != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            subtitle!,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontSize: 12,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      );
    }

    return Text(
      title,
      style: theme.textTheme.titleMedium?.copyWith(
        color: colorScheme.onSurface,
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  /// Builds the back button with platform-appropriate styling
  Widget _buildBackButton(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final appTheme = context.appTheme;

    return IconButton(
      onPressed: onLeadingPressed ?? () => Navigator.of(context).pop(),
      icon: Icon(
        appTheme.isIOS ? Icons.arrow_back_ios_rounded : Icons.arrow_back_rounded,
        color: colorScheme.onSurface,
        size: appTheme.isIOS ? 20 : 24,
      ),
      tooltip: 'Back',
    );
  }

  @override
  Size get preferredSize {
    final bottomHeight = bottom?.preferredSize.height ?? 0.0;
    return Size.fromHeight(kToolbarHeight + bottomHeight);
  }
}

/// Extension to easily create AppBar with common patterns
extension AppAppBarExtensions on AppAppBar {
  /// Creates an AppBar with a back button and title
  static AppAppBar withBackButton({
    required String title,
    String? subtitle,
    List<Widget>? actions,
    VoidCallback? onBackPressed,
    PreferredSizeWidget? bottom,
  }) {
    return AppAppBar(
      title: title,
      subtitle: subtitle,
      actions: actions,
      onLeadingPressed: onBackPressed,
      bottom: bottom,
    );
  }

  /// Creates an AppBar with custom leading widget
  static AppAppBar withCustomLeading({
    required String title,
    String? subtitle,
    required Widget leading,
    List<Widget>? actions,
    PreferredSizeWidget? bottom,
  }) {
    return AppAppBar(
      title: title,
      subtitle: subtitle,
      leading: leading,
      actions: actions,
      automaticallyImplyLeading: false,
      bottom: bottom,
    );
  }

  /// Creates an AppBar without back button
  static AppAppBar withoutBackButton({
    required String title,
    String? subtitle,
    List<Widget>? actions,
    PreferredSizeWidget? bottom,
  }) {
    return AppAppBar(
      title: title,
      subtitle: subtitle,
      actions: actions,
      automaticallyImplyLeading: false,
      bottom: bottom,
    );
  }

  /// Creates an AppBar with TabBar
  static AppAppBar withTabBar({
    required String title,
    String? subtitle,
    required TabController tabController,
    required List<String> tabs,
    List<Widget>? actions,
    VoidCallback? onBackPressed,
    Color? backgroundColor,
  }) {
    return AppAppBar(
      title: title,
      subtitle: subtitle,
      actions: actions,
      onLeadingPressed: onBackPressed,
      backgroundColor: backgroundColor,
      bottom: TabBar(
        controller: tabController,
        isScrollable: true,
        dividerColor: Colors.transparent,
        tabs: tabs.map((tab) => Tab(text: tab)).toList(),
      ),
    );
  }
} 