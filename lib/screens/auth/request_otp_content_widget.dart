import 'package:flutter/material.dart';

class RequestOtpContentWidget extends StatelessWidget {
  final bool isTablet;
  final bool isDesktop;
  final Size screenSize;
  final ThemeData theme;

  const RequestOtpContentWidget({
    super.key,
    required this.isTablet,
    required this.isDesktop,
    required this.screenSize,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    // Request OTP screen doesn't have additional content below header
    return const SizedBox.shrink();
  }
}