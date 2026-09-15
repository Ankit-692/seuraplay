import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/profile_providers.dart';
import 'completed_movies_screen.dart';
import 'completed_shows_screen.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileStatsAsync = ref.watch(profileStatsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Profile Dashboard')),
      body: profileStatsAsync.when(
        data: (stats) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStatCards(context, stats),
                const SizedBox(height: 24),
                const Text(
                  'Genres Watched',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                _buildGenreBreakdown(context, stats),
                const SizedBox(height: 32),
                const Text(
                  'Completed Lists',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                _buildNavigationButtons(context),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildStatCards(BuildContext context, ProfileStats stats) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _StatCard(
                title: 'Movies Added',
                value: '${stats.moviesAdded}',
                icon: Icons.movie_creation_outlined,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                title: 'Movies Watched',
                value: '${stats.moviesWatched}',
                icon: Icons.movie_filter_outlined,
                color: Colors.greenAccent,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _StatCard(
                title: 'Shows Added',
                value: '${stats.showsAdded}',
                icon: Icons.tv_outlined,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                title: 'Shows Watched',
                value: '${stats.showsWatched}',
                icon: Icons.live_tv_outlined,
                color: Colors.greenAccent,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: _StatCard(
            title: 'Unique Genres Watched',
            value: '${stats.uniqueGenresCount}',
            icon: Icons.category_outlined,
            color: Colors.purpleAccent,
          ),
        ),
      ],
    );
  }

  Widget _buildGenreBreakdown(BuildContext context, ProfileStats stats) {
    if (stats.watchedGenreCounts.isEmpty) {
      return const Text(
        'No genres watched yet.',
        style: TextStyle(color: Colors.grey),
      );
    }

    final sortedEntries = stats.watchedGenreCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value)); // Sort descending by count

    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: sortedEntries.map((entry) {
        return Chip(
          backgroundColor: Colors.white.withValues(alpha: 0.05),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
          ),
          label: Text(
            '${entry.key}: ${entry.value}',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildNavigationButtons(BuildContext context) {
    return Column(
      children: [
        Card(
          elevation: 0,
          color: Colors.blueAccent.withValues(alpha: 0.05),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.blueAccent.withValues(alpha: 0.15)),
          ),
          child: ListTile(
            leading: const Icon(Icons.movie, color: Colors.blueAccent),
            title: const Text(
              'All Completed Movies',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            trailing: const Icon(Icons.chevron_right, color: Colors.grey),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const CompletedMoviesScreen(),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        Card(
          elevation: 0,
          color: Colors.purpleAccent.withValues(alpha: 0.05),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: Colors.purpleAccent.withValues(alpha: 0.15),
            ),
          ),
          child: ListTile(
            leading: const Icon(Icons.tv, color: Colors.purpleAccent),
            title: const Text(
              'All Completed Shows',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            trailing: const Icon(Icons.chevron_right, color: Colors.grey),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CompletedShowsScreen()),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.15)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.white70,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
