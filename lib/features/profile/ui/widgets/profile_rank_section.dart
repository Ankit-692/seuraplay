import 'package:flutter/material.dart';
import '../../providers/profile_providers.dart';

class ProfileRankSection extends StatelessWidget {
  final ProfileStats stats;

  const ProfileRankSection({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
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
}
