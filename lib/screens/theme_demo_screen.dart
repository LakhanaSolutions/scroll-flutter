import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/app_spacing.dart';
import '../theme/theme_extensions.dart';
import '../widgets/text/app_text.dart';
import '../widgets/inputs/app_text_field.dart';
import '../widgets/buttons/app_buttons.dart';
import '../widgets/dialogs/app_dialogs.dart';
import '../providers/theme_provider.dart';
import '../widgets/bottom_sheets/app_modal_bottom_sheet.dart';

/// Demo screen showcasing all themed components
/// Demonstrates the comprehensive design system implementation
class ThemeDemoScreen extends ConsumerStatefulWidget {
  /// Creates a [ThemeDemoScreen]
  const ThemeDemoScreen({super.key});

  @override
  ConsumerState<ThemeDemoScreen> createState() => _ThemeDemoScreenState();
}

class _ThemeDemoScreenState extends ConsumerState<ThemeDemoScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _searchController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appTheme = context.appTheme;
    final isDarkMode = ref.watch(themeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const AppTitleText('Design System Demo'),
        actions: [
          AppIconButton(
            icon: isDarkMode ? Icons.light_mode : Icons.dark_mode,
            onPressed: () => ref.read(themeProvider.notifier).toggleTheme(),
            tooltip: 'Toggle theme',
          ),
          AppIconButton(
            icon: Icons.more_vert,
            onPressed: _showActionSheet,
            tooltip: 'More options',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.medium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTypographySection(),
            const SizedBox(height: AppSpacing.section),
            _buildColorSection(),
            const SizedBox(height: AppSpacing.section),
            _buildButtonSection(),
            const SizedBox(height: AppSpacing.section),
            _buildInputSection(),
            const SizedBox(height: AppSpacing.section),
            _buildCardSection(),
            const SizedBox(height: AppSpacing.section),
            _buildInfoMessagesSection(),
            const SizedBox(height: AppSpacing.section),
            _buildDialogSection(),
            const SizedBox(height: AppSpacing.section),
            _buildPlatformInfoSection(appTheme),
          ],
        ),
      ),
      floatingActionButton: AppFloatingActionButton(
        onPressed: _showBottomSheet,
        tooltip: 'Show bottom sheet',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildTypographySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppTitleText('Typography'),
        const SizedBox(height: AppSpacing.medium),
        const AppTitleText('Main Title (Title Large)'),
        const AppSubtitleText('Subtitle for sections'),
        const SizedBox(height: AppSpacing.small),
        const AppBodyText(
          'This is body text that provides the main content. It should be easily readable and have good contrast against the background.',
        ),
        const SizedBox(height: AppSpacing.small),
        const AppCaptionText('Caption text for small descriptions'),
        const SizedBox(height: AppSpacing.small),
        const AppLabelText('Form Label', isRequired: true),
      ],
    );
  }

  Widget _buildColorSection() {
    final theme = Theme.of(context);
    final appTheme = context.appTheme;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppTitleText('Colors'),
        const SizedBox(height: AppSpacing.medium),
        Wrap(
          spacing: AppSpacing.small,
          runSpacing: AppSpacing.small,
          children: [
            _buildColorChip('Primary', theme.colorScheme.primary),
            _buildColorChip('Secondary', theme.colorScheme.secondary),
            _buildColorChip('Tertiary', theme.colorScheme.tertiary),
            _buildColorChip('Success', appTheme.success),
            _buildColorChip('Warning', appTheme.warning),
            _buildColorChip('Error', theme.colorScheme.error),
            _buildColorChip('Info', appTheme.info),
            _buildColorChip('Surface', theme.colorScheme.surface),
          ],
        ),
      ],
    );
  }

  Widget _buildColorChip(String label, Color color) {
    final theme = Theme.of(context);
    final isLight = color.computeLuminance() > 0.5;
    
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.medium,
        vertical: AppSpacing.small,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: AppCaptionText(
        label,
        color: isLight ? Colors.black : Colors.white,
      ),
    );
  }

  Widget _buildButtonSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppTitleText('Buttons'),
        const SizedBox(height: AppSpacing.medium),
        Wrap(
          spacing: AppSpacing.medium,
          runSpacing: AppSpacing.small,
          children: [
            AppPrimaryButton(
              onPressed: _simulateLoading,
              isLoading: _isLoading,
              child: const Text('Primary Button'),
            ),
            AppSecondaryButton(
              onPressed: () => _showSnackBar('Secondary button pressed'),
              child: const Text('Secondary Button'),
            ),
            AppTextButton(
              onPressed: () => _showSnackBar('Text button pressed'),
              child: const Text('Text Button'),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.medium),
        Row(
          children: [
            AppIconButton(
              icon: Icons.favorite,
              onPressed: () => _showSnackBar('Icon button pressed'),
              style: AppIconButtonStyle.standard,
            ),
            const SizedBox(width: AppSpacing.small),
            AppIconButton(
              icon: Icons.share,
              onPressed: () => _showSnackBar('Filled icon button pressed'),
              style: AppIconButtonStyle.filled,
            ),
            const SizedBox(width: AppSpacing.small),
            AppIconButton(
              icon: Icons.bookmark,
              onPressed: () => _showSnackBar('Outlined icon button pressed'),
              style: AppIconButtonStyle.outlined,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInputSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppTitleText('Input Fields'),
        const SizedBox(height: AppSpacing.medium),
        AppTextField(
          controller: _nameController,
          labelText: 'Full Name',
          hintText: 'Enter your full name',
          prefixIcon: const Icon(Icons.person),
          isRequired: true,
        ),
        const SizedBox(height: AppSpacing.medium),
        AppTextField(
          controller: _emailController,
          labelText: 'Email Address',
          hintText: 'Enter your email',
          keyboardType: TextInputType.emailAddress,
          prefixIcon: const Icon(Icons.email),
          helperText: 'We will never share your email',
        ),
        const SizedBox(height: AppSpacing.medium),
        const AppTextField(
          labelText: 'Password',
          hintText: 'Enter your password',
          obscureText: true,
          prefixIcon: Icon(Icons.lock),
        ),
        const SizedBox(height: AppSpacing.medium),
        AppSearchField(
          controller: _searchController,
          hintText: 'Search something...',
          onChanged: (value) => debugPrint('Search: $value'),
        ),
      ],
    );
  }

  Widget _buildCardSection() {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppTitleText('Cards & Surfaces'),
        const SizedBox(height: AppSpacing.medium),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.medium),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: theme.colorScheme.primary,
                      child: const Icon(Icons.person, color: Colors.white),
                    ),
                    const SizedBox(width: AppSpacing.medium),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppSubtitleText('Card Title'),
                          AppCaptionText('Card subtitle with description'),
                        ],
                      ),
                    ),
                    AppIconButton(
                      icon: Icons.more_vert,
                      onPressed: () => _showSnackBar('Card menu pressed'),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.medium),
                const AppBodyText(
                  'This is a sample card component showing how content is laid out with proper spacing and typography.',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoMessagesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppTitleText('Info Messages'),
        const SizedBox(height: AppSpacing.medium),
        const AppInfoText(
          'This is a success message indicating completion',
          type: InfoType.success,
        ),
        const SizedBox(height: AppSpacing.small),
        const AppInfoText(
          'This is a warning message for important information',
          type: InfoType.warning,
        ),
        const SizedBox(height: AppSpacing.small),
        const AppInfoText(
          'This is an error message for validation issues',
          type: InfoType.error,
        ),
        const SizedBox(height: AppSpacing.small),
        const AppInfoText(
          'This is an info message for general information',
          type: InfoType.info,
        ),
      ],
    );
  }

  Widget _buildDialogSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppTitleText('Dialogs & Modals'),
        const SizedBox(height: AppSpacing.medium),
        Wrap(
          spacing: AppSpacing.medium,
          runSpacing: AppSpacing.small,
          children: [
            AppSecondaryButton(
              onPressed: _showAlertDialog,
              child: const Text('Alert Dialog'),
            ),
            AppSecondaryButton(
              onPressed: _showConfirmationDialog,
              child: const Text('Confirmation'),
            ),
            AppSecondaryButton(
              onPressed: _showLoadingDialog,
              child: const Text('Loading Dialog'),
            ),
            AppSecondaryButton(
              onPressed: _showModalBottomSheet,
              child: const Text('Modal Bottom Sheet'),
            ),
            AppSecondaryButton(
              onPressed: _showScrollableModal,
              child: const Text('Scrollable Modal'),
            ),
            AppSecondaryButton(
              onPressed: _showActionModal,
              child: const Text('Action Modal'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPlatformInfoSection(AppThemeExtension appTheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppTitleText('Platform Information'),
        const SizedBox(height: AppSpacing.medium),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.medium),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppBodyText('Platform: ${appTheme.isIOS ? 'iOS' : 'Android/Material'}'),
              const SizedBox(height: AppSpacing.small),
              AppBodyText('Card Elevation: ${appTheme.cardElevation}'),
              const SizedBox(height: AppSpacing.small),
              AppBodyText('Dialog Elevation: ${appTheme.dialogElevation}'),
            ],
          ),
        ),
      ],
    );
  }

  void _simulateLoading() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      setState(() => _isLoading = false);
      _showSnackBar('Primary button action completed');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showAlertDialog() {
    AppAlertDialog.show(
      context,
      title: 'Information',
      content: const AppBodyText(
        'This is an example alert dialog. It can contain any content and supports platform-specific styling.',
      ),
    );
  }

  void _showConfirmationDialog() {
    AppConfirmationDialog.show(
      context,
      title: 'Delete Item',
      content: 'Are you sure you want to delete this item? This action cannot be undone.',
      confirmText: 'Delete',
      isDestructive: true,
      onConfirm: () => _showSnackBar('Item deleted'),
    );
  }

  void _showLoadingDialog() async {
    AppLoadingDialog.show(context, message: 'Processing...');
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      AppLoadingDialog.hide(context);
      _showSnackBar('Processing completed');
    }
  }

  void _showBottomSheet() {
    // Keep the original implementation for comparison
    AppBottomSheet.show(
      context,
      title: 'Bottom Sheet Example',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const AppBodyText(
            'This is a bottom sheet that can contain any content. It follows platform conventions for presentation.',
          ),
          const SizedBox(height: AppSpacing.medium),
          AppPrimaryButton(
            onPressed: () {
              Navigator.of(context).pop();
              _showSnackBar('Bottom sheet action performed');
            },
            width: double.infinity,
            child: const Text('Perform Action'),
          ),
        ],
      ),
    );
  }

  void _showModalBottomSheet() {
    AppModalBottomSheet.show(
      context: context,
      title: 'Modal Bottom Sheet',
      builder: (context) => Padding(
        padding: const EdgeInsets.all(AppSpacing.large),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const AppBodyText(
              'This is a platform-native modal bottom sheet using the modal_bottom_sheet package. It automatically adapts to iOS and Android styling.',
            ),
            const SizedBox(height: AppSpacing.large),
            Row(
              children: [
                Expanded(
                  child: AppSecondaryButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: AppSpacing.medium),
                Expanded(
                  child: AppPrimaryButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _showSnackBar('Modal action completed');
                    },
                    child: const Text('Confirm'),
                  ),
                ),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).padding.bottom),
          ],
        ),
      ),
    );
  }

  void _showScrollableModal() {
    AppModalBottomSheet.showScrollable(
      context: context,
      title: 'Scrollable Content',
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.large),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppBodyText(
              'This modal bottom sheet contains scrollable content. The scroll controller is properly synced with the modal\'s drag gestures.',
            ),
            const SizedBox(height: AppSpacing.large),
            ...List.generate(20, (index) => Container(
              margin: const EdgeInsets.only(bottom: AppSpacing.medium),
              padding: const EdgeInsets.all(AppSpacing.medium),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    child: Text('${index + 1}'),
                  ),
                  const SizedBox(width: AppSpacing.medium),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppSubtitleText('Item ${index + 1}'),
                        AppCaptionText('Description for item ${index + 1}'),
                      ],
                    ),
                  ),
                ],
              ),
            )),
            SizedBox(height: MediaQuery.of(context).padding.bottom),
          ],
        ),
      ),
    );
  }

  void _showActionModal() async {
    final result = await AppActionModalBottomSheet.showActions<String>(
      context: context,
      title: 'Choose Action',
      subtitle: 'Select one of the following actions to perform',
      actions: [
        const AppModalAction(
          title: 'Share Content',
          subtitle: 'Share this content with others',
          icon: Icons.share,
          value: 'share',
        ),
        const AppModalAction(
          title: 'Edit Content',
          subtitle: 'Make changes to this content',
          icon: Icons.edit,
          value: 'edit',
        ),
        const AppModalAction(
          title: 'Bookmark',
          subtitle: 'Save this content for later',
          icon: Icons.bookmark_add,
          value: 'bookmark',
        ),
        const AppModalAction(
          title: 'Delete Content',
          subtitle: 'Permanently remove this content',
          icon: Icons.delete,
          value: 'delete',
          isDestructive: true,
        ),
      ],
    );

    if (result != null && mounted) {
      _showSnackBar('Selected action: $result');
    }
  }

  void _showActionSheet() {
    AppActionSheet.show(
      context,
      title: 'Action Sheet',
      message: 'Choose an action from the options below',
      actions: [
        AppActionSheetAction(
          title: 'Share',
          onPressed: () => _showSnackBar('Share action selected'),
        ),
        AppActionSheetAction(
          title: 'Edit',
          onPressed: () => _showSnackBar('Edit action selected'),
        ),
        AppActionSheetAction(
          title: 'Delete',
          isDestructive: true,
          onPressed: () => _showSnackBar('Delete action selected'),
        ),
      ],
    );
  }
}