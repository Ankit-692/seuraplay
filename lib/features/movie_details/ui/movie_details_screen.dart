import 'dart:convert';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/movie_details_provider.dart';
import '../../library/repositories/library_repository.dart';
import '../../library/providers/search_provider.dart';
import '../../home/main_screen.dart';
import '../../../core/utils/app_toasts.dart';
class MovieDetailsScreen extends ConsumerWidget {
  final int movieId;

  const MovieDetailsScreen({super.key, required this.movieId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final movieAsync = ref.watch(movieMetadataProvider(movieId));
    final trailerAsync = ref.watch(movieTrailersProvider(movieId));

    return Scaffold(
      body: movieAsync.when(
        data: (movie) {
          if (movie == null) {
            return const CustomScrollView(
              slivers: [
                SliverAppBar(),
                SliverFillRemaining(child: Center(child: Text('Movie not found'))),
              ],
            );
          }

          final posterUrl = movie.posterPath != null
              ? 'https://image.tmdb.org/t/p/w500${movie.posterPath}'
              : null;

          final isWatched = movie.status == 'watched';
          final isUnreleased = movie.releaseDate != null && movie.releaseDate!.isAfter(DateTime.now());

          List<dynamic> castList = [];
          if (movie.castList != null && movie.castList!.isNotEmpty) {
            try {
              castList = jsonDecode(movie.castList!);
            } catch (e) {
              // ignore decoding errors
            }
          }

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 320,
                pinned: true,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                surfaceTintColor: Colors.transparent,
                scrolledUnderElevation: 0,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                    onPressed: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          backgroundColor: Theme.of(context).cardColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          title: const Text('Remove Movie?'),
                          content: const Text(
                            'Are you sure you want to remove this movie from your library?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text(
                                'CANCEL',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: const Text(
                                'REMOVE',
                                style: TextStyle(color: Colors.redAccent),
                              ),
                            ),
                          ],
                        ),
                      );

                      if (confirm == true && context.mounted) {
                        await ref.read(libraryRepositoryProvider).removeMovie(movieId);
                        if (context.mounted) {
                          Navigator.pop(context);
                          AppToasts.showInfo(context, 'Movie removed from library.');
                        }
                      }
                    },
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Blurred background
                      if (posterUrl != null)
                        CachedNetworkImage(
                          imageUrl: posterUrl,
                          fit: BoxFit.cover,
                        ),
                      ClipRect(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                          child: Container(
                            color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.5),
                          ),
                        ),
                      ),
                      // Gradient overlay
                      DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black54,
                              Colors.transparent,
                              Theme.of(context).scaffoldBackgroundColor.withOpacity(0.8),
                              Theme.of(context).scaffoldBackgroundColor,
                            ],
                            stops: const [0.0, 0.3, 0.8, 1.0],
                          ),
                        ),
                      ),
                      // Foreground content
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              // Poster
                              Hero(
                                tag: 'movie_poster_$movieId',
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.4),
                                        blurRadius: 10,
                                        offset: const Offset(0, 5),
                                      ),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: SizedBox(
                                      width: 120,
                                      height: 180,
                                      child: posterUrl != null
                                          ? CachedNetworkImage(
                                              imageUrl: posterUrl,
                                              fit: BoxFit.cover,
                                            )
                                          : Container(
                                              color: Colors.grey[800],
                                              child: const Icon(Icons.movie, size: 50),
                                            ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 20),
                              // Title and Info
                              Expanded(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      movie.title,
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        fontStyle: (isUnreleased && !isWatched) ? FontStyle.italic : FontStyle.normal,
                                        color: (isUnreleased && !isWatched) ? Colors.white54 : Colors.white,
                                        height: 1.2,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    if (movie.genres != null && movie.genres!.isNotEmpty) ...[
                                      Text(
                                        movie.genres!,
                                        style: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                    ],
                                    if (movie.releaseDate != null)
                                      Text(
                                        '${isUnreleased ? 'Releasing' : 'Released'}: ${movie.releaseDate!.toLocal().toString().split(' ')[0]}',
                                        style: const TextStyle(
                                          color: Colors.white70,
                                          fontSize: 12,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Overview Section
              SliverToBoxAdapter(
                child: Padding(
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
                                    ? Theme.of(context).primaryColor.withOpacity(0.15)
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
                                        ? Theme.of(context).primaryColor.withOpacity(0.5) 
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
                ),
              ),
            ],
          );
        },
        loading: () => const CustomScrollView(
          slivers: [
            SliverAppBar(),
            SliverFillRemaining(child: Center(child: CircularProgressIndicator())),
          ],
        ),
        error: (e, _) => CustomScrollView(
          slivers: [
            const SliverAppBar(),
            SliverFillRemaining(child: Center(child: Text('Error: $e'))),
          ],
        ),
      ),
    );
  }
}
