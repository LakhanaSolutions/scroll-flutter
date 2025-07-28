import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../theme/app_spacing.dart';
import '../theme/theme_extensions.dart';
import '../widgets/text/app_text.dart';
import '../widgets/cards/app_card.dart';
import '../widgets/images/app_image.dart';
import '../widgets/app_bar/app_app_bar.dart';
import 'narrator_screen.dart';

/// Narrators list screen with voice type tabs
/// Shows narrators categorized by their voice type
class NarratorsListScreen extends StatefulWidget {
  const NarratorsListScreen({super.key});

  @override
  State<NarratorsListScreen> createState() => _NarratorsListScreenState();
}

class _NarratorsListScreenState extends State<NarratorsListScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  
  final List<String> _voiceTypes = ['All', 'Male voice', 'Female voice', 'Kid voice', 'AI voice'];
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _voiceTypes.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<NarratorData> _getNarratorsByVoiceType(String voiceType) {
    final narrators = MockData.getMockNarrators();
    if (voiceType == 'All') return narrators;
    
    // Filter narrators by voice type (simplified logic based on narrator characteristics)
    return narrators.where((narrator) {
      switch (voiceType) {
        case 'Male voice':
          return true; // All current narrators are male in our data
        case 'Female voice':
          return false; // No female narrators in current data
        case 'Kid voice':
          return narrator.genres.contains('Youth Education');
        case 'AI voice':
          return false; // No AI narrators in current data
        default:
          return false;
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBarExtensions.withTabBar(
        title: 'Narrators & Speakers',
        tabController: _tabController,
        tabs: _voiceTypes,
        onBackPressed: () => Navigator.of(context).pop(),
      ),
      body: TabBarView(
        controller: _tabController,
        children: _voiceTypes.map((voiceType) {
          final narrators = _getNarratorsByVoiceType(voiceType);
          return _buildNarratorsTab(narrators, voiceType);
        }).toList(),
      ),
    );
  }

  Widget _buildNarratorsTab(List<NarratorData> narrators, String voiceType) {
    if (narrators.isEmpty) {
      return _buildEmptyState(voiceType);
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.medium),
      itemCount: narrators.length,
      itemBuilder: (context, index) {
        final narrator = narrators[index];
        return _NarratorTile(
          narrator: narrator,
          voiceType: voiceType,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => NarratorScreen(narrator: narrator),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildEmptyState(String voiceType) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.large),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.mic_off_rounded,
              size: AppSpacing.iconHero,
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            ),
            const SizedBox(height: AppSpacing.large),
            AppTitleText('No Narrators Found'),
            const SizedBox(height: AppSpacing.small),
            AppBodyText(
              voiceType == 'All' 
                  ? 'No narrators available at the moment.'
                  : 'No narrators found for $voiceType.',
              textAlign: TextAlign.center,
              color: colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}

/// Individual narrator tile widget
class _NarratorTile extends StatelessWidget {
  final NarratorData narrator;
  final String voiceType;
  final VoidCallback? onTap;

  const _NarratorTile({
    required this.narrator,
    required this.voiceType,
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
          // Narrator avatar
          AppCircularImage(
            imageUrl: narrator.imageUrl,
            fallbackIcon: Icons.mic_rounded,
            size: 60,
            backgroundColor: colorScheme.secondaryContainer,
            iconColor: colorScheme.onSecondaryContainer,
            iconSize: AppSpacing.iconLarge,
          ),
          const SizedBox(width: AppSpacing.medium),
          // Narrator info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Narrator type indicator
                Row(
                  children: [
                    Icon(
                      Icons.record_voice_over_rounded,
                      color: colorScheme.secondary,
                      size: AppSpacing.iconExtraSmall,
                    ),
                    const SizedBox(width: AppSpacing.extraSmall),
                    AppCaptionText(
                      voiceType == 'All' ? 'Narrator' : voiceType,
                      color: colorScheme.secondary,
                    ),
                    if (narrator.isFollowing) ...[
                      const SizedBox(width: AppSpacing.small),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.extraSmall,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.secondaryContainer,
                          borderRadius: BorderRadius.circular(AppSpacing.radiusExtraSmall),
                        ),
                        child: Text(
                          'FOLLOWING',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: colorScheme.onSecondaryContainer,
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
                  narrator.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.extraSmall),
                // Voice description
                AppCaptionText(
                  narrator.voiceDescription,
                  color: colorScheme.onSurfaceVariant,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.small),
                // Stats
                Row(
                  children: [
                    Icon(
                      Icons.library_music_rounded,
                      color: colorScheme.onSurfaceVariant,
                      size: AppSpacing.iconExtraSmall,
                    ),
                    const SizedBox(width: AppSpacing.extraSmall),
                    AppCaptionText(
                      '${narrator.totalNarrations} narrations',
                      color: colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: AppSpacing.medium),
                    Icon(
                      Icons.schedule_rounded,
                      color: colorScheme.onSurfaceVariant,
                      size: AppSpacing.iconExtraSmall,
                    ),
                    const SizedBox(width: AppSpacing.extraSmall),
                    AppCaptionText(
                      '${narrator.experienceYears} years',
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.extraSmall),
                // Languages
                Wrap(
                  spacing: AppSpacing.extraSmall,
                  children: narrator.languages.take(3).map((language) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.small,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainer,
                        borderRadius: BorderRadius.circular(AppSpacing.radiusExtraSmall),
                      ),
                      child: Text(
                        language,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          fontSize: 9,
                        ),
                      ),
                    );
                  }).toList(),
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