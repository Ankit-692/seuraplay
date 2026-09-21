import 'package:flutter/material.dart';
import '../../providers/profile_providers.dart';
import 'compact_stat_card.dart';

class ProfileStatsGrid extends StatelessWidget {
  final ProfileStats stats;

  const ProfileStatsGrid({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 2.2, // Makes them wider and shorter (more compact)
      ),
      delegate: SliverChildListDelegate([
        CompactStatCard(
          title: 'Movies Watched',
          value: '${stats.moviesWatched}',
          icon: Icons.movie_rounded,
          color: const Color(0xFFFF416C),
        ),
        CompactStatCard(
          title: 'Eps Watched',
          value: '${stats.episodesWatched}',
          icon: Icons.live_tv_rounded,
          color: const Color(0xFF11998E),
        ),
        CompactStatCard(
          title: 'Movies Added',
          value: '${stats.moviesAdded}',
          icon: Icons.add_to_queue_rounded,
          color: const Color(0xFF8A2387),
        ),
        CompactStatCard(
          title: 'Shows Added',
          value: '${stats.showsAdded}',
          icon: Icons.queue_play_next_rounded,
          color: const Color(0xFF00B4DB),
        ),
      ]),
    );
  }
}
