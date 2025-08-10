import 'package:flutter/material.dart';
import '../../data/mock_data.dart';
import '../tiles/app_person_tile.dart';

/// Author search result tile widget
/// Reuses AppPersonTile for consistent author display
class AuthorResultTile extends StatelessWidget {
  final AuthorData author;
  final VoidCallback? onTap;
  final EdgeInsets? margin;

  const AuthorResultTile({
    super.key,
    required this.author,
    this.onTap,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return AppPersonTile.author(
      author: author,
      onTap: onTap,
      margin: margin,
    );
  }
}