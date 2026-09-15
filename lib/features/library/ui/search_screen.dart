import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:seuraplay/features/library/repositories/library_repository.dart';
import '../../settings/providers/settings_provider.dart';
import '../providers/search_provider.dart';
import '../providers/library_providers.dart';
import '../../../core/utils/app_toasts.dart';

class SearchScreen extends ConsumerWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchState = ref.watch(searchProvider);
    final searchController = ref.read(searchProvider.notifier);

    final savedShowsAsync = ref.watch(savedShowsProvider);
    final savedMoviesAsync = ref.watch(savedMoviesProvider);
    final savedShowIds = savedShowsAsync.value?.map((s) => s.id).toSet() ?? {};
    final savedMovieIds =
        savedMoviesAsync.value?.map((m) => m.id).toSet() ?? {};

    final tokenAsync = ref.watch(tmdbTokenProvider);
    final hasToken = tokenAsync.value?.isNotEmpty == true;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // --- SEARCH BAR ---
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Search for shows or movies...',
                  hintStyle: const TextStyle(color: Colors.grey),
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  filled: true,
                  fillColor: Colors.white.withValues(alpha: 0.05),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 0,
                    horizontal: 16,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24.0),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24.0),
                    borderSide: BorderSide(
                      color: Theme.of(context).primaryColor,
                      width: 2,
                    ),
                  ),
                ),
                onSubmitted: (query) => searchController.search(query),
              ),
            ),

            // --- SEARCH RESULTS ---
            Expanded(
              child: tokenAsync.isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        color: Theme.of(context).primaryColor,
                      ),
                    )
                  : !hasToken
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(
                              Icons.warning_amber_rounded,
                              size: 64,
                              color: Colors.orangeAccent,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'API Token Required',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 12),
                            Text(
                              'Please create a completely free TMDB account and paste the API Read Access Token in the Settings page to start searching.',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.grey, height: 1.4),
                            ),
                          ],
                        ),
                      ),
                    )
                  : searchState.isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        color: Theme.of(context).primaryColor,
                      ),
                    )
                  : searchState.error != null
                  ? Center(
                      child: Text(
                        'Error: ${searchState.error}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.redAccent),
                      ),
                    )
                  : searchState.results.isEmpty
                  ? const Center(
                      child: Text(
                        'Type a name and hit enter to search.',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.only(bottom: 100.0),
                      itemCount: searchState.results.length,
                      itemBuilder: (context, index) {
                        final item = searchState.results[index];
                        final isMovie = item['media_type'] == 'movie';
                        final isAdded = isMovie
                            ? savedMovieIds.contains(item['id'])
                            : savedShowIds.contains(item['id']);

                        final title = isMovie ? item['title'] : item['name'];
                        final year = isMovie
                            ? item['release_date']
                            : item['first_air_date'];

                        // --- NEW: Image URL Construction ---
                        final posterPath = item['poster_path'];
                        // 'w200' is a small size perfect for list thumbnails
                        final imageUrl = posterPath != null
                            ? 'https://image.tmdb.org/t/p/w200$posterPath'
                            : null;

                        return Card(
                          elevation: 0,
                          color: Colors.grey.withValues(alpha: 0.08),
                          margin: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 8.0,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            side: BorderSide(
                              color: Colors.white.withValues(alpha: 0.05),
                            ),
                          ),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(12.0),
                                  bottomLeft: Radius.circular(12.0),
                                ),
                                child: Container(
                                  width: 80,
                                  height: 120,
                                  color: Colors.grey[800],
                                  child: imageUrl != null
                                      ? CachedNetworkImage(
                                          imageUrl: imageUrl,
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) =>
                                              const Center(
                                                child: SizedBox(
                                                  width: 20,
                                                  height: 20,
                                                  child:
                                                      CircularProgressIndicator(
                                                        strokeWidth: 2,
                                                      ),
                                                ),
                                              ),
                                          errorWidget: (context, url, error) =>
                                              Icon(
                                                isMovie
                                                    ? Icons.movie
                                                    : Icons.tv,
                                                color: Colors.white54,
                                                size: 32,
                                              ),
                                        )
                                      : Icon(
                                          isMovie ? Icons.movie : Icons.tv,
                                          color: Colors.white54,
                                          size: 32,
                                        ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      title ?? 'Unknown Title',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      '${isMovie ? "Movie" : "Show"} • ${year != null && year.toString().length >= 4 ? year.toString().substring(0, 4) : "N/A"}',
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: IconButton(
                                  icon: Icon(
                                    isAdded
                                        ? Icons.check_circle_rounded
                                        : Icons.add_circle_outline_rounded,
                                    color: isAdded
                                        ? Colors.green
                                        : Theme.of(context).primaryColor,
                                    size: 28,
                                  ),
                                  onPressed: isAdded
                                      ? null
                                      : () async {
                                          final libraryRepo = ref.read(
                                            libraryRepositoryProvider,
                                          );

                                          // Show an immediate feedback snackbar
                                          AppToasts.showInfo(
                                            context,
                                            'Adding $title...',
                                          );

                                          try {
                                            if (isMovie) {
                                              await libraryRepo.addMovie(
                                                item['id'],
                                              );
                                            } else {
                                              await libraryRepo.addTvShow(
                                                item['id'],
                                              );
                                            }

                                            if (context.mounted) {
                                              AppToasts.showSuccess(
                                                context,
                                                '$title added to Library!',
                                              );
                                            }
                                          } catch (e) {
                                            if (context.mounted) {
                                              AppToasts.showError(
                                                context,
                                                'Error adding $title: $e',
                                              );
                                            }
                                          }
                                        },
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
