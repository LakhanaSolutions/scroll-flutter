import 'package:flutter/material.dart';
import '../theme/app_spacing.dart';
import '../widgets/text/app_text.dart';
import '../widgets/cards/app_card.dart';
import '../widgets/buttons/app_buttons.dart';

enum DeviceType { mobile, tablet, desktop, web }
enum DeviceStatus { current, active, inactive }

class DeviceInfo {
  final String id;
  final String name;
  final DeviceType type;
  final DeviceStatus status;
  final String lastActive;
  final String location;
  final String ipAddress;

  DeviceInfo({
    required this.id,
    required this.name,
    required this.type,
    required this.status,
    required this.lastActive,
    required this.location,
    required this.ipAddress,
  });
}

/// Screen for managing logged-in devices with logout functionality
class ManageDevicesScreen extends StatefulWidget {
  const ManageDevicesScreen({super.key});

  @override
  State<ManageDevicesScreen> createState() => _ManageDevicesScreenState();
}

class _ManageDevicesScreenState extends State<ManageDevicesScreen> {
  List<DeviceInfo> get _devices => [
    DeviceInfo(
      id: '1',
      name: 'iPhone 15 Pro',
      type: DeviceType.mobile,
      status: DeviceStatus.current,
      lastActive: 'Active now',
      location: 'Riyadh, Saudi Arabia',
      ipAddress: '192.168.1.100',
    ),
    DeviceInfo(
      id: '2',
      name: 'iPad Air',
      type: DeviceType.tablet,
      status: DeviceStatus.active,
      lastActive: '2 hours ago',
      location: 'Riyadh, Saudi Arabia',
      ipAddress: '192.168.1.101',
    ),
    DeviceInfo(
      id: '3',
      name: 'MacBook Pro',
      type: DeviceType.desktop,
      status: DeviceStatus.active,
      lastActive: '1 day ago',
      location: 'Jeddah, Saudi Arabia',
      ipAddress: '10.0.0.45',
    ),
    DeviceInfo(
      id: '4',
      name: 'Chrome Browser',
      type: DeviceType.web,
      status: DeviceStatus.inactive,
      lastActive: '1 week ago',
      location: 'Dubai, UAE',
      ipAddress: '185.20.34.12',
    ),
    DeviceInfo(
      id: '5',
      name: 'Samsung Galaxy',
      type: DeviceType.mobile,
      status: DeviceStatus.inactive,
      lastActive: '2 weeks ago',
      location: 'Cairo, Egypt',
      ipAddress: '41.234.56.78',
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
              Icons.devices_rounded,
              color: colorScheme.primary,
              size: AppSpacing.iconMedium,
            ),
            const SizedBox(width: AppSpacing.small),
            const AppTitleText('Manage Devices'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Header section
          Container(
            width: double.infinity,
            color: colorScheme.surface,
            padding: const EdgeInsets.all(AppSpacing.large),
            child: Column(
              children: [
                Icon(
                  Icons.security_rounded,
                  size: 48,
                  color: colorScheme.primary,
                ),
                const SizedBox(height: AppSpacing.medium),
                const AppTitleText(
                  'Your Devices',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.small),
                AppBodyText(
                  'Manage all devices where you\'re logged in',
                  textAlign: TextAlign.center,
                  color: colorScheme.onSurfaceVariant,
                ),
              ],
            ),
          ),
          
          // Devices list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(AppSpacing.medium),
              itemCount: _devices.length,
              itemBuilder: (context, index) {
                final device = _devices[index];
                return _DeviceCard(
                  device: device,
                  onLogout: () => _logoutDevice(device),
                );
              },
            ),
          ),
          
          // Bottom action area
          Container(
            padding: const EdgeInsets.all(AppSpacing.medium),
            color: colorScheme.surface,
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: AppSecondaryButton(
                    onPressed: _logoutAllDevices,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.logout_rounded,
                          color: colorScheme.error,
                        ),
                        const SizedBox(width: AppSpacing.small),
                        Text(
                          'Logout from All Devices',
                          style: TextStyle(color: colorScheme.error),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.small),
                AppCaptionText(
                  'This will sign you out from all devices except this one',
                  textAlign: TextAlign.center,
                  color: colorScheme.onSurfaceVariant,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _logoutDevice(DeviceInfo device) {
    if (device.status == DeviceStatus.current) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cannot logout from current device'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout Device'),
        content: Text('Are you sure you want to logout from "${device.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              // TODO: Implement device logout
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Logged out from ${device.name}'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  void _logoutAllDevices() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout All Devices'),
        content: const Text(
          'This will sign you out from all other devices. You will remain logged in on this device. Are you sure?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              // TODO: Implement logout all devices
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Logged out from all other devices'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Logout All'),
          ),
        ],
      ),
    );
  }
}

/// Individual device card widget
class _DeviceCard extends StatelessWidget {
  final DeviceInfo device;
  final VoidCallback? onLogout;

  const _DeviceCard({
    required this.device,
    this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.medium),
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
            // Header with device name and status
            Row(
              children: [
                // Device icon
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: _getDeviceColor(device.type).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
                  ),
                  child: Icon(
                    _getDeviceIcon(device.type),
                    color: _getDeviceColor(device.type),
                    size: AppSpacing.iconMedium,
                  ),
                ),
                const SizedBox(width: AppSpacing.medium),
                // Device name and status
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: AppSubtitleText(
                              device.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          _StatusBadge(status: device.status),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.extraSmall),
                      AppCaptionText(
                        _getDeviceTypeText(device.type),
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: AppSpacing.medium),
            
            // Device details
            _buildDetailRow(
              context,
              Icons.schedule_rounded,
              'Last Active',
              device.lastActive,
            ),
            _buildDetailRow(
              context,
              Icons.location_on_rounded,
              'Location',
              device.location,
            ),
            _buildDetailRow(
              context,
              Icons.network_check_rounded,
              'IP Address',
              device.ipAddress,
            ),
            
            const SizedBox(height: AppSpacing.medium),
            
            // Actions
            if (device.status != DeviceStatus.current) ...[ 
              SizedBox(
                width: double.infinity,
                child: AppSecondaryButton(
                  onPressed: onLogout,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.logout_rounded,
                        color: colorScheme.error,
                        size: AppSpacing.iconSmall,
                      ),
                      const SizedBox(width: AppSpacing.small),
                      Text(
                        'Logout',
                        style: TextStyle(color: colorScheme.error),
                      ),
                    ],
                  ),
                ),
              ),
            ] else ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.medium,
                  vertical: AppSpacing.small,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.smartphone_rounded,
                      color: colorScheme.onPrimaryContainer,
                      size: AppSpacing.iconSmall,
                    ),
                    const SizedBox(width: AppSpacing.small),
                    Text(
                      'This Device',
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.small),
      child: Row(
        children: [
          Icon(
            icon,
            size: AppSpacing.iconExtraSmall,
            color: colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: AppSpacing.small),
          SizedBox(
            width: 80,
            child: AppCaptionText(
              label,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          Expanded(
            child: AppCaptionText(
              value,
              color: colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getDeviceIcon(DeviceType type) {
    switch (type) {
      case DeviceType.mobile:
        return Icons.smartphone_rounded;
      case DeviceType.tablet:
        return Icons.tablet_rounded;
      case DeviceType.desktop:
        return Icons.computer_rounded;
      case DeviceType.web:
        return Icons.web_rounded;
    }
  }

  Color _getDeviceColor(DeviceType type) {
    switch (type) {
      case DeviceType.mobile:
        return const Color(0xFF4CAF50);
      case DeviceType.tablet:
        return const Color(0xFF2196F3);
      case DeviceType.desktop:
        return const Color(0xFF9C27B0);
      case DeviceType.web:
        return const Color(0xFFFF9800);
    }
  }

  String _getDeviceTypeText(DeviceType type) {
    switch (type) {
      case DeviceType.mobile:
        return 'Mobile Device';
      case DeviceType.tablet:
        return 'Tablet';
      case DeviceType.desktop:
        return 'Desktop';
      case DeviceType.web:
        return 'Web Browser';
    }
  }
}

/// Status badge widget for device status
class _StatusBadge extends StatelessWidget {
  final DeviceStatus status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    Color backgroundColor;
    Color textColor;
    String text;
    IconData icon;

    switch (status) {
      case DeviceStatus.current:
        backgroundColor = colorScheme.primaryContainer;
        textColor = colorScheme.onPrimaryContainer;
        text = 'CURRENT';
        icon = Icons.smartphone_rounded;
        break;
      case DeviceStatus.active:
        backgroundColor = colorScheme.secondaryContainer;
        textColor = colorScheme.onSecondaryContainer;
        text = 'ACTIVE';
        icon = Icons.check_circle_rounded;
        break;
      case DeviceStatus.inactive:
        backgroundColor = colorScheme.surfaceContainer;
        textColor = colorScheme.onSurfaceVariant;
        text = 'INACTIVE';
        icon = Icons.schedule_rounded;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.small,
        vertical: AppSpacing.extraSmall,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: textColor,
            size: AppSpacing.iconExtraSmall,
          ),
          const SizedBox(width: AppSpacing.extraSmall),
          Text(
            text,
            style: theme.textTheme.labelSmall?.copyWith(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: 9,
            ),
          ),
        ],
      ),
    );
  }
}