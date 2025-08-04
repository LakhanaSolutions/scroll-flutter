import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import '../theme/app_spacing.dart';
import '../theme/theme_extensions.dart';
import '../widgets/text/app_text.dart';

/// Privacy Policy screen that displays HTML content from API
class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  String? _htmlContent;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadPrivacyPolicy();
  }

  Future<void> _loadPrivacyPolicy() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      // TODO-012: Replace with actual API call
      // For now, using mock HTML content
      await Future.delayed(const Duration(seconds: 1));
      
      const mockHtml = '''
      <h1>Privacy Policy</h1>
      <p><strong>Last updated:</strong> January 2024</p>
      
      <h2>Information We Collect</h2>
      <p>We collect information you provide directly to us, such as when you create an account, make a purchase, or contact us for support.</p>
      
      <h3>Personal Information</h3>
      <ul>
        <li>Name and email address</li>
        <li>Account credentials</li>
        <li>Payment information</li>
        <li>Listening preferences and history</li>
      </ul>
      
      <h3>Usage Information</h3>
      <p>We automatically collect certain information about your use of our services, including:</p>
      <ul>
        <li>Device information (type, operating system, etc.)</li>
        <li>Log data (IP address, browser type, etc.)</li>
        <li>Usage patterns and preferences</li>
      </ul>
      
      <h2>How We Use Your Information</h2>
      <p>We use the information we collect to:</p>
      <ul>
        <li>Provide and maintain our services</li>
        <li>Process transactions and send related information</li>
        <li>Send you technical notices and support messages</li>
        <li>Personalize your experience</li>
        <li>Improve our services</li>
      </ul>
      
      <h2>Information Sharing</h2>
      <p>We do not sell, trade, or otherwise transfer your personal information to third parties without your consent, except as described in this policy.</p>
      
      <h2>Data Security</h2>
      <p>We implement appropriate technical and organizational security measures to protect your personal information against unauthorized access, alteration, disclosure, or destruction.</p>
      
      <h2>Your Rights</h2>
      <p>You have the right to:</p>
      <ul>
        <li>Access your personal information</li>
        <li>Correct inaccurate information</li>
        <li>Delete your account and personal information</li>
        <li>Object to processing of your information</li>
        <li>Data portability</li>
      </ul>
      
      <h2>Contact Us</h2>
      <p>If you have any questions about this Privacy Policy, please contact us at:</p>
      <p><strong>Email:</strong> privacy@siraaj.app<br>
      <strong>Address:</strong> Riyadh, Saudi Arabia</p>
      ''';

      setState(() {
        _htmlContent = mockHtml;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load privacy policy. Please try again.';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: context.appTheme.iosSystemBackground,
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
              Icons.privacy_tip_rounded,
              color: colorScheme.primary,
              size: AppSpacing.iconMedium,
            ),
            const SizedBox(width: AppSpacing.small),
            const AppTitleText('Privacy Policy'),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.refresh_rounded,
              color: colorScheme.onSurfaceVariant,
            ),
            onPressed: _loadPrivacyPolicy,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.large),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline_rounded,
                size: AppSpacing.iconHero,
                color: colorScheme.error,
              ),
              const SizedBox(height: AppSpacing.large),
              AppTitleText(
                'Unable to Load',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.small),
              AppBodyText(
                _error!,
                textAlign: TextAlign.center,
                color: colorScheme.onSurfaceVariant,
              ),
              const SizedBox(height: AppSpacing.large),
              FilledButton(
                onPressed: _loadPrivacyPolicy,
                child: const Text('Try Again'),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      color: colorScheme.surface,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.large),
        child: HtmlWidget(
          _htmlContent!,
          textStyle: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurface,
            height: 1.6,
          ),
          customStylesBuilder: (element) {
            if (element.localName == 'h1') {
              return {
                'color': '#1976D2',
                'font-size': '24px',
                'font-weight': 'bold',
                'margin-bottom': '16px',
              };
            }
            if (element.localName == 'h2') {
              return {
                'color': '#212121',
                'font-size': '20px',
                'font-weight': '600',
                'margin-top': '24px',
                'margin-bottom': '12px',
              };
            }
            if (element.localName == 'h3') {
              return {
                'color': '#212121',
                'font-size': '18px',
                'font-weight': '600',
                'margin-top': '20px',
                'margin-bottom': '8px',
              };
            }
            if (element.localName == 'p') {
              return {
                'margin-bottom': '12px',
                'line-height': '1.6',
              };
            }
            if (element.localName == 'ul') {
              return {
                'margin-bottom': '16px',
                'padding-left': '20px',
              };
            }
            if (element.localName == 'li') {
              return {
                'margin-bottom': '8px',
                'line-height': '1.5',
              };
            }
            return null;
          },
          onTapUrl: (url) {
            // Handle URL taps if needed
            debugPrint('Tapped URL: $url');
            return true;
          },
        ),
      ),
    );
  }
}