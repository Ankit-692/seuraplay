import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../../core/network/tmdb_repository.dart';

// Represents the different states of our search screen
class SearchState {
  final bool isLoading;
  final List<dynamic> results;
  final String? error;

  SearchState({this.isLoading = false, this.results = const [], this.error});
}

class SearchController extends StateNotifier<SearchState> {
  // We pass the Ref instead of the repository directly
  final Ref _ref;

  SearchController(this._ref) : super(SearchState());

  Future<void> search(String query) async {
    if (query.trim().isEmpty) {
      state = SearchState(results: []); // Clear results if query is empty
      return;
    }

    state = SearchState(isLoading: true, results: state.results);

    try {
      // 1. Read the Provider to get the fully initialized TmdbRepository
      final repository = _ref.read(tmdbRepositoryProvider);
      
      // 2. Make the API call
      final rawResults = await repository.search(query);
      
      // 3. Filter out 'person' results but include their known movies/shows
      final List<dynamic> filteredResults = [];
      bool fetchedFullCredits = false;
      
      for (var item in rawResults) {
        final mediaType = item['media_type'];
        if (mediaType == 'tv' || mediaType == 'movie') {
          filteredResults.add(item);
        } else if (mediaType == 'person') {
          // Fetch full credits for the top person match to show their entire filmography
          if (!fetchedFullCredits) {
            fetchedFullCredits = true;
            try {
              final credits = await repository.getPersonCredits(item['id']);
              for (var credit in credits) {
                final kType = credit['media_type'];
                if (kType == 'tv' || kType == 'movie') {
                  if (!filteredResults.any((e) => e['id'] == credit['id'])) {
                    filteredResults.add(credit);
                  }
                }
              }
              continue; // Skip the known_for fallback if we successfully got full credits
            } catch (_) {}
          }
          
          // Fallback to known_for for other people to avoid spamming the API
          if (item['known_for'] != null) {
            for (var knownFor in item['known_for']) {
              final kType = knownFor['media_type'];
              if (kType == 'tv' || kType == 'movie') {
                // Ensure we don't add duplicates
                if (!filteredResults.any((e) => e['id'] == knownFor['id'])) {
                  filteredResults.add(knownFor);
                }
              }
            }
          }
        }
      }

      state = SearchState(isLoading: false, results: filteredResults);
    } catch (e) {
      state = SearchState(isLoading: false, error: e.toString());
    }
  }
}

// The provider to expose this controller to the UI
final searchProvider = StateNotifierProvider<SearchController, SearchState>((ref) {
  return SearchController(ref);
});

// A provider to programmatically set the search query from anywhere
final searchQueryProvider = StateProvider<String>((ref) => '');