import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_spacing.dart';
import '../theme/app_icons.dart';
import '../widgets/text/app_text.dart';
import '../widgets/app_bar/app_app_bar.dart';
import '../widgets/cards/app_card.dart';
import '../widgets/buttons/app_buttons.dart';
import '../widgets/inputs/app_text_field.dart';

/// Finish profile screen for new signup users to complete their profile setup
class FinishProfileScreen extends StatefulWidget {
  const FinishProfileScreen({super.key});

  @override
  State<FinishProfileScreen> createState() => _FinishProfileScreenState();
}

class _FinishProfileScreenState extends State<FinishProfileScreen> {
  final _fullNameController = TextEditingController();
  final _referralCodeController = TextEditingController();
  String _selectedTitle = 'Mr.';
  final List<String> _titles = ['Mr.', 'Miss.', 'Mrs.', 'Dr.'];

  @override
  void dispose() {
    _fullNameController.dispose();
    _referralCodeController.dispose();
    super.dispose();
  }

  void _submitProfile() {
    if (_fullNameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your full name')),
      );
      return;
    }

    // TODO: Implement profile submission functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile completed successfully')),
    );
    
    // Navigate to home after successful submission
    context.go('/home');
  }

  void _logout() {
    // TODO: Implement logout functionality
    context.go('/welcome');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppAppBar(
        title: 'Complete Your Profile',
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
              _buildProfileForm(context),
              const SizedBox(height: AppSpacing.extraLarge),
              _buildLogoutButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileForm(BuildContext context) {
    return AppCard(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppSubtitleText('Tell us about yourself'),
          const SizedBox(height: AppSpacing.large),
          
          // Title Selection
          _buildTitleSelection(),
          const SizedBox(height: AppSpacing.medium),
          
          // Full Name Field
          _buildFormField(
            label: 'Full Name',
            controller: _fullNameController,
            icon: AppIcons.person,
            isRequired: true,
          ),
          const SizedBox(height: AppSpacing.medium),
          
          // Referral Code Field (Optional)
          _buildFormField(
            label: 'Referral Code (Optional)',
            controller: _referralCodeController,
            icon: AppIcons.gift,
            isRequired: false,
          ),
          const SizedBox(height: AppSpacing.large),
          
          // Submit Button
          SizedBox(
            width: double.infinity,
            child: AppPrimaryButton(
              onPressed: _submitProfile,
              child: const Text('Complete Profile'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitleSelection() {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppLabelText('What should we call you?'),
        const SizedBox(height: AppSpacing.small),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.medium,
            vertical: AppSpacing.small,
          ),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
            border: Border.all(
              color: colorScheme.outline.withValues(alpha: 0.5),
              width: 1,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedTitle,
              isExpanded: true,
              icon: Icon(
                AppIcons.arrowDown,
                color: colorScheme.onSurfaceVariant,
              ),
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurface,
              ),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedTitle = newValue;
                  });
                }
              },
              items: _titles.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFormField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    required bool isRequired,
    TextInputType? keyboardType,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            AppLabelText(label),
            if (isRequired) ...[
              const SizedBox(width: AppSpacing.extraSmall),
              Text(
                '*',
                style: TextStyle(
                  color: colorScheme.error,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: AppSpacing.small),
        AppTextField(
          controller: controller,
          hintText: 'Enter your ${label.toLowerCase()}',
          prefixIcon: Icon(icon),
          keyboardType: keyboardType,
          fillColor: colorScheme.surfaceContainerLow,
        ),
      ],
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return TextButton(
      onPressed: _logout,
      style: TextButton.styleFrom(
        foregroundColor: colorScheme.onSurfaceVariant,
        textStyle: Theme.of(context).textTheme.bodyMedium,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            AppIcons.logout,
            size: AppSpacing.iconSmall,
            color: colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: AppSpacing.small),
          const Text('Logout'),
        ],
      ),
    );
  }
}