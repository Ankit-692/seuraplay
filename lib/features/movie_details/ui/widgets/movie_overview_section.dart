import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/database/database.dart';
import '../../../../core/utils/app_toasts.dart';
import '../../../home/main_screen.dart';
import '../../../library/providers/search_provider.dart';
import '../../providers/movie_details_provider.dart';

class MovieOverviewSection extends ConsumerWidget {
  final Movie movie;
  final int movieId;
  final List<dynamic> castList;
  final bool isWatched;
  final bool isUnreleased;

  const MovieOverviewSection({
    super.key,
    required this.movie,
    required this.movieId,
    required this.castList,
    required this.isWatched,
    required this.isUnreleased,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trailerAsync = ref.watch(movieTrailersProvider(movieId));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- ACTIONS BAR ---
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isWatched
                        ? Theme.of(context).primaryColor.withValues(alpha: 0.15)
                        : Colors.white12,
                    foregroundColor: isWatched
                        ? Theme.of(context).primaryColor
                        : (isUnreleased ? Colors.white54 : Colors.white),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(
                        color: isWatched 
                            ? Theme.of(context).primaryColor.withValues(alpha: 0.5) 
                            : Colors.transparent,
                      ),
                    ),
                  ),
                  icon: Icon(
                    isWatched ? Icons.check_circle : (isUnreleased ? Icons.schedule : Icons.visibility),
                    size: 18,
                  ),
                  label: Text(
                    isWatched ? 'Watched' : 'Mark as Watched',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  onPressed: () {
                    if (isUnreleased && !isWatched) {
                      AppToasts.showInfo(context, 'This movie hasn\'t been released yet. Long press to mark as watched.');
                      return;
                    }
                    ref
                        .read(movieControllerProvider)
                        .toggleStatus(movie.id, movie.status);
                  },
                  onLongPress: () {
                    if (isUnreleased && !isWatched) {
                      ref
                          .read(movieControllerProvider)
                          .toggleStatus(movie.id, movie.status);
                      AppToasts.showSuccess(context, 'Marked unreleased movie as watched.');
                    }
                  },
                ),
              ),
              if (trailerAsync.value != null) ...[
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white12,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: const BorderSide(color: Colors.transparent),
                      ),
                    ),
                    icon: const Icon(Icons.play_arrow, size: 18),
                    label: const Text(
                      'Watch Trailer',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    onPressed: () async {
                      final url = Uri.parse('https://www.youtube.com/watch?v=${trailerAsync.value}');
                      try {
                        await launchUrl(url, mode: LaunchMode.externalApplication);
                      } catch (_) {}
                    },
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 24),

          if (movie.overview.isNotEmpty) ...[
            const Text(
              'Synopsis',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              movie.overview,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
          ],

          // Cast Section
          if (castList.isNotEmpty) ...[
            const Text(
              'Cast',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 160,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: castList.length,
                itemBuilder: (context, index) {
                  final actor = castList[index];
                  final profilePath = actor['profile_path'];
                  final imageUrl = profilePath != null
                      ? 'https://image.tmdb.org/t/p/w200$profilePath'
                      : null;

                  return Container(
                    width: 90,
                    margin: const EdgeInsets.only(right: 16),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        final actorName = actor['name'];
                        if (actorName != null) {
                          ref.read(bottomNavIndexProvider.notifier).state = 2;
                          ref.read(searchQueryProvider.notifier).state = actorName;
                          Navigator.popUntil(context, (route) => route.isFirst);
                        }
                      },
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              width: 90,
                              height: 110,
                              color: Colors.grey[900],
                              child: imageUrl != null
                                  ? CachedNetworkImage(
                                      imageUrl: imageUrl,
                                      fit: BoxFit.cover,
                                    )
                                  : const Icon(Icons.person, color: Colors.grey),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            actor['name'] ?? '',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            actor['character'] ?? '',
                            style: const TextStyle(
                              fontSize: 11,
                              color: Colors.white54,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 32),
          ],
        ],
      ),
    );
  }
}
