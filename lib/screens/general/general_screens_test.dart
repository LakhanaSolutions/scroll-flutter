import 'package:flutter/material.dart';
import '../../theme/app_spacing.dart';
import '../../widgets/text/app_text.dart';
import '../../widgets/buttons/app_buttons.dart';
import 'loading_screen.dart';
import 'exception_screen.dart';
import 'update_available_screen.dart';
import 'maintenance_screen.dart';
import 'no_internet_screen.dart';

/// Test page for all general screens
/// Provides navigation to test each screen individually
class GeneralScreensTest extends StatelessWidget {
  const GeneralScreensTest({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('General Screens Test'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.medium),
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(AppSpacing.large),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    colorScheme.primary,
                    colorScheme.primaryContainer,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.science_rounded,
                    color: colorScheme.onPrimary,
                    size: AppSpacing.iconLarge,
                  ),
                  const SizedBox(height: AppSpacing.small),
                  AppTitleText(
                    'Screen Testing Lab',
                    color: colorScheme.onPrimary,
                  ),
                  const SizedBox(height: AppSpacing.extraSmall),
                  AppCaptionText(
                    'Test all general screens and their variations',
                    color: colorScheme.onPrimary.withValues(alpha: 0.8),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.large),

            // Loading Screens Section
            _buildSection(
              context,
              title: 'Loading Screens',
              icon: Icons.hourglass_empty_rounded,
              children: [
                _buildTestItem(
                  context,
                  'Basic Loading Screen',
                  'Standard loading screen with app branding',
                  Icons.refresh_rounded,
                  () => _navigateToScreen(context, const LoadingScreen()),
                ),
                _buildTestItem(
                  context,
                  'Custom Message Loading',
                  'Loading screen with custom message',
                  Icons.message_rounded,
                  () => _navigateToScreen(context, const LoadingScreen(
                    message: 'Syncing your library...',
                    showAppName: false,
                  )),
                ),
                _buildTestItem(
                  context,
                  'Cancellable Loading',
                  'Loading screen with cancel option',
                  Icons.cancel_rounded,
                  () => _navigateToScreen(context, LoadingScreen(
                    message: 'Downloading audiobook...',
                    canCancel: true,
                    onCancel: () => Navigator.of(context).pop(),
                  )),
                ),
                _buildTestItem(
                  context,
                  'Circular Indicator',
                  'Simple circular progress indicator',
                  Icons.donut_small_rounded,
                  () => _navigateToScreen(context, const LoadingScreen(
                    message: 'Processing...',
                    useCircularIndicator: true,
                    showAppName: false,
                  )),
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.large),

            // Exception Screens Section
            _buildSection(
              context,
              title: 'Exception Screens',
              icon: Icons.error_outline_rounded,
              children: [
                _buildTestItem(
                  context,
                  '404 Not Found',
                  'Page or content not found error',
                  Icons.search_off_rounded,
                  () => _navigateToScreen(context, ExceptionScreen.notFound(
                    primaryActionText: 'Go Back',
                    onPrimaryAction: () => Navigator.of(context).pop(),
                  )),
                ),
                _buildTestItem(
                  context,
                  '500 Server Error',
                  'Internal server error screen',
                  Icons.dns_rounded,
                  () => _navigateToScreen(context, ExceptionScreen.serverError(
                    primaryActionText: 'Try Again',
                    onPrimaryAction: () => Navigator.of(context).pop(),
                    secondaryActionText: 'Contact Support',
                    onSecondaryAction: () => Navigator.of(context).pop(),
                  )),
                ),
                _buildTestItem(
                  context,
                  'Network Error',
                  'Connection or network related error',
                  Icons.wifi_off_rounded,
                  () => _navigateToScreen(context, ExceptionScreen.networkError(
                    primaryActionText: 'Retry',
                    onPrimaryAction: () => Navigator.of(context).pop(),
                  )),
                ),
                _buildTestItem(
                  context,
                  'Generic Exception',
                  'General error with custom message',
                  Icons.warning_rounded,
                  () => _navigateToScreen(context, const ExceptionScreen(
                    exceptionType: ExceptionType.generic,
                    message: 'Something unexpected happened. Please try again.',
                  )),
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.large),

            // Update Screens Section
            _buildSection(
              context,
              title: 'Update Screens',
              icon: Icons.system_update_rounded,
              children: [
                _buildTestItem(
                  context,
                  'Optional Update',
                  'Update available with skip/later options',
                  Icons.update_rounded,
                  () => _navigateToScreen(context, UpdateAvailableScreen.optional(
                    version: '2.1.0',
                    releaseNotes: [
                      'New offline reading mode',
                      'Improved audio quality',
                      'Bug fixes and performance improvements',
                      'Dark mode enhancements',
                    ],
                    onUpdate: () => Navigator.of(context).pop(),
                    onLater: () => Navigator.of(context).pop(),
                    onSkip: () => Navigator.of(context).pop(),
                  )),
                ),
                _buildTestItem(
                  context,
                  'Required Update',
                  'Mandatory update that blocks app usage',
                  Icons.priority_high_rounded,
                  () => _navigateToScreen(context, UpdateAvailableScreen.required(
                    version: '2.0.1',
                    releaseNotes: [
                      'Critical security fixes',
                      'Important stability improvements',
                    ],
                    onUpdate: () => Navigator.of(context).pop(),
                  )),
                ),
                _buildTestItem(
                  context,
                  'Simple Update',
                  'Basic update screen without release notes',
                  Icons.file_download_rounded,
                  () => _navigateToScreen(context, UpdateAvailableScreen(
                    version: '1.9.5',
                    onUpdate: () => Navigator.of(context).pop(),
                  )),
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.large),

            // Maintenance Screens Section
            _buildSection(
              context,
              title: 'Maintenance Screens',
              icon: Icons.construction_rounded,
              children: [
                _buildTestItem(
                  context,
                  'Scheduled Maintenance',
                  'Planned maintenance with estimated time',
                  Icons.schedule_rounded,
                  () => _navigateToScreen(context, MaintenanceScreen.scheduled(
                    estimatedTime: 'Today at 3:00 PM EST',
                    onRetry: () => Navigator.of(context).pop(),
                    onContactSupport: () => Navigator.of(context).pop(),
                    supportEmail: 'support@scroll.app',
                  )),
                ),
                _buildTestItem(
                  context,
                  'Emergency Maintenance',
                  'Unplanned maintenance due to issues',
                  Icons.warning_amber_rounded,
                  () => _navigateToScreen(context, MaintenanceScreen.emergency(
                    onRetry: () => Navigator.of(context).pop(),
                    onContactSupport: () => Navigator.of(context).pop(),
                    supportEmail: 'support@scroll.app',
                  )),
                ),
                _buildTestItem(
                  context,
                  'Server Maintenance',
                  'Server-specific maintenance screen',
                  Icons.dns_rounded,
                  () => _navigateToScreen(context, MaintenanceScreen.server(
                    estimatedTime: '2 hours',
                    onRetry: () => Navigator.of(context).pop(),
                  )),
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.large),

            // No Internet Screens Section
            _buildSection(
              context,
              title: 'No Internet Screens',
              icon: Icons.wifi_off_rounded,
              children: [
                _buildTestItem(
                  context,
                  'No Internet Connection',
                  'Standard no internet screen with tips',
                  Icons.signal_wifi_off_rounded,
                  () => _navigateToScreen(context, NoInternetScreen.standard(
                    onRetry: () => Navigator.of(context).pop(),
                    onSettings: () => Navigator.of(context).pop(),
                    showOfflineMode: true,
                    onOfflineMode: () => Navigator.of(context).pop(),
                  )),
                ),
                _buildTestItem(
                  context,
                  'Weak Signal',
                  'Poor connection quality screen',
                  Icons.signal_wifi_connected_no_internet_4_rounded,
                  () => _navigateToScreen(context, NoInternetScreen.weakSignal(
                    onRetry: () => Navigator.of(context).pop(),
                    onSettings: () => Navigator.of(context).pop(),
                  )),
                ),
                _buildTestItem(
                  context,
                  'Airplane Mode',
                  'Device in airplane mode screen',
                  Icons.airplanemode_active_rounded,
                  () => _navigateToScreen(context, NoInternetScreen.airplaneMode(
                    onRetry: () => Navigator.of(context).pop(),
                    onSettings: () => Navigator.of(context).pop(),
                  )),
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.large),

            // Dialog Tests Section
            _buildSection(
              context,
              title: 'Dialog Tests',
              icon: Icons.dialpad_rounded,
              children: [
                _buildTestItem(
                  context,
                  'Error Dialog',
                  'Simple error dialog popup',
                  Icons.error_outline,
                  () => ErrorDialog.show(
                    context,
                    title: 'Test Error',
                    message: 'This is a test error message to demonstrate the error dialog.',
                  ),
                ),
                _buildTestItem(
                  context,
                  'Update Dialog',
                  'Quick update notification dialog',
                  Icons.system_update_alt,
                  () => UpdateDialog.show(
                    context,
                    version: '2.0.0',
                    onUpdate: () {},
                    onLater: () {},
                  ),
                ),
                _buildTestItem(
                  context,
                  'Maintenance Dialog',
                  'Brief maintenance notification',
                  Icons.build,
                  () => MaintenanceDialog.show(
                    context,
                    estimatedTime: '1 hour',
                    onRetry: () {},
                  ),
                ),
                _buildTestItem(
                  context,
                  'No Internet Dialog',
                  'Quick no internet notification',
                  Icons.wifi_off,
                  () => NoInternetDialog.show(
                    context,
                    onRetry: () {},
                    onSettings: () {},
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.extraLarge),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.small),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
              ),
              child: Icon(
                icon,
                color: colorScheme.onPrimaryContainer,
                size: AppSpacing.iconSmall,
              ),
            ),
            const SizedBox(width: AppSpacing.medium),
            AppSubtitleText(
              title,
              color: colorScheme.onSurface,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.medium),
        ...children,
      ],
    );
  }

  Widget _buildTestItem(
    BuildContext context,
    String title,
    String description,
    IconData icon,
    VoidCallback onTap,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.medium),
      child: Material(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.medium),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSpacing.small),
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
                    border: Border.all(
                      color: colorScheme.outline.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Icon(
                    icon,
                    color: colorScheme.onSurface,
                    size: AppSpacing.iconMedium,
                  ),
                ),
                const SizedBox(width: AppSpacing.medium),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppBodyText(
                        title,
                        color: colorScheme.onSurface,
                      ),
                      const SizedBox(height: AppSpacing.extraSmall),
                      AppCaptionText(
                        description,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: colorScheme.onSurfaceVariant,
                  size: AppSpacing.iconSmall,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToScreen(BuildContext context, Widget screen) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => screen,
      ),
    );
  }
}