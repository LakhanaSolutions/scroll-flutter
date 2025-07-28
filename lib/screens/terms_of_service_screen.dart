import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import '../theme/app_spacing.dart';
import '../widgets/text/app_text.dart';

/// Terms of Service screen that displays HTML content from API
class TermsOfServiceScreen extends StatefulWidget {
  const TermsOfServiceScreen({super.key});

  @override
  State<TermsOfServiceScreen> createState() => _TermsOfServiceScreenState();
}

class _TermsOfServiceScreenState extends State<TermsOfServiceScreen> {
  String? _htmlContent;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadTermsOfService();
  }

  Future<void> _loadTermsOfService() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      // TODO: Replace with actual API call
      // For now, using mock HTML content
      await Future.delayed(const Duration(seconds: 1));
      
      const mockHtml = '''
      <h1>Terms of Service</h1>
      <p><strong>Last updated:</strong> January 2024</p>
      
      <h2>Acceptance of Terms</h2>
      <p>By accessing and using Siraaj, you accept and agree to be bound by the terms and provision of this agreement.</p>
      
      <h2>Description of Service</h2>
      <p>Siraaj is a premium Islamic audiobook and lecture platform that provides access to high-quality religious content from renowned scholars and speakers.</p>
      
      <h3>Service Features</h3>
      <ul>
        <li>Streaming and offline access to audiobooks</li>
        <li>Curated Islamic content library</li>
        <li>Personalized recommendations</li>
        <li>Cross-device synchronization</li>
        <li>Premium subscriber benefits</li>
      </ul>
      
      <h2>User Accounts</h2>
      <p>To access certain features of the service, you must create an account. You are responsible for:</p>
      <ul>
        <li>Maintaining the confidentiality of your account</li>
        <li>All activities that occur under your account</li>
        <li>Providing accurate and complete information</li>
        <li>Updating your information as necessary</li>
      </ul>
      
      <h2>Subscription Plans</h2>
      <h3>Free Plan (Siraaj Glimpse)</h3>
      <ul>
        <li>Limited access to content library</li>
        <li>Basic features included</li>
        <li>No payment required</li>
      </ul>
      
      <h3>Premium Plans</h3>
      <ul>
        <li>Monthly subscription: 29.99 SAR/month</li>
        <li>Annual subscription: 299.99 SAR/year</li>
        <li>Full access to content library</li>
        <li>Offline downloads</li>
        <li>Premium features</li>
      </ul>
      
      <h2>Payment Terms</h2>
      <p>Premium subscriptions are billed in advance on a monthly or annual basis. Payments are non-refundable except as required by law.</p>
      
      <h3>Auto-Renewal</h3>
      <p>Subscriptions automatically renew unless canceled at least 24 hours before the current period ends.</p>
      
      <h2>Content Usage</h2>
      <p>The content available on Siraaj is for personal, non-commercial use only. You may not:</p>
      <ul>
        <li>Distribute, share, or make content available to others</li>
        <li>Copy, reproduce, or create derivative works</li>
        <li>Use content for commercial purposes</li>
        <li>Remove or modify copyright notices</li>
      </ul>
      
      <h2>Prohibited Activities</h2>
      <p>You agree not to:</p>
      <ul>
        <li>Violate any applicable laws or regulations</li>
        <li>Infringe on intellectual property rights</li>
        <li>Interfere with the service or other users</li>
        <li>Attempt to gain unauthorized access</li>
        <li>Use the service for any harmful or illegal purpose</li>
      </ul>
      
      <h2>Intellectual Property</h2>
      <p>All content, features, and functionality of Siraaj are owned by us or our licensors and are protected by copyright, trademark, and other intellectual property laws.</p>
      
      <h2>Termination</h2>
      <p>We may terminate or suspend your account and access to the service immediately, without prior notice, for conduct that we believe violates these Terms or is harmful to other users, us, or third parties.</p>
      
      <h2>Disclaimers</h2>
      <p>The service is provided "as is" and "as available" without warranties of any kind. We do not guarantee that the service will be uninterrupted, secure, or error-free.</p>
      
      <h2>Limitation of Liability</h2>
      <p>In no event shall Siraaj be liable for any indirect, incidental, special, consequential, or punitive damages arising from your use of the service.</p>
      
      <h2>Governing Law</h2>
      <p>These Terms are governed by and construed in accordance with the laws of Saudi Arabia.</p>
      
      <h2>Changes to Terms</h2>
      <p>We reserve the right to modify these Terms at any time. We will notify users of significant changes via email or through the service.</p>
      
      <h2>Contact Information</h2>
      <p>If you have any questions about these Terms, please contact us at:</p>
      <p><strong>Email:</strong> legal@siraaj.app<br>
      <strong>Address:</strong> Riyadh, Saudi Arabia</p>
      ''';

      setState(() {
        _htmlContent = mockHtml;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load terms of service. Please try again.';
        _isLoading = false;
      });
    }
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
              Icons.description_rounded,
              color: colorScheme.primary,
              size: AppSpacing.iconMedium,
            ),
            const SizedBox(width: AppSpacing.small),
            const AppTitleText('Terms of Service'),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.refresh_rounded,
              color: colorScheme.onSurfaceVariant,
            ),
            onPressed: _loadTermsOfService,
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
                onPressed: _loadTermsOfService,
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