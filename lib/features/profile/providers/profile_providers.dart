import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../library/providers/library_providers.dart';

class ProfileStats {
  final int moviesAdded;
  final int showsAdded;
  final int moviesWatched;
  final int showsWatched;
  final int uniqueGenresCount;
  final Map<String, int> watchedGenreCounts;

  ProfileStats({
    required this.moviesAdded,
    required this.showsAdded,
    required this.moviesWatched,
    required this.showsWatched,
    required this.uniqueGenresCount,
    required this.watchedGenreCounts,
  });
}

final profileStatsProvider = Provider<AsyncValue<ProfileStats>>((ref) {
  final moviesAsyncValue = ref.watch(savedMoviesProvider);
  final showsAsyncValue = ref.watch(savedShowsProvider);

  if (moviesAsyncValue.isLoading || showsAsyncValue.isLoading) {
    return const AsyncValue.loading();
  }

  if (moviesAsyncValue.hasError) {
    return AsyncValue.error(moviesAsyncValue.error!, moviesAsyncValue.stackTrace!);
  }
  
  if (showsAsyncValue.hasError) {
    return AsyncValue.error(showsAsyncValue.error!, showsAsyncValue.stackTrace!);
  }

  final movies = moviesAsyncValue.value ?? [];
  final shows = showsAsyncValue.value ?? [];

  final watchedMovies = movies.where((m) => m.status == 'watched').toList();
  final watchedShows = shows.where((s) => s.status == 'watched').toList();

  final Map<String, int> genreCounts = {};

  void processGenres(String? genresStr) {
    if (genresStr == null || genresStr.isEmpty) return;
    
    final genresList = genresStr.split(',').map((g) => g.trim()).where((g) => g.isNotEmpty);
    for (final genre in genresList) {
      genreCounts[genre] = (genreCounts[genre] ?? 0) + 1;
    }
  }

  for (final movie in watchedMovies) {
    processGenres(movie.genres);
  }

  for (final show in watchedShows) {
    processGenres(show.genres);
  }

  return AsyncValue.data(ProfileStats(
    moviesAdded: movies.length,
    showsAdded: shows.length,
    moviesWatched: watchedMovies.length,
    showsWatched: watchedShows.length,
    uniqueGenresCount: genreCounts.length,
    watchedGenreCounts: genreCounts,
  ));
});
