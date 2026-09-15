import 'dart:convert';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/database/database.dart';
import '../providers/show_details_provider.dart';
import '../../library/repositories/library_repository.dart';
import '../../../core/utils/app_toasts.dart';
class ShowDetailsScreen extends ConsumerWidget {
  final int showId;

  const ShowDetailsScreen({super.key, required this.showId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showAsync = ref.watch(showMetadataProvider(showId));
    final seasonsAsync = ref.watch(showSeasonsProvider(showId));
    final progressAsync = ref.watch(showProgressProvider(showId));

    return Scaffold(
      body: showAsync.when(
        data: (show) {
          if (show == null) {
            return const CustomScrollView(
              slivers: [
                SliverAppBar(),
                SliverFillRemaining(child: Center(child: Text('Show not found'))),
              ],
            );
          }

          final posterUrl = show.posterPath != null
              ? 'https://image.tmdb.org/t/p/w500${show.posterPath}'
              : null;

          List<dynamic> castList = [];
          if (show.castList != null && show.castList!.isNotEmpty) {
            try {
              castList = jsonDecode(show.castList!);
            } catch (e) {
              // ignore decoding errors
            }
          }

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 320,
                pinned: true,
                actions: [
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
                                tag: 'show_poster_$showId',
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
                                                backgroundColor: Colors.white.withOpacity(0.2),
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
              ),

              // Overview and Cast
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ],
                  ),
                ),
              ),

              // Seasons Title
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                  child: Text(
                    'Seasons',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              // Seasons & Episodes list
              seasonsAsync.when(
                data: (seasons) {
                  final regularSeasons = seasons.where((s) => s.seasonNumber > 0).toList();

                  return SliverPadding(
                    padding: const EdgeInsets.only(bottom: 30),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final season = regularSeasons[index];
                        return _SeasonAccordion(season: season);
                      }, childCount: regularSeasons.length),
                    ),
                  );
                },
                loading: () => const SliverToBoxAdapter(
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (e, _) => SliverToBoxAdapter(
                  child: Center(child: Text('Error: $e')),
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

class _SeasonAccordion extends ConsumerWidget {
  final Season season;

  const _SeasonAccordion({required this.season});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final episodesAsync = ref.watch(seasonEpisodesProvider(season.id));

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      elevation: 0,
      color: Colors.grey.withOpacity(0.08),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.white.withOpacity(0.05)),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent, // Remove line on expansion
        ),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          title: Row(
            children: [
              Text(
                season.name,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(width: 12),
              episodesAsync.maybeWhen(
                data: (episodes) {
                  if (episodes.isEmpty) return const SizedBox.shrink();
                  final watchedCount = episodes.where((e) => e.isWatched).length;
                  final totalCount = episodes.length;
                  final isComplete = totalCount > 0 && watchedCount == totalCount;

                  if (isComplete) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.green.withOpacity(0.4)),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.check_circle, size: 12, color: Colors.greenAccent),
                          SizedBox(width: 4),
                          Text(
                            'COMPLETED',
                            style: TextStyle(
                              fontSize: 9,
                              color: Colors.greenAccent,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    );
                  } else if (watchedCount > 0) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Theme.of(context).primaryColor.withOpacity(0.4)),
                      ),
                      child: Text(
                        '$watchedCount / $totalCount watched',
                        style: TextStyle(
                          fontSize: 10,
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  } else {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '$totalCount eps',
                        style: const TextStyle(fontSize: 10, color: Colors.white54),
                      ),
                    );
                  }
                },
                orElse: () => const SizedBox.shrink(),
              ),
            ],
          ),
          children: [
            episodesAsync.when(
              data: (episodes) {
                if (episodes.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text('No episodes found.', style: TextStyle(color: Colors.white54)),
                  );
                }

                final allWatched = episodes.every((ep) => ep.isWatched);

                return Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.2),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
                  ),
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () {
                          ref
                              .read(episodeControllerProvider)
                              .markSeasonWatched(season.id, !allWatched);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 12.0,
                            horizontal: 16.0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Icon(
                                allWatched ? Icons.remove_done : Icons.checklist,
                                size: 18,
                                color: Theme.of(context).primaryColor,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                allWatched ? 'Mark Season Unwatched' : 'Mark Season Watched',
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Divider(height: 1, color: Colors.white12),
                      ...episodes.map((ep) {
                        return ListTile(
                          dense: true,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                          title: Text(
                            'E${ep.episodeNumber}: ${ep.title}',
                            style: TextStyle(
                              color: ep.isWatched ? Colors.white54 : Colors.white,
                            ),
                          ),
                          subtitle: ep.airDate != null
                              ? Text(
                                  'Aired: ${ep.airDate!.toLocal().toString().split(' ')[0]}',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Colors.white38,
                                  ),
                                )
                              : null,
                          trailing: IconButton(
                            icon: Icon(
                              ep.isWatched ? Icons.check_circle : Icons.circle_outlined,
                              color: ep.isWatched ? Theme.of(context).primaryColor : Colors.white38,
                            ),
                            onPressed: () {
                              ref
                                  .read(episodeControllerProvider)
                                  .toggleWatched(ep.id, ep.isWatched);
                            },
                          ),
                        );
                      }),
                      const SizedBox(height: 8),
                    ],
                  ),
                );
              },
              loading: () => const Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (e, _) => Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('Error: $e'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
