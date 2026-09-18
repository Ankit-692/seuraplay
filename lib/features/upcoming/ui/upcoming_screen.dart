import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/upcoming_provider.dart';
import '../../show_details/ui/show_details_screen.dart';
import '../../movie_details/ui/movie_details_screen.dart';

class UpcomingScreen extends ConsumerWidget {
  const UpcomingScreen({super.key});

  /// Helper function to format the countdown text beautifully
  String _getCountdownText(DateTime airDate) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final targetDate = DateTime(airDate.year, airDate.month, airDate.day);
    
    final difference = targetDate.difference(today).inDays;
    
    if (difference == 0) return 'TODAY';
    if (difference == 1) return 'TOMORROW';
    return 'IN $difference DAYS';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final upcomingAsync = ref.watch(upcomingItemsProvider);

    return Scaffold(
      body: upcomingAsync.when(
        data: (items) {
          if (items.isEmpty) {
            return const Center(
              child: Text(
                'No upcoming items announced\nfor the shows and movies you are watching/planning.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 100.0),
            itemCount: items.length,
            separatorBuilder: (context, index) => const SizedBox(height: 24),
            itemBuilder: (context, index) {
              final item = items[index];
              final date = item.date;
              final countdownText = _getCountdownText(date);
              
              // Use w500 for higher quality backdrops
              final posterUrl = item.posterPath != null 
                  ? 'https://image.tmdb.org/t/p/w500${item.posterPath}' 
                  : null;

              return Container(
                height: 140,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Stack(
                    children: [
                      // Blurred immersive backdrop
                      Positioned.fill(
                        child: posterUrl != null
                            ? CachedNetworkImage(
                                imageUrl: posterUrl,
                                fit: BoxFit.cover,
                              )
                            : Container(color: Colors.grey[900]),
                      ),
                      // Dark gradient overlay
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.black.withValues(alpha: 0.9),
                                Colors.black.withValues(alpha: 0.7),
                                Colors.black.withValues(alpha: 0.3),
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                          ),
                        ),
                      ),
                      // Content
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => item.isMovie
                                    ? MovieDetailsScreen(movieId: item.id)
                                    : ShowDetailsScreen(showId: item.id),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              children: [
                                // Sharp foreground poster
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Container(
                                    width: 75,
                                    height: 115,
                                    color: Colors.black26,
                                    child: posterUrl != null
                                        ? CachedNetworkImage(
                                            imageUrl: posterUrl,
                                            fit: BoxFit.cover,
                                          )
                                        : Icon(
                                            item.isMovie ? Icons.movie_rounded : Icons.tv_rounded, 
                                            color: Colors.white54,
                                            size: 24,
                                          ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                
                                // Details
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        item.title,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w800,
                                          letterSpacing: -0.5,
                                          color: Colors.white,
                                          shadows: [
                                            Shadow(
                                              color: Colors.black54,
                                              blurRadius: 4,
                                              offset: Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${item.isMovie ? 'Releases' : 'Airs'}: ${date.toLocal().toString().split(' ')[0]}',
                                        style: TextStyle(
                                          color: Colors.white.withValues(alpha: 0.7),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const Spacer(),
                                      // Bold countdown pill
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 14, 
                                          vertical: 6
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.black.withValues(alpha: 0.8),
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(
                                            color: Theme.of(context).primaryColor.withValues(alpha: 0.8),
                                            width: 1.5,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withValues(alpha: 0.5),
                                              blurRadius: 4,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: Text(
                                          countdownText,
                                          style: TextStyle(
                                            color: Theme.of(context).primaryColor,
                                            fontWeight: FontWeight.w900,
                                            fontSize: 14,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Icon(Icons.chevron_right_rounded, color: Colors.white54, size: 24),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}