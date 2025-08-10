import 'package:go_router/go_router.dart';
import 'package:siraaj/screens/auth/auth_screen.dart';
import 'package:siraaj/screens/notifications_screen.dart';
import '../screens/home_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/theme_demo_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/otp_verification_screen.dart';
import '../screens/subscription_screen.dart';
import '../screens/manage_devices_screen.dart';
import '../screens/notifications_list_screen.dart';
import '../screens/help_support_screen.dart';
import '../screens/send_feedback_screen.dart';
import '../screens/privacy_policy_screen.dart';
import '../screens/terms_of_service_screen.dart';
import '../screens/about_screen.dart';
import '../screens/search_screen.dart';
import '../screens/chapter_screen.dart';
import '../screens/playlist_screen.dart';
import '../screens/category_view_screen.dart';
import '../screens/narrator_screen.dart';
import '../screens/author_screen.dart';
import '../screens/note_screen.dart';
import '../screens/narrators_list_screen.dart';
import '../screens/authors_list_screen.dart';
import '../screens/reviews_screen.dart';
import '../screens/mood_screen.dart';
import '../screens/finish_profile_screen.dart';
import '../screens/bookmarks_screen.dart';
import '../screens/downloads_screen.dart';
import '../screens/following_screen.dart';
import '../data/mock_data.dart';
import '../services/token_service.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  redirect: (context, state) async {
    // Check if user has a valid token
    final hasToken = await TokenService.hasToken();
    
    final isOnAuthRoute = state.matchedLocation.startsWith('/welcome') ||
                         state.matchedLocation.startsWith('/login') ||
                         state.matchedLocation.startsWith('/verify-otp') ||
                         state.matchedLocation.startsWith('/finish-profile');
    
    final isOnPublicRoute = state.matchedLocation == '/about';
    
    // If user has token and is on auth route, redirect to home
    if (hasToken && isOnAuthRoute) {
      return '/home';
    }
    
    // If user has no token and is not on auth route or public route, redirect to welcome
    if (!hasToken && !isOnAuthRoute && !isOnPublicRoute) {
      return '/welcome';
    }
    
    // Allow the route to proceed
    return null;
  },
  routes: [
    // Auth routes
    GoRoute(
      path: '/welcome',
      builder: (context, state) => const AuthScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/verify-otp',
      builder: (context, state) => const OTPVerificationScreen(),
    ),
    GoRoute(
      path: '/finish-profile',
      builder: (context, state) => const FinishProfileScreen(),
    ),
    
    // Public routes (accessible without authentication)
    GoRoute(
      path: '/about',
      builder: (context, state) => const AboutScreen(),
    ),
    
    // Main app routes
    GoRoute(
      path: '/',
      redirect: (context, state) => '/home',
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeScreen(),
      routes: [
        GoRoute(
          path: 'profile',
          builder: (context, state) => const ProfileScreen(),
        ),
        GoRoute(
          path: 'theme-demo',
          builder: (context, state) => const ThemeDemoScreen(),
        ),
        GoRoute(
          path: 'subscription',
          builder: (context, state) => const SubscriptionScreen(),
        ),
        GoRoute(
          path: 'bookmarks',
          builder: (context, state) => const BookmarksScreen(),
        ),
        GoRoute(
          path: 'downloads',
          builder: (context, state) => const DownloadsScreen(),
        ),
        GoRoute(
          path: 'following',
          builder: (context, state) => const FollowingScreen(),
        ),
        GoRoute(
          path: 'manage-devices',
          builder: (context, state) => const ManageDevicesScreen(),
        ),
        GoRoute(
          path: 'notifications-list',
          builder: (context, state) => const NotificationsListScreen(),
        ),
        GoRoute(
          path: 'notifications',
          builder: (context, state) => const NotificationsScreen(),
        ),
        GoRoute(
          path: 'help-support',
          builder: (context, state) => const HelpSupportScreen(),
        ),
        GoRoute(
          path: 'send-feedback',
          builder: (context, state) => const SendFeedbackScreen(),
        ),
        GoRoute(
          path: 'privacy-policy',
          builder: (context, state) => const PrivacyPolicyScreen(),
        ),
        GoRoute(
          path: 'terms-of-service',
          builder: (context, state) => const TermsOfServiceScreen(),
        ),
        GoRoute(
          path: 'search',
          builder: (context, state) => const SearchScreen(),
        ),
        GoRoute(
          path: 'chapter/:chapterId/:contentId',
          builder: (context, state) {
            final chapterId = state.pathParameters['chapterId']!;
            final contentId = state.pathParameters['contentId']!;
            
            // Get mock data - in real app, fetch from API
            final content = MockData.getCategoryContent('1').firstWhere(
              (item) => item.id == contentId,
              orElse: () => MockData.getCategoryContent('1').first,
            );
            final chapter = content.chapters.firstWhere(
              (ch) => ch.id == chapterId,
              orElse: () => content.chapters.first,
            );
            
            return ChapterScreen(chapter: chapter, content: content);
          },
        ),
        GoRoute(
          path: 'playlist/:contentId',
          builder: (context, state) {
            final contentId = state.pathParameters['contentId']!;
            final progressParam = state.uri.queryParameters['progress'];
            final progress = progressParam != null ? double.tryParse(progressParam) : null;
            
            // Get mock data - in real app, fetch from API
            final content = MockData.getCategoryContent('1').firstWhere(
              (item) => item.id == contentId,
              orElse: () => MockData.getCategoryContent('1').first,
            );
            
            return PlaylistScreen(content: content, progress: progress);
          },
        ),
        GoRoute(
          path: 'category/:categoryId',
          builder: (context, state) {
            final categoryId = state.pathParameters['categoryId']!;
            
            // Get mock data - in real app, fetch from API
            final categories = MockData.getIslamicCategories();
            final category = categories.firstWhere(
              (cat) => cat.id == categoryId,
              orElse: () => categories.first,
            );
            
            return CategoryViewScreen(category: category);
          },
        ),
        GoRoute(
          path: 'narrator/:narratorId',
          builder: (context, state) {
            final narratorId = state.pathParameters['narratorId']!;
            
            // Get mock data - in real app, fetch from API
            final narrators = MockData.getMockNarrators();
            final narrator = narrators.firstWhere(
              (n) => n.id == narratorId,
              orElse: () => narrators.first,
            );
            
            return NarratorScreen(narrator: narrator);
          },
        ),
        GoRoute(
          path: 'author/:authorId',
          builder: (context, state) {
            final authorId = state.pathParameters['authorId']!;
            
            // Get mock data - in real app, fetch from API
            final authors = MockData.getMockAuthors();
            final author = authors.firstWhere(
              (a) => a.id == authorId,
              orElse: () => authors.first,
            );
            
            return AuthorScreen(author: author);
          },
        ),
        GoRoute(
          path: 'note/:chapterId/:contentId',
          builder: (context, state) {
            final chapterId = state.pathParameters['chapterId']!;
            final contentId = state.pathParameters['contentId']!;
            final positionParam = state.uri.queryParameters['position'] ?? '0';
            final wasPlayingParam = state.uri.queryParameters['wasPlaying'] ?? 'false';
            
            // Get mock data - in real app, fetch from API
            final content = MockData.getCategoryContent('1').firstWhere(
              (item) => item.id == contentId,
              orElse: () => MockData.getCategoryContent('1').first,
            );
            final chapter = content.chapters.firstWhere(
              (ch) => ch.id == chapterId,
              orElse: () => content.chapters.first,
            );
            
            return NoteScreen(
              chapter: chapter,
              content: content,
              currentPosition: double.tryParse(positionParam) ?? 0.0,
              wasAudioPlaying: wasPlayingParam == 'true',
            );
          },
        ),
        GoRoute(
          path: 'narrators',
          builder: (context, state) => const NarratorsListScreen(),
        ),
        GoRoute(
          path: 'authors',
          builder: (context, state) => const AuthorsListScreen(),
        ),
        GoRoute(
          path: 'reviews/:contentType/:contentId',
          builder: (context, state) {
            final contentType = state.pathParameters['contentType']!;
            final contentId = state.pathParameters['contentId']!;
            
            // Get content title based on type and ID
            String contentTitle = 'Content';
            
            switch (contentType) {
              case 'content':
                // Get content from all categories
                final allContent = [
                  ...MockData.getCategoryContent('1'),
                  ...MockData.getCategoryContent('2'),
                  ...MockData.getCategoryContent('3'),
                ];
                final content = allContent.firstWhere(
                  (item) => item.id == contentId,
                  orElse: () => allContent.first,
                );
                contentTitle = content.title;
                break;
              case 'author':
                final authors = MockData.getMockAuthors();
                final author = authors.firstWhere(
                  (a) => a.id == contentId,
                  orElse: () => authors.first,
                );
                contentTitle = author.name;
                break;
              case 'narrator':
                final narrators = MockData.getMockNarrators();
                final narrator = narrators.firstWhere(
                  (n) => n.id == contentId,
                  orElse: () => narrators.first,
                );
                contentTitle = narrator.name;
                break;
            }
            
            return ReviewsScreen(
              contentType: contentType,
              contentId: contentId,
              contentTitle: contentTitle,
            );
          },
        ),
        GoRoute(
          path: 'mood/:moodId',
          builder: (context, state) {
            final moodId = state.pathParameters['moodId']!;
            
            // Get mood category from mock data
            final moodCategories = MockData.getMoodCategories();
            final moodCategory = moodCategories.firstWhere(
              (mood) => mood.id == moodId,
              orElse: () => moodCategories.first,
            );
            
            return MoodScreen(moodCategory: moodCategory);
          },
        ),
      ],
    ),
    
    // Direct deep link routes (these will redirect to /home/... if user is authenticated)
    GoRoute(
      path: '/book/:bookId',
      redirect: (context, state) async {
        final hasToken = await TokenService.hasToken();
        if (!hasToken) return '/welcome';
        final bookId = state.pathParameters['bookId']!;
        return '/home/playlist/$bookId';
      },
    ),
    GoRoute(
      path: '/author/:authorId',
      redirect: (context, state) async {
        final hasToken = await TokenService.hasToken();
        if (!hasToken) return '/welcome';
        final authorId = state.pathParameters['authorId']!;
        return '/home/author/$authorId';
      },
    ),
    GoRoute(
      path: '/narrator/:narratorId',
      redirect: (context, state) async {
        final hasToken = await TokenService.hasToken();
        if (!hasToken) return '/welcome';
        final narratorId = state.pathParameters['narratorId']!;
        return '/home/narrator/$narratorId';
      },
    ),
    GoRoute(
      path: '/category/:categoryId',
      redirect: (context, state) async {
        final hasToken = await TokenService.hasToken();
        if (!hasToken) return '/welcome';
        final categoryId = state.pathParameters['categoryId']!;
        return '/home/category/$categoryId';
      },
    ),
  ],
);