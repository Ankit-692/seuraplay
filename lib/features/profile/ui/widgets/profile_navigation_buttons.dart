import 'package:flutter/material.dart';
import '../completed_movies_screen.dart';
import '../completed_shows_screen.dart';
import '../dropped_shows_screen.dart';
import 'navigation_tile.dart';

class ProfileNavigationButtons extends StatelessWidget {
  const ProfileNavigationButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        NavigationTile(
          title: 'Completed Movies',
          icon: Icons.movie_rounded,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CompletedMoviesScreen()),
          ),
        ),
        const SizedBox(height: 8),
        NavigationTile(
          title: 'Completed Shows',
          icon: Icons.tv_rounded,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CompletedShowsScreen()),
          ),
        ),
        const SizedBox(height: 8),
        NavigationTile(
          title: 'Dropped Shows',
          icon: Icons.archive_outlined,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const DroppedShowsScreen()),
          ),
        ),
      ],
    );
  }
}
