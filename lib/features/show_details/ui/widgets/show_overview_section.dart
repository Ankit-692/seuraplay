import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/database/database.dart';
import '../../../../core/utils/app_toasts.dart';
import '../../../home/main_screen.dart';
import '../../../library/providers/search_provider.dart';
import '../../providers/show_details_provider.dart';

class ShowOverviewSection extends ConsumerWidget {
  final TvShow show;
  final int showId;
  final List<dynamic> castList;

  const ShowOverviewSection({
    super.key,
    required this.show,
    required this.showId,
    required this.castList,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trailerAsync = ref.watch(showTrailersProvider(showId));
    final trailerKey = trailerAsync.value;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- ACTIONS BAR ---
          Consumer(
            builder: (context, ref, child) {
              final progressAsync = ref.watch(showProgressProvider(showId));
              final isAllWatched = progressAsync.maybeWhen(
                data: (p) => p.total > 0 && p.watched == p.total,
                orElse: () => false,
              );
              
              return Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isAllWatched
                            ? Theme.of(context).primaryColor.withValues(alpha: 0.15)
                            : Colors.white12,
                        foregroundColor: isAllWatched
                            ? Theme.of(context).primaryColor
                            : Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(
                            color: isAllWatched 
                                ? Theme.of(context).primaryColor.withValues(alpha: 0.5) 
                                : Colors.transparent,
                          ),
                        ),
                      ),
                      icon: Icon(
                        isAllWatched ? Icons.check_circle : Icons.visibility,
                        size: 18,
                      ),
                      label: Text(
                        isAllWatched ? 'Completed' : 'Mark as Watched',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      onPressed: () {
                        if (!isAllWatched) {
                          AppToasts.showInfo(context, 'Long press to mark the entire series completed');
                        } else {
                          ref.read(episodeControllerProvider).markShowWatched(showId, false);
                        }
                      },
                      onLongPress: () {
                        if (!isAllWatched) {
                          ref.read(episodeControllerProvider).markShowWatched(showId, true);
                          AppToasts.showSuccess(context, 'Marked series as completed');
                        }
                      },
                    ),
                  ),
                  if (trailerKey != null) ...[
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
                          final url = Uri.parse('https://www.youtube.com/watch?v=$trailerKey');
                          try {
                            await launchUrl(url, mode: LaunchMode.externalApplication);
                          } catch (_) {}
                        },
                      ),
                    ),
                  ],
                ],
              );
            },
          ),
          const SizedBox(height: 24),
          if (show.overview.isNotEmpty) ...[
            const Text(
              'Synopsis',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              show.overview,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
          ],
          if (castList.isNotEmpty) ...[
            const Text(
              'Cast',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
            const SizedBox(height: 16),
          ],
        ],
      ),
    );
  }
}
