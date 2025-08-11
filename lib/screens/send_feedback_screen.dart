import 'package:flutter/material.dart';
import '../theme/app_spacing.dart';
import '../theme/theme_extensions.dart';
import '../widgets/text/app_text.dart';
import '../widgets/cards/app_card.dart';
import '../widgets/buttons/app_buttons.dart';

enum FeedbackType { bug, feature, improvement, content, other }

/// Send Feedback screen with form input
class SendFeedbackScreen extends StatefulWidget {
  const SendFeedbackScreen({super.key});

  @override
  State<SendFeedbackScreen> createState() => _SendFeedbackScreenState();
}

class _SendFeedbackScreenState extends State<SendFeedbackScreen> {
  final _formKey = GlobalKey<FormState>();
  final _feedbackController = TextEditingController();
  final _emailController = TextEditingController(text: 'ahmed.alrashid@example.com');
  
  FeedbackType _selectedType = FeedbackType.improvement;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _feedbackController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  String _getFeedbackTypeLabel(FeedbackType type) {
    switch (type) {
      case FeedbackType.bug:
        return 'Bug Report';
      case FeedbackType.feature:
        return 'Feature Request';
      case FeedbackType.improvement:
        return 'Improvement Suggestion';
      case FeedbackType.content:
        return 'Content Request';
      case FeedbackType.other:
        return 'Other';
    }
  }

  String _getFeedbackTypeDescription(FeedbackType type) {
    switch (type) {
      case FeedbackType.bug:
        return 'Report a bug or technical issue';
      case FeedbackType.feature:
        return 'Suggest a new feature';
      case FeedbackType.improvement:
        return 'Suggest improvements to existing features';
      case FeedbackType.content:
        return 'Request specific content or scholars';
      case FeedbackType.other:
        return 'General feedback or questions';
    }
  }

  IconData _getFeedbackTypeIcon(FeedbackType type) {
    switch (type) {
      case FeedbackType.bug:
        return Icons.bug_report_rounded;
      case FeedbackType.feature:
        return Icons.lightbulb_rounded;
      case FeedbackType.improvement:
        return Icons.trending_up_rounded;
      case FeedbackType.content:
        return Icons.library_books_rounded;
      case FeedbackType.other:
        return Icons.chat_rounded;
    }
  }

  Future<void> _submitFeedback() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      // TODO-018: Implement actual feedback submission API call
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Thank you! Your feedback has been submitted.'),
            backgroundColor: Colors.green,
          ),
        );

        // Clear form
        _feedbackController.clear();
        setState(() {
          _selectedType = FeedbackType.improvement;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to submit feedback. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
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
              Icons.feedback_rounded,
              color: colorScheme.primary,
              size: AppSpacing.iconMedium,
            ),
            const SizedBox(width: AppSpacing.small),
            const AppTitleText('Send Feedback'),
          ],
        ),
      ),
      body: Form(
        key: _formKey,
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
                    Icons.rate_review_rounded,
                    size: 48,
                    color: colorScheme.primary,
                  ),
                  const SizedBox(height: AppSpacing.medium),
                  const AppTitleText(
                    'We Value Your Input',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.small),
                  AppBodyText(
                    'Help us improve Scroll by sharing your thoughts',
                    textAlign: TextAlign.center,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
            ),

            // Form content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.medium),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Feedback type selection
                    AppCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const AppSubtitleText('Feedback Type'),
                          const SizedBox(height: AppSpacing.medium),
                          ...FeedbackType.values.map((type) {
                            return Column(
                              children: [
                                RadioListTile<FeedbackType>(
                                  value: type,
                                  groupValue: _selectedType,
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedType = value!;
                                    });
                                  },
                                  title: Row(
                                    children: [
                                      Icon(
                                        _getFeedbackTypeIcon(type),
                                        size: AppSpacing.iconSmall,
                                        color: _selectedType == type
                                            ? colorScheme.primary
                                            : colorScheme.onSurfaceVariant,
                                      ),
                                      const SizedBox(width: AppSpacing.small),
                                      AppBodyText(_getFeedbackTypeLabel(type)),
                                    ],
                                  ),
                                  subtitle: AppCaptionText(
                                    _getFeedbackTypeDescription(type),
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                  contentPadding: EdgeInsets.zero,
                                ),
                                if (type != FeedbackType.values.last)
                                  Divider(
                                    height: 1,
                                    thickness: 1,
                                    color: colorScheme.outline.withValues(alpha: 0.1),
                                  ),
                              ],
                            );
                          }).toList(),
                        ],
                      ),
                    ),

                    const SizedBox(height: AppSpacing.medium),

                    // Email field
                    AppCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.email_rounded,
                                size: AppSpacing.iconSmall,
                                color: colorScheme.primary,
                              ),
                              const SizedBox(width: AppSpacing.small),
                              const AppSubtitleText('Your Email'),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.medium),
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              hintText: 'Enter your email address',
                              prefixIcon: Icon(Icons.email_rounded),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email address';
                              }
                              if (!value.contains('@')) {
                                return 'Please enter a valid email address';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: AppSpacing.small),
                          AppCaptionText(
                            'We\'ll use this to follow up on your feedback if needed',
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: AppSpacing.medium),

                    // Feedback text field
                    AppCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.edit_rounded,
                                size: AppSpacing.iconSmall,
                                color: colorScheme.primary,
                              ),
                              const SizedBox(width: AppSpacing.small),
                              const AppSubtitleText('Your Feedback'),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.medium),
                          TextFormField(
                            controller: _feedbackController,
                            maxLines: 5,
                            maxLength: 1000,
                            decoration: const InputDecoration(
                              hintText: 'Please share your detailed feedback here...',
                              border: OutlineInputBorder(),
                              alignLabelWithHint: true,
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter your feedback';
                              }
                              if (value.trim().length < 10) {
                                return 'Please provide more detailed feedback (at least 10 characters)';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: AppSpacing.small),
                          AppCaptionText(
                            'Please be as specific as possible to help us understand your feedback better',
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: AppSpacing.large),
                  ],
                ),
              ),
            ),

            // Submit button
            Container(
              padding: const EdgeInsets.all(AppSpacing.medium),
              color: colorScheme.surface,
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: AppPrimaryButton(
                      onPressed: _isSubmitting ? null : _submitFeedback,
                      child: _isSubmitting
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      colorScheme.onPrimary,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: AppSpacing.small),
                                const Text('Submitting...'),
                              ],
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.send_rounded),
                                const SizedBox(width: AppSpacing.small),
                                const Text('Submit Feedback'),
                              ],
                            ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.small),
                  AppCaptionText(
                    'Your feedback helps us make Scroll better for everyone',
                    textAlign: TextAlign.center,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}