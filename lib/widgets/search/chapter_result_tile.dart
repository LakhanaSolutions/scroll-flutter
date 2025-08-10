import 'package:flutter/material.dart';
import '../../data/mock_data.dart';
import '../books/content_tile.dart';

/// Chapter search result tile widget
/// Reuses ContentTile from CategoryViewScreen to maintain consistency
class ChapterResultTile extends StatelessWidget {
  final ChapterData chapter;
  final ContentItemData parentContent;
  final VoidCallback? onTap;
  final EdgeInsets? margin;

  const ChapterResultTile({
    super.key,
    required this.chapter,
    required this.parentContent,
    this.onTap,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    // Create a ContentItemData representing this chapter for ContentTile
    final chapterContentData = ContentItemData(
      id: chapter.id,
      title: chapter.title,
      author: parentContent.author,
      authorData: parentContent.authorData,
      coverUrl: parentContent.coverUrl,
      type: parentContent.type,
      availability: parentContent.availability,
      rating: parentContent.rating,
      duration: chapter.duration,
      chapterCount: parentContent.chapterCount,
      description: 'From: ${parentContent.title}',
      narrators: parentContent.narrators,
      chapters: parentContent.chapters,
      isBookmarked: parentContent.isBookmarked,
    );

    return Padding(
      padding: margin ?? const EdgeInsets.only(bottom: 8.0),
      child: ContentTile(
        content: chapterContentData,
        onTap: onTap,
      ),
    );
  }
}