import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../theme/app_spacing.dart';
import '../widgets/text/app_text.dart';
import '../widgets/app_bar/app_app_bar.dart';
import '../widgets/buttons/app_buttons.dart';
import '../widgets/cards/app_card.dart';
import '../widgets/inputs/app_text_field.dart';
import '../widgets/dialogs/app_dialogs.dart';

/// Note colors for categorization
enum NoteColor {
  blue(Color(0xFF2196F3), 'General'),
  green(Color(0xFF4CAF50), 'Important'),
  yellow(Color(0xFFFFC107), 'Highlight'),
  orange(Color(0xFFFF9800), 'Question'),
  red(Color(0xFFF44336), 'Critical'),
  purple(Color(0xFF9C27B0), 'Insight'),
  teal(Color(0xFF009688), 'Reference'),
  pink(Color(0xFFE91E63), 'Personal');

  const NoteColor(this.color, this.label);

  final Color color;
  final String label;
}

/// Note types for backward compatibility with existing notes
enum NoteType { personal, highlight, thought }

/// Note item data model
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

/// Note screen for adding timestamped notes during audio playback
class NoteScreen extends StatefulWidget {
  final ChapterData chapter;
  final ContentItemData content;
  final double currentPosition;
  final NoteItem? existingNote; // Optional existing note for editing
  final bool wasAudioPlaying; // Whether audio was playing when navigating here

  const NoteScreen({
    super.key,
    required this.chapter,
    required this.content,
    required this.currentPosition,
    this.existingNote,
    this.wasAudioPlaying = false,
  });

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  NoteColor _selectedColor = NoteColor.blue;
  bool _hasUnsavedChanges = false;

  @override
  void initState() {
    super.initState();
    _titleController.addListener(_onTextChanged);
    _noteController.addListener(_onTextChanged);
    
    // If editing existing note, prefill the fields
    if (widget.existingNote != null) {
      _titleController.text = widget.existingNote!.title;
      _noteController.text = widget.existingNote!.content;
      _selectedColor = _mapNoteTypeToColor(widget.existingNote!.type);
    }
  }

  @override
  void dispose() {
    _titleController.removeListener(_onTextChanged);
    _noteController.removeListener(_onTextChanged);
    _titleController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    if (!_hasUnsavedChanges) {
      setState(() {
        _hasUnsavedChanges = true;
      });
    }
  }

  String _formatTime(double seconds) {
    final hours = (seconds / 3600).floor();
    final minutes = ((seconds % 3600) / 60).floor();
    final secs = (seconds % 60).floor();
    
    if (hours > 0) {
      return '${hours.toString().padLeft(1, '0')}:${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
    } else {
      return '${minutes.toString().padLeft(1, '0')}:${secs.toString().padLeft(2, '0')}';
    }
  }

  /// Map NoteType to NoteColor for editing existing notes
  NoteColor _mapNoteTypeToColor(NoteType type) {
    switch (type) {
      case NoteType.personal:
        return NoteColor.pink;
      case NoteType.highlight:
        return NoteColor.yellow;
      case NoteType.thought:
        return NoteColor.purple;
    }
  }

  void _saveNote() {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add a title for your note'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (_noteController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add some content to your note'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // TODO: Implement actual save functionality
    final isEditing = widget.existingNote != null;
    debugPrint('${isEditing ? "Updated" : "Created"} note: ${_titleController.text} at ${_formatTime(widget.currentPosition)}');
    debugPrint('Content: ${_noteController.text}');
    debugPrint('Color: ${_selectedColor.label}');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isEditing ? 'Note updated successfully!' : 'Note saved successfully!'),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.of(context).pop();
  }

  void _discardChanges() {
    if (_hasUnsavedChanges) {
      AppAlertDialog.show(
        context,
        title: 'Discard Changes?',
        content: const Text('You have unsaved changes. Are you sure you want to discard them?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
              Navigator.of(context).pop(); // Close note screen
            },
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Discard'),
          ),
        ],
      );
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppAppBar(
        title: widget.existingNote != null ? 'Edit Note' : 'Add Note',
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: _discardChanges,
        ),
        actions: [
          TextButton(
            onPressed: _saveNote,
            child: Text(
              'Save',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () {
          // Dismiss keyboard when tapping outside text fields
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.medium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Privacy Info Section
              _buildPrivacyInfoSection(context),
              const SizedBox(height: AppSpacing.large),

              // Audio Status Section (only show if audio was playing)
              if (widget.wasAudioPlaying) ...[
                _buildAudioStatusSection(context),
                const SizedBox(height: AppSpacing.large),
              ],

              // Track Info Section
              _buildTrackInfoSection(context),
              const SizedBox(height: AppSpacing.large),
              
              // Color Selection
              _buildColorSelectionSection(context),
              const SizedBox(height: AppSpacing.large),
              
              // Note Input Fields
              _buildNoteInputSection(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTrackInfoSection(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final narrator = widget.content.narrators.firstWhere(
      (n) => n.id == widget.chapter.narratorId,
      orElse: () => widget.content.narrators.first,
    );

    return AppCard(
      child: Row(
        children: [
          // Color indicator bar
          Container(
            width: 6,
            height: 120,
            decoration: BoxDecoration(
              color: _selectedColor.color,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          const SizedBox(width: AppSpacing.medium),
          // Content info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    
                    AppSubtitleText(widget.existingNote != null ? 'Editing note at' : 'Note at'),
                    // const Spacer(),
                    const AppSubtitleText(' '),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.small,
                        vertical: AppSpacing.extraSmall,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
                      ),
                      child: Text(
                        widget.existingNote?.timestamp ?? _formatTime(widget.currentPosition),
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.medium),
                
                // Book/Content info
                _buildInfoRow(
                  context,
                  Icons.book_rounded,
                  'Book',
                  widget.content.title,
                ),
                const SizedBox(height: AppSpacing.small),
                
                _buildInfoRow(
                  context,
                  Icons.person_rounded,
                  'Narrator',
                  narrator.name,
                ),
                const SizedBox(height: AppSpacing.small),
                
                _buildInfoRow(
                  context,
                  Icons.library_books_rounded,
                  'Chapter',
                  widget.chapter.title,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, IconData icon, String label, String value) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: colorScheme.onSurfaceVariant,
          size: AppSpacing.iconExtraSmall,
        ),
        const SizedBox(width: AppSpacing.extraSmall),
        SizedBox(
          width: 60,
          child: AppCaptionText(
            label,
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(width: AppSpacing.small),
        Expanded(
          child: AppCaptionText(
            value,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildPrivacyInfoSection(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.medium),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
        border: Border.all(
          color: colorScheme.primary.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.lock_rounded,
            color: colorScheme.primary,
            size: AppSpacing.iconSmall,
          ),
          const SizedBox(width: AppSpacing.medium),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Private & Personal',
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppSpacing.extraSmall),
                Text(
                  'Your notes and bookmarks are personal and only visible to you. They are stored securely and never shared.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAudioStatusSection(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.medium),
      decoration: BoxDecoration(
        color: colorScheme.tertiaryContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
        border: Border.all(
          color: colorScheme.tertiary.withValues(alpha: 0.4),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.small),
            decoration: BoxDecoration(
              color: colorScheme.tertiary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.pause_circle_outline_rounded,
              color: colorScheme.tertiary,
              size: AppSpacing.iconMedium,
            ),
          ),
          const SizedBox(width: AppSpacing.medium),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Audio Paused',
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: colorScheme.tertiary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppSpacing.extraSmall),
                Text(
                  'Audio playback is automatically paused while taking notes to help you focus. It will resume when you go back to the player.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColorSelectionSection(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.palette_rounded,
              color: colorScheme.primary,
              size: AppSpacing.iconSmall,
            ),
            const SizedBox(width: AppSpacing.small),
            const AppSubtitleText('Note Category'),
          ],
        ),
        const SizedBox(height: AppSpacing.medium),
        
        // Color options
        Wrap(
          spacing: AppSpacing.small,
          runSpacing: AppSpacing.small,
          children: NoteColor.values.map((noteColor) {
            final isSelected = _selectedColor == noteColor;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedColor = noteColor;
                  _hasUnsavedChanges = true;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.medium,
                  vertical: AppSpacing.small,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? noteColor.color.withValues(alpha: 0.1) : colorScheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
                  border: Border.all(
                    color: isSelected ? noteColor.color : colorScheme.outline.withValues(alpha: 0.2),
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: noteColor.color,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.small),
                    Text(
                      noteColor.label,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: isSelected ? noteColor.color : colorScheme.onSurface,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildNoteInputSection(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.edit_rounded,
                color: colorScheme.primary,
                size: AppSpacing.iconSmall,
              ),
              const SizedBox(width: AppSpacing.small),
              const AppSubtitleText('Note Details'),
            ],
          ),
          const SizedBox(height: AppSpacing.medium),
          
          // Title field
          AppTextField(
            controller: _titleController,
            labelText: 'Title',
            hintText: 'Enter note title...',
            prefixIcon: const Icon(Icons.title_rounded),
            fillColor: colorScheme.surfaceContainerLow,
            isRequired: true,
          ),
          const SizedBox(height: AppSpacing.medium),
          
          // Note content field
          AppTextField(
            controller: _noteController,
            labelText: 'Note',
            hintText: 'Write your note here...',
            maxLines: 5,
            fillColor: colorScheme.surfaceContainerLow,
            isRequired: true,
          ),
          const SizedBox(height: AppSpacing.large),
          
          // Save button
          SizedBox(
            width: double.infinity,
            child: AppPrimaryButton(
              onPressed: _saveNote,
              child: Text(widget.existingNote != null ? 'Update Note' : 'Save Note'),
            ),
          ),
        ],
      ),
    );
  }
} 