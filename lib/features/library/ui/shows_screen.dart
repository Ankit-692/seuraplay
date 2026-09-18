import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/library_providers.dart';
import '../../show_details/ui/show_details_screen.dart';
import '../../../core/database/database.dart';
import '../models/sort_option.dart';
import '../providers/library_view_provider.dart';

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
                _buildHeader(context, viewMode),
                Expanded(
                  child: TabBarView(
                    children: [
                      _buildShowsList(
                        watchingShows,
                        'No shows currently watching.',
                        viewMode,
                      ),
                      _buildShowsList(
                        planningShows,
                        'No shows in planning.',
                        viewMode,
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
                    hintText: 'Search your shows...',
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
    );
  }

  Widget _buildShowsList(
    List<TvShow> shows,
    String emptyMessage,
    LibraryViewMode viewMode,
  ) {
    if (shows.isEmpty) {
      return Center(
        child: Text(
          _searchQuery.isNotEmpty
              ? 'No shows match your search.'
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
        itemCount: shows.length,
        itemBuilder: (context, index) {
          final show = shows[index];
          final isUpcoming =
              show.nextEpisodeAirDate != null &&
              show.nextEpisodeAirDate!.isAfter(DateTime.now());

          return InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ShowDetailsScreen(showId: show.id),
                ),
              );
            },
            child: Stack(
              children: [
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: show.posterPath != null
                        ? CachedNetworkImage(
                            imageUrl:
                                'https://image.tmdb.org/t/p/w500${show.posterPath}',
                            fit: BoxFit.cover,
                            placeholder: (context, url) =>
                                Container(color: Colors.grey[800]),
                            errorWidget: (context, url, error) => Container(
                              color: Colors.grey[800],
                              child: const Icon(
                                Icons.tv,
                                color: Colors.white54,
                              ),
                            ),
                          )
                        : Container(
                            color: Colors.grey[800],
                            child: const Icon(Icons.tv, color: Colors.white54),
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
                      show.title,
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
                Positioned(
                  top: 0,
                  left: 0,
                  child: Consumer(
                    builder: (context, ref, child) {
                      final summaryAsync = ref.watch(
                        showProgressSummaryProvider(show.id),
                      );
                      return summaryAsync.when(
                        data: (summary) {
                          if (summary.isEmpty) return const SizedBox.shrink();
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.75),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(8),
                                bottomRight: Radius.circular(8),
                              ),
                            ),
                            child: Text(
                              summary,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        },
                        loading: () => const SizedBox.shrink(),
                        error: (_, __) => const SizedBox.shrink(),
                      );
                    },
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
      itemCount: shows.length,
      separatorBuilder: (context, index) =>
          Divider(color: Colors.white.withValues(alpha: 0.05), height: 1),
      itemBuilder: (context, index) {
        final show = shows[index];

        // Check if the show has an upcoming episode
        final isUpcoming =
            show.nextEpisodeAirDate != null &&
            show.nextEpisodeAirDate!.isAfter(DateTime.now());

        return Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ShowDetailsScreen(showId: show.id),
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
                            child: show.posterPath != null
                                ? CachedNetworkImage(
                                    imageUrl:
                                        'https://image.tmdb.org/t/p/w200${show.posterPath}',
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) =>
                                        Container(color: Colors.grey[800]),
                                    errorWidget: (context, url, error) =>
                                        Container(
                                          color: Colors.grey[800],
                                          child: const Icon(
                                            Icons.tv,
                                            color: Colors.white54,
                                            size: 20,
                                          ),
                                        ),
                                  )
                                : Container(
                                    color: Colors.grey[800],
                                    child: const Icon(
                                      Icons.tv,
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
                          show.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            letterSpacing: -0.2,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        // Replace genres with the Next Episode indicator
                        Consumer(
                          builder: (context, ref, child) {
                            final summaryAsync = ref.watch(
                              showProgressSummaryProvider(show.id),
                            );
                            return summaryAsync.when(
                              data: (summary) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Theme.of(
                                      context,
                                    ).primaryColor.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(
                                      color: Theme.of(
                                        context,
                                      ).primaryColor.withOpacity(0.3),
                                    ),
                                  ),
                                  child: Text(
                                    summary,
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                );
                              },
                              loading: () => const SizedBox(
                                height: 16,
                                width: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                              error: (_, __) => const SizedBox.shrink(),
                            );
                          },
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
