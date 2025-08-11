import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:scroll/theme/app_gradients.dart';
import '../data/mock_data.dart';
import '../theme/app_spacing.dart';
import '../theme/theme_extensions.dart';
import '../widgets/text/app_text.dart';
import '../widgets/app_bar/app_app_bar.dart';
import '../widgets/cards/app_card.dart';
import '../widgets/buttons/app_buttons.dart';
import '../widgets/books/content_tile.dart';
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
    // TODO-027: Implement voice sample playback
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
            // Badge bar with alive tags
            _buildBadgeBar(context),
            // Narrator info with engaging design
            _buildNarratorInfo(context),
            // Real audio player for voice sample
            _buildVoiceSampleSection(context),
            // Awards & Achievements
            if (widget.narrator.awards.isNotEmpty)
              _buildAwardsSection(context),
            // Narrations/Content
            _buildContentSection(context),
            // Reviews section
            _buildReviewsSection(context),
            // Personalization section
            _buildPersonalizationSection(context),
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

  Widget _buildBadgeBar(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.medium),
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.small),
      child: Row(
        children: [
          // Active status badge
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.small,
              vertical: AppSpacing.extraSmall,
            ),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF4CAF50), // Green
                  Color(0xFF66BB6A), // Light green
                ],
              ),
              borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF4CAF50).withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: AppSpacing.extraSmall),
                Text(
                  'Active Today',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.small),
          // Trending badge
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.small,
              vertical: AppSpacing.extraSmall,
            ),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFFFFD700), // Gold
                  Color(0xFFFFA000), // Amber
                ],
              ),
              borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.trending_up_rounded,
                  color: Colors.white,
                  size: AppSpacing.iconExtraSmall,
                ),
                const SizedBox(width: AppSpacing.extraSmall),
                Text(
                  'Trending',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.small),
          // Experience badge
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.small,
              vertical: AppSpacing.extraSmall,
            ),
            decoration: BoxDecoration(
              color: colorScheme.tertiaryContainer,
              borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
            ),
            child: Text(
              'Pro Voice',
              style: theme.textTheme.labelSmall?.copyWith(
                color: colorScheme.onTertiaryContainer,
                fontWeight: FontWeight.w600,
                fontSize: 11,
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
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.extraSmall),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF00838F), // Teal
                          Color(0xFF00ACC1), // Light teal
                        ],
                      ),
                      borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
                    ),
                    child: Icon(
                      Icons.person_pin_rounded,
                      color: Colors.white,
                      size: AppSpacing.iconSmall,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.small),
                  const AppSubtitleText('About This Voice Artist'),
                ],
              ),
              const SizedBox(height: AppSpacing.medium),
              Container(
                padding: const EdgeInsets.all(AppSpacing.medium),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
                  border: Border(
                    left: BorderSide(
                      color: const Color(0xFF00838F),
                      width: 3,
                    ),
                  ),
                ),
                child: AppBodyText(
                  widget.narrator.bio,
                  color: colorScheme.onSurfaceVariant,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    height: 1.5,
                    fontSize: 14,
                  ),
                ),
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
        gradient: LinearGradient(
          colors: [
            colorScheme.surface,
            colorScheme.surfaceContainer,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.medium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.extraSmall),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFFE91E63), // Pink
                          Color(0xFFF06292), // Light pink
                        ],
                      ),
                      borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
                    ),
                    child: Icon(
                      Icons.waves_rounded,
                      color: Colors.white,
                      size: AppSpacing.iconSmall,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.small),
                  const AppSubtitleText('Voice Sample'),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.small,
                      vertical: AppSpacing.extraSmall,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE91E63).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
                    ),
                    child: Text(
                      '2:47',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: const Color(0xFFE91E63),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.medium),
              
              // Real audio player interface
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.medium),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFFE91E63).withValues(alpha: 0.1),
                      const Color(0xFFF06292).withValues(alpha: 0.05),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
                  border: Border.all(
                    color: const Color(0xFFE91E63).withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    // Waveform visualization (mock)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(20, (index) {
                        final heights = [4.0, 8.0, 12.0, 6.0, 16.0, 10.0, 8.0, 14.0, 4.0, 12.0, 
                                       18.0, 8.0, 10.0, 6.0, 14.0, 8.0, 12.0, 4.0, 10.0, 6.0];
                        return Container(
                          width: 3,
                          height: heights[index % heights.length],
                          margin: const EdgeInsets.symmetric(horizontal: 1),
                          decoration: BoxDecoration(
                            color: index < 7 ? const Color(0xFFE91E63) : const Color(0xFFE91E63).withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(1.5),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: AppSpacing.medium),
                    
                    // Progress bar
                    Row(
                      children: [
                        Text('0:45', style: theme.textTheme.labelSmall?.copyWith(color: const Color(0xFFE91E63))),
                        const SizedBox(width: AppSpacing.small),
                        Expanded(
                          child: Stack(
                            alignment: Alignment.centerLeft,
                            children: [
                              Container(
                                height: 4,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE91E63).withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                              FractionallySizedBox(
                                widthFactor: 0.35,
                                child: Container(
                                  height: 4,
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFFE91E63),
                                        Color(0xFFF06292),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: AppSpacing.small),
                        Text('2:47', style: theme.textTheme.labelSmall?.copyWith(color: colorScheme.onSurfaceVariant)),
                      ],
                    ),
                    
                    const SizedBox(height: AppSpacing.medium),
                    
                    // Play controls
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () => debugPrint('Previous 10s'),
                          child: Container(
                            padding: const EdgeInsets.all(AppSpacing.small),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE91E63).withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.replay_10_rounded,
                              color: const Color(0xFFE91E63),
                              size: AppSpacing.iconMedium,
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.large),
                        GestureDetector(
                          onTap: _playVoiceSample,
                          child: Container(
                            padding: const EdgeInsets.all(AppSpacing.medium),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFFE91E63),
                                  Color(0xFFF06292),
                                ],
                              ),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFFE91E63).withValues(alpha: 0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.play_arrow_rounded,
                              color: Colors.white,
                              size: AppSpacing.iconMedium,
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.large),
                        GestureDetector(
                          onTap: () => debugPrint('Forward 30s'),
                          child: Container(
                            padding: const EdgeInsets.all(AppSpacing.small),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE91E63).withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.forward_30_rounded,
                              color: const Color(0xFFE91E63),
                              size: AppSpacing.iconMedium,
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: AppSpacing.medium),
                    Text(
                      '"${widget.narrator.name} brings stories to life with incredible emotion"',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontStyle: FontStyle.italic,
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

  Widget _buildPersonalizationSection(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.all(AppSpacing.medium),
      child: AppCard(
        elevation: 0,
        gradient: LinearGradient(
          colors: [
            colorScheme.primaryContainer.withValues(alpha: 0.3),
            colorScheme.surfaceContainer,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.medium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.extraSmall),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF9C27B0), // Purple
                          Color(0xFFBA68C8), // Light purple
                        ],
                      ),
                      borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
                    ),
                    child: Icon(
                      Icons.tune_rounded,
                      color: Colors.white,
                      size: AppSpacing.iconSmall,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.small),
                  const AppSubtitleText('Personalize Your Experience'),
                ],
              ),
              const SizedBox(height: AppSpacing.medium),
              
              // Quick action buttons
              Row(
                children: [
                  Expanded(
                    child: _PersonalizationButton(
                      icon: Icons.notifications_rounded,
                      label: 'New Releases',
                      subtitle: 'Get notified',
                      color: const Color(0xFF2196F3),
                      onTap: () {
                        debugPrint('Enable notifications for ${widget.narrator.name}');
                      },
                    ),
                  ),
                  const SizedBox(width: AppSpacing.small),
                  Expanded(
                    child: _PersonalizationButton(
                      icon: Icons.playlist_add_rounded,
                      label: 'Auto Add',
                      subtitle: 'To playlists',
                      color: const Color(0xFF4CAF50),
                      onTap: () {
                        debugPrint('Auto-add ${widget.narrator.name} content');
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.small),
              Row(
                children: [
                  Expanded(
                    child: _PersonalizationButton(
                      icon: Icons.speed_rounded,
                      label: 'Playback',
                      subtitle: 'Speed: 1.2x',
                      color: const Color(0xFFFF9800),
                      onTap: () {
                        debugPrint('Set preferred playback speed for ${widget.narrator.name}');
                      },
                    ),
                  ),
                  const SizedBox(width: AppSpacing.small),
                  Expanded(
                    child: _PersonalizationButton(
                      icon: Icons.share_rounded,
                      label: 'Share',
                      subtitle: 'This profile',
                      color: const Color(0xFF9C27B0),
                      onTap: () {
                        debugPrint('Share ${widget.narrator.name} profile');
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Personalization button widget
class _PersonalizationButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _PersonalizationButton({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.small),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
          border: Border.all(
            color: color.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: color,
              size: AppSpacing.iconMedium,
            ),
            const SizedBox(height: AppSpacing.extraSmall),
            Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              subtitle,
              style: theme.textTheme.labelSmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}