class WelcomeContent {
  final String title;
  final String description;
  final String buttonText;

  const WelcomeContent({
    required this.title,
    required this.description,
    required this.buttonText,
  });

  static const WelcomeContent defaultContent = WelcomeContent(
    title: 'Welcome to Scroll',
    description: 'Your personalized learning companion that illuminates the path of knowledge.',
    buttonText: 'Get Started',
  );
}