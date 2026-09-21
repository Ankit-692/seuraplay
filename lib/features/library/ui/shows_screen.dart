import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/library_providers.dart';
import '../../../core/database/database.dart';
import '../models/sort_option.dart';
import '../providers/library_view_provider.dart';
import 'widgets/library_header.dart';
import 'widgets/shows_grid.dart';

class ShowsScreen extends ConsumerStatefulWidget {
  const ShowsScreen({super.key});

  @override
  ConsumerState<ShowsScreen> createState() => _ShowsScreenState();
}

class _ShowsScreenState extends ConsumerState<ShowsScreen> {
  String _searchQuery = '';
  SortOption _currentSort = SortOption.recentlyAdded;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<TvShow> _filterAndSortShows(List<TvShow> allShows, String status) {
    // 1. Filter by status
    var filtered = allShows.where((s) => s.status == status).toList();

    // 2. Filter by search query
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      filtered = filtered
          .where((s) => s.title.toLowerCase().contains(query))
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
    final showsAsyncValue = ref.watch(savedShowsProvider);
    final viewMode = ref.watch(libraryViewProvider);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: showsAsyncValue.when(
          data: (shows) {
            if (shows.isEmpty && _searchQuery.isEmpty) {
              return const Center(
                child: Text(
                  'No shows added yet.\nTap Search to find your favorites.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
              );
            }

            final watchingShows = _filterAndSortShows(shows, 'watching');
            final planningShows = _filterAndSortShows(shows, 'planning');

            return Column(
              children: [
                LibraryHeader(
                  searchController: _searchController,
                  searchQuery: _searchQuery,
                  currentSort: _currentSort,
                  viewMode: viewMode,
                  hintText: 'Search your shows...',
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
                Container(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: Column(
                    children: [
                      const SizedBox(height: 16),
                      TabBar(
                        indicatorColor: Theme.of(context).primaryColor,
                        labelColor: Theme.of(context).primaryColor,
                        unselectedLabelColor: Colors.grey,
                        dividerColor: Colors.transparent,
                        indicatorSize: TabBarIndicatorSize.label,
                        labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                        tabs: const [
                          Tab(text: 'Watching'),
                          Tab(text: 'Planning'),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      ShowsGrid(
                        shows: watchingShows,
                        emptyMessage: 'No shows currently watching.',
                        searchQuery: _searchQuery,
                        viewMode: viewMode,
                      ),
                      ShowsGrid(
                        shows: planningShows,
                        emptyMessage: 'No shows in planning.',
                        searchQuery: _searchQuery,
                        viewMode: viewMode,
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) =>
              Center(child: Text('Error loading shows: $err')),
        ),
      ),
    );
  }
}
