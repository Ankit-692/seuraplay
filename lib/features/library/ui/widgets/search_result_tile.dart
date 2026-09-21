import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/utils/app_toasts.dart';
import '../../../movie_details/ui/movie_details_screen.dart';
import '../../../show_details/ui/show_details_screen.dart';
import '../search_details_screen.dart';
import '../../repositories/library_repository.dart';

class SearchResultTile extends ConsumerStatefulWidget {
  final dynamic item;
  final bool isMovie;
  final bool isAdded;
  final String? title;
  final dynamic year;
  final String? imageUrl;

  const SearchResultTile({
    super.key,
    required this.item,
    required this.isMovie,
    required this.isAdded,
    required this.title,
    required this.year,
    required this.imageUrl,
  });

  @override
  ConsumerState<SearchResultTile> createState() => _SearchResultTileState();
}

class _SearchResultTileState extends ConsumerState<SearchResultTile> {
  bool _isAdding = false;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          if (widget.isAdded) {
            // It's already in the library, navigate to the offline details screen
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => widget.isMovie
                    ? MovieDetailsScreen(movieId: widget.item['id'])
                    : ShowDetailsScreen(showId: widget.item['id']),
              ),
            );
          } else {
            // Not in library, navigate to SearchDetailsScreen
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SearchDetailsScreen(
                  item: widget.item,
                  isMovie: widget.isMovie,
                  isAdded: widget.isAdded,
                  title: widget.title,
                  year: widget.year,
                  imageUrl: widget.imageUrl,
                ),
              ),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Sleek small thumbnail
              Hero(
                tag: 'search_poster_${widget.item['id']}',
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Container(
                    width: 55,
                    height: 80,
                    color: Colors.white.withValues(alpha: 0.02),
                    child: widget.imageUrl != null
                        ? CachedNetworkImage(
                            imageUrl: widget.imageUrl!,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => const Center(
                              child: SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) => Icon(
                              widget.isMovie
                                  ? Icons.movie_rounded
                                  : Icons.tv_rounded,
                              color: Colors.white12,
                              size: 24,
                            ),
                          )
                        : Icon(
                            widget.isMovie
                                ? Icons.movie_rounded
                                : Icons.tv_rounded,
                            color: Colors.white12,
                            size: 24,
                          ),
                  ),
                ),
              ),
              const SizedBox(width: 14),

              // Text Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title ?? 'Unknown Title',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        letterSpacing: -0.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${widget.isMovie ? "Movie" : "Show"} • ${widget.year != null && widget.year.toString().length >= 4 ? widget.year.toString().substring(0, 4) : "N/A"}',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.4),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              // Compact Animated Button
              const SizedBox(width: 12),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: widget.isAdded || _isAdding
                      ? null
                      : () async {
                          setState(() {
                            _isAdding = true;
                          });

                          final libraryRepo = ref.read(
                            libraryRepositoryProvider,
                          );

                          try {
                            if (widget.isMovie) {
                              await libraryRepo.addMovie(widget.item['id']);
                            } else {
                              await libraryRepo.addTvShow(widget.item['id']);
                            }

                            if (context.mounted) {
                              AppToasts.showSuccess(
                                context,
                                '${widget.title} added!',
                              );
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
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOutCubic,
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: widget.isAdded
                          ? Colors.green.withValues(alpha: 0.1)
                          : Colors.white.withValues(alpha: 0.05),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: widget.isAdded
                            ? Colors.green.withValues(alpha: 0.3)
                            : Colors.transparent,
                      ),
                    ),
                    child: Center(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        transitionBuilder: (child, animation) {
                          return ScaleTransition(
                            scale: animation,
                            child: FadeTransition(
                              opacity: animation,
                              child: child,
                            ),
                          );
                        },
                        child: _isAdding
                            ? const SizedBox(
                                key: ValueKey<int>(1),
                                width: 14,
                                height: 14,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white70,
                                ),
                              )
                            : Icon(
                                widget.isAdded
                                    ? Icons.check_rounded
                                    : Icons.add_rounded,
                                key: ValueKey<bool>(widget.isAdded),
                                color: widget.isAdded
                                    ? Colors.green
                                    : Colors.white70,
                                size: 18,
                              ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
