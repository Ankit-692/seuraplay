import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/utils/app_toasts.dart';
import '../../../library/repositories/library_repository.dart';
import '../../providers/search_provider.dart';
import '../../../home/main_screen.dart';
import '../search_details_screen.dart'; // To access searchDetailsProvider

class SearchDetailsContent extends ConsumerStatefulWidget {
  final dynamic item;
  final bool isMovie;
  final bool isAdded;
  final String? title;

  const SearchDetailsContent({
    super.key,
    required this.item,
    required this.isMovie,
    required this.isAdded,
    required this.title,
  });

  @override
  ConsumerState<SearchDetailsContent> createState() => _SearchDetailsContentState();
}

class _SearchDetailsContentState extends ConsumerState<SearchDetailsContent> {
  late bool _isAdded;
  bool _isAdding = false;

  @override
  void initState() {
    super.initState();
    _isAdded = widget.isAdded;
  }

  @override
  Widget build(BuildContext context) {
    final overview = widget.item['overview'] as String? ?? '';

    return Padding(
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
                                ? Theme.of(context).primaryColor.withValues(alpha: 0.15)
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
                                    ? Theme.of(context).primaryColor.withValues(alpha: 0.5)
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
    );
  }
}
