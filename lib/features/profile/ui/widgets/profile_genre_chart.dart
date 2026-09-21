import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../providers/profile_providers.dart';

class ProfileGenreChart extends StatelessWidget {
  final ProfileStats stats;

  const ProfileGenreChart({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
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
}
