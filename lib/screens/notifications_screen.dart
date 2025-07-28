import 'package:flutter/material.dart';
import '../theme/app_spacing.dart';
import '../widgets/text/app_text.dart';
import '../widgets/cards/app_card.dart';

enum NotificationFrequency { never, daily, weekly, monthly }

class NotificationPreference {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  bool isEnabled;

  NotificationPreference({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    this.isEnabled = true,
  });
}

/// Notifications preferences screen
class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool _masterNotifications = true;
  NotificationFrequency _newContentFrequency = NotificationFrequency.weekly;
  NotificationFrequency _reminderFrequency = NotificationFrequency.daily;
  
  final List<NotificationPreference> _preferences = [
    NotificationPreference(
      id: 'new_releases',
      title: 'New Releases',
      description: 'Notify me when new audiobooks and lectures are added',
      icon: Icons.new_releases_rounded,
      isEnabled: true,
    ),
    NotificationPreference(
      id: 'featured_content',
      title: 'Featured Content',
      description: 'Weekly highlights and editor\'s picks',
      icon: Icons.star_rounded,
      isEnabled: true,
    ),
    NotificationPreference(
      id: 'listening_reminders',
      title: 'Listening Reminders',
      description: 'Gentle reminders to continue your spiritual journey',
      icon: Icons.schedule_rounded,
      isEnabled: false,
    ),
    NotificationPreference(
      id: 'subscription_updates',
      title: 'Subscription Updates',
      description: 'Important updates about your subscription',
      icon: Icons.subscriptions_rounded,
      isEnabled: true,
    ),
    NotificationPreference(
      id: 'download_complete',
      title: 'Download Complete',
      description: 'When your offline content finishes downloading',
      icon: Icons.download_done_rounded,
      isEnabled: true,
    ),
    NotificationPreference(
      id: 'special_events',
      title: 'Special Events',
      description: 'Live lectures, Q&A sessions, and special occasions',
      icon: Icons.event_rounded,
      isEnabled: true,
    ),
    NotificationPreference(
      id: 'progress_milestones',
      title: 'Progress Milestones',
      description: 'Celebrate your listening achievements',
      icon: Icons.emoji_events_rounded,
      isEnabled: false,
    ),
  ];

  String _getFrequencyLabel(NotificationFrequency frequency) {
    switch (frequency) {
      case NotificationFrequency.never:
        return 'Never';
      case NotificationFrequency.daily:
        return 'Daily';
      case NotificationFrequency.weekly:
        return 'Weekly';
      case NotificationFrequency.monthly:
        return 'Monthly';
    }
  }

  void _showFrequencySelector({
    required String title,
    required NotificationFrequency currentValue,
    required ValueChanged<NotificationFrequency> onChanged,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _FrequencyBottomSheet(
        title: title,
        currentValue: currentValue,
        onChanged: onChanged,
      ),
    );
  }

  Future<void> _savePreferences() async {
    // TODO: Implement saving notification preferences
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Notification preferences saved'),
        backgroundColor: Colors.green,
      ),
    );
  }

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
              Icons.notifications_rounded,
              color: colorScheme.primary,
              size: AppSpacing.iconMedium,
            ),
            const SizedBox(width: AppSpacing.small),
            const AppTitleText('Notifications'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: _savePreferences,
            child: const Text('Save'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              color: colorScheme.surface,
              padding: const EdgeInsets.all(AppSpacing.large),
              child: Column(
                children: [
                  Icon(
                    Icons.notifications_active_rounded,
                    size: 48,
                    color: colorScheme.primary,
                  ),
                  const SizedBox(height: AppSpacing.medium),
                  const AppTitleText(
                    'Notification Preferences',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.small),
                  AppBodyText(
                    'Customize what notifications you receive',
                    textAlign: TextAlign.center,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.medium),

            // Master notification toggle
            Container(
              margin: const EdgeInsets.symmetric(horizontal: AppSpacing.medium),
              child: AppCard(
                child: SwitchListTile(
                  secondary: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: _masterNotifications 
                          ? colorScheme.primaryContainer 
                          : colorScheme.surfaceContainer,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
                    ),
                    child: Icon(
                      _masterNotifications 
                          ? Icons.notifications_active_rounded 
                          : Icons.notifications_off_rounded,
                      color: _masterNotifications 
                          ? colorScheme.onPrimaryContainer 
                          : colorScheme.onSurfaceVariant,
                      size: AppSpacing.iconMedium,
                    ),
                  ),
                  title: const AppSubtitleText('Allow Notifications'),
                  subtitle: AppCaptionText(
                    _masterNotifications 
                        ? 'Notifications are enabled' 
                        : 'All notifications are disabled',
                    color: colorScheme.onSurfaceVariant,
                  ),
                  value: _masterNotifications,
                  onChanged: (value) {
                    setState(() {
                      _masterNotifications = value;
                    });
                  },
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),

            if (_masterNotifications) ...[
              const SizedBox(height: AppSpacing.large),

              // Notification categories
              _buildSection(
                context,
                title: 'Notification Types',
                children: _preferences.map((pref) {
                  return _buildNotificationTile(context, pref);
                }).toList(),
              ),

              const SizedBox(height: AppSpacing.large),

              // Frequency settings
              _buildSection(
                context,
                title: 'Frequency Settings',
                children: [
                  _buildFrequencyTile(
                    context,
                    icon: Icons.new_releases_rounded,
                    title: 'New Content Updates',
                    subtitle: 'How often to notify about new releases',
                    frequency: _newContentFrequency,
                    onTap: () => _showFrequencySelector(
                      title: 'New Content Updates',
                      currentValue: _newContentFrequency,
                      onChanged: (value) {
                        setState(() {
                          _newContentFrequency = value;
                        });
                      },
                    ),
                    isFirst: true,
                  ),
                  _buildFrequencyTile(
                    context,
                    icon: Icons.schedule_rounded,
                    title: 'Listening Reminders',
                    subtitle: 'Frequency of gentle listening reminders',
                    frequency: _reminderFrequency,
                    onTap: () => _showFrequencySelector(
                      title: 'Listening Reminders',
                      currentValue: _reminderFrequency,
                      onChanged: (value) {
                        setState(() {
                          _reminderFrequency = value;
                        });
                      },
                    ),
                    isLast: true,
                  ),
                ],
              ),

              const SizedBox(height: AppSpacing.large),

              // Quiet hours
              _buildSection(
                context,
                title: 'Quiet Hours',
                children: [
                  ListTile(
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
                      ),
                      child: Icon(
                        Icons.bedtime_rounded,
                        color: colorScheme.onPrimaryContainer,
                        size: AppSpacing.iconMedium,
                      ),
                    ),
                    title: const AppBodyText('Do Not Disturb'),
                    subtitle: AppCaptionText(
                      '10:00 PM - 7:00 AM',
                      color: colorScheme.onSurfaceVariant,
                    ),
                    trailing: Icon(
                      Icons.chevron_right_rounded,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    onTap: () {
                      // TODO: Show time picker for quiet hours
                      debugPrint('Configure quiet hours');
                    },
                    contentPadding: EdgeInsets.zero,
                  ),
                ],
              ),
            ],

            const SizedBox(height: AppSpacing.section),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required List<Widget> children,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.medium),
          child: Text(
            title.toUpperCase(),
            style: theme.textTheme.labelSmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.bold,
              fontSize: 10,
              letterSpacing: 1.2,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.small),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: AppSpacing.medium),
          child: AppCard(
            padding: EdgeInsets.zero,
            child: Column(children: children),
          ),
        ),
      ],
    );
  }

  Widget _buildNotificationTile(BuildContext context, NotificationPreference pref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        border: _preferences.last != pref ? Border(
          bottom: BorderSide(
            color: colorScheme.outline.withValues(alpha: 0.1),
            width: 1,
          ),
        ) : null,
      ),
      child: SwitchListTile(
        secondary: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: pref.isEnabled 
                ? colorScheme.primaryContainer 
                : colorScheme.surfaceContainer,
            borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
          ),
          child: Icon(
            pref.icon,
            color: pref.isEnabled 
                ? colorScheme.onPrimaryContainer 
                : colorScheme.onSurfaceVariant,
            size: AppSpacing.iconMedium,
          ),
        ),
        title: AppBodyText(pref.title),
        subtitle: AppCaptionText(
          pref.description,
          color: colorScheme.onSurfaceVariant,
        ),
        value: pref.isEnabled,
        onChanged: (value) {
          setState(() {
            pref.isEnabled = value;
          });
        },
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.medium,
          vertical: AppSpacing.small,
        ),
      ),
    );
  }

  Widget _buildFrequencyTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required NotificationFrequency frequency,
    required VoidCallback onTap,
    bool isFirst = false,
    bool isLast = false,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        border: !isLast ? Border(
          bottom: BorderSide(
            color: colorScheme.outline.withValues(alpha: 0.1),
            width: 1,
          ),
        ) : null,
      ),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
          ),
          child: Icon(
            icon,
            color: colorScheme.onPrimaryContainer,
            size: AppSpacing.iconMedium,
          ),
        ),
        title: AppBodyText(title),
        subtitle: AppCaptionText(
          subtitle,
          color: colorScheme.onSurfaceVariant,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppBodyText(
              _getFrequencyLabel(frequency),
              color: colorScheme.primary,
            ),
            const SizedBox(width: AppSpacing.small),
            Icon(
              Icons.chevron_right_rounded,
              color: colorScheme.onSurfaceVariant,
            ),
          ],
        ),
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.medium,
          vertical: AppSpacing.small,
        ),
      ),
    );
  }
}

/// Frequency selection bottom sheet
class _FrequencyBottomSheet extends StatelessWidget {
  final String title;
  final NotificationFrequency currentValue;
  final ValueChanged<NotificationFrequency> onChanged;

  const _FrequencyBottomSheet({
    required this.title,
    required this.currentValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
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
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // Title
          Padding(
            padding: const EdgeInsets.all(AppSpacing.large),
            child: AppTitleText(title),
          ),
          
          // Options
          Padding(
            padding: const EdgeInsets.only(
              left: AppSpacing.large,
              right: AppSpacing.large,
              bottom: AppSpacing.large,
            ),
            child: Column(
              children: NotificationFrequency.values.map((frequency) {
                return Column(
                  children: [
                    AppCard(
                      onTap: () {
                        onChanged(frequency);
                        Navigator.pop(context);
                      },
                      child: ListTile(
                        title: AppBodyText(_getFrequencyLabel(frequency)),
                        trailing: Radio<NotificationFrequency>(
                          value: frequency,
                          groupValue: currentValue,
                          onChanged: (value) {
                            onChanged(value!);
                            Navigator.pop(context);
                          },
                        ),
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                    if (frequency != NotificationFrequency.values.last)
                      const SizedBox(height: AppSpacing.small),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  String _getFrequencyLabel(NotificationFrequency frequency) {
    switch (frequency) {
      case NotificationFrequency.never:
        return 'Never';
      case NotificationFrequency.daily:
        return 'Daily';
      case NotificationFrequency.weekly:
        return 'Weekly';
      case NotificationFrequency.monthly:
        return 'Monthly';
    }
  }
}