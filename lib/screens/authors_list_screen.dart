import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../data/mock_data.dart';
import '../theme/app_spacing.dart';
import '../theme/theme_extensions.dart';
import '../widgets/text/app_text.dart';
import '../widgets/cards/app_card.dart';
import '../widgets/images/app_image.dart';
import '../widgets/app_bar/app_app_bar.dart';

/// Authors list screen with language tabs
/// Shows authors categorized by their primary language
class AuthorsListScreen extends StatefulWidget {
  const AuthorsListScreen({super.key});

  @override
  State<AuthorsListScreen> createState() => _AuthorsListScreenState();
}

class _AuthorsListScreenState extends State<AuthorsListScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  
  final List<String> _languages = ['All', 'Arabic', 'English', 'Urdu', 'Persian'];
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _languages.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<AuthorData> _getAuthorsByLanguage(String language) {
    final authors = MockData.getMockAuthors();
    if (language == 'All') return authors;
    
    // Filter authors by language (simplified logic)
    return authors.where((author) {
      switch (language) {
        case 'Arabic':
          return author.nationality == 'Syrian' || author.nationality == 'Saudi';
        case 'English':
          return author.genres.contains('Contemporary Issues');
        case 'Urdu':
          return author.nationality == 'Indian' || author.nationality == 'Pakistani';
        case 'Persian':
          return author.genres.contains('Tasawwuf') || author.genres.contains('Sufism');
        default:
          return false;
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBarExtensions.withTabBar(
        title: 'Authors',
        tabController: _tabController,
        tabs: _languages,
        onBackPressed: () => Navigator.of(context).pop(),
      ),
      body: TabBarView(
        controller: _tabController,
        children: _languages.map((language) {
          final authors = _getAuthorsByLanguage(language);
          return _buildAuthorsTab(authors, language);
        }).toList(),
      ),
    );
  }

  Widget _buildAuthorsTab(List<AuthorData> authors, String language) {
    if (authors.isEmpty) {
      return _buildEmptyState(language);
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.medium),
      itemCount: authors.length,
      itemBuilder: (context, index) {
        final author = authors[index];
        return _AuthorTile(
          author: author,
          onTap: () {
            context.go('/home/author/${author.id}');
          },
        );
      },
    );
  }

  Widget _buildEmptyState(String language) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.large),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person_search_rounded,
              size: AppSpacing.iconHero,
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            ),
            const SizedBox(height: AppSpacing.large),
            AppTitleText('No Authors Found'),
            const SizedBox(height: AppSpacing.small),
            AppBodyText(
              language == 'All' 
                  ? 'No authors available at the moment.'
                  : 'No authors found for $language language.',
              textAlign: TextAlign.center,
              color: colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}

/// Individual author tile widget
class _AuthorTile extends StatelessWidget {
  final AuthorData author;
  final VoidCallback? onTap;

  const _AuthorTile({
    required this.author,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AppCard(
      margin: const EdgeInsets.only(bottom: AppSpacing.small),
      gradient: context.surfaceGradient,
      elevation: AppSpacing.elevationNone,
      onTap: onTap,
      child: Row(
        children: [
          // Author avatar
          AppCircularImage(
            imageUrl: author.imageUrl,
            fallbackIcon: Icons.person_rounded,
            size: 60,
            backgroundColor: colorScheme.primaryContainer,
            iconColor: colorScheme.onPrimaryContainer,
            iconSize: AppSpacing.iconLarge,
          ),
          const SizedBox(width: AppSpacing.medium),
          // Author info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Author type indicator
                Row(
                  children: [
                    Icon(
                      Icons.edit_rounded,
                      color: colorScheme.primary,
                      size: AppSpacing.iconExtraSmall,
                    ),
                    const SizedBox(width: AppSpacing.extraSmall),
                    AppCaptionText(
                      'Author',
                      color: colorScheme.primary,
                    ),
                    if (author.isFollowing) ...[
                      const SizedBox(width: AppSpacing.small),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.extraSmall,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(AppSpacing.radiusExtraSmall),
                        ),
                        child: Text(
                          'FOLLOWING',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: colorScheme.onPrimaryContainer,
                            fontWeight: FontWeight.bold,
                            fontSize: 8,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: AppSpacing.extraSmall),
                // Name
                AppSubtitleText(
                  author.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.extraSmall),
                // Bio
                AppCaptionText(
                  author.bio,
                  color: colorScheme.onSurfaceVariant,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.small),
                // Stats
                Row(
                  children: [
                    Icon(
                      Icons.book_rounded,
                      color: colorScheme.onSurfaceVariant,
                      size: AppSpacing.iconExtraSmall,
                    ),
                    const SizedBox(width: AppSpacing.extraSmall),
                    AppCaptionText(
                      '${author.totalBooks} books',
                      color: colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: AppSpacing.medium),
                    Icon(
                      Icons.public_rounded,
                      color: colorScheme.onSurfaceVariant,
                      size: AppSpacing.iconExtraSmall,
                    ),
                    const SizedBox(width: AppSpacing.extraSmall),
                    AppCaptionText(
                      author.nationality,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Arrow icon
          Icon(
            Icons.chevron_right_rounded,
            color: colorScheme.onSurfaceVariant,
            size: AppSpacing.iconMedium,
          ),
        ],
      ),
    );
  }
}