import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/library_providers.dart';
import '../../movie_details/ui/movie_details_screen.dart';
import '../../../core/database/database.dart';
import '../models/sort_option.dart';

class MoviesScreen extends ConsumerStatefulWidget {
  const MoviesScreen({super.key});

  @override
  ConsumerState<MoviesScreen> createState() => _MoviesScreenState();
}

class _MoviesScreenState extends ConsumerState<MoviesScreen> {
  String _searchQuery = '';
  SortOption _currentSort = SortOption.recentlyAdded;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Movie> _filterAndSortMovies(List<Movie> allMovies, String status) {
    // 1. Filter by status
    var filtered = allMovies.where((m) => m.status == status).toList();

    // 2. Filter by search query
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      filtered = filtered
          .where((m) => m.title.toLowerCase().contains(query))
          .toList();
    }

    // 3. Sort
    filtered.sort((a, b) {
      if (_currentSort == SortOption.alphabetical) {
        return a.title.compareTo(b.title);
      } else {
        // recentlyAdded
        return b.addedAt.compareTo(a.addedAt);
      }
    });

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final moviesAsyncValue = ref.watch(savedMoviesProvider);

    return Scaffold(
      body: moviesAsyncValue.when(
        data: (movies) {
          if (movies.isEmpty && _searchQuery.isEmpty) {
            return const Center(
              child: Text(
                'No movies added yet.\nTap Search to find your favorites.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            );
          }

          final planningMovies = _filterAndSortMovies(movies, 'planning');

          return Column(
            children: [
              _buildHeader(context),
              Expanded(
                child: _buildMoviesList(
                  planningMovies,
                  'No movies in planning.',
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) =>
            Center(child: Text('Error loading movies: $err')),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              onChanged: (val) {
                setState(() {
                  _searchQuery = val;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search your movies...',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.grey),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _searchQuery = '';
                          });
                        },
                      )
                    : null,
                filled: true,
                fillColor: Colors.white.withOpacity(0.05),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 0,
                  horizontal: 16,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
            ),
            child: PopupMenuButton<SortOption>(
              icon: const Icon(Icons.sort),
              tooltip: 'Sort Options',
              onSelected: (SortOption result) {
                setState(() {
                  _currentSort = result;
                });
              },
              itemBuilder: (BuildContext context) =>
                  SortOption.values.map((option) {
                    return PopupMenuItem<SortOption>(
                      value: option,
                      child: Row(
                        children: [
                          Icon(
                            _currentSort == option ? Icons.check : Icons.circle,
                            color: _currentSort == option
                                ? Theme.of(context).primaryColor
                                : Colors.transparent,
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Text(option.label),
                        ],
                      ),
                    );
                  }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMoviesList(List<Movie> movies, String emptyMessage) {
    if (movies.isEmpty) {
      return Center(
        child: Text(
          _searchQuery.isNotEmpty
              ? 'No movies match your search.'
              : emptyMessage,
          style: const TextStyle(color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 100.0),
      itemCount: movies.length,
      itemBuilder: (context, index) {
        final movie = movies[index];
        return Card(
          elevation: 0,
          color: Colors.grey.withValues(alpha: .08),
          margin: const EdgeInsets.only(bottom: 12.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.white.withValues(alpha: 0.05)),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MovieDetailsScreen(movieId: movie.id),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: SizedBox(
                      width: 50,
                      height: 75,
                      child: movie.posterPath != null
                          ? CachedNetworkImage(
                              imageUrl:
                                  'https://image.tmdb.org/t/p/w200${movie.posterPath}',
                              fit: BoxFit.cover,
                              placeholder: (context, url) =>
                                  Container(color: Colors.grey[800]),
                              errorWidget: (context, url, error) => Container(
                                color: Colors.grey[800],
                                child: const Icon(
                                  Icons.movie,
                                  color: Colors.white54,
                                  size: 20,
                                ),
                              ),
                            )
                          : Container(
                              color: Colors.grey[800],
                              child: const Icon(
                                Icons.movie,
                                color: Colors.white54,
                                size: 20,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          movie.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.2,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            if (movie.releaseDate != null) ...[
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  movie.releaseDate!.year.toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                            ],
                            Expanded(
                              child: Text(
                                (movie.genres != null &&
                                        movie.genres!.isNotEmpty)
                                    ? movie.genres!
                                    : 'Movie',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
