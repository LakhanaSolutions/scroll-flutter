import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:siraaj/theme/app_gradients.dart';
import '../data/mock_data.dart';
import '../theme/app_spacing.dart';
import '../theme/theme_extensions.dart';
import '../widgets/text/app_text.dart';
import '../widgets/app_bar/app_app_bar.dart';
import '../widgets/cards/app_card.dart';
import '../widgets/buttons/app_buttons.dart';
import '../widgets/books/content_tile.dart';
import '../widgets/images/app_image.dart';
import '../widgets/reviews/add_review_card.dart';

/// Narrator/Speaker profile screen showing detailed information
/// Displays bio, narrations, awards, voice samples, and other relevant information
class NarratorScreen extends StatefulWidget {
  final NarratorData narrator;

  const NarratorScreen({
    super.key,
    required this.narrator,
  });

  @override
  State<NarratorScreen> createState() => _NarratorScreenState();
}

class _NarratorScreenState extends State<NarratorScreen> {
  bool _isFollowing = false;
  List<ContentItemData> _narratorContent = [];

  @override
  void initState() {
    super.initState();
    _isFollowing = widget.narrator.isFollowing;
    _loadNarratorContent();
  }

  void _loadNarratorContent() {
    // Mock loading content by this narrator from all categories
    final allContent = [
      ...MockData.getCategoryContent('1'),
      ...MockData.getCategoryContent('2'),
      ...MockData.getCategoryContent('3'),
    ];
    
    _narratorContent = allContent
        .where((content) => content.narrators
            .any((narrator) => narrator.id == widget.narrator.id))
        .toList();
  }

  void _toggleFollow() {
    setState(() {
      _isFollowing = !_isFollowing;
    });
    debugPrint('${_isFollowing ? "Followed" : "Unfollowed"} ${widget.narrator.name}');
  }

  void _playVoiceSample() {
    debugPrint('Play voice sample for ${widget.narrator.name}');
    // TODO: Implement voice sample playback
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: context.appTheme.iosSystemBackground,
      appBar: AppAppBar(
        title: widget.narrator.name,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Narrator header
            _buildNarratorHeader(context),
            // Narrator info
            _buildNarratorInfo(context),
            // Voice sample section
            _buildVoiceSampleSection(context),
            // Awards & Achievements
            if (widget.narrator.awards.isNotEmpty)
              _buildAwardsSection(context),
            // Narrations/Content
            _buildContentSection(context),
            // Reviews section
            _buildReviewsSection(context),
            const SizedBox(height: AppSpacing.large),
          ],
        ),
      ),
    );
  }

  Widget _buildNarratorHeader(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      color: colorScheme.surface,
      padding: const EdgeInsets.all(AppSpacing.medium),
      child: Column(
        children: [
          // Narrator avatar
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
              Icons.mic_rounded,
              color: colorScheme.onPrimaryContainer,
              size: 60,
            ),
          ),
          const SizedBox(height: AppSpacing.large),
          // Narrator name
          AppTitleText(
            widget.narrator.name,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSpacing.small),
          // Experience and stats
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppCaptionText(
                '${widget.narrator.experienceYears} years experience',
                color: colorScheme.onSurfaceVariant,
              ),
              AppCaptionText(
                ' • ',
                color: colorScheme.onSurfaceVariant,
              ),
              AppCaptionText(
                '${widget.narrator.totalNarrations} narrations',
                color: colorScheme.primary,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.small),
          // Voice description
          AppCaptionText(
            widget.narrator.voiceDescription,
            textAlign: TextAlign.center,
            color: colorScheme.onSurfaceVariant,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
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

  Widget _buildNarratorInfo(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.all(AppSpacing.medium),
      child: AppCard(
        elevation: 0,
        gradient: AppGradients.subtleSurfaceGradient(colorScheme),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.medium),
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
                widget.narrator.bio,
                color: colorScheme.onSurfaceVariant,
              ),
              if (widget.narrator.languages.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.large),
                const AppSubtitleText('Languages'),
                const SizedBox(height: AppSpacing.small),
                Wrap(
                  spacing: AppSpacing.small,
                  runSpacing: AppSpacing.small,
                  children: widget.narrator.languages.map((language) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.medium,
                        vertical: AppSpacing.extraSmall,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.language_rounded,
                            color: colorScheme.onPrimaryContainer,
                            size: AppSpacing.iconExtraSmall,
                          ),
                          const SizedBox(width: AppSpacing.extraSmall),
                          AppCaptionText(
                            language,
                            color: colorScheme.onPrimaryContainer,
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],
              if (widget.narrator.genres.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.large),
                const AppSubtitleText('Specializations'),
                const SizedBox(height: AppSpacing.small),
                Wrap(
                  spacing: AppSpacing.small,
                  runSpacing: AppSpacing.small,
                  children: widget.narrator.genres.map((genre) {
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
              if (widget.narrator.socialLinks.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.large),
                const AppSubtitleText('Social Media'),
                const SizedBox(height: AppSpacing.small),
                ...widget.narrator.socialLinks.map((link) {
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
    final reviewSummary = MockData.getReviewSummary(widget.narrator.id);
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.medium),
      child: AddReviewCard(
        contentId: widget.narrator.id,
        contentType: 'narrator',
        contentTitle: widget.narrator.name,
        reviewSummary: reviewSummary,
        onReviewTap: () {
          context.push('/home/reviews/narrator/${widget.narrator.id}');
        },
      ),
    );
  }

  Widget _buildVoiceSampleSection(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.medium),
      child: AppCard(
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.medium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.play_circle_outline_rounded,
                    color: colorScheme.primary,
                    size: AppSpacing.iconSmall,
                  ),
                  const SizedBox(width: AppSpacing.small),
                  const AppSubtitleText('Voice Sample'),
                ],
              ),
              const SizedBox(height: AppSpacing.medium),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.medium),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.graphic_eq_rounded,
                      color: colorScheme.primary,
                      size: AppSpacing.iconLarge,
                    ),
                    const SizedBox(height: AppSpacing.medium),
                    AppBodyText(
                      'Listen to a sample of ${widget.narrator.name}\'s narration',
                      textAlign: TextAlign.center,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(height: AppSpacing.large),
                    AppPrimaryButton(
                      onPressed: _playVoiceSample,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.play_arrow_rounded,
                            size: AppSpacing.iconSmall,
                          ),
                          const SizedBox(width: AppSpacing.small),
                          const Text('Play Sample'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAwardsSection(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.all(AppSpacing.medium),
      child: AppCard(
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.medium),
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
              ...widget.narrator.awards.map((award) {
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

  Widget _buildContentSection(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Separate books and podcasts
    final books = _narratorContent
        .where((content) => content.type == ContentType.book)
        .toList();
    final podcasts = _narratorContent
        .where((content) => content.type == ContentType.podcast)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.medium),
          child: Row(
            children: [
              Icon(
                Icons.library_music_rounded,
                color: colorScheme.primary,
                size: AppSpacing.iconSmall,
              ),
              const SizedBox(width: AppSpacing.small),
              const AppSubtitleText('Narrations'),
              const Spacer(),
              AppCaptionText(
                '${_narratorContent.length} total',
                color: colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.medium),
        
        // Content list
        if (_narratorContent.isEmpty)
          Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: AppSpacing.medium),
            child: AppCard(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.medium),
                child: Column(
                  children: [
                    Icon(
                      Icons.mic_off_rounded,
                      color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                      size: AppSpacing.iconLarge,
                    ),
                    const SizedBox(height: AppSpacing.medium),
                    AppBodyText(
                      'No narrations available yet',
                      textAlign: TextAlign.center,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ],
                ),
              ),
            ),
          )
        else ...[
          if (books.isNotEmpty) ...[
            // Books subsection header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.medium),
              child: Row(
                children: [
                  Icon(
                    Icons.book_rounded,
                    color: colorScheme.onSurfaceVariant,
                    size: AppSpacing.iconSmall,
                  ),
                  const SizedBox(width: AppSpacing.small),
                  AppSubtitleText(
                    'Books (${books.length})',
                    color: colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.medium),
            // Books list
            ...books.map((book) {
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
          
          if (podcasts.isNotEmpty) ...[
            if (books.isNotEmpty)
              const SizedBox(height: AppSpacing.medium),
            // Podcasts subsection header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.medium),
              child: Row(
                children: [
                  Icon(
                    Icons.podcasts_rounded,
                    color: colorScheme.onSurfaceVariant,
                    size: AppSpacing.iconSmall,
                  ),
                  const SizedBox(width: AppSpacing.small),
                  AppSubtitleText(
                    'Podcasts (${podcasts.length})',
                    color: colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.medium),
            // Podcasts list
            ...podcasts.map((podcast) {
              return Container(
                margin: const EdgeInsets.only(
                  left: AppSpacing.medium,
                  right: AppSpacing.medium,
                  bottom: AppSpacing.small,
                ),
                child: ContentTile(
                  content: podcast,
                  onTap: () {
                    debugPrint('Navigate to podcast: ${podcast.title}');
                  },
                ),
              );
            }),
          ],
        ],
      ],
    );
  }
}