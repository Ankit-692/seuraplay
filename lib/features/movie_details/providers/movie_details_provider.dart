import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/database/database.dart';
import '../../../../core/database/database_provider.dart';


/// Streams the movie metadata for a specific ID directly from Drift
final movieMetadataProvider = StreamProvider.family<Movie?, int>((
  ref,
  movieId,
) {
  final db = ref.watch(databaseProvider);
  return (db.select(
    db.movies,
  )..where((tbl) => tbl.id.equals(movieId))).watchSingleOrNull();
});

/// Controller to toggle the movie's status between 'planning' and 'watched'
final movieControllerProvider = Provider((ref) {
  final db = ref.watch(databaseProvider);
  return MovieController(db);
});

class MovieController {
  final AppDatabase _db;
  MovieController(this._db);

  Future<void> toggleStatus(int movieId, String currentStatus) async {
    final newStatus = currentStatus == 'watched' ? 'planning' : 'watched';

    await (_db.update(_db.movies)..where((tbl) => tbl.id.equals(movieId)))
        .write(MoviesCompanion(status: Value(newStatus)));
  }
}

final movieTrailersProvider = StreamProvider.family<String?, int>((ref, movieId) {
  final db = ref.watch(databaseProvider);
  return (db.select(db.movies)..where((tbl) => tbl.id.equals(movieId)))
      .watchSingleOrNull()
      .map((movie) => movie?.trailerKey);
});
