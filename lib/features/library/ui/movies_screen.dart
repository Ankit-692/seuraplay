import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/library_providers.dart';
import '../../../core/database/database.dart';
import '../models/sort_option.dart';
import '../providers/library_view_provider.dart';
import 'widgets/library_header.dart';
import 'widgets/movies_grid.dart';

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
              LibraryHeader(
                searchController: _searchController,
                searchQuery: _searchQuery,
                currentSort: _currentSort,
                viewMode: viewMode,
                hintText: 'Search your movies...',
                onSearchChanged: (val) {
                  setState(() {
                    _searchQuery = val;
                  });
                },
                onClearSearch: () {
                  _searchController.clear();
                  setState(() {
                    _searchQuery = '';
                  });
                },
                onSortChanged: (SortOption result) {
                  setState(() {
                    _currentSort = result;
                  });
                },
              ),
              Expanded(
                child: MoviesGrid(
                  movies: planningMovies,
                  emptyMessage: 'No movies in planning.',
                  searchQuery: _searchQuery,
                  viewMode: viewMode,
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
}
