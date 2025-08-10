import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../data/mock_data.dart';
import '../theme/app_spacing.dart';
import '../widgets/app_bar/app_app_bar.dart';
import '../widgets/states/app_empty_state.dart';
import '../widgets/tiles/app_person_tile.dart';

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
      return AppEmptyState.authors(language: language);
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.medium),
      itemCount: authors.length,
      itemBuilder: (context, index) {
        final author = authors[index];
        return AppPersonTile.author(
          author: author,
          onTap: () {
            context.push('/home/author/${author.id}');
          },
        );
      },
    );
  }

}