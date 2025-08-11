import 'package:flutter/services.dart';

/// Service for handling deep links and generating shareable URLs
class DeepLinkService {
  static const String _baseUrl = 'https://scroll.app';
  static const String _customScheme = 'scroll://';

  /// Generate a shareable URL for a book/audiobook
  static String generateBookUrl(String bookId) {
    return '$_baseUrl/book/$bookId';
  }

  /// Generate a shareable URL for an author
  static String generateAuthorUrl(String authorId) {
    return '$_baseUrl/author/$authorId';
  }

  /// Generate a shareable URL for a narrator
  static String generateNarratorUrl(String narratorId) {
    return '$_baseUrl/narrator/$narratorId';
  }

  /// Generate a shareable URL for a category
  static String generateCategoryUrl(String categoryId) {
    return '$_baseUrl/category/$categoryId';
  }

  /// Generate a shareable URL for a chapter with playback position
  static String generateChapterUrl(String chapterId, String contentId, {int? position}) {
    String url = '$_baseUrl/home/chapter/$chapterId/$contentId';
    if (position != null) {
      url += '?position=$position';
    }
    return url;
  }

  /// Generate a custom scheme URL for the app
  static String generateCustomSchemeUrl(String path) {
    return '$_customScheme$path';
  }

  /// Copy a shareable URL to clipboard
  static Future<void> copyToClipboard(String url) async {
    await Clipboard.setData(ClipboardData(text: url));
  }

  /// Share a URL using the platform's share functionality
  /// Note: This would require adding share_plus package to pubspec.yaml
  static Future<void> shareUrl(String url, {String? title}) async {
    // This would use share_plus package:
    // await Share.share(url, subject: title);
    // For now, just copy to clipboard
    await copyToClipboard(url);
  }

  /// Generate a shareable text with URL
  static String generateShareText(String title, String url) {
    return 'Check out "$title" on Scroll: $url';
  }

  /// Parse a deep link URL and extract information
  static Map<String, dynamic>? parseDeepLink(String url) {
    final uri = Uri.tryParse(url);
    if (uri == null) return null;

    // Handle custom scheme
    if (uri.scheme == 'scroll') {
      return {
        'type': 'custom',
        'path': uri.path,
        'queryParameters': uri.queryParameters,
      };
    }

    // Handle HTTPS scheme
    if (uri.scheme == 'https' && uri.host == 'scroll.app') {
      final pathSegments = uri.pathSegments;
      if (pathSegments.isEmpty) return null;

      switch (pathSegments[0]) {
        case 'book':
          if (pathSegments.length >= 2) {
            return {
              'type': 'book',
              'bookId': pathSegments[1],
              'queryParameters': uri.queryParameters,
            };
          }
          break;
        case 'author':
          if (pathSegments.length >= 2) {
            return {
              'type': 'author',
              'authorId': pathSegments[1],
              'queryParameters': uri.queryParameters,
            };
          }
          break;
        case 'narrator':
          if (pathSegments.length >= 2) {
            return {
              'type': 'narrator',
              'narratorId': pathSegments[1],
              'queryParameters': uri.queryParameters,
            };
          }
          break;
        case 'category':
          if (pathSegments.length >= 2) {
            return {
              'type': 'category',
              'categoryId': pathSegments[1],
              'queryParameters': uri.queryParameters,
            };
          }
          break;
        case 'home':
          return {
            'type': 'internal',
            'path': '/${pathSegments.join('/')}',
            'queryParameters': uri.queryParameters,
          };
      }
    }

    return null;
  }

  /// Validate if a URL is a valid Scroll deep link
  static bool isValidDeepLink(String url) {
    return parseDeepLink(url) != null;
  }
}