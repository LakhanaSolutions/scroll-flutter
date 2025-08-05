import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../data/mock_data.dart';
import '../../theme/app_spacing.dart';
import '../../theme/theme_extensions.dart';
import '../../theme/app_icons.dart';
import '../../widgets/text/app_text.dart';
import '../../widgets/buttons/app_buttons.dart';
import '../../widgets/cards/app_card.dart';
import '../../widgets/dialogs/app_dialogs.dart';

enum NoteType { personal, highlight, thought }

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

/// Library tab content widget
/// Shows user's personal library with recently played and downloaded books
class LibraryTab extends StatefulWidget {
  final int initialTabIndex;
  
  const LibraryTab({
    super.key, 
    this.initialTabIndex = 0,
  });

  @override
  State<LibraryTab> createState() => _LibraryTabState();
}

class _LibraryTabState extends State<LibraryTab> with TickerProviderStateMixin {
  late TabController _tabController;
  
  // Filter state for notes
  Set<NoteType> _selectedNoteTypes = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 3, 
      vsync: this,
      initialIndex: widget.initialTabIndex,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

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

    return Column(
      children: [
        // Header
        Container(
          padding: const EdgeInsets.all(AppSpacing.medium),
          decoration: BoxDecoration(
            color: context.appTheme.iosBackground, // Match scaffold background
            border: Border(
              bottom: BorderSide(
                color: colorScheme.outline.withValues(alpha: 0.1),
                width: 1,
              ),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    AppIcons.library,
                    color: colorScheme.primary,
                    size: AppSpacing.iconMedium,
                  ),
                  const SizedBox(width: AppSpacing.small),
                  const AppTitleText('My Library'),
                ],
              ),
              const SizedBox(height: AppSpacing.medium),
              // Tab bar
              TabBar(
                controller: _tabController,
                // isScrollable: true,
                labelColor: colorScheme.primary,
                unselectedLabelColor: colorScheme.onSurfaceVariant,
                indicatorColor: colorScheme.primary,
                dividerColor: Colors.transparent,
                tabs: const [
                  Tab(text: 'Recent'),
                  Tab(text: 'Saved'),
                  Tab(text: 'Notes'),
                ],
              ),
            ],
          ),
        ),
        
        // Tab content
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildRecentlyPlayedTab(),
              _buildSavedTab(),
              _buildNotesTab(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRecentlyPlayedTab() {
    final recentlyPlayed = MockData.getRecentlyPlayed();

    if (recentlyPlayed.isEmpty) {
      return _buildEmptyState(
        icon: Icons.history_rounded,
        title: 'No Recent Activity',
        description: 'Books you listen to will appear here',
        actionText: 'Browse Books',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.medium),
      itemCount: recentlyPlayed.length,
      itemBuilder: (context, index) {
        final book = recentlyPlayed[index];
        return _RecentlyPlayedTile(
          book: book,
          onTap: () {
            context.push('/home/playlist/${book.id}?progress=${book.progress}');
          },
        );
      },
    );
  }

  Widget _buildSavedTab() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.medium),
      children: [
        // Bookmarks tile
        _SavedMenuItem(
          icon: Icons.bookmark_rounded,
          title: 'Bookmarks',
          subtitle: 'Your saved playlists and books',
          onTap: () => context.push('/home/bookmarks'),
        ),
        const SizedBox(height: AppSpacing.medium),
        // Downloads tile
        _SavedMenuItem(
          icon: Icons.download_rounded,
          title: 'Downloads',
          subtitle: 'Offline content for listening',
          onTap: () => context.push('/home/downloads'),
        ),
        const SizedBox(height: AppSpacing.medium),
        // Following tile
        _SavedMenuItem(
          icon: Icons.person_add_rounded,
          title: 'Following',
          subtitle: 'Authors and narrators you follow',
          onTap: () => context.push('/home/following'),
        ),
      ],
    );
  }

  Widget _buildDownloadsTab() {
    final downloads = MockData.getDownloadedBooks();

    if (downloads.isEmpty) {
      return _buildEmptyState(
        icon: Icons.download_rounded,
        title: 'No Downloads',
        description: 'Books you download will appear here for offline listening',
        actionText: 'Browse Books',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.medium),
      itemCount: downloads.length,
      itemBuilder: (context, index) {
        final book = downloads[index];
        return _DownloadedBookTile(
          book: book,
          onTap: () {
            debugPrint('Downloaded book tapped: ${book.title}');
          },
          onDelete: () {
            _showDeleteConfirmation(book);
          },
        );
      },
    );
  }

  Widget _buildFollowingTab() {
    final followedNarrators = MockData.getFollowedNarrators();
    final followedAuthors = MockData.getFollowedAuthors();
    
    if (followedNarrators.isEmpty && followedAuthors.isEmpty) {
      return _buildEmptyState(
        icon: Icons.person_add_rounded,
        title: 'Not Following Anyone',
        description: 'Authors and narrators you follow will appear here',
        actionText: 'Explore Authors',
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.medium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Narrators section
          if (followedNarrators.isNotEmpty) ...[
            _buildFollowingSection(
              title: 'Narrators',
              count: followedNarrators.length,
              icon: Icons.mic_rounded,
            ),
            const SizedBox(height: AppSpacing.medium),
            ...followedNarrators.map((narrator) {
              return _FollowingTile(
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
              );
            }),
            if (followedAuthors.isNotEmpty)
              const SizedBox(height: AppSpacing.large),
          ],
          
          // Authors section
          if (followedAuthors.isNotEmpty) ...[
            _buildFollowingSection(
              title: 'Authors',
              count: followedAuthors.length,
              icon: Icons.edit_rounded,
            ),
            const SizedBox(height: AppSpacing.medium),
            ...followedAuthors.map((author) {
              return _FollowingTile(
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
              );
            }),
          ],
        ],
      ),
    );
  }

  Widget _buildNotesTab() {
    final filteredNotes = _selectedNoteTypes.isEmpty 
        ? _mockNotes 
        : _mockNotes.where((note) => _selectedNoteTypes.contains(note.type)).toList();

    return Column(
      children: [
        // Filter header
        Container(
          padding: const EdgeInsets.all(AppSpacing.medium),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.1),
                width: 1,
              ),
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.notes_rounded,
                color: Theme.of(context).colorScheme.primary,
                size: AppSpacing.iconSmall,
              ),
              const SizedBox(width: AppSpacing.small),
              const Expanded(
                child: AppSubtitleText('Notes'),
              ),
              _buildNotesFilterButton(context),
            ],
          ),
        ),
        
        // Notes content
        Expanded(
          child: filteredNotes.isEmpty 
              ? _buildEmptyState(
                  icon: Icons.note_add_rounded,
                  title: _selectedNoteTypes.isEmpty ? 'No Notes Yet' : 'No Notes Found',
                  description: _selectedNoteTypes.isEmpty 
                      ? 'Start taking notes while listening to remember key insights'
                      : 'No notes match the selected filters',
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(AppSpacing.medium),
                  itemCount: filteredNotes.length,
                  itemBuilder: (context, index) {
                    final note = filteredNotes[index];
                    return _NoteTile(
                      note: note,
                      onEdit: () => _editNote(note),
                    );
                  },
                ),
        ),
      ],
    );
  }

  void _editNote(NoteItem note) {
    // Mock chapter and content data for editing - in real app this would come from the note
    final mockAuthor = AuthorData(
      id: 'author1',
      name: note.author,
      bio: 'Renowned Islamic scholar and author',
      nationality: 'Unknown',
      birthYear: '1800',
      genres: ['Islamic Studies'],
      awards: [],
      socialLinks: [],
      quote: 'Knowledge is light',
      totalBooks: 50,
    );

    final mockChapter = ChapterData(
      id: 'chapter1',
      title: note.contentTitle,
      description: 'Chapter containing this note',
      duration: '30m',
      chapterNumber: 1,
      status: ChapterStatus.notPlayed,
      narratorId: 'narrator1',
      progress: 0.5,
    );
    
    final mockContent = ContentItemData(
      id: 'content1',
      title: note.contentTitle,
      author: note.author,
      authorData: mockAuthor,
      coverUrl: 'https://via.placeholder.com/150x200',
      type: ContentType.book,
      availability: AvailabilityType.free,
      rating: 4.5,
      duration: '5h 30m',
      chapterCount: 10,
      description: 'Book description',
      narrators: [
        NarratorData(
          id: 'narrator1',
          name: note.author,
          bio: 'Author bio',
          languages: ['Arabic', 'Urdu'],
          genres: ['Islamic Studies'],
          awards: [],
          socialLinks: [],
          experienceYears: 20,
          voiceDescription: 'Clear voice',
          totalNarrations: 10,
          isFollowing: false,
        ),
      ],
      chapters: [mockChapter],
      isBookmarked: false,
    );

    context.push('/home/note/${mockChapter.id}/${mockContent.id}?position=${_parseTimestamp(note.timestamp)}&wasPlaying=false');
  }

  double _parseTimestamp(String timestamp) {
    // Parse timestamp like "23:15" to seconds
    final parts = timestamp.split(':');
    if (parts.length == 2) {
      final minutes = int.tryParse(parts[0]) ?? 0;
      final seconds = int.tryParse(parts[1]) ?? 0;
      return (minutes * 60 + seconds).toDouble();
    }
    return 0.0;
  }

  Widget _buildNotesFilterButton(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final hasActiveFilters = _selectedNoteTypes.isNotEmpty;

    return Stack(
      children: [
        AppIconButton(
          icon: Icons.tune_rounded,
          onPressed: () => _showNotesFiltersBottomSheet(context),
          tooltip: 'Filter Notes',
        ),
        if (hasActiveFilters)
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                color: colorScheme.primary,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '${_selectedNoteTypes.length}',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 9,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  void _showNotesFiltersBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppSpacing.radiusLarge),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle
              Container(
                margin: const EdgeInsets.only(top: AppSpacing.medium),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Content
              Padding(
                padding: const EdgeInsets.all(AppSpacing.large),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    const AppTitleText('Filter Notes'),
                    const SizedBox(height: AppSpacing.large),
                    
                    // Note types section
                    _buildNoteTypesFilterSection(context, setModalState),
                    
                    const SizedBox(height: AppSpacing.large),
                    
                    // Clear filters button
                    if (_selectedNoteTypes.isNotEmpty)
                      Center(
                        child: AppSecondaryButton(
                          onPressed: () {
                            setState(() {
                              _selectedNoteTypes.clear();
                            });
                            setModalState(() {});
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.clear_rounded,
                                size: AppSpacing.iconSmall,
                              ),
                              const SizedBox(width: AppSpacing.small),
                              const Text('Clear Filters'),
                            ],
                          ),
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

  Widget _buildNoteTypesFilterSection(BuildContext context, StateSetter setModalState) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.category_rounded,
              color: colorScheme.primary,
              size: AppSpacing.iconSmall,
            ),
            const SizedBox(width: AppSpacing.small),
            Text(
              'Note Types',
              style: theme.textTheme.labelLarge?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.medium),
        Wrap(
          spacing: AppSpacing.small,
          runSpacing: AppSpacing.small,
          children: NoteType.values.map((noteType) {
            final isSelected = _selectedNoteTypes.contains(noteType);
            return _NoteTypeFilterChip(
              noteType: noteType,
              isSelected: isSelected,
              onTap: () {
                setState(() {
                  if (isSelected) {
                    _selectedNoteTypes.remove(noteType);
                  } else {
                    _selectedNoteTypes.add(noteType);
                  }
                });
                setModalState(() {});
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildFollowingSection({
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

  void _showDeleteConfirmation(DownloadedBookData book) {
    AppAlertDialog.show(
      context,
      title: 'Delete Download',
      content: Text('Are you sure you want to delete "${book.title}" from your downloads?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            debugPrint('Deleting book: ${book.title}');
            // Handle delete logic here
          },
          style: TextButton.styleFrom(
            foregroundColor: Theme.of(context).colorScheme.error,
          ),
          child: const Text('Delete'),
        ),
      ],
    );
  }



  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String description,
    String? actionText,
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
            if (actionText != null) ...[
              const SizedBox(height: AppSpacing.large),
              AppPrimaryButton(
                onPressed: () {
                  debugPrint('Empty state action tapped');
                },
                child: Text(actionText),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Recently played book tile widget
class _RecentlyPlayedTile extends StatelessWidget {
  final RecentlyPlayedData book;
  final VoidCallback? onTap;

  const _RecentlyPlayedTile({
    required this.book,
    this.onTap,
  });

  String _formatPlayedWhen(DateTime playedWhen) {
    final now = DateTime.now();
    final difference = now.difference(playedWhen);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${(difference.inDays / 7).floor()} weeks ago';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AppCard(
      elevation: 0,
      backgroundColor: colorScheme.surfaceContainer,
      margin: const EdgeInsets.only(bottom: AppSpacing.small),
      onTap: onTap,
      child: Row(
        children: [
          // Book cover
          Stack(
            children: [
              Container(
                width: 60,
                height: 80,
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
                ),
                child: Icon(
                  Icons.menu_book_rounded,
                  color: colorScheme.onPrimary,
                  size: AppSpacing.iconMedium,
                ),
              ),
              // Finished indicator
              if (book.isFinished)
                Positioned(
                  top: 4,
                  right: 4,
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.check,
                      color: colorScheme.onPrimary,
                      size: 14,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: AppSpacing.medium),
          // Book info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppSubtitleText(
                  book.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.extraSmall),
                AppCaptionText(
                  'by ${book.narrator}',
                  color: colorScheme.onSurfaceVariant,
                ),
                const SizedBox(height: AppSpacing.extraSmall),
                Row(
                  children: [
                    AppCaptionText(
                      _formatPlayedWhen(book.playedWhen),
                      color: colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: AppSpacing.medium),
                    Icon(
                      Icons.access_time_rounded,
                      size: AppSpacing.iconExtraSmall,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: AppSpacing.extraSmall),
                    AppCaptionText(
                      '${book.playedMinutes} min',
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ],
                ),
                if (!book.isFinished) ...[
                  const SizedBox(height: AppSpacing.small),
                  // Progress bar
                  LinearProgressIndicator(
                    value: book.progress,
                    backgroundColor: colorScheme.surfaceContainerLow,
                    valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Downloaded book tile widget
class _DownloadedBookTile extends StatelessWidget {
  final DownloadedBookData book;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const _DownloadedBookTile({
    required this.book,
    this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AppCard(
      margin: const EdgeInsets.only(bottom: AppSpacing.small),
      onTap: onTap,
      child: Row(
        children: [
          // Book cover
          Container(
            width: 60,
            height: 80,
            decoration: BoxDecoration(
              color: colorScheme.primary,
              borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
            ),
            child: Icon(
              Icons.menu_book_rounded,
              color: colorScheme.onPrimary,
              size: AppSpacing.iconMedium,
            ),
          ),
          const SizedBox(width: AppSpacing.medium),
          // Book info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppSubtitleText(
                  book.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.extraSmall),
                AppCaptionText(
                  'by ${book.narrator}',
                  color: colorScheme.onSurfaceVariant,
                ),
                const SizedBox(height: AppSpacing.extraSmall),
                AppCaptionText(
                  book.downloadSize,
                  color: colorScheme.onSurfaceVariant,
                ),
                if (book.isDownloading) ...[
                  const SizedBox(height: AppSpacing.small),
                  // Download progress bar
                  LinearProgressIndicator(
                    value: book.downloadProgress,
                    backgroundColor: colorScheme.surfaceContainer,
                    valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
                  ),
                  const SizedBox(height: AppSpacing.extraSmall),
                  AppCaptionText(
                    '${(book.downloadProgress * 100).toInt()}% downloaded',
                    color: colorScheme.onSurfaceVariant,
                  ),
                ],
              ],
            ),
          ),
          // Menu button
          PopupMenuButton<String>(
            icon: Icon(
              Icons.more_vert_rounded,
              color: colorScheme.onSurfaceVariant,
            ),
            onSelected: (value) {
              if (value == 'delete') {
                onDelete?.call();
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem<String>(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(
                      Icons.delete_rounded,
                      color: colorScheme.error,
                      size: AppSpacing.iconSmall,
                    ),
                    const SizedBox(width: AppSpacing.small),
                    Text(
                      'Delete',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.error,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
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
      margin: const EdgeInsets.only(bottom: AppSpacing.small),
      onTap: onTap,
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
    );
  }
}

/// Individual note tile widget
class _NoteTile extends StatelessWidget {
  final NoteItem note;
  final VoidCallback? onEdit;

  const _NoteTile({
    required this.note,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AppCard(
      elevation: 0,
      backgroundColor: colorScheme.surfaceContainer,
      margin: const EdgeInsets.only(bottom: AppSpacing.small),
      child: Row(
        children: [
          // Color indicator bar
          Container(
            width: 4,
            height: 120,
            decoration: BoxDecoration(
              color: _getNoteColor(note.type),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: AppSpacing.medium),
          // Note content
          Expanded(
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
                      onTap: onEdit ?? () => debugPrint('Edit note'),
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

/// Note type filter chip widget
class _NoteTypeFilterChip extends StatelessWidget {
  final NoteType noteType;
  final bool isSelected;
  final VoidCallback onTap;

  const _NoteTypeFilterChip({
    required this.noteType,
    required this.isSelected,
    required this.onTap,
  });

  String _getNoteTypeLabel(NoteType type) {
    switch (type) {
      case NoteType.personal:
        return 'Personal';
      case NoteType.highlight:
        return 'Highlight';
      case NoteType.thought:
        return 'Thought';
    }
  }

  Color _getNoteTypeColor(NoteType type) {
    switch (type) {
      case NoteType.personal:
        return Colors.green;
      case NoteType.highlight:
        return Colors.yellow.shade700;
      case NoteType.thought:
        return Colors.purple;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final noteColor = _getNoteTypeColor(noteType);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.medium,
          vertical: AppSpacing.small,
        ),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  colors: [
                    noteColor,
                    noteColor.withValues(alpha: 0.7),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isSelected ? null : colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
          border: Border.all(
            color: isSelected 
                ? Colors.transparent 
                : colorScheme.outline.withValues(alpha: 0.3),
            width: 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: noteColor.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Color dot
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: isSelected ? Colors.white : noteColor,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: AppSpacing.small),
            if (isSelected)
              Icon(
                Icons.check_rounded,
                color: Colors.white,
                size: AppSpacing.iconExtraSmall,
              ),
            if (isSelected)
              const SizedBox(width: AppSpacing.extraSmall),
            Text(
              _getNoteTypeLabel(noteType),
              style: theme.textTheme.labelMedium?.copyWith(
                color: isSelected 
                    ? Colors.white 
                    : colorScheme.onSurfaceVariant,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Saved menu item widget for the Saved tab
class _SavedMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _SavedMenuItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AppCard(
      elevation: 0,
      backgroundColor: colorScheme.surfaceContainer,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.medium),
        child: Row(
          children: [
            // Icon
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
              ),
              child: Icon(
                icon,
                color: colorScheme.onPrimaryContainer,
                size: AppSpacing.iconMedium,
              ),
            ),
            const SizedBox(width: AppSpacing.medium),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppSubtitleText(
                    title,
                    color: colorScheme.onSurface,
                  ),
                  const SizedBox(height: AppSpacing.extraSmall),
                  AppCaptionText(
                    subtitle,
                    color: colorScheme.onSurfaceVariant,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            // Arrow
            Icon(
              Icons.chevron_right_rounded,
              color: colorScheme.onSurfaceVariant,
              size: AppSpacing.iconMedium,
            ),
          ],
        ),
      ),
    );
  }
}