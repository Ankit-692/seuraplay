import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/database/database.dart';
import '../../../../core/database/database_provider.dart';
import '../models/upcoming_item.dart';

/// Streams TV shows that have an announced upcoming episode, sorted by closest date.
final upcomingShowsProvider = StreamProvider<List<TvShow>>((ref) {
  final db = ref.watch(databaseProvider);

  // Create a DateTime object for "now" (we only care about the date, not the exact time)
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);

  return (db.select(db.tvShows)
        // 1. Must have a next episode date
        ..where((tbl) => tbl.nextEpisodeAirDate.isNotNull())
        // 2. The date must be today or in the future
        ..where((tbl) => tbl.nextEpisodeAirDate.isBiggerOrEqualValue(today))
        // 3. Status should ideally be 'watching' (optional, but good for UX)
        ..where((tbl) => tbl.status.equals('watching'))
        // 4. Sort by the closest date first
        ..orderBy([
          (tbl) => OrderingTerm(
            expression: tbl.nextEpisodeAirDate,
            mode: OrderingMode.asc,
          ),
        ]))
      .watch();
});

/// Streams Movies that have a future release date.
final upcomingMoviesProvider = StreamProvider<List<Movie>>((ref) {
  final db = ref.watch(databaseProvider);

  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);

  return (db.select(db.movies)
        ..where((tbl) => tbl.releaseDate.isNotNull())
        ..where((tbl) => tbl.releaseDate.isBiggerOrEqualValue(today))
        ..where((tbl) => tbl.status.equals('planning'))
        ..orderBy([
          (tbl) => OrderingTerm(
            expression: tbl.releaseDate,
            mode: OrderingMode.asc,
          ),
        ]))
      .watch();
});

/// Combines upcoming shows and movies into a single sorted list.
final upcomingItemsProvider = Provider<AsyncValue<List<UpcomingItem>>>((ref) {
  final showsAsync = ref.watch(upcomingShowsProvider);
  final moviesAsync = ref.watch(upcomingMoviesProvider);

  if (showsAsync is AsyncLoading || moviesAsync is AsyncLoading) {
    return const AsyncValue.loading();
  }

  if (showsAsync is AsyncError) {
    return AsyncValue.error(showsAsync.error!, showsAsync.stackTrace!);
  }
  if (moviesAsync is AsyncError) {
    return AsyncValue.error(moviesAsync.error!, moviesAsync.stackTrace!);
  }

  final shows = showsAsync.value ?? [];
  final movies = moviesAsync.value ?? [];

  final items = <UpcomingItem>[];
  for (final show in shows) {
    items.add(UpcomingItem(
      id: show.id,
      title: show.title,
      posterPath: show.posterPath,
      date: show.nextEpisodeAirDate!,
      isMovie: false,
    ));
  }
  for (final movie in movies) {
    items.add(UpcomingItem(
      id: movie.id,
      title: movie.title,
      posterPath: movie.posterPath,
      date: movie.releaseDate!,
      isMovie: true,
    ));
  }

  items.sort((a, b) => a.date.compareTo(b.date));

  return AsyncValue.data(items);
});
