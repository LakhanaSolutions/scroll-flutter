import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:water_drop_nav_bar/water_drop_nav_bar.dart';
import '../providers/theme_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int selectedIndex = 0;
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(themeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Siraaj Demo'),
        actions: [
          IconButton(
            icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: () => ref.read(themeProvider.notifier).toggleTheme(),
          ),
        ],
      ),
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        children: [
          _buildHomePage(),
          _buildBookmarksPage(),
          _buildFavoritesPage(),
          _buildSettingsPage(),
        ],
      ),
      bottomNavigationBar: WaterDropNavBar(
        backgroundColor: isDarkMode ? Colors.grey[900]! : Colors.white,
        waterDropColor: Theme.of(context).primaryColor,
        onItemSelected: (index) {
          setState(() {
            selectedIndex = index;
          });
          pageController.animateToPage(
            selectedIndex,
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeOutQuad,
          );
        },
        selectedIndex: selectedIndex,
        barItems: [
          BarItem(
            filledIcon: Icons.home_rounded,
            outlinedIcon: Icons.home_outlined,
          ),
          BarItem(
            filledIcon: Icons.bookmark_rounded,
            outlinedIcon: Icons.bookmark_border_rounded,
          ),
          BarItem(
            filledIcon: Icons.favorite_rounded,
            outlinedIcon: Icons.favorite_border_rounded,
          ),
          BarItem(
            filledIcon: Icons.settings_rounded,
            outlinedIcon: Icons.settings_outlined,
          ),
        ],
      ),
    );
  }

  Widget _buildHomePage() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.home_rounded, size: 80, color: Colors.blue),
          SizedBox(height: 20),
          Text(
            'Welcome to Siraaj!',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            'Home Page',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildBookmarksPage() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.bookmark_rounded, size: 80, color: Colors.orange),
          SizedBox(height: 20),
          Text(
            'Bookmarks',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            'Your saved bookmarks will appear here',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoritesPage() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_rounded, size: 80, color: Colors.red),
          SizedBox(height: 20),
          Text(
            'Favorites',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            'Your favorite items will appear here',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsPage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.settings_rounded, size: 80, color: Colors.green),
          const SizedBox(height: 20),
          const Text(
            'Settings',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          const Text(
            'Configure your app settings',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () => context.go('/settings'),
            child: const Text('Go to Full Settings'),
          ),
        ],
      ),
    );
  }
}