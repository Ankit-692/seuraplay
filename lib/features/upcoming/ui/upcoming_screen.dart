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

          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 100.0),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              final date = item.date;
              final countdownText = _getCountdownText(date);
              
              final posterUrl = item.posterPath != null 
                  ? 'https://image.tmdb.org/t/p/w200${item.posterPath}' 
                  : null;

              return Card(
                elevation: 0,
                color: Colors.grey.withOpacity(0.08),
                margin: const EdgeInsets.only(bottom: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.white.withOpacity(0.05)),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
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
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: SizedBox(
                            width: 60,
                            height: 90,
                            child: posterUrl != null
                                ? CachedNetworkImage(
                                    imageUrl: posterUrl,
                                    fit: BoxFit.cover,
                                  )
                                : Container(
                                    color: Colors.grey[800],
                                    child: Icon(item.isMovie ? Icons.movie : Icons.tv, color: Colors.white54),
                                  ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.title,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8, 
                                  vertical: 4
                                ),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor.withValues(alpha:0.2),
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(
                                    color: Theme.of(context).primaryColor,
                                    width: 1,
                                  ),
                                ),
                                child: Text(
                                  countdownText,
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                '${item.isMovie ? 'Releases' : 'Airs'}: ${date.toLocal().toString().split(' ')[0]}',
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.chevron_right, color: Colors.grey),
                      ],
                    ),
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