import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:water_drop_nav_bar/water_drop_nav_bar.dart';
import 'dart:io';
import '../providers/theme_provider.dart';
import '../theme/theme_extensions.dart';
import 'home/home_tab.dart';
import 'home/categories_tab.dart';
import 'home/library_tab.dart';
import 'home/settings_tab.dart';

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
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: pageController,
          children: const [
            HomeTab(),
            CategoriesTab(),
            LibraryTab(),
            SettingsTab(),
          ],
        ),
      ),
      bottomNavigationBar: WaterDropNavBar(
        backgroundColor: isDarkMode ? Colors.grey[900]! : Colors.white,
        waterDropColor: theme.colorScheme.primary,
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
        barItems: <BarItem>[
          BarItem(
            filledIcon: Icons.home_rounded,
            outlinedIcon: Icons.home_outlined,
          ),
          BarItem(
            filledIcon: Icons.category_rounded,
            outlinedIcon: Icons.category_outlined,
          ),
          // BarItem(
          //   filledIcon: Icons.search_rounded,
          //   outlinedIcon: Icons.search_rounded,
          // ),
          BarItem(
            filledIcon: Icons.library_books_rounded,
            outlinedIcon: Icons.library_books_outlined,
          ),
          BarItem(
            filledIcon: Icons.settings_rounded,
            outlinedIcon: Icons.settings_outlined,
          ),
        ],
      ),
    );
  }




}