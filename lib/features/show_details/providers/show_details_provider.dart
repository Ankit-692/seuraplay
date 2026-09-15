import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/database/database.dart';
import '../../../core/database/database_provider.dart';

/// Streams the show metadata for a specific ID
final showMetadataProvider = StreamProvider.family<TvShow?, int>((ref, showId) {
  final db = ref.watch(databaseProvider);
  return (db.select(db.tvShows)..where((tbl) => tbl.id.equals(showId)))
      .watchSingleOrNull();
});

/// Streams all seasons for this show ordered by season number
final showSeasonsProvider = StreamProvider.family<List<Season>, int>((ref, showId) {
  final db = ref.watch(databaseProvider);
  return (db.select(db.seasons)
        ..where((tbl) => tbl.showId.equals(showId))
        ..orderBy([(tbl) => OrderingTerm(expression: tbl.seasonNumber)]))
      .watch();
});

/// Streams all episodes for a specific season ordered by episode number
final seasonEpisodesProvider = StreamProvider.family<List<Episode>, int>((ref, seasonId) {
  final db = ref.watch(databaseProvider);
  return (db.select(db.episodes)
        ..where((tbl) => tbl.seasonId.equals(seasonId))
        ..orderBy([(tbl) => OrderingTerm(expression: tbl.episodeNumber)]))
      .watch();
});

/// Streams the watch progress (watched count vs total count) for the show
final showProgressProvider = StreamProvider.family<({int watched, int total}), int>((ref, showId) {
  final db = ref.watch(databaseProvider);
  
  final query = db.select(db.episodes).join([
    innerJoin(db.seasons, db.seasons.id.equalsExp(db.episodes.seasonId))
  ])..where(db.episodes.showId.equals(showId) & db.seasons.seasonNumber.isBiggerThanValue(0));

  return query.watch().map((rows) {
    final episodes = rows.map((row) => row.readTable(db.episodes)).toList();
    final total = episodes.length;
    final watched = episodes.where((e) => e.isWatched).length;
    return (watched: watched, total: total);
  });
});

/// Controller to toggle episode status in the database
final episodeControllerProvider = Provider((ref) {
  final db = ref.watch(databaseProvider);
  return EpisodeController(db);
});

class EpisodeController {
  final AppDatabase _db;
  EpisodeController(this._db);

  Future<void> toggleWatched(int episodeId, bool currentStatus) async {
    final newStatus = !currentStatus;
    await (_db.update(_db.episodes)..where((tbl) => tbl.id.equals(episodeId))).write(
      EpisodesCompanion(
        isWatched: Value(newStatus),
        watchedAt: Value(newStatus ? DateTime.now() : null),
      ),
    );
    
    final ep = await (_db.select(_db.episodes)..where((tbl) => tbl.id.equals(episodeId))).getSingle();
    await _updateShowStatus(ep.showId);
  }

  Future<void> markSeasonWatched(int seasonId, bool isWatched) async {
    // This instantly updates every single episode in the season at once
    await (_db.update(_db.episodes)..where((tbl) => tbl.seasonId.equals(seasonId))).write(
      EpisodesCompanion(
        isWatched: Value(isWatched),
        watchedAt: Value(isWatched ? DateTime.now() : null),
      ),
    );
    
    final season = await (_db.select(_db.seasons)..where((tbl) => tbl.id.equals(seasonId))).getSingle();
    await _updateShowStatus(season.showId);
  }
  
  Future<void> _updateShowStatus(int showId) async {
    final query = _db.select(_db.episodes).join([
      innerJoin(_db.seasons, _db.seasons.id.equalsExp(_db.episodes.seasonId))
    ])..where(_db.episodes.showId.equals(showId) & _db.seasons.seasonNumber.isBiggerThanValue(0));

    final rows = await query.get();
    final episodes = rows.map((row) => row.readTable(_db.episodes)).toList();
    
    final total = episodes.length;
    final watchedCount = episodes.where((e) => e.isWatched).length;

    String newStatus = 'planning';
    if (watchedCount > 0 && watchedCount < total) {
      newStatus = 'watching';
    } else if (watchedCount > 0 && watchedCount == total) {
      newStatus = 'watched';
    }

    await (_db.update(_db.tvShows)..where((tbl) => tbl.id.equals(showId))).write(
      TvShowsCompanion(status: Value(newStatus)),
    );
  }
}