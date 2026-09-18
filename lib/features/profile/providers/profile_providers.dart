import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../library/providers/library_providers.dart';
import '../../../core/database/database_provider.dart';

class ProfileStats {
  final int moviesAdded;
  final int showsAdded;
  final int moviesWatched;
  final int showsWatched;
  final int episodesWatched;
  final int uniqueGenresCount;
  final Map<String, int> watchedGenreCounts;

  ProfileStats({
    required this.moviesAdded,
    required this.showsAdded,
    required this.moviesWatched,
    required this.showsWatched,
    required this.episodesWatched,
    required this.uniqueGenresCount,
    required this.watchedGenreCounts,
  });
}

final watchedEpisodesCountProvider = StreamProvider<int>((ref) {
  final db = ref.watch(databaseProvider);
  final query = db.select(db.episodes)..where((t) => t.isWatched.equals(true));
  return query.watch().map((episodes) => episodes.length);
});

final profileStatsProvider = Provider<AsyncValue<ProfileStats>>((ref) {
  final moviesAsyncValue = ref.watch(savedMoviesProvider);
  final showsAsyncValue = ref.watch(savedShowsProvider);
  final episodesWatchedAsyncValue = ref.watch(watchedEpisodesCountProvider);

  if (moviesAsyncValue.isLoading || showsAsyncValue.isLoading || episodesWatchedAsyncValue.isLoading) {
    return const AsyncValue.loading();
  }

  if (moviesAsyncValue.hasError) {
    return AsyncValue.error(moviesAsyncValue.error!, moviesAsyncValue.stackTrace!);
  }
  
  if (showsAsyncValue.hasError) {
    return AsyncValue.error(showsAsyncValue.error!, showsAsyncValue.stackTrace!);
  }

  if (episodesWatchedAsyncValue.hasError) {
    return AsyncValue.error(episodesWatchedAsyncValue.error!, episodesWatchedAsyncValue.stackTrace!);
  }

  final movies = moviesAsyncValue.value ?? [];
  final shows = showsAsyncValue.value ?? [];
  final episodesWatchedCount = episodesWatchedAsyncValue.value ?? 0;

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
    episodesWatched: episodesWatchedCount,
    uniqueGenresCount: genreCounts.length,
    watchedGenreCounts: genreCounts,
  ));
});
