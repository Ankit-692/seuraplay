import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart';
import '../../../core/database/database_provider.dart';
import '../../../core/database/database.dart'; // Your drift database

/// Streams all TV Shows currently saved in the local database
final savedShowsProvider = StreamProvider<List<TvShow>>((ref) {
  final db = ref.watch(databaseProvider);
  
  // Drift allows us to watch a query as a continuous stream.
  // Whenever the database updates, this automatically pushes new data to the UI.
  return db.select(db.tvShows).watch();
});

/// Streams all Movies currently saved in the local database
final savedMoviesProvider = StreamProvider<List<Movie>>((ref) {
  final db = ref.watch(databaseProvider);
  
  return db.select(db.movies).watch();
});

/// Streams the next unwatched episode summary (e.g. S2 E4) for a show
final showProgressSummaryProvider = StreamProvider.family<String, int>((ref, showId) {
  final db = ref.watch(databaseProvider);
  
  final query = db.select(db.episodes).join([
    innerJoin(db.seasons, db.seasons.id.equalsExp(db.episodes.seasonId))
  ])
    ..where(db.episodes.showId.equals(showId) & db.seasons.seasonNumber.isBiggerThanValue(0) & db.episodes.isWatched.equals(false))
    ..orderBy([
      OrderingTerm(expression: db.seasons.seasonNumber),
      OrderingTerm(expression: db.episodes.episodeNumber)
    ])
    ..limit(1);
    
  return query.watch().map((rows) {
    if (rows.isEmpty) return 'All caught up';
    final row = rows.first;
    final season = row.readTable(db.seasons);
    final episode = row.readTable(db.episodes);
    return 'S${season.seasonNumber} E${episode.episodeNumber}';
  });
});