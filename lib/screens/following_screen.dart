import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../data/mock_data.dart';
import '../theme/app_spacing.dart';
import '../widgets/text/app_text.dart';
import '../widgets/app_bar/app_app_bar.dart';
import '../widgets/cards/app_card.dart';

/// Following screen that displays user's followed authors and narrators
class FollowingScreen extends ConsumerWidget {
  const FollowingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final followedNarrators = MockData.getFollowedNarrators();
    final followedAuthors = MockData.getFollowedAuthors();

    return Scaffold(
      appBar: AppAppBar(
        title: 'Following',
      ),
      body: (followedNarrators.isEmpty && followedAuthors.isEmpty)
          ? _buildEmptyState(context)
          : _buildFollowingList(context, followedNarrators, followedAuthors),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.large),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person_add_rounded,
              size: 80,
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            ),
            const SizedBox(height: AppSpacing.large),
            AppTitleText(
              'Not Following Anyone',
              color: colorScheme.onSurface,
            ),
            const SizedBox(height: AppSpacing.small),
            AppBodyText(
              'Authors and narrators you follow will appear here.',
              color: colorScheme.onSurfaceVariant,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.large),
            ElevatedButton.icon(
              onPressed: () => context.go('/home/authors'),
              icon: const Icon(Icons.explore_rounded),
              label: const Text('Explore Authors'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFollowingList(
    BuildContext context,
    List<NarratorData> followedNarrators,
    List<AuthorData> followedAuthors,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.medium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Narrators section
          if (followedNarrators.isNotEmpty) ...[
            _buildSectionHeader(
              context,
              title: 'Narrators',
              count: followedNarrators.length,
              icon: Icons.mic_rounded,
            ),
            const SizedBox(height: AppSpacing.medium),
            ...followedNarrators.map((narrator) {
              return Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.medium),
                child: _FollowingTile(
                  name: narrator.name,
                  description: narrator.voiceDescription,
                  type: 'Narrator',
                  totalContent: narrator.totalNarrations,
                  contentLabel: 'narrations',
                  isFollowing: narrator.isFollowing,
                  onTap: () {
                    context.push('/home/narrator/${narrator.id}');
                  },
                  onFollowToggle: () {
                    debugPrint('${narrator.isFollowing ? "Unfollowed" : "Followed"} narrator: ${narrator.name}');
                  },
                ),
              );
            }),
            if (followedAuthors.isNotEmpty)
              const SizedBox(height: AppSpacing.large),
          ],
          
          // Authors section
          if (followedAuthors.isNotEmpty) ...[
            _buildSectionHeader(
              context,
              title: 'Authors',
              count: followedAuthors.length,
              icon: Icons.edit_rounded,
            ),
            const SizedBox(height: AppSpacing.medium),
            ...followedAuthors.map((author) {
              return Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.medium),
                child: _FollowingTile(
                  name: author.name,
                  description: author.bio,
                  type: 'Author',
                  totalContent: author.totalBooks,
                  contentLabel: 'books',
                  isFollowing: author.isFollowing,
                  onTap: () {
                    context.push('/home/author/${author.id}');
                  },
                  onFollowToggle: () {
                    debugPrint('${author.isFollowing ? "Unfollowed" : "Followed"} author: ${author.name}');
                  },
                ),
              );
            }),
          ],
        ],
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context, {
    required String title,
    required int count,
    required IconData icon,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      children: [
        Icon(
          icon,
          color: colorScheme.primary,
          size: AppSpacing.iconSmall,
        ),
        const SizedBox(width: AppSpacing.small),
        AppSubtitleText(title),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.small,
            vertical: AppSpacing.extraSmall,
          ),
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(AppSpacing.radiusExtraSmall),
          ),
          child: Text(
            count.toString(),
            style: theme.textTheme.labelSmall?.copyWith(
              color: colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

/// Following tile widget for authors and narrators
class _FollowingTile extends StatelessWidget {
  final String name;
  final String description;
  final String type;
  final int totalContent;
  final String contentLabel;
  final bool isFollowing;
  final VoidCallback? onTap;
  final VoidCallback? onFollowToggle;

  const _FollowingTile({
    required this.name,
    required this.description,
    required this.type,
    required this.totalContent,
    required this.contentLabel,
    required this.isFollowing,
    this.onTap,
    this.onFollowToggle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AppCard(
      elevation: 0,
      backgroundColor: colorScheme.surfaceContainer,
      padding: EdgeInsets.zero,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.medium),
          child: Row(
            children: [
              // Avatar
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: type == 'Narrator' 
                      ? colorScheme.secondaryContainer 
                      : colorScheme.primaryContainer,
                ),
                child: Icon(
                  type == 'Narrator' ? Icons.mic_rounded : Icons.edit_rounded,
                  color: type == 'Narrator' 
                      ? colorScheme.onSecondaryContainer 
                      : colorScheme.onPrimaryContainer,
                  size: AppSpacing.iconMedium,
                ),
              ),
              const SizedBox(width: AppSpacing.medium),
              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Type indicator
                    Row(
                      children: [
                        Icon(
                          type == 'Narrator' ? Icons.record_voice_over_rounded : Icons.person_rounded,
                          color: colorScheme.primary,
                          size: AppSpacing.iconExtraSmall,
                        ),
                        const SizedBox(width: AppSpacing.extraSmall),
                        AppCaptionText(
                          type,
                          color: colorScheme.primary,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.extraSmall),
                    // Name
                    AppSubtitleText(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppSpacing.extraSmall),
                    // Description
                    AppCaptionText(
                      description,
                      color: colorScheme.onSurfaceVariant,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppSpacing.small),
                    // Stats
                    Row(
                      children: [
                        Icon(
                          type == 'Narrator' ? Icons.library_music_rounded : Icons.book_rounded,
                          color: colorScheme.onSurfaceVariant,
                          size: AppSpacing.iconExtraSmall,
                        ),
                        const SizedBox(width: AppSpacing.extraSmall),
                        AppCaptionText(
                          '$totalContent $contentLabel',
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Follow button
              GestureDetector(
                onTap: onFollowToggle,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.medium,
                    vertical: AppSpacing.small,
                  ),
                  decoration: BoxDecoration(
                    color: isFollowing ? colorScheme.surfaceContainer : colorScheme.primary,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
                    border: isFollowing 
                        ? Border.all(
                            color: colorScheme.outline.withValues(alpha: 0.3),
                            width: 1,
                          )
                        : null,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isFollowing ? Icons.check_rounded : Icons.person_add_rounded,
                        color: isFollowing ? colorScheme.onSurfaceVariant : colorScheme.onPrimary,
                        size: AppSpacing.iconExtraSmall,
                      ),
                      const SizedBox(width: AppSpacing.extraSmall),
                      Text(
                        isFollowing ? 'Following' : 'Follow',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: isFollowing ? colorScheme.onSurfaceVariant : colorScheme.onPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}