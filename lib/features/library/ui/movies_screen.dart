import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/library_providers.dart';
import '../../movie_details/ui/movie_details_screen.dart';
import '../../../core/database/database.dart';
import '../models/sort_option.dart';
import '../providers/library_view_provider.dart';

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
    final viewMode = ref.watch(libraryViewProvider);

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
              _buildHeader(context, viewMode),
              Expanded(
                child: _buildMoviesList(
                  planningMovies,
                  'No movies in planning.',
                  viewMode,
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

  Widget _buildHeader(BuildContext context, LibraryViewMode viewMode) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        children: [
          Row(
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
                child: IconButton(
                  icon: Icon(
                    viewMode == LibraryViewMode.grid
                        ? Icons.list
                        : Icons.grid_view,
                  ),
                  onPressed: () =>
                      ref.read(libraryViewProvider.notifier).toggle(),
                  tooltip: 'Toggle View',
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
                  itemBuilder: (BuildContext context) => SortOption.values.map((
                    option,
                  ) {
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
        ],
      ),
    );
  }

  Widget _buildMoviesList(
    List<Movie> movies,
    String emptyMessage,
    LibraryViewMode viewMode,
  ) {
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

    if (viewMode == LibraryViewMode.grid) {
      return GridView.builder(
        padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 100.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 2 / 3,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: movies.length,
        itemBuilder: (context, index) {
          final movie = movies[index];
          final isUpcoming =
              movie.releaseDate != null &&
              movie.releaseDate!.isAfter(DateTime.now());

          return InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MovieDetailsScreen(movieId: movie.id),
                ),
              );
            },
            child: Stack(
              children: [
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: movie.posterPath != null
                        ? CachedNetworkImage(
                            imageUrl:
                                'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                            fit: BoxFit.cover,
                            placeholder: (context, url) =>
                                Container(color: Colors.grey[800]),
                            errorWidget: (context, url, error) => Container(
                              color: Colors.grey[800],
                              child: const Icon(
                                Icons.movie,
                                color: Colors.white54,
                              ),
                            ),
                          )
                        : Container(
                            color: Colors.grey[800],
                            child: const Icon(
                              Icons.movie,
                              color: Colors.white54,
                            ),
                          ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(8),
                        bottomRight: Radius.circular(8),
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.9),
                          Colors.transparent,
                        ],
                      ),
                    ),
                    child: Text(
                      movie.title,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                if (isUpcoming)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(8),
                          topRight: Radius.circular(8),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.5),
                            blurRadius: 4,
                            offset: const Offset(-1, 1),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.calendar_month_rounded,
                        color: Colors.white,
                        size: 12,
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 100.0),
      itemCount: movies.length,
      separatorBuilder: (context, index) =>
          Divider(color: Colors.white.withValues(alpha: 0.05), height: 1),
      itemBuilder: (context, index) {
        final movie = movies[index];

        // Check if the movie is upcoming
        final isUpcoming =
            movie.releaseDate != null &&
            movie.releaseDate!.isAfter(DateTime.now());

        return Material(
          color: Colors.transparent,
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
              padding: const EdgeInsets.symmetric(
                vertical: 10.0,
                horizontal: 8.0,
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 55,
                    height: 85,
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: movie.posterPath != null
                                ? CachedNetworkImage(
                                    imageUrl:
                                        'https://image.tmdb.org/t/p/w200${movie.posterPath}',
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) =>
                                        Container(color: Colors.grey[800]),
                                    errorWidget: (context, url, error) =>
                                        Container(
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
                        if (isUpcoming)
                          Positioned(
                            top: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(8),
                                  topRight: Radius.circular(8),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.5),
                                    blurRadius: 4,
                                    offset: const Offset(-1, 1),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.calendar_month_rounded,
                                color: Colors.white,
                                size: 12,
                              ),
                            ),
                          ),
                      ],
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
                            fontWeight: FontWeight.w600,
                            letterSpacing: -0.2,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
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
                                style: const TextStyle(
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
