import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/database/database.dart';
import '../../../core/database/database_provider.dart';
import '../../../core/network/tmdb_repository.dart';

final libraryRepositoryProvider = Provider((ref) {
  return LibraryRepository(
    ref.watch(databaseProvider),
    ref.watch(tmdbRepositoryProvider),
  );
});

class LibraryRepository {
  final AppDatabase _db;
  final TmdbRepository _tmdb;

  LibraryRepository(this._db, this._tmdb);

  /// Fetches a TV Show and ALL its seasons/episodes and saves them locally.
  Future<void> addTvShow(int showId) async {
    // 1. Fetch main show details
    final details = await _tmdb.getShowDetails(showId);

    // Parse the next episode date if it exists (crucial for your Upcoming tab)
    DateTime? nextAirDate;
    if (details['next_episode_to_air'] != null) {
      nextAirDate = DateTime.tryParse(
        details['next_episode_to_air']['air_date'] ?? '',
      );
    }

    // Parse genres
    final List<dynamic>? genresList = details['genres'];
    final String? genresStr = genresList != null
        ? genresList.map((g) => g['name'].toString()).join(', ')
        : null;

    // Parse cast
    final Map<String, dynamic>? credits = details['credits'];
    final List<dynamic>? castList = credits?['cast'];
    String? castStr;
    if (castList != null) {
      // Get top 15 cast members
      final topCast = castList
          .take(15)
          .map(
            (c) => {
              'name': c['name'],
              'character': c['character'],
              'profile_path': c['profile_path'],
            },
          )
          .toList();
      castStr = jsonEncode(topCast);
    }

    // 2. Prepare the Show object
    final show = TvShowsCompanion.insert(
      id: Value(showId),
      title: details['name'] ?? 'Unknown',
      posterPath: Value(details['poster_path']),
      overview: details['overview'] ?? '',
      status: const Value('planning'),
      nextEpisodeAirDate: Value(nextAirDate),
      addedAt: Value(DateTime.now()),
      genres: Value(genresStr),
      castList: Value(castStr),
    );

    // We removed the immediate save here to prevent partial states (0 episodes shown in UI)
    // await _db.into(_db.tvShows).insert(show, mode: InsertMode.insertOrReplace);

    // 3. Fetch and prepare Seasons & Episodes
    final seasonsList = details['seasons'] as List<dynamic>? ?? [];
    List<SeasonsCompanion> seasonsToInsert = [];
    List<EpisodesCompanion> episodesToInsert = [];

    // Use Future.wait to fetch all season data concurrently for massive speed up
    final seasonFutures = seasonsList.map((s) async {
      int seasonNum = s['season_number'];
      int seasonId = s['id'];

      seasonsToInsert.add(
        SeasonsCompanion.insert(
          id: Value(seasonId),
          showId: showId,
          seasonNumber: seasonNum,
          name: s['name'] ?? 'Season $seasonNum',
          airDate: Value(DateTime.tryParse(s['air_date'] ?? '')),
        ),
      );

      // Fetch episodes for this specific season
      final epList = await _tmdb.getSeasonEpisodes(showId, seasonNum);

      for (var e in epList) {
        episodesToInsert.add(
          EpisodesCompanion.insert(
            id: Value(e['id']),
            seasonId: seasonId,
            showId: showId,
            episodeNumber: e['episode_number'],
            title: e['name'] ?? 'Episode ${e['episode_number']}',
            airDate: Value(DateTime.tryParse(e['air_date'] ?? '')),
            isWatched: const Value(false),
          ),
        );
      }
    });

    await Future.wait(seasonFutures);

    // 4. Batch Insert all at once (This prevents partial UI updates and is very fast)
    await _db.batch((batch) {
      batch.insert(_db.tvShows, show, mode: InsertMode.insertOrReplace);
      batch.insertAllOnConflictUpdate(_db.seasons, seasonsToInsert);
      batch.insertAllOnConflictUpdate(_db.episodes, episodesToInsert);
    });
  }

  /// Fetches Movie details and saves it locally.
  Future<void> addMovie(int movieId) async {
    final details = await _tmdb.getMovieDetails(movieId);

    // Parse genres
    final List<dynamic>? genresList = details['genres'];
    final String? genresStr = genresList != null
        ? genresList.map((g) => g['name'].toString()).join(', ')
        : null;

    // Parse cast
    final Map<String, dynamic>? credits = details['credits'];
    final List<dynamic>? castList = credits?['cast'];
    String? castStr;
    if (castList != null) {
      // Get top 15 cast members
      final topCast = castList
          .take(15)
          .map(
            (c) => {
              'name': c['name'],
              'character': c['character'],
              'profile_path': c['profile_path'],
            },
          )
          .toList();
      castStr = jsonEncode(topCast);
    }

    final movie = MoviesCompanion.insert(
      id: Value(movieId),
      title: details['title'] ?? 'Unknown Title',
      posterPath: Value(details['poster_path']),
      overview: details['overview'] ?? '',
      releaseDate: Value(DateTime.tryParse(details['release_date'] ?? '')),
      status: const Value('planning'),
      addedAt: Value(DateTime.now()),
      genres: Value(genresStr),
      castList: Value(castStr),
    );

    await _db.into(_db.movies).insert(movie, mode: InsertMode.insertOrReplace);
  }

  Future<void> removeTvShow(int showId) async {
    // We use a transaction so if anything fails, it rolls back and doesn't corrupt data
    await _db.transaction(() async {
      // 1. Delete all episodes for this show
      await (_db.delete(
        _db.episodes,
      )..where((tbl) => tbl.showId.equals(showId))).go();

      // 2. Delete all seasons for this show
      await (_db.delete(
        _db.seasons,
      )..where((tbl) => tbl.showId.equals(showId))).go();

      // 3. Finally, delete the show itself
      await (_db.delete(
        _db.tvShows,
      )..where((tbl) => tbl.id.equals(showId))).go();
    });
  }

  /// Deletes a Movie from the database
  Future<void> removeMovie(int movieId) async {
    await (_db.delete(_db.movies)..where((tbl) => tbl.id.equals(movieId))).go();
  }
}
