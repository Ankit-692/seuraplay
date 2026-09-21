import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:seuraplay/features/library/ui/shows_screen.dart';
import 'package:seuraplay/features/library/ui/movies_screen.dart';
import 'package:seuraplay/features/library/ui/search_screen.dart';
import 'package:seuraplay/features/upcoming/ui/upcoming_screen.dart';
import '../settings/ui/settings_screen.dart';
import '../profile/ui/profile_screen.dart';
import 'widgets/nav_bar_item.dart';

// A simple Riverpod provider to keep track of the selected tab index
final bottomNavIndexProvider = StateProvider<int>((ref) => 0);

class MainScreen extends ConsumerWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(bottomNavIndexProvider);

    final List<Widget> screens = [
      const ShowsScreen(),
      const MoviesScreen(),
      const SearchScreen(),
      const UpcomingScreen(),
    ];

    return Scaffold(
      extendBody: true, // Allows lists to scroll behind the floating nav bar margin
      appBar: AppBar(
        title: const Text('Seuraplay'),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.person_rounded),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings_rounded),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: IndexedStack(index: currentIndex, children: screens),
      bottomNavigationBar: SafeArea(
        child: Container(
          margin: const EdgeInsets.only(left: 24, right: 24, bottom: 20),
          decoration: BoxDecoration(
            color: Colors.grey.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(32.0),
            border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(32.0),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    NavBarItem(
                      icon: Icons.tv_rounded,
                      label: 'Shows',
                      isSelected: currentIndex == 0,
                      onTap: () => ref.read(bottomNavIndexProvider.notifier).state = 0,
                    ),
                    NavBarItem(
                      icon: Icons.movie_creation_rounded,
                      label: 'Movies',
                      isSelected: currentIndex == 1,
                      onTap: () => ref.read(bottomNavIndexProvider.notifier).state = 1,
                    ),
                    NavBarItem(
                      icon: Icons.search_rounded,
                      label: 'Search',
                      isSelected: currentIndex == 2,
                      onTap: () => ref.read(bottomNavIndexProvider.notifier).state = 2,
                    ),
                    NavBarItem(
                      icon: Icons.calendar_month_rounded,
                      label: 'Upcoming',
                      isSelected: currentIndex == 3,
                      onTap: () => ref.read(bottomNavIndexProvider.notifier).state = 3,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
