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
      
      // 3. Filter out 'person' results (actors/directors)
      final filteredResults = rawResults.where((item) {
        final mediaType = item['media_type'];
        return mediaType == 'tv' || mediaType == 'movie';
      }).toList();

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