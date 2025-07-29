import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:siraaj/widgets/buttons/music_player_fab.dart';
import 'package:water_drop_nav_bar/water_drop_nav_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../providers/theme_provider.dart';
import '../theme/app_icons.dart';
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
  DateTime? lastBackPressTime;

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

  bool _onWillPop() {
    // If not on home tab (index 0), navigate to home tab
    if (selectedIndex != 0) {
      setState(() {
        selectedIndex = 0;
      });
      pageController.animateToPage(
        0,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutQuad,
      );
      return false; // Don't exit app
    }

    // If on home tab, check for double back press to exit
    final now = DateTime.now();
    if (lastBackPressTime == null || 
        now.difference(lastBackPressTime!) > const Duration(seconds: 2)) {
      lastBackPressTime = now;
      
      Fluttertoast.showToast(
        msg: "Press back again to exit",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black87,
        textColor: Colors.white,
      );
      
      return false; // Don't exit app
    }

    return true; // Exit app
  }

  @override
  Widget build(BuildContext context) {
    final themeState = ref.watch(themeProvider);
    final theme = Theme.of(context);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          final shouldPop = _onWillPop();
          if (shouldPop) {
            Navigator.of(context).pop();
          }
        }
      },
      child: Scaffold(
      floatingActionButton: const MusicPlayerFab(),
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
              backgroundColor: themeState.isDark ? Colors.grey[900]! : Colors.white,
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
                  filledIcon: AppIcons.home,
                  outlinedIcon: AppIcons.homeOutlined,
                ),
                BarItem(
                  filledIcon: AppIcons.category,
                  outlinedIcon: AppIcons.categoryOutlined,
                ),
                BarItem(
                  filledIcon: AppIcons.library,
                  outlinedIcon: AppIcons.libraryOutlined,
                ),
                BarItem(
                  filledIcon: AppIcons.settings,
                  outlinedIcon: AppIcons.settingsOutlined,
                ),
              ],
            ),
      ),
    );
  }
}