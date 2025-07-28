import 'package:flutter/material.dart';
import '../theme/app_spacing.dart';
import '../widgets/text/app_text.dart';
import '../widgets/cards/app_card.dart';

class FAQItem {
  final String question;
  final String answer;
  final String category;

  FAQItem({
    required this.question,
    required this.answer,
    required this.category,
  });

  factory FAQItem.fromJson(Map<String, dynamic> json) {
    return FAQItem(
      question: json['question'] ?? '',
      answer: json['answer'] ?? '',
      category: json['category'] ?? 'General',
    );
  }
}

/// Help & Support screen with collapsible FAQ sections
class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({super.key});

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {
  List<FAQItem> _faqs = [];
  bool _isLoading = true;
  String? _error;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadFAQs();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadFAQs() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      // TODO: Replace with actual API call
      // For now, using mock FAQ data
      await Future.delayed(const Duration(milliseconds: 800));
      
      const mockFAQsJson = [
        {
          "question": "How do I subscribe to Siraaj Premium?",
          "answer": "You can subscribe to Siraaj Premium by going to Settings > Subscription and selecting your preferred plan. We offer monthly and annual subscriptions with a 14-day free trial.",
          "category": "Subscription"
        },
        {
          "question": "Can I cancel my subscription anytime?",
          "answer": "Yes, you can cancel your subscription at any time from your account settings. Your access will continue until the end of your current billing period.",
          "category": "Subscription"
        },
        {
          "question": "How do I download content for offline listening?",
          "answer": "Premium subscribers can download content by tapping the download icon next to any audiobook or lecture. Downloaded content is available in your Library under the Downloads section.",
          "category": "Downloads"
        },
        {
          "question": "Why can't I download certain content?",
          "answer": "Some content may not be available for download due to licensing restrictions. This is indicated by a grayed-out download button.",
          "category": "Downloads"
        },
        {
          "question": "How much storage space do downloads use?",
          "answer": "Download sizes vary by content length and quality. On average, a 1-hour audiobook uses about 50-100MB depending on your download quality setting.",
          "category": "Downloads"
        },
        {
          "question": "Can I sync my progress across devices?",
          "answer": "Yes, your listening progress, bookmarks, and notes automatically sync across all devices when you're signed in to your account.",
          "category": "Account"
        },
        {
          "question": "How do I reset my password?",
          "answer": "Tap 'Forgot Password' on the login screen and enter your email address. You'll receive instructions to reset your password.",
          "category": "Account"
        },
        {
          "question": "Can I share my account with family members?",
          "answer": "Each account is intended for individual use. We recommend each family member have their own account to maintain personalized recommendations and progress tracking.",
          "category": "Account"
        },
        {
          "question": "How do I change the playback speed?",
          "answer": "You can adjust playback speed from the player controls or by going to Settings > Audio > Playback Speed. Options range from 0.5x to 2.0x speed.",
          "category": "Playback"
        },
        {
          "question": "Why does audio playback keep stopping?",
          "answer": "This could be due to poor internet connection, low battery optimization settings, or background app restrictions. Try downloading content for offline playback.",
          "category": "Playback"
        },
        {
          "question": "How do I add bookmarks and notes?",
          "answer": "While listening, tap the bookmark icon to save your current position. To add a note, tap and hold the bookmark icon and type your note.",
          "category": "Features"
        },
        {
          "question": "Can I request specific content to be added?",
          "answer": "Yes! We welcome content suggestions. Use the 'Send Feedback' option in Settings to request specific scholars, books, or topics you'd like to see added.",
          "category": "Features"
        }
      ];

      final faqs = mockFAQsJson.map((json) => FAQItem.fromJson(json)).toList();

      setState(() {
        _faqs = faqs;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load FAQ data. Please try again.';
        _isLoading = false;
      });
    }
  }

  List<FAQItem> get _filteredFAQs {
    if (_searchQuery.isEmpty) return _faqs;
    
    return _faqs.where((faq) {
      return faq.question.toLowerCase().contains(_searchQuery.toLowerCase()) ||
             faq.answer.toLowerCase().contains(_searchQuery.toLowerCase()) ||
             faq.category.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  Map<String, List<FAQItem>> get _groupedFAQs {
    final filtered = _filteredFAQs;
    final grouped = <String, List<FAQItem>>{};
    
    for (final faq in filtered) {
      grouped[faq.category] = (grouped[faq.category] ?? [])..add(faq);
    }
    
    return grouped;
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
              Icons.help_outline_rounded,
              color: colorScheme.primary,
              size: AppSpacing.iconMedium,
            ),
            const SizedBox(width: AppSpacing.small),
            const AppTitleText('Help & Support'),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.refresh_rounded,
              color: colorScheme.onSurfaceVariant,
            ),
            onPressed: _loadFAQs,
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
                onPressed: _loadFAQs,
                child: const Text('Try Again'),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        // Header with search
        Container(
          width: double.infinity,
          color: colorScheme.surface,
          padding: const EdgeInsets.all(AppSpacing.large),
          child: Column(
            children: [
              Icon(
                Icons.quiz_rounded,
                size: 48,
                color: colorScheme.primary,
              ),
              const SizedBox(height: AppSpacing.medium),
              const AppTitleText(
                'Frequently Asked Questions',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.small),
              AppBodyText(
                'Find answers to common questions',
                textAlign: TextAlign.center,
                color: colorScheme.onSurfaceVariant,
              ),
              const SizedBox(height: AppSpacing.large),
              // Search field
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search FAQs...',
                  prefixIcon: const Icon(Icons.search_rounded),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
                  ),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear_rounded),
                          onPressed: () {
                            _searchController.clear();
                            setState(() {
                              _searchQuery = '';
                            });
                          },
                        )
                      : null,
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              ),
            ],
          ),
        ),
        
        // FAQ sections
        Expanded(
          child: _groupedFAQs.isEmpty
              ? _buildEmptyState(context)
              : ListView.builder(
                  padding: const EdgeInsets.all(AppSpacing.medium),
                  itemCount: _groupedFAQs.keys.length,
                  itemBuilder: (context, index) {
                    final category = _groupedFAQs.keys.elementAt(index);
                    final categoryFAQs = _groupedFAQs[category]!;
                    return _FAQSection(
                      category: category,
                      faqs: categoryFAQs,
                    );
                  },
                ),
        ),
        
        // Contact support section
        Container(
          padding: const EdgeInsets.all(AppSpacing.medium),
          color: colorScheme.surface,
          child: Column(
            children: [
              AppSubtitleText('Still need help?'),
              const SizedBox(height: AppSpacing.small),
              AppBodyText(
                'Contact our support team',
                color: colorScheme.onSurfaceVariant,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.medium),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        // TODO: Open email client
                        debugPrint('Email support');
                      },
                      icon: const Icon(Icons.email_rounded),
                      label: const Text('Email'),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.medium),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        // TODO: Open chat or phone
                        debugPrint('Live chat');
                      },
                      icon: const Icon(Icons.chat_rounded),
                      label: const Text('Live Chat'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.large),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off_rounded,
              size: AppSpacing.iconHero,
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            ),
            const SizedBox(height: AppSpacing.large),
            const AppTitleText('No Results Found'),
            const SizedBox(height: AppSpacing.small),
            AppBodyText(
              'Try adjusting your search terms',
              textAlign: TextAlign.center,
              color: colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}

/// Collapsible FAQ section widget
class _FAQSection extends StatefulWidget {
  final String category;
  final List<FAQItem> faqs;

  const _FAQSection({
    required this.category,
    required this.faqs,
  });

  @override
  State<_FAQSection> createState() => _FAQSectionState();
}

class _FAQSectionState extends State<_FAQSection> {
  bool _isExpanded = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.medium),
      child: AppCard(
        padding: EdgeInsets.zero,
        child: Column(
          children: [
            // Section header
            ListTile(
              leading: Icon(
                _getCategoryIcon(widget.category),
                color: colorScheme.primary,
              ),
              title: AppSubtitleText(widget.category),
              subtitle: AppCaptionText(
                '${widget.faqs.length} question${widget.faqs.length != 1 ? 's' : ''}',
                color: colorScheme.onSurfaceVariant,
              ),
              trailing: Icon(
                _isExpanded 
                    ? Icons.expand_less_rounded 
                    : Icons.expand_more_rounded,
                color: colorScheme.onSurfaceVariant,
              ),
              onTap: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
            ),
            
            // FAQ items
            if (_isExpanded) ...widget.faqs.map((faq) => _FAQTile(faq: faq)),
          ],
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'subscription':
        return Icons.subscriptions_rounded;
      case 'downloads':
        return Icons.download_rounded;
      case 'account':
        return Icons.person_rounded;
      case 'playback':
        return Icons.play_circle_rounded;
      case 'features':
        return Icons.star_rounded;
      default:
        return Icons.help_outline_rounded;
    }
  }
}

/// Individual FAQ item widget
class _FAQTile extends StatefulWidget {
  final FAQItem faq;

  const _FAQTile({required this.faq});

  @override
  State<_FAQTile> createState() => _FAQTileState();
}

class _FAQTileState extends State<_FAQTile> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: colorScheme.outline.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
      ),
      child: ExpansionTile(
        title: AppBodyText(
          widget.faq.question,
          maxLines: _isExpanded ? null : 2,
          overflow: _isExpanded ? null : TextOverflow.ellipsis,
        ),
        trailing: Icon(
          _isExpanded 
              ? Icons.remove_rounded 
              : Icons.add_rounded,
          color: colorScheme.primary,
        ),
        onExpansionChanged: (expanded) {
          setState(() {
            _isExpanded = expanded;
          });
        },
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.medium,
              0,
              AppSpacing.medium,
              AppSpacing.medium,
            ),
            child: AppBodyText(
              widget.faq.answer,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}