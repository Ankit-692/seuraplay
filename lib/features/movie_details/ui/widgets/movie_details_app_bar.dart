import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/database/database.dart';
import '../../../../core/utils/app_toasts.dart';
import '../../../library/repositories/library_repository.dart';

class MovieDetailsAppBar extends ConsumerWidget {
  final Movie movie;
  final int movieId;
  final String? posterUrl;
  final bool isUnreleased;
  final bool isWatched;

  const MovieDetailsAppBar({
    super.key,
    required this.movie,
    required this.movieId,
    this.posterUrl,
    required this.isUnreleased,
    required this.isWatched,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SliverAppBar(
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
                imageUrl: posterUrl!,
                fit: BoxFit.cover,
              ),
            ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Container(
                  color: Theme.of(context).scaffoldBackgroundColor.withValues(alpha: 0.5),
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
                    Theme.of(context).scaffoldBackgroundColor.withValues(alpha: 0.8),
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
                              color: Colors.black.withValues(alpha: 0.4),
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
                                    imageUrl: posterUrl!,
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
    );
  }
}
