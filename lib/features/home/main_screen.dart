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
            color: Colors.grey.withOpacity(0.08),
            borderRadius: BorderRadius.circular(32.0),
            border: Border.all(color: Colors.white.withOpacity(0.05)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
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
                    _NavBarItem(
                      icon: Icons.tv_rounded,
                      label: 'Shows',
                      isSelected: currentIndex == 0,
                      onTap: () => ref.read(bottomNavIndexProvider.notifier).state = 0,
                    ),
                    _NavBarItem(
                      icon: Icons.movie_creation_rounded,
                      label: 'Movies',
                      isSelected: currentIndex == 1,
                      onTap: () => ref.read(bottomNavIndexProvider.notifier).state = 1,
                    ),
                    _NavBarItem(
                      icon: Icons.search_rounded,
                      label: 'Search',
                      isSelected: currentIndex == 2,
                      onTap: () => ref.read(bottomNavIndexProvider.notifier).state = 2,
                    ),
                    _NavBarItem(
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

class _NavBarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavBarItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutQuint,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Theme.of(context).primaryColor.withOpacity(0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? Theme.of(context).primaryColor : Colors.white54,
              size: 24,
            ),
            if (isSelected) ...[
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
