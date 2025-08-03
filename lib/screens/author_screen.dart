import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:siraaj/theme/app_gradients.dart';
import '../data/mock_data.dart';
import '../theme/app_spacing.dart';
import '../widgets/text/app_text.dart';
import '../widgets/app_bar/app_app_bar.dart';
import '../widgets/cards/app_card.dart';
import '../widgets/buttons/app_buttons.dart';
import '../widgets/books/content_tile.dart';
import '../widgets/reviews/add_review_card.dart';

/// Author profile screen showing detailed information about an author
/// Displays bio, books, awards, and other relevant information
class AuthorScreen extends StatefulWidget {
  final AuthorData author;

  const AuthorScreen({
    super.key,
    required this.author,
  });

  @override
  State<AuthorScreen> createState() => _AuthorScreenState();
}

class _AuthorScreenState extends State<AuthorScreen> {
  bool _isFollowing = false;
  List<ContentItemData> _authorBooks = [];

  @override
  void initState() {
    super.initState();
    _isFollowing = widget.author.isFollowing;
    _loadAuthorBooks();
  }

  void _loadAuthorBooks() {
    // Mock loading books by this author from all categories
    final allContent = [
      ...MockData.getCategoryContent('1'),
      ...MockData.getCategoryContent('2'),
      ...MockData.getCategoryContent('3'),
    ];
    
    _authorBooks = allContent
        .where((content) => content.authorData.id == widget.author.id)
        .toList();
  }

  void _toggleFollow() {
    setState(() {
      _isFollowing = !_isFollowing;
    });
    debugPrint('${_isFollowing ? "Followed" : "Unfollowed"} ${widget.author.name}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBar(
        title: widget.author.name,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Author header
            _buildAuthorHeader(context),
            // Author info
            _buildAuthorInfo(context),
            // Awards & Achievements
            if (widget.author.awards.isNotEmpty)
              _buildAwardsSection(context),
            // Quote section
            _buildQuoteSection(context),
            // Books by this author
            _buildBooksSection(context),
            // Reviews section
            _buildReviewsSection(context),
            const SizedBox(height: AppSpacing.large),
          ],
        ),
      ),
    );
  }

  Widget _buildAuthorHeader(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      color: colorScheme.surface,
      padding: const EdgeInsets.all(AppSpacing.large),
      child: Column(
        children: [
          // Author avatar
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colorScheme.primaryContainer,
              boxShadow: [
                BoxShadow(
                  color: colorScheme.shadow.withValues(alpha: 0.15),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              Icons.person_rounded,
              color: colorScheme.onPrimaryContainer,
              size: 60,
            ),
          ),
          const SizedBox(height: AppSpacing.large),
          // Author name
          AppTitleText(
            widget.author.name,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSpacing.small),
          // Author details
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppCaptionText(
                widget.author.nationality,
                color: colorScheme.onSurfaceVariant,
              ),
              AppCaptionText(
                ' • ',
                color: colorScheme.onSurfaceVariant,
              ),
              AppCaptionText(
                'Born ${widget.author.birthYear}',
                color: colorScheme.onSurfaceVariant,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.small),
          AppCaptionText(
            '${widget.author.totalBooks} Books',
            color: colorScheme.primary,
          ),
          const SizedBox(height: AppSpacing.large),
          // Follow button
          SizedBox(
            width: 200,
            child: _isFollowing
                ? AppSecondaryButton(
                    onPressed: _toggleFollow,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.check_rounded,
                          size: AppSpacing.iconSmall,
                        ),
                        const SizedBox(width: AppSpacing.small),
                        const Text('Following'),
                      ],
                    ),
                  )
                : AppPrimaryButton(
                    onPressed: _toggleFollow,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.person_add_rounded,
                          size: AppSpacing.iconSmall,
                        ),
                        const SizedBox(width: AppSpacing.small),
                        const Text('Follow'),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildAuthorInfo(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.all(AppSpacing.medium),
      child: AppCard(
        elevation: 0,
        gradient: AppGradients.subtleSurfaceGradient(colorScheme),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.large),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    color: colorScheme.primary,
                    size: AppSpacing.iconSmall,
                  ),
                  const SizedBox(width: AppSpacing.small),
                  const AppSubtitleText('About'),
                ],
              ),
              const SizedBox(height: AppSpacing.medium),
              AppBodyText(
                widget.author.bio,
                color: colorScheme.onSurfaceVariant,
              ),
              if (widget.author.genres.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.large),
                const AppSubtitleText('Genres'),
                const SizedBox(height: AppSpacing.small),
                Wrap(
                  spacing: AppSpacing.small,
                  runSpacing: AppSpacing.small,
                  children: widget.author.genres.map((genre) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.medium,
                        vertical: AppSpacing.extraSmall,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
                      ),
                      child: AppCaptionText(
                        genre,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    );
                  }).toList(),
                ),
              ],
              if (widget.author.socialLinks.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.large),
                const AppSubtitleText('Social Media'),
                const SizedBox(height: AppSpacing.small),
                ...widget.author.socialLinks.map((link) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.small),
                    child: GestureDetector(
                      onTap: () {
                        debugPrint('Open social link: $link');
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.link_rounded,
                            color: colorScheme.primary,
                            size: AppSpacing.iconSmall,
                          ),
                          const SizedBox(width: AppSpacing.small),
                          AppBodyText(
                            link,
                            color: colorScheme.primary,
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReviewsSection(BuildContext context) {
    final reviewSummary = MockData.getReviewSummary(widget.author.id);
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.medium),
      child: AddReviewCard(
        contentId: widget.author.id,
        contentType: 'author',
        contentTitle: widget.author.name,
        reviewSummary: reviewSummary,
        onReviewTap: () {
          context.push('/home/reviews/author/${widget.author.id}');
        },
      ),
    );
  }

  Widget _buildAwardsSection(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.medium),
      child: AppCard(
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.large),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.emoji_events_rounded,
                    color: colorScheme.primary,
                    size: AppSpacing.iconSmall,
                  ),
                  const SizedBox(width: AppSpacing.small),
                  const AppSubtitleText('Awards & Recognition'),
                ],
              ),
              const SizedBox(height: AppSpacing.medium),
              ...widget.author.awards.map((award) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.small),
                  child: Row(
                    children: [
                      Icon(
                        Icons.star_rounded,
                        color: colorScheme.secondary,
                        size: AppSpacing.iconSmall,
                      ),
                      const SizedBox(width: AppSpacing.small),
                      Expanded(
                        child: AppBodyText(
                          award,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuoteSection(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.all(AppSpacing.medium),
      child: AppCard(
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.large),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.format_quote_rounded,
                    color: colorScheme.primary,
                    size: AppSpacing.iconSmall,
                  ),
                  const SizedBox(width: AppSpacing.small),
                  const AppSubtitleText('Notable Quote'),
                ],
              ),
              const SizedBox(height: AppSpacing.medium),
              Container(
                padding: const EdgeInsets.all(AppSpacing.medium),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
                  border: Border(
                    left: BorderSide(
                      color: colorScheme.primary,
                      width: 3,
                    ),
                  ),
                ),
                child: AppBodyText(
                  '"${widget.author.quote}"',
                  color: colorScheme.onSurface,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBooksSection(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.medium),
          child: Row(
            children: [
              Icon(
                Icons.library_books_rounded,
                color: colorScheme.primary,
                size: AppSpacing.iconSmall,
              ),
              const SizedBox(width: AppSpacing.small),
              const AppSubtitleText('Books by this Author'),
              const Spacer(),
              AppCaptionText(
                '${_authorBooks.length} books',
                color: colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.medium),
        
        // Books list
        if (_authorBooks.isEmpty)
          Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: AppSpacing.medium),
            child: AppCard(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.large),
                child: Column(
                  children: [
                    Icon(
                      Icons.book_outlined,
                      color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                      size: AppSpacing.iconLarge,
                    ),
                    const SizedBox(height: AppSpacing.medium),
                    AppBodyText(
                      'No books available yet',
                      textAlign: TextAlign.center,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ],
                ),
              ),
            ),
          )
        else
          ..._authorBooks.map((book) {
            return Container(
              margin: const EdgeInsets.only(
                left: AppSpacing.medium,
                right: AppSpacing.medium,
                bottom: AppSpacing.small,
              ),
              child: ContentTile(
                content: book,
                onTap: () {
                  debugPrint('Navigate to book: ${book.title}');
                },
              ),
            );
          }),
      ],
    );
  }
}