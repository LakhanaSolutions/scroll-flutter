import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../data/mock_data.dart';
import '../theme/app_spacing.dart';
import '../widgets/app_bar/app_app_bar.dart';
import '../widgets/states/app_empty_state.dart';
import '../widgets/tiles/app_person_tile.dart';

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
      return AppEmptyState.narrators(voiceType: voiceType);
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.medium),
      itemCount: narrators.length,
      itemBuilder: (context, index) {
        final narrator = narrators[index];
        return AppPersonTile.narrator(
          narrator: narrator,
          voiceType: voiceType,
          onTap: () {
            context.push('/home/narrator/${narrator.id}');
          },
        );
      },
    );
  }

}