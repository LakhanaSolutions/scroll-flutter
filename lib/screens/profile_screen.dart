import 'package:flutter/material.dart';
import '../theme/app_spacing.dart';
import '../theme/theme_extensions.dart';
import '../widgets/text/app_text.dart';
import '../widgets/app_bar/app_app_bar.dart';
import '../widgets/cards/app_card.dart';
import '../widgets/buttons/app_buttons.dart';
import '../widgets/inputs/app_text_field.dart';
import 'subscription_screen.dart';

/// User profile screen showing profile details and settings
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _nameController = TextEditingController(text: 'Ahmed Al-Rashid');
  final _emailController = TextEditingController(text: 'ahmed.alrashid@example.com');

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    // TODO: Implement save functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile updated successfully')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: const AppAppBar(
        title: 'Profile',
      ),
      body: GestureDetector(
        onTap: () {
          // Dismiss keyboard when tapping outside text fields
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.medium),
          child: Column(
            children: [
              // Current Plan Section
              _buildCurrentPlanSection(context),
              const SizedBox(height: AppSpacing.medium),
              // Profile Form
              _buildProfileForm(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentPlanSection(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    // Mock data - replace with actual data
    final planName = 'Premium Plan';
    final startDate = DateTime(2025, 1, 1);
    final endDate = DateTime(2025, 12, 31);
    final currentDate = DateTime.now();
    final daysRemaining = endDate.difference(currentDate).inDays;
    final totalDays = endDate.difference(startDate).inDays;
    final daysUsed = currentDate.difference(startDate).inDays;
    final progressPercentage = (daysUsed / totalDays).clamp(0.0, 1.0);

    return AppCard(
      gradient: context.planGradient(planName),
      elevation: 0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.workspace_premium_rounded,
                color: colorScheme.onPrimaryContainer,
                size: AppSpacing.iconMedium,
              ),
              const SizedBox(width: AppSpacing.small),
              AppSubtitleText(planName),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.small,
                  vertical: AppSpacing.extraSmall,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
                ),
                child: AppCaptionText(
                  'ACTIVE',
                  color: colorScheme.primary,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.medium),
                    
          // Days Remaining - Prominent Display
          Center(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.access_time_rounded,
                      color: colorScheme.primary,
                      size: AppSpacing.iconMedium,
                    ),
                    const SizedBox(width: AppSpacing.small),
                    Text(
                      '$daysRemaining',
                      style: theme.textTheme.displaySmall?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.small),
                    Text(
                      'days remaining',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.medium),
          
          // Progress Bar
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppLabelText('Subscription Progress'),
              const SizedBox(height: AppSpacing.small),
              LinearProgressIndicator(
                value: progressPercentage,
                backgroundColor: colorScheme.outline.withValues(alpha: 0.2),
                valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
                borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
              ),
              const SizedBox(height: AppSpacing.small),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppCaptionText(
                    'Started ${_formatDate(startDate)}',
                    color: colorScheme.onSurfaceVariant,
                  ),
                  AppCaptionText(
                    'Expires ${_formatDate(endDate)}',
                    color: colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.medium),
          
          // Upgrade Plan Button
          SizedBox(
            width: double.infinity,
            child: AppSecondaryButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const SubscriptionScreen(),
                  ),
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.upgrade_rounded,
                    size: AppSpacing.iconSmall,
                    color: colorScheme.primary,
                  ),
                  const SizedBox(width: AppSpacing.small),
                  const Text('Upgrade Plan'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }


  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  Widget _buildProfileForm(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AppCard(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppSubtitleText('Profile Information'),
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
          const SizedBox(height: AppSpacing.large),
          // Save Button
          SizedBox(
            width: double.infinity,
            child: AppPrimaryButton(
              onPressed: _saveProfile,
              child: const Text('Save Profile'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    TextInputType? keyboardType,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return AppTextField(
      controller: controller,
      labelText: label,
      hintText: 'Enter your $label',
      prefixIcon: Icon(icon),
      keyboardType: keyboardType,
      fillColor: colorScheme.surfaceContainerLow,
    );
  }
}