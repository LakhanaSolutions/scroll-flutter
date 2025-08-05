import 'package:flutter/material.dart';

class WelcomeContentWidget extends StatelessWidget {
  final bool isTablet;
  final bool isDesktop;
  final Size screenSize;
  final ThemeData theme;

  const WelcomeContentWidget({
    super.key,
    required this.isTablet,
    required this.isDesktop,
    required this.screenSize,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    // Welcome screen doesn't have additional content below header
    return const SizedBox.shrink();
  }
}