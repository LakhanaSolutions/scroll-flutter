import 'package:flutter/material.dart';
import '../theme/app_spacing.dart';
import '../theme/theme_extensions.dart';
import '../widgets/text/app_text.dart';
import '../widgets/app_bar/app_app_bar.dart';
import '../widgets/cards/app_card.dart';
import '../widgets/buttons/app_buttons.dart';
import '../widgets/images/app_image.dart';
import 'manage_devices_screen.dart';

/// User profile screen showing profile details and settings
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _nameController = TextEditingController(text: 'Ahmed Al-Rashid');
  final _emailController = TextEditingController(text: 'ahmed.alrashid@example.com');
  bool _isEditing = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _toggleEdit() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  void _saveProfile() {
    // TODO: Implement save functionality
    setState(() {
      _isEditing = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile updated successfully')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: context.appTheme.iosSystemBackground,
      appBar: AppAppBar(
        title: 'Profile',
        actions: [
          IconButton(
            icon: Icon(
              Icons.edit_rounded,
              color: colorScheme.onSurfaceVariant,
            ),
            onPressed: () {
              debugPrint('Edit profile tapped');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header
            _buildProfileHeader(context),
            // Profile Form
            _buildProfileForm(context),
            // Settings Section
            _buildSettingsSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      color: colorScheme.surface,
      padding: const EdgeInsets.all(AppSpacing.large),
      child: Column(
        children: [
          // Profile Picture
          Stack(
            children: [
              AppCircularImage(
                imageUrl: null, // No profile image yet
                fallbackIcon: Icons.person_rounded,
                size: 120,
                backgroundColor: colorScheme.primaryContainer,
                iconColor: colorScheme.onPrimaryContainer,
                iconSize: 60,
              ),
              if (_isEditing)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () {
                      // TODO: Implement image picker
                      debugPrint('Change profile picture');
                    },
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: colorScheme.primary,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: colorScheme.surface,
                          width: 2,
                        ),
                      ),
                      child: Icon(
                        Icons.camera_alt_rounded,
                        color: colorScheme.onPrimary,
                        size: 18,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.medium),
          // User Name
          if (!_isEditing) ...[
            AppTitleText(
              _nameController.text,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.small),
            AppBodyText(
              _emailController.text,
              color: colorScheme.onSurfaceVariant,
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildProfileForm(BuildContext context) {
    if (!_isEditing) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.medium),
      child: AppCard(
        gradient: LinearGradient(
          colors: [
            colorScheme.surfaceContainer.withValues(alpha: 0.8),
            colorScheme.surfaceContainerHigh.withValues(alpha: 0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppSubtitleText('Edit Profile'),
            const SizedBox(height: AppSpacing.large),
            // Full Name Field
            _buildFormField(
              label: 'Full Name',
              controller: _nameController,
              icon: Icons.person_rounded,
            ),
            const SizedBox(height: AppSpacing.medium),
            // Email Field
            _buildFormField(
              label: 'Email Address',
              controller: _emailController,
              icon: Icons.email_rounded,
              keyboardType: TextInputType.emailAddress,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    TextInputType? keyboardType,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppLabelText(label),
        const SizedBox(height: AppSpacing.small),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            prefixIcon: Icon(icon),
            hintText: 'Enter your $label',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
              borderSide: BorderSide(color: colorScheme.outline),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
              borderSide: BorderSide(color: colorScheme.outline),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
              borderSide: BorderSide(color: colorScheme.primary, width: 2),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsSection(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (_isEditing) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.medium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppSubtitleText('Account Settings'),
          const SizedBox(height: AppSpacing.medium),
          AppCard(
            gradient: LinearGradient(
              colors: [
                colorScheme.surfaceContainer.withValues(alpha: 0.8),
                colorScheme.surfaceContainerHigh.withValues(alpha: 0.8),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                _buildSettingsTile(
                  icon: Icons.subscriptions_rounded,
                  title: 'Subscription',
                  subtitle: 'Manage your subscription',
                  onTap: () {
                    debugPrint('Navigate to subscription');
                  },
                ),
                _buildDivider(),
                _buildSettingsTile(
                  icon: Icons.devices_rounded,
                  title: 'Manage Devices',
                  subtitle: 'See all logged in devices',
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const ManageDevicesScreen(),
                      ),
                    );
                  },
                ),
                _buildDivider(),
                _buildSettingsTile(
                  icon: Icons.privacy_tip_rounded,
                  title: 'Privacy Settings',
                  subtitle: 'Control your privacy preferences',
                  onTap: () {
                    debugPrint('Navigate to privacy settings');
                  },
                ),
                _buildDivider(),
                _buildSettingsTile(
                  icon: Icons.help_rounded,
                  title: 'Help & Support',
                  subtitle: 'Get help and contact support',
                  onTap: () {
                    debugPrint('Navigate to help & support');
                  },
                ),
                _buildDivider(),
                _buildSettingsTile(
                  icon: Icons.logout_rounded,
                  title: 'Sign Out',
                  subtitle: 'Sign out of your account',
                  onTap: () {
                    _showSignOutDialog(context);
                  },
                  isDestructive: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: isDestructive 
              ? colorScheme.errorContainer 
              : colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
        ),
        child: Icon(
          icon,
          color: isDestructive 
              ? colorScheme.onErrorContainer 
              : colorScheme.onPrimaryContainer,
          size: AppSpacing.iconMedium,
        ),
      ),
      title: AppBodyText(
        title,
        color: isDestructive ? colorScheme.error : colorScheme.onSurface,
      ),
      subtitle: AppCaptionText(
        subtitle,
        color: colorScheme.onSurfaceVariant,
      ),
      trailing: Icon(
        Icons.chevron_right_rounded,
        color: colorScheme.onSurfaceVariant,
      ),
      onTap: onTap,
    );
  }

  Widget _buildDivider() {
    final theme = Theme.of(context);
    return Divider(
      height: 1,
      thickness: 1,
      color: theme.colorScheme.outline.withValues(alpha: 0.1),
      indent: AppSpacing.iconLarge + AppSpacing.medium * 2,
    );
  }

  void _showSignOutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out of your account?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              // TODO: Implement sign out
              debugPrint('User signed out');
            },
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }
}