import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/database/database.dart';
import '../../../../core/utils/app_toasts.dart';
import '../../../library/repositories/library_repository.dart';
import '../../providers/show_details_provider.dart';

class ShowDetailsAppBar extends ConsumerWidget {
  final TvShow show;
  final int showId;
  final String? posterUrl;

  const ShowDetailsAppBar({
    super.key,
    required this.show,
    required this.showId,
    this.posterUrl,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progressAsync = ref.watch(showProgressProvider(showId));

    return SliverAppBar(
      expandedHeight: 320,
      pinned: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      surfaceTintColor: Colors.transparent,
      scrolledUnderElevation: 0,
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh, color: Colors.white),
          onPressed: () async {
            AppToasts.showInfo(context, 'Refreshing show data...');
            try {
              await ref.read(libraryRepositoryProvider).addTvShow(showId);
              if (context.mounted) {
                AppToasts.showSuccess(context, 'Show data updated successfully!');
              }
            } catch (e) {
              if (context.mounted) {
                if (e.toString().contains('401')) {
                  AppToasts.showError(context, 'Invalid TMDB API Token in code.');
                } else {
                  AppToasts.showError(context, 'Failed to update show data.');
                }
              }
            }
          },
        ),
        if (show.status != 'dropped')
          IconButton(
            icon: const Icon(Icons.archive_outlined, color: Colors.orangeAccent),
            tooltip: 'Drop Show',
            onPressed: () async {
              await ref.read(libraryRepositoryProvider).updateTvShowStatus(showId, 'dropped');
              if (context.mounted) {
                AppToasts.showInfo(context, 'Show moved to Dropped.');
              }
            },
          )
        else
          IconButton(
            icon: const Icon(Icons.unarchive_outlined, color: Colors.greenAccent),
            tooltip: 'Move to Planning',
            onPressed: () async {
              await ref.read(libraryRepositoryProvider).updateTvShowStatus(showId, 'planning');
              if (context.mounted) {
                AppToasts.showInfo(context, 'Show moved to Planning.');
              }
            },
          ),
        IconButton(
          icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
          onPressed: () async {
            // Show confirmation dialog
            final confirm = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                backgroundColor: Theme.of(context).cardColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                title: const Text('Remove Show?'),
                content: const Text(
                  'This will delete the show and all your watching progress.',
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
              await ref.read(libraryRepositoryProvider).removeTvShow(showId);
              if (context.mounted) {
                Navigator.pop(context); // Go back to Library
                AppToasts.showInfo(context, 'Show removed from library.');
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
                      tag: 'show_poster_$showId',
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
                                    child: const Icon(Icons.tv, size: 50),
                                  ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    // Title and Progress
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            show.title,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 8),
                          if (show.genres != null && show.genres!.isNotEmpty) ...[
                            Text(
                              show.genres!,
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 12),
                          ],
                          progressAsync.maybeWhen(
                            data: (progress) {
                              final percentage = progress.total > 0
                                  ? progress.watched / progress.total
                                  : 0.0;
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '${progress.watched} / ${progress.total} eps',
                                        style: const TextStyle(
                                          color: Colors.white70,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        '${(percentage * 100).toInt()}%',
                                        style: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
                                    child: LinearProgressIndicator(
                                      value: percentage,
                                      minHeight: 6,
                                      backgroundColor: Colors.white.withValues(alpha: 0.2),
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                ],
                              );
                            },
                            orElse: () => const SizedBox.shrink(),
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
