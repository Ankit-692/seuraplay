import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'database.g.dart';

@DataClassName('Movie')
class Movies extends Table {
  IntColumn get id => integer()();
  TextColumn get title => text()();
  TextColumn get posterPath => text().nullable()();
  TextColumn get overview => text()();
  DateTimeColumn get releaseDate => dateTime().nullable()();
  TextColumn get status => text().withDefault(const Constant('planning'))();
  DateTimeColumn get addedAt => dateTime().withDefault(currentDateAndTime)();
  TextColumn get genres => text().nullable()();
  TextColumn get castList => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('TvShow')
class TvShows extends Table {
  IntColumn get id => integer()();
  TextColumn get title => text()();
  TextColumn get posterPath => text().nullable()();
  TextColumn get overview => text()();
  TextColumn get status => text().withDefault(const Constant('planning'))();
  DateTimeColumn get nextEpisodeAirDate => dateTime().nullable()();
  DateTimeColumn get addedAt => dateTime().withDefault(currentDateAndTime)();
  TextColumn get genres => text().nullable()();
  TextColumn get castList => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class Seasons extends Table {
  IntColumn get id => integer()();
  IntColumn get showId => integer().references(TvShows, #id)();
  IntColumn get seasonNumber => integer()();
  TextColumn get name => text()();
  DateTimeColumn get airDate => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class Episodes extends Table {
  IntColumn get id => integer()();
  IntColumn get seasonId => integer().references(Seasons, #id)();
  IntColumn get showId => integer().references(TvShows, #id)();
  IntColumn get episodeNumber => integer()();
  TextColumn get title => text()();
  DateTimeColumn get airDate => dateTime().nullable()();
  BoolColumn get isWatched => boolean().withDefault(const Constant(false))();
  DateTimeColumn get watchedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [Movies, TvShows, Seasons, Episodes])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      beforeOpen: (details) async {
        // Optional: you can enable foreign keys or do pragmas here
      },
    );
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));

    return NativeDatabase.createInBackground(file);
  });
}
