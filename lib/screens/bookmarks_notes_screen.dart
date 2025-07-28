import 'package:flutter/material.dart';
import '../theme/app_spacing.dart';
import '../widgets/text/app_text.dart';
import '../widgets/cards/app_card.dart';
import '../widgets/buttons/app_buttons.dart';

enum BookmarkType { chapter, quote, moment }
enum NoteType { personal, highlight, thought }

class BookmarkItem {
  final String id;
  final String title;
  final String contentTitle;
  final String author;
  final String timestamp;
  final BookmarkType type;
  final String snippet;

  BookmarkItem({
    required this.id,
    required this.title,
    required this.contentTitle,
    required this.author,
    required this.timestamp,
    required this.type,
    required this.snippet,
  });
}

class NoteItem {
  final String id;
  final String title;
  final String content;
  final String contentTitle;
  final String author;
  final DateTime createdAt;
  final DateTime? modifiedAt;
  final NoteType type;
  final String timestamp;

  NoteItem({
    required this.id,
    required this.title,
    required this.content,
    required this.contentTitle,
    required this.author,
    required this.createdAt,
    this.modifiedAt,
    required this.type,
    required this.timestamp,
  });
}

/// Bookmarks & Notes screen with modern tabbed interface
class BookmarksNotesScreen extends StatefulWidget {
  const BookmarksNotesScreen({super.key});

  @override
  State<BookmarksNotesScreen> createState() => _BookmarksNotesScreenState();
}

class _BookmarksNotesScreenState extends State<BookmarksNotesScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<BookmarkItem> get _mockBookmarks => [
    BookmarkItem(
      id: '1',
      title: 'Chapter 3: The Nature of Faith',
      contentTitle: 'Kanz ul Iman',
      author: 'Imam Ahmed Raza Khan Barelvi',
      timestamp: '12:34',
      type: BookmarkType.chapter,
      snippet: 'Faith is not merely a belief, but a state of the heart that encompasses complete submission to Allah...',
    ),
    BookmarkItem(
      id: '2',
      title: 'Beautiful Dua for Forgiveness',
      contentTitle: 'Jaa al-Haq',
      author: 'Allama Kaukab Noorani Okarvi',
      timestamp: '25:18',
      type: BookmarkType.quote,
      snippet: 'Rabbana atina fi\'d-dunya hasanatan wa fi\'l-akhirati hasanatan wa qina adhab an-nar',
    ),
    BookmarkItem(
      id: '3',
      title: 'The Importance of Salawat',
      contentTitle: 'Bahaar-e-Shariat',
      author: 'Maulana Amjad Ali Azmi',
      timestamp: '45:22',
      type: BookmarkType.moment,
      snippet: 'Sending blessings upon the Prophet (PBUH) is one of the most beloved acts of worship...',
    ),
    BookmarkItem(
      id: '4',
      title: 'Rights of Parents in Islam',
      contentTitle: 'Fatawa Razvia',
      author: 'Imam Ahmed Raza Khan Barelvi',
      timestamp: '18:45',
      type: BookmarkType.chapter,
      snippet: 'Paradise lies beneath the feet of mothers, and respect for parents is ordained by Allah...',
    ),
  ];

  List<NoteItem> get _mockNotes => [
    NoteItem(
      id: '1',
      title: 'Key Points on Fiqh',
      content: 'Important rulings from today\'s lesson:\n• Purification before prayer is essential\n• The conditions for valid wudu\n• Different schools of thought perspectives',
      contentTitle: 'Bahaar-e-Shariat',
      author: 'Maulana Amjad Ali Azmi',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      type: NoteType.personal,
      timestamp: '23:15',
    ),
    NoteItem(
      id: '2',
      title: 'Beautiful Reflection',
      content: 'This passage about the mercy of Allah really touched my heart. It reminds us that no matter how many sins we commit, Allah\'s mercy is always greater.',
      contentTitle: 'Kanz ul Iman',
      author: 'Imam Ahmed Raza Khan Barelvi',
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
      modifiedAt: DateTime.now().subtract(const Duration(hours: 2)),
      type: NoteType.thought,
      timestamp: '15:30',
    ),
    NoteItem(
      id: '3',
      title: 'Highlighted Quote',
      content: '"The best of people are those who benefit others" - This quote perfectly encapsulates the Islamic teaching of service to humanity.',
      contentTitle: 'Jaa al-Haq',
      author: 'Allama Kaukab Noorani Okarvi',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      type: NoteType.highlight,
      timestamp: '42:18',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F7), // iOS background
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_rounded,
            color: colorScheme.onSurface,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(
          children: [
            Icon(
              Icons.bookmark_rounded,
              color: colorScheme.primary,
              size: AppSpacing.iconMedium,
            ),
            const SizedBox(width: AppSpacing.small),
            const AppTitleText('Bookmarks & Notes'),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.search_rounded,
              color: colorScheme.onSurface,
            ),
            onPressed: () => debugPrint('Search tapped'),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: colorScheme.primary,
          unselectedLabelColor: colorScheme.onSurfaceVariant,
          indicatorColor: colorScheme.primary,
          tabs: const [
            Tab(
              icon: Icon(Icons.bookmark_rounded),
              text: 'Bookmarks',
            ),
            Tab(
              icon: Icon(Icons.note_rounded),
              text: 'Notes',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildBookmarksTab(),
          _buildNotesTab(),
        ],
      ),
    );
  }

  Widget _buildBookmarksTab() {
    return Column(
      children: [
        // Stats header
        Container(
          margin: const EdgeInsets.all(AppSpacing.medium),
          child: AppCard(
            child: Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    icon: Icons.bookmark_rounded,
                    label: 'Total Bookmarks',
                    value: _mockBookmarks.length.toString(),
                    color: Colors.blue,
                  ),
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
                ),
                Expanded(
                  child: _buildStatItem(
                    icon: Icons.access_time_rounded,
                    label: 'This Week',
                    value: '12',
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),
        ),
        
        // Bookmarks list
        Expanded(
          child: _mockBookmarks.isEmpty 
              ? _buildEmptyState(
                  icon: Icons.bookmark_border_rounded,
                  title: 'No Bookmarks Yet',
                  description: 'Tap the bookmark icon while listening to save your favorite moments',
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.medium),
                  itemCount: _mockBookmarks.length,
                  itemBuilder: (context, index) {
                    final bookmark = _mockBookmarks[index];
                    return _BookmarkTile(bookmark: bookmark);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildNotesTab() {
    return Column(
      children: [
        // Add note button
        Container(
          width: double.infinity,
          margin: const EdgeInsets.all(AppSpacing.medium),
          child: AppPrimaryButton(
            onPressed: () => _showAddNoteDialog(),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.add_rounded),
                SizedBox(width: AppSpacing.small),
                Text('Add New Note'),
              ],
            ),
          ),
        ),
        
        // Notes list
        Expanded(
          child: _mockNotes.isEmpty 
              ? _buildEmptyState(
                  icon: Icons.note_add_rounded,
                  title: 'No Notes Yet',
                  description: 'Start taking notes while listening to remember key insights',
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.medium),
                  itemCount: _mockNotes.length,
                  itemBuilder: (context, index) {
                    final note = _mockNotes[index];
                    return _NoteTile(note: note);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    final theme = Theme.of(context);
    
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
          ),
          child: Icon(
            icon,
            color: color,
            size: AppSpacing.iconMedium,
          ),
        ),
        const SizedBox(height: AppSpacing.small),
        Text(
          value,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        AppCaptionText(
          label,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String description,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.large),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: AppSpacing.iconHero,
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            ),
            const SizedBox(height: AppSpacing.large),
            AppTitleText(title),
            const SizedBox(height: AppSpacing.small),
            AppBodyText(
              description,
              textAlign: TextAlign.center,
              color: colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }

  void _showAddNoteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Note'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Note Title',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Note Content',
                border: OutlineInputBorder(),
              ),
              maxLines: 4,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              debugPrint('Note added');
            },
            child: const Text('Add Note'),
          ),
        ],
      ),
    );
  }
}

/// Individual bookmark tile widget
class _BookmarkTile extends StatelessWidget {
  final BookmarkItem bookmark;

  const _BookmarkTile({required this.bookmark});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AppCard(
      margin: const EdgeInsets.only(bottom: AppSpacing.small),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(
                _getBookmarkIcon(bookmark.type),
                color: _getBookmarkColor(bookmark.type),
                size: AppSpacing.iconSmall,
              ),
              const SizedBox(width: AppSpacing.small),
              Expanded(
                child: AppSubtitleText(
                  bookmark.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                bookmark.timestamp,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.small),
          
          // Content info
          Row(
            children: [
              Icon(
                Icons.book_rounded,
                color: colorScheme.onSurfaceVariant,
                size: AppSpacing.iconExtraSmall,
              ),
              const SizedBox(width: AppSpacing.extraSmall),
              Expanded(
                child: AppCaptionText(
                  '${bookmark.contentTitle} • ${bookmark.author}',
                  color: colorScheme.onSurfaceVariant,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.small),
          
          // Snippet
          AppCaptionText(
            bookmark.snippet,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSpacing.small),
          
          // Actions
          Row(
            children: [
              _ActionButton(
                icon: Icons.play_arrow_rounded,
                label: 'Play',
                onTap: () => debugPrint('Play bookmark'),
              ),
              const SizedBox(width: AppSpacing.medium),
              _ActionButton(
                icon: Icons.share_rounded,
                label: 'Share',
                onTap: () => debugPrint('Share bookmark'),
              ),
              const Spacer(),
              IconButton(
                icon: Icon(
                  Icons.more_vert_rounded,
                  color: colorScheme.onSurfaceVariant,
                  size: AppSpacing.iconSmall,
                ),
                onPressed: () => debugPrint('More options'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  IconData _getBookmarkIcon(BookmarkType type) {
    switch (type) {
      case BookmarkType.chapter:
        return Icons.menu_book_rounded;
      case BookmarkType.quote:
        return Icons.format_quote_rounded;
      case BookmarkType.moment:
        return Icons.favorite_rounded;
    }
  }

  Color _getBookmarkColor(BookmarkType type) {
    switch (type) {
      case BookmarkType.chapter:
        return Colors.blue;
      case BookmarkType.quote:
        return Colors.orange;
      case BookmarkType.moment:
        return Colors.red;
    }
  }
}

/// Individual note tile widget
class _NoteTile extends StatelessWidget {
  final NoteItem note;

  const _NoteTile({required this.note});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AppCard(
      margin: const EdgeInsets.only(bottom: AppSpacing.small),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(
                _getNoteIcon(note.type),
                color: _getNoteColor(note.type),
                size: AppSpacing.iconSmall,
              ),
              const SizedBox(width: AppSpacing.small),
              Expanded(
                child: AppSubtitleText(
                  note.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                _formatDate(note.createdAt),
                style: theme.textTheme.labelSmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.small),
          
          // Content info
          Row(
            children: [
              Icon(
                Icons.book_rounded,
                color: colorScheme.onSurfaceVariant,
                size: AppSpacing.iconExtraSmall,
              ),
              const SizedBox(width: AppSpacing.extraSmall),
              Expanded(
                child: AppCaptionText(
                  '${note.contentTitle} • ${note.author} • ${note.timestamp}',
                  color: colorScheme.onSurfaceVariant,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.small),
          
          // Note content
          AppCaptionText(
            note.content,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          
          if (note.modifiedAt != null) ...[
            const SizedBox(height: AppSpacing.small),
            AppCaptionText(
              'Last modified: ${_formatDate(note.modifiedAt!)}',
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
            ),
          ],
          const SizedBox(height: AppSpacing.small),
          
          // Actions
          Row(
            children: [
              _ActionButton(
                icon: Icons.edit_rounded,
                label: 'Edit',
                onTap: () => debugPrint('Edit note'),
              ),
              const SizedBox(width: AppSpacing.medium),
              _ActionButton(
                icon: Icons.share_rounded,
                label: 'Share',
                onTap: () => debugPrint('Share note'),
              ),
              const Spacer(),
              IconButton(
                icon: Icon(
                  Icons.more_vert_rounded,
                  color: colorScheme.onSurfaceVariant,
                  size: AppSpacing.iconSmall,
                ),
                onPressed: () => debugPrint('More options'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  IconData _getNoteIcon(NoteType type) {
    switch (type) {
      case NoteType.personal:
        return Icons.person_rounded;
      case NoteType.highlight:
        return Icons.highlight_rounded;
      case NoteType.thought:
        return Icons.lightbulb_rounded;
    }
  }

  Color _getNoteColor(NoteType type) {
    switch (type) {
      case NoteType.personal:
        return Colors.green;
      case NoteType.highlight:
        return Colors.yellow.shade700;
      case NoteType.thought:
        return Colors.purple;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}

/// Action button widget for tiles
class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: colorScheme.primary,
            size: AppSpacing.iconSmall,
          ),
          const SizedBox(width: AppSpacing.extraSmall),
          AppCaptionText(
            label,
            color: colorScheme.primary,
          ),
        ],
      ),
    );
  }
}