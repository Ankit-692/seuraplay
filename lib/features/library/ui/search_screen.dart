import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/search_provider.dart';
import '../providers/library_providers.dart';
import 'widgets/search_result_tile.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  late final TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<String>(searchQueryProvider, (previous, next) {
      if (next.isNotEmpty && next != _textController.text) {
        _textController.text = next;
        ref.read(searchProvider.notifier).search(next);
      }
    });

    final searchState = ref.watch(searchProvider);
    final searchController = ref.read(searchProvider.notifier);

    final savedShowsAsync = ref.watch(savedShowsProvider);
    final savedMoviesAsync = ref.watch(savedMoviesProvider);
    final savedShowIds = savedShowsAsync.value?.map((s) => s.id).toSet() ?? {};
    final savedMovieIds =
        savedMoviesAsync.value?.map((m) => m.id).toSet() ?? {};

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // --- SEARCH BAR ---
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 12.0,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.03),
                  borderRadius: BorderRadius.circular(16.0),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.05),
                  ),
                ),
                child: TextField(
                  controller: _textController,
                  style: const TextStyle(color: Colors.white, fontSize: 15),
                  decoration: InputDecoration(
                    hintText: 'Search for shows or movies...',
                    hintStyle: const TextStyle(
                      color: Colors.white30,
                      fontSize: 15,
                    ),
                    prefixIcon: const Icon(
                      Icons.search_rounded,
                      color: Colors.white30,
                      size: 20,
                    ),
                    suffixIcon: ValueListenableBuilder<TextEditingValue>(
                      valueListenable: _textController,
                      builder: (context, value, child) {
                        if (value.text.isEmpty) {
                          return const SizedBox.shrink();
                        }
                        return IconButton(
                          icon: const Icon(
                            Icons.clear_rounded,
                            color: Colors.white54,
                            size: 20,
                          ),
                          onPressed: () {
                            _textController.clear();
                            searchController.search('');
                          },
                        );
                      },
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 16,
                    ),
                  ),
                  onSubmitted: (query) => searchController.search(query),
                ),
              ),
            ),

            // --- SEARCH RESULTS ---
            Expanded(
              child: searchState.isLoading
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
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Type a name and hit enter to search.',
                            style: TextStyle(color: Colors.white30),
                          ),
                          const SizedBox(height: 32),
                          const Text(
                            'Powered by',
                            style: TextStyle(
                              color: Colors.white38,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              fontStyle: FontStyle.italic,
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Image.asset('assets/TMDB.png', height: 28),
                        ],
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.only(bottom: 100.0, top: 8.0),
                      itemCount: searchState.results.length,
                      separatorBuilder: (context, index) => Divider(
                        color: Colors.white.withValues(alpha: 0.02),
                        height: 1,
                        indent: 84, // Align with text
                      ),
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

                        final posterPath = item['poster_path'];
                        final imageUrl = posterPath != null
                            ? 'https://image.tmdb.org/t/p/w200$posterPath'
                            : null;

                        return SearchResultTile(
                          item: item,
                          isMovie: isMovie,
                          isAdded: isAdded,
                          title: title,
                          year: year,
                          imageUrl: imageUrl,
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
