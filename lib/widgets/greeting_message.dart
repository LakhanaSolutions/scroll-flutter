import 'package:flutter/material.dart';
import '../models/user_model.dart';

class GreetingMessage extends StatelessWidget {
  final String title;
  final String subtitle;

  const GreetingMessage({
    super.key,
    required this.title,
    required this.subtitle,
  });

  static GreetingMessage generic() {
    return const GreetingMessage(
      title: 'Welcome to Siraaj',
      subtitle: 'Please enter your email to get started',
    );
  }

  static GreetingMessage newUser() {
    return const GreetingMessage(
      title: 'Welcome to Siraaj!',
      subtitle: 'We\'ll send you a verification code to get started',
    );
  }

  static GreetingMessage returningUser(User user) {
    final name = user.name ?? user.email.split('@').first;
    return GreetingMessage(
      title: 'Welcome back, $name!',
      subtitle: 'We\'ll send you a verification code to sign in',
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.width > 600;

    return Column(
      children: [
        Text(
          title,
          style: theme.textTheme.headlineMedium?.copyWith(
            fontSize: isTablet ? 32 : 28,
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: isTablet ? 12 : 8),
        Container(
          constraints: BoxConstraints(
            maxWidth: screenSize.width * 0.8,
          ),
          child: Text(
            subtitle,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontSize: isTablet ? 16 : 14,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              height: 1.4,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}