import 'package:flutter/material.dart';
import '../../data/mock_data.dart';
import '../tiles/app_person_tile.dart';

/// Narrator search result tile widget
/// Reuses AppPersonTile for consistent narrator display
class NarratorResultTile extends StatelessWidget {
  final NarratorData narrator;
  final VoidCallback? onTap;
  final EdgeInsets? margin;

  const NarratorResultTile({
    super.key,
    required this.narrator,
    this.onTap,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return AppPersonTile.narrator(
      narrator: narrator,
      onTap: onTap,
      margin: margin,
    );
  }
}