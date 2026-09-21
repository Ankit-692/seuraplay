import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seuraplay/features/library/repositories/library_repository.dart';
import '../../../core/utils/app_toasts.dart';
import '../../../core/network/tmdb_repository.dart';
import '../../home/main_screen.dart';
import '../providers/search_provider.dart';

import 'dart:async';
import 'package:url_launcher/url_launcher.dart';

final searchDetailsProvider = FutureProvider.family.autoDispose<Map<String, dynamic>?, ({int id, bool isMovie})>((ref, args) async {
  // Keep the result cached for 5 minutes after leaving the screen
  final link = ref.keepAlive();
  final timer = Timer(const Duration(minutes: 5), () {
    link.close();
  });
  ref.onDispose(() => timer.cancel());

  final tmdb = ref.read(tmdbRepositoryProvider);
  try {
    if (args.isMovie) {
      return await tmdb.getMovieDetails(args.id);
    } else {
      return await tmdb.getShowDetails(args.id);
    }
  } catch (_) {
    return null;
  }
});

class SearchDetailsScreen extends ConsumerStatefulWidget {
  final dynamic item;
  final bool isMovie;
  final bool isAdded;
  final String? title;
  final dynamic year;
  final String? imageUrl;

  const SearchDetailsScreen({
    super.key,
    required this.item,
    required this.isMovie,
    required this.isAdded,
    required this.title,
    required this.year,
    required this.imageUrl,
  });

  @override
  ConsumerState<SearchDetailsScreen> createState() => _SearchDetailsScreenState();
}

class _SearchDetailsScreenState extends ConsumerState<SearchDetailsScreen> {
  late bool _isAdded;
  bool _isAdding = false;

  @override
  void initState() {
    super.initState();
    _isAdded = widget.isAdded;
  }

  @override
  Widget build(BuildContext context) {
    final posterUrl = widget.imageUrl;
    final overview = widget.item['overview'] as String? ?? '';

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 320,
            pinned: true,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            surfaceTintColor: Colors.transparent,
            scrolledUnderElevation: 0,
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
                            tag: 'search_poster_${widget.item['id']}',
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
                                          child: Icon(
                                            widget.isMovie ? Icons.movie : Icons.tv,
                                            size: 50,
                                          ),
                                        ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                          // Title and Year
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.title ?? 'Unknown Title',
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    height: 1.2,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '${widget.isMovie ? "Movie" : "Show"} • ${widget.year != null && widget.year.toString().length >= 4 ? widget.year.toString().substring(0, 4) : "N/A"}',
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
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
                  Consumer(
                    builder: (context, ref, child) {
                      final detailsAsync = ref.watch(searchDetailsProvider((id: widget.item['id'], isMovie: widget.isMovie)));
                      
                      String? trailerKey;
                      int? numberOfSeasons;
                      detailsAsync.whenData((details) {
                        final videos = details?['videos']?['results'] as List<dynamic>? ?? [];
                        final trailer = videos.firstWhere(
                          (v) => (v['type'] == 'Trailer' || v['type'] == 'Teaser') && v['site'] == 'YouTube',
                          orElse: () => null,
                        );
                        trailerKey = trailer?['key'];
                        numberOfSeasons = details?['number_of_seasons'];
                      });

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _isAdded
                                    ? Theme.of(context).primaryColor.withOpacity(0.15)
                                    : Colors.white12,
                                foregroundColor: _isAdded
                                    ? Theme.of(context).primaryColor
                                    : Colors.white,
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  side: BorderSide(
                                    color: _isAdded
                                        ? Theme.of(context).primaryColor.withOpacity(0.5)
                                        : Colors.transparent,
                                  ),
                                ),
                              ),
                              icon: _isAdding 
                                ? const SizedBox(
                                    width: 18, 
                                    height: 18, 
                                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white70)
                                  ) 
                                : Icon(
                                    _isAdded ? Icons.check_circle : Icons.add_circle_outline,
                                    size: 18,
                                  ),
                              label: Text(
                                _isAdded ? 'Added to Library' : 'Add to Library',
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              onPressed: _isAdded || _isAdding
                                  ? null
                                  : () async {
                                      setState(() {
                                        _isAdding = true;
                                      });

                                      final libraryRepo = ref.read(libraryRepositoryProvider);

                                      try {
                                        Map<String, dynamic>? details;
                                        try {
                                          details = await ref.read(searchDetailsProvider((id: widget.item['id'], isMovie: widget.isMovie)).future);
                                        } catch (_) {}

                                        if (widget.isMovie) {
                                          await libraryRepo.addMovie(widget.item['id'], preFetchedDetails: details);
                                        } else {
                                          await libraryRepo.addTvShow(widget.item['id'], preFetchedDetails: details);
                                        }

                                        if (context.mounted) {
                                          AppToasts.showSuccess(
                                            context,
                                            '${widget.title} added!',
                                          );
                                        }
                                        if (mounted) {
                                          setState(() {
                                            _isAdded = true;
                                          });
                                        }
                                      } catch (e) {
                                        if (context.mounted) {
                                          AppToasts.showError(context, 'Error: $e');
                                        }
                                      } finally {
                                        if (mounted) {
                                          setState(() {
                                            _isAdding = false;
                                          });
                                        }
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
                      ),
                      if (!widget.isMovie && numberOfSeasons != null && numberOfSeasons! > 0) ...[
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            const Icon(Icons.style, size: 16, color: Colors.white54),
                            const SizedBox(width: 6),
                            Text(
                              '$numberOfSeasons Season${numberOfSeasons! > 1 ? "s" : ""}',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  );
                },
              ),
                  const SizedBox(height: 24),
                  if (overview.isNotEmpty) ...[
                    const Text(
                      'Synopsis',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      overview,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                  
                  // --- CAST LIST ---
                  Consumer(
                    builder: (context, ref, child) {
                      final detailsAsync = ref.watch(searchDetailsProvider((id: widget.item['id'], isMovie: widget.isMovie)));
                      
                      return detailsAsync.when(
                        data: (details) {
                          final castList = details?['credits']?['cast'] as List<dynamic>? ?? [];
                          if (castList.isEmpty) return const SizedBox.shrink();
                          
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
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
                          );
                        },
                        loading: () => const Center(
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: CircularProgressIndicator(),
                          )
                        ),
                        error: (err, stack) => const SizedBox.shrink(),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
