import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/profile_providers.dart';
import 'completed_movies_screen.dart';
import 'completed_shows_screen.dart';
import 'dropped_shows_screen.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileStatsAsync = ref.watch(profileStatsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F0F0F),
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        elevation: 0,
        title: const Text(
          'Profile',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
            letterSpacing: -0.5,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: profileStatsAsync.when(
        data: (stats) {
          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              const SliverToBoxAdapter(
                child: SizedBox(height: 16),
              ),
              SliverToBoxAdapter(
                child: _buildRankSection(context, stats),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 24)),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                sliver: SliverToBoxAdapter(
                  child: const Text(
                    'Library Overview',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 12)),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                sliver: _buildCompactStatsGrid(context, stats),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 32)),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                sliver: SliverToBoxAdapter(
                  child: const Text(
                    'Top Genres',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 16)),
              SliverToBoxAdapter(
                child: _buildGenreChart(context, stats),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 32)),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                sliver: SliverToBoxAdapter(
                  child: const Text(
                    'Collections',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 12)),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                sliver: SliverToBoxAdapter(
                  child: _buildNavigationButtons(context),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 48)),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator(color: Colors.blueAccent)),
        error: (err, stack) => Center(child: Text('Error: $err', style: const TextStyle(color: Colors.redAccent))),
      ),
    );
  }

  Widget _buildRankSection(BuildContext context, ProfileStats stats) {
    // 1. Base Watch Points
    final baseWatchPoints = (stats.moviesWatched * 10) + (stats.episodesWatched * 1);
    
    // 2. Diversity Multiplier (Max 2.0x for 20+ genres)
    double diversityMultiplier = 1.0 + (stats.uniqueGenresCount / 20.0);
    if (diversityMultiplier > 2.0) diversityMultiplier = 2.0;
    
    // 3. Completion Bonus
    final completionBonus = (stats.showsWatched * 50) + (stats.moviesAdded * 1) + (stats.showsAdded * 2);

    // Total Score
    final score = ((baseWatchPoints * diversityMultiplier) + completionBonus).round();

    String rankTitle = 'Novice Viewer';
    Color rankColor = Colors.grey;
    IconData rankIcon = Icons.star_outline_rounded;

    if (score >= 25000) {
      rankTitle = 'Master Viewer';
      rankColor = const Color(0xFFFFD700); // Gold
      rankIcon = Icons.workspace_premium_rounded;
    } else if (score >= 10000) {
      rankTitle = 'Cinephile';
      rankColor = const Color(0xFF9370DB); // Purple
      rankIcon = Icons.local_movies_rounded;
    } else if (score >= 5000) {
      rankTitle = 'Connoisseur';
      rankColor = const Color(0xFF00C6FF); // Blue
      rankIcon = Icons.stars_rounded;
    } else if (score >= 2000) {
      rankTitle = 'Enthusiast';
      rankColor = const Color(0xFF38EF7D); // Green
      rankIcon = Icons.movie_filter_rounded;
    } else if (score >= 500) {
      rankTitle = 'Explorer';
      rankColor = const Color(0xFFFF9800); // Orange
      rankIcon = Icons.explore_rounded;
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xFF161616),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Row(
        children: [
          Container(
            height: 64,
            width: 64,
            decoration: BoxDecoration(
              color: rankColor.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(rankIcon, color: rankColor, size: 32),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  rankTitle,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: rankColor,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$score XP Points',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white54,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompactStatsGrid(BuildContext context, ProfileStats stats) {
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 2.2, // Makes them wider and shorter (more compact)
      ),
      delegate: SliverChildListDelegate([
        _CompactStatCard(
          title: 'Movies Watched',
          value: '${stats.moviesWatched}',
          icon: Icons.movie_rounded,
          color: const Color(0xFFFF416C),
        ),
        _CompactStatCard(
          title: 'Eps Watched',
          value: '${stats.episodesWatched}',
          icon: Icons.live_tv_rounded,
          color: const Color(0xFF11998E),
        ),
        _CompactStatCard(
          title: 'Movies Added',
          value: '${stats.moviesAdded}',
          icon: Icons.add_to_queue_rounded,
          color: const Color(0xFF8A2387),
        ),
        _CompactStatCard(
          title: 'Shows Added',
          value: '${stats.showsAdded}',
          icon: Icons.queue_play_next_rounded,
          color: const Color(0xFF00B4DB),
        ),
      ]),
    );
  }

  Widget _buildGenreChart(BuildContext context, ProfileStats stats) {
    if (stats.watchedGenreCounts.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: Text(
          'No genres watched yet.',
          style: TextStyle(color: Colors.white54),
        ),
      );
    }

    final sortedEntries = stats.watchedGenreCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    // Take top 5, combine the rest into "Other"
    final topEntries = sortedEntries.take(5).toList();
    final otherCount = sortedEntries.skip(5).fold<int>(0, (sum, item) => sum + item.value);

    if (otherCount > 0) {
      topEntries.add(MapEntry('Other', otherCount));
    }

    final totalCount = topEntries.fold<int>(0, (sum, item) => sum + item.value);

    final predefinedColors = [
      const Color(0xFF6B11FF), // Deep Purple
      const Color(0xFF00C6FF), // Cyan
      const Color(0xFFFF416C), // Pink
      const Color(0xFF38EF7D), // Green
      const Color(0xFFF9D423), // Yellow
      Colors.grey, // For 'Other'
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF161616),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 200,
            child: Stack(
              children: [
                PieChart(
                  PieChartData(
                    sectionsSpace: 2,
                    centerSpaceRadius: 60,
                    startDegreeOffset: -90,
                    sections: topEntries.asMap().entries.map((entry) {
                      final index = entry.key;
                      final mapEntry = entry.value;
                      final percentage = (mapEntry.value / totalCount * 100);
                      final isOther = mapEntry.key == 'Other';
                      final color = isOther ? Colors.grey : predefinedColors[index % (predefinedColors.length - 1)];

                      return PieChartSectionData(
                        color: color,
                        value: mapEntry.value.toDouble(),
                        title: '${percentage.toStringAsFixed(0)}%',
                        radius: 25,
                        titleStyle: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      );
                    }).toList(),
                  ),
                ),
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${stats.uniqueGenresCount}',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const Text(
                        'Genres',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white54,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 16,
            runSpacing: 12,
            alignment: WrapAlignment.center,
            children: topEntries.asMap().entries.map((entry) {
              final index = entry.key;
              final mapEntry = entry.value;
              final isOther = mapEntry.key == 'Other';
              final color = isOther ? Colors.grey : predefinedColors[index % (predefinedColors.length - 1)];

              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '${mapEntry.key} (${mapEntry.value})',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white70,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationButtons(BuildContext context) {
    return Column(
      children: [
        _NavigationTile(
          title: 'Completed Movies',
          icon: Icons.movie_rounded,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CompletedMoviesScreen()),
          ),
        ),
        const SizedBox(height: 8),
        _NavigationTile(
          title: 'Completed Shows',
          icon: Icons.tv_rounded,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CompletedShowsScreen()),
          ),
        ),
        const SizedBox(height: 8),
        _NavigationTile(
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

class _CompactStatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _CompactStatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF161616),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: -0.5,
                  ),
                ),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.white54,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NavigationTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _NavigationTile({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFF161616),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white70, size: 20),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white30, size: 14),
          ],
        ),
      ),
    );
  }
}
