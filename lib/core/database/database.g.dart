// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $MoviesTable extends Movies with TableInfo<$MoviesTable, Movie> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MoviesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _posterPathMeta = const VerificationMeta(
    'posterPath',
  );
  @override
  late final GeneratedColumn<String> posterPath = GeneratedColumn<String>(
    'poster_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _overviewMeta = const VerificationMeta(
    'overview',
  );
  @override
  late final GeneratedColumn<String> overview = GeneratedColumn<String>(
    'overview',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _releaseDateMeta = const VerificationMeta(
    'releaseDate',
  );
  @override
  late final GeneratedColumn<DateTime> releaseDate = GeneratedColumn<DateTime>(
    'release_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('planning'),
  );
  static const VerificationMeta _addedAtMeta = const VerificationMeta(
    'addedAt',
  );
  @override
  late final GeneratedColumn<DateTime> addedAt = GeneratedColumn<DateTime>(
    'added_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _genresMeta = const VerificationMeta('genres');
  @override
  late final GeneratedColumn<String> genres = GeneratedColumn<String>(
    'genres',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _castListMeta = const VerificationMeta(
    'castList',
  );
  @override
  late final GeneratedColumn<String> castList = GeneratedColumn<String>(
    'cast_list',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _trailerKeyMeta = const VerificationMeta(
    'trailerKey',
  );
  @override
  late final GeneratedColumn<String> trailerKey = GeneratedColumn<String>(
    'trailer_key',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    posterPath,
    overview,
    releaseDate,
    status,
    addedAt,
    genres,
    castList,
    trailerKey,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'movies';
  @override
  VerificationContext validateIntegrity(
    Insertable<Movie> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('poster_path')) {
      context.handle(
        _posterPathMeta,
        posterPath.isAcceptableOrUnknown(data['poster_path']!, _posterPathMeta),
      );
    }
    if (data.containsKey('overview')) {
      context.handle(
        _overviewMeta,
        overview.isAcceptableOrUnknown(data['overview']!, _overviewMeta),
      );
    } else if (isInserting) {
      context.missing(_overviewMeta);
    }
    if (data.containsKey('release_date')) {
      context.handle(
        _releaseDateMeta,
        releaseDate.isAcceptableOrUnknown(
          data['release_date']!,
          _releaseDateMeta,
        ),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('added_at')) {
      context.handle(
        _addedAtMeta,
        addedAt.isAcceptableOrUnknown(data['added_at']!, _addedAtMeta),
      );
    }
    if (data.containsKey('genres')) {
      context.handle(
        _genresMeta,
        genres.isAcceptableOrUnknown(data['genres']!, _genresMeta),
      );
    }
    if (data.containsKey('cast_list')) {
      context.handle(
        _castListMeta,
        castList.isAcceptableOrUnknown(data['cast_list']!, _castListMeta),
      );
    }
    if (data.containsKey('trailer_key')) {
      context.handle(
        _trailerKeyMeta,
        trailerKey.isAcceptableOrUnknown(data['trailer_key']!, _trailerKeyMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Movie map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Movie(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      posterPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}poster_path'],
      ),
      overview: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}overview'],
      )!,
      releaseDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}release_date'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      addedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}added_at'],
      )!,
      genres: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}genres'],
      ),
      castList: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cast_list'],
      ),
      trailerKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}trailer_key'],
      ),
    );
  }

  @override
  $MoviesTable createAlias(String alias) {
    return $MoviesTable(attachedDatabase, alias);
  }
}

class Movie extends DataClass implements Insertable<Movie> {
  final int id;
  final String title;
  final String? posterPath;
  final String overview;
  final DateTime? releaseDate;
  final String status;
  final DateTime addedAt;
  final String? genres;
  final String? castList;
  final String? trailerKey;
  const Movie({
    required this.id,
    required this.title,
    this.posterPath,
    required this.overview,
    this.releaseDate,
    required this.status,
    required this.addedAt,
    this.genres,
    this.castList,
    this.trailerKey,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || posterPath != null) {
      map['poster_path'] = Variable<String>(posterPath);
    }
    map['overview'] = Variable<String>(overview);
    if (!nullToAbsent || releaseDate != null) {
      map['release_date'] = Variable<DateTime>(releaseDate);
    }
    map['status'] = Variable<String>(status);
    map['added_at'] = Variable<DateTime>(addedAt);
    if (!nullToAbsent || genres != null) {
      map['genres'] = Variable<String>(genres);
    }
    if (!nullToAbsent || castList != null) {
      map['cast_list'] = Variable<String>(castList);
    }
    if (!nullToAbsent || trailerKey != null) {
      map['trailer_key'] = Variable<String>(trailerKey);
    }
    return map;
  }

  MoviesCompanion toCompanion(bool nullToAbsent) {
    return MoviesCompanion(
      id: Value(id),
      title: Value(title),
      posterPath: posterPath == null && nullToAbsent
          ? const Value.absent()
          : Value(posterPath),
      overview: Value(overview),
      releaseDate: releaseDate == null && nullToAbsent
          ? const Value.absent()
          : Value(releaseDate),
      status: Value(status),
      addedAt: Value(addedAt),
      genres: genres == null && nullToAbsent
          ? const Value.absent()
          : Value(genres),
      castList: castList == null && nullToAbsent
          ? const Value.absent()
          : Value(castList),
      trailerKey: trailerKey == null && nullToAbsent
          ? const Value.absent()
          : Value(trailerKey),
    );
  }

  factory Movie.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Movie(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      posterPath: serializer.fromJson<String?>(json['posterPath']),
      overview: serializer.fromJson<String>(json['overview']),
      releaseDate: serializer.fromJson<DateTime?>(json['releaseDate']),
      status: serializer.fromJson<String>(json['status']),
      addedAt: serializer.fromJson<DateTime>(json['addedAt']),
      genres: serializer.fromJson<String?>(json['genres']),
      castList: serializer.fromJson<String?>(json['castList']),
      trailerKey: serializer.fromJson<String?>(json['trailerKey']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'posterPath': serializer.toJson<String?>(posterPath),
      'overview': serializer.toJson<String>(overview),
      'releaseDate': serializer.toJson<DateTime?>(releaseDate),
      'status': serializer.toJson<String>(status),
      'addedAt': serializer.toJson<DateTime>(addedAt),
      'genres': serializer.toJson<String?>(genres),
      'castList': serializer.toJson<String?>(castList),
      'trailerKey': serializer.toJson<String?>(trailerKey),
    };
  }

  Movie copyWith({
    int? id,
    String? title,
    Value<String?> posterPath = const Value.absent(),
    String? overview,
    Value<DateTime?> releaseDate = const Value.absent(),
    String? status,
    DateTime? addedAt,
    Value<String?> genres = const Value.absent(),
    Value<String?> castList = const Value.absent(),
    Value<String?> trailerKey = const Value.absent(),
  }) => Movie(
    id: id ?? this.id,
    title: title ?? this.title,
    posterPath: posterPath.present ? posterPath.value : this.posterPath,
    overview: overview ?? this.overview,
    releaseDate: releaseDate.present ? releaseDate.value : this.releaseDate,
    status: status ?? this.status,
    addedAt: addedAt ?? this.addedAt,
    genres: genres.present ? genres.value : this.genres,
    castList: castList.present ? castList.value : this.castList,
    trailerKey: trailerKey.present ? trailerKey.value : this.trailerKey,
  );
  Movie copyWithCompanion(MoviesCompanion data) {
    return Movie(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      posterPath: data.posterPath.present
          ? data.posterPath.value
          : this.posterPath,
      overview: data.overview.present ? data.overview.value : this.overview,
      releaseDate: data.releaseDate.present
          ? data.releaseDate.value
          : this.releaseDate,
      status: data.status.present ? data.status.value : this.status,
      addedAt: data.addedAt.present ? data.addedAt.value : this.addedAt,
      genres: data.genres.present ? data.genres.value : this.genres,
      castList: data.castList.present ? data.castList.value : this.castList,
      trailerKey: data.trailerKey.present
          ? data.trailerKey.value
          : this.trailerKey,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Movie(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('posterPath: $posterPath, ')
          ..write('overview: $overview, ')
          ..write('releaseDate: $releaseDate, ')
          ..write('status: $status, ')
          ..write('addedAt: $addedAt, ')
          ..write('genres: $genres, ')
          ..write('castList: $castList, ')
          ..write('trailerKey: $trailerKey')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    posterPath,
    overview,
    releaseDate,
    status,
    addedAt,
    genres,
    castList,
    trailerKey,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Movie &&
          other.id == this.id &&
          other.title == this.title &&
          other.posterPath == this.posterPath &&
          other.overview == this.overview &&
          other.releaseDate == this.releaseDate &&
          other.status == this.status &&
          other.addedAt == this.addedAt &&
          other.genres == this.genres &&
          other.castList == this.castList &&
          other.trailerKey == this.trailerKey);
}

class MoviesCompanion extends UpdateCompanion<Movie> {
  final Value<int> id;
  final Value<String> title;
  final Value<String?> posterPath;
  final Value<String> overview;
  final Value<DateTime?> releaseDate;
  final Value<String> status;
  final Value<DateTime> addedAt;
  final Value<String?> genres;
  final Value<String?> castList;
  final Value<String?> trailerKey;
  const MoviesCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.posterPath = const Value.absent(),
    this.overview = const Value.absent(),
    this.releaseDate = const Value.absent(),
    this.status = const Value.absent(),
    this.addedAt = const Value.absent(),
    this.genres = const Value.absent(),
    this.castList = const Value.absent(),
    this.trailerKey = const Value.absent(),
  });
  MoviesCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    this.posterPath = const Value.absent(),
    required String overview,
    this.releaseDate = const Value.absent(),
    this.status = const Value.absent(),
    this.addedAt = const Value.absent(),
    this.genres = const Value.absent(),
    this.castList = const Value.absent(),
    this.trailerKey = const Value.absent(),
  }) : title = Value(title),
       overview = Value(overview);
  static Insertable<Movie> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<String>? posterPath,
    Expression<String>? overview,
    Expression<DateTime>? releaseDate,
    Expression<String>? status,
    Expression<DateTime>? addedAt,
    Expression<String>? genres,
    Expression<String>? castList,
    Expression<String>? trailerKey,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (posterPath != null) 'poster_path': posterPath,
      if (overview != null) 'overview': overview,
      if (releaseDate != null) 'release_date': releaseDate,
      if (status != null) 'status': status,
      if (addedAt != null) 'added_at': addedAt,
      if (genres != null) 'genres': genres,
      if (castList != null) 'cast_list': castList,
      if (trailerKey != null) 'trailer_key': trailerKey,
    });
  }

  MoviesCompanion copyWith({
    Value<int>? id,
    Value<String>? title,
    Value<String?>? posterPath,
    Value<String>? overview,
    Value<DateTime?>? releaseDate,
    Value<String>? status,
    Value<DateTime>? addedAt,
    Value<String?>? genres,
    Value<String?>? castList,
    Value<String?>? trailerKey,
  }) {
    return MoviesCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      posterPath: posterPath ?? this.posterPath,
      overview: overview ?? this.overview,
      releaseDate: releaseDate ?? this.releaseDate,
      status: status ?? this.status,
      addedAt: addedAt ?? this.addedAt,
      genres: genres ?? this.genres,
      castList: castList ?? this.castList,
      trailerKey: trailerKey ?? this.trailerKey,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (posterPath.present) {
      map['poster_path'] = Variable<String>(posterPath.value);
    }
    if (overview.present) {
      map['overview'] = Variable<String>(overview.value);
    }
    if (releaseDate.present) {
      map['release_date'] = Variable<DateTime>(releaseDate.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (addedAt.present) {
      map['added_at'] = Variable<DateTime>(addedAt.value);
    }
    if (genres.present) {
      map['genres'] = Variable<String>(genres.value);
    }
    if (castList.present) {
      map['cast_list'] = Variable<String>(castList.value);
    }
    if (trailerKey.present) {
      map['trailer_key'] = Variable<String>(trailerKey.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MoviesCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('posterPath: $posterPath, ')
          ..write('overview: $overview, ')
          ..write('releaseDate: $releaseDate, ')
          ..write('status: $status, ')
          ..write('addedAt: $addedAt, ')
          ..write('genres: $genres, ')
          ..write('castList: $castList, ')
          ..write('trailerKey: $trailerKey')
          ..write(')'))
        .toString();
  }
}

class $TvShowsTable extends TvShows with TableInfo<$TvShowsTable, TvShow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TvShowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _posterPathMeta = const VerificationMeta(
    'posterPath',
  );
  @override
  late final GeneratedColumn<String> posterPath = GeneratedColumn<String>(
    'poster_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _overviewMeta = const VerificationMeta(
    'overview',
  );
  @override
  late final GeneratedColumn<String> overview = GeneratedColumn<String>(
    'overview',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('planning'),
  );
  static const VerificationMeta _nextEpisodeAirDateMeta =
      const VerificationMeta('nextEpisodeAirDate');
  @override
  late final GeneratedColumn<DateTime> nextEpisodeAirDate =
      GeneratedColumn<DateTime>(
        'next_episode_air_date',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _addedAtMeta = const VerificationMeta(
    'addedAt',
  );
  @override
  late final GeneratedColumn<DateTime> addedAt = GeneratedColumn<DateTime>(
    'added_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _genresMeta = const VerificationMeta('genres');
  @override
  late final GeneratedColumn<String> genres = GeneratedColumn<String>(
    'genres',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _castListMeta = const VerificationMeta(
    'castList',
  );
  @override
  late final GeneratedColumn<String> castList = GeneratedColumn<String>(
    'cast_list',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _trailerKeyMeta = const VerificationMeta(
    'trailerKey',
  );
  @override
  late final GeneratedColumn<String> trailerKey = GeneratedColumn<String>(
    'trailer_key',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    posterPath,
    overview,
    status,
    nextEpisodeAirDate,
    addedAt,
    genres,
    castList,
    trailerKey,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tv_shows';
  @override
  VerificationContext validateIntegrity(
    Insertable<TvShow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('poster_path')) {
      context.handle(
        _posterPathMeta,
        posterPath.isAcceptableOrUnknown(data['poster_path']!, _posterPathMeta),
      );
    }
    if (data.containsKey('overview')) {
      context.handle(
        _overviewMeta,
        overview.isAcceptableOrUnknown(data['overview']!, _overviewMeta),
      );
    } else if (isInserting) {
      context.missing(_overviewMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('next_episode_air_date')) {
      context.handle(
        _nextEpisodeAirDateMeta,
        nextEpisodeAirDate.isAcceptableOrUnknown(
          data['next_episode_air_date']!,
          _nextEpisodeAirDateMeta,
        ),
      );
    }
    if (data.containsKey('added_at')) {
      context.handle(
        _addedAtMeta,
        addedAt.isAcceptableOrUnknown(data['added_at']!, _addedAtMeta),
      );
    }
    if (data.containsKey('genres')) {
      context.handle(
        _genresMeta,
        genres.isAcceptableOrUnknown(data['genres']!, _genresMeta),
      );
    }
    if (data.containsKey('cast_list')) {
      context.handle(
        _castListMeta,
        castList.isAcceptableOrUnknown(data['cast_list']!, _castListMeta),
      );
    }
    if (data.containsKey('trailer_key')) {
      context.handle(
        _trailerKeyMeta,
        trailerKey.isAcceptableOrUnknown(data['trailer_key']!, _trailerKeyMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TvShow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TvShow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      posterPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}poster_path'],
      ),
      overview: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}overview'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      nextEpisodeAirDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}next_episode_air_date'],
      ),
      addedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}added_at'],
      )!,
      genres: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}genres'],
      ),
      castList: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cast_list'],
      ),
      trailerKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}trailer_key'],
      ),
    );
  }

  @override
  $TvShowsTable createAlias(String alias) {
    return $TvShowsTable(attachedDatabase, alias);
  }
}

class TvShow extends DataClass implements Insertable<TvShow> {
  final int id;
  final String title;
  final String? posterPath;
  final String overview;
  final String status;
  final DateTime? nextEpisodeAirDate;
  final DateTime addedAt;
  final String? genres;
  final String? castList;
  final String? trailerKey;
  const TvShow({
    required this.id,
    required this.title,
    this.posterPath,
    required this.overview,
    required this.status,
    this.nextEpisodeAirDate,
    required this.addedAt,
    this.genres,
    this.castList,
    this.trailerKey,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || posterPath != null) {
      map['poster_path'] = Variable<String>(posterPath);
    }
    map['overview'] = Variable<String>(overview);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || nextEpisodeAirDate != null) {
      map['next_episode_air_date'] = Variable<DateTime>(nextEpisodeAirDate);
    }
    map['added_at'] = Variable<DateTime>(addedAt);
    if (!nullToAbsent || genres != null) {
      map['genres'] = Variable<String>(genres);
    }
    if (!nullToAbsent || castList != null) {
      map['cast_list'] = Variable<String>(castList);
    }
    if (!nullToAbsent || trailerKey != null) {
      map['trailer_key'] = Variable<String>(trailerKey);
    }
    return map;
  }

  TvShowsCompanion toCompanion(bool nullToAbsent) {
    return TvShowsCompanion(
      id: Value(id),
      title: Value(title),
      posterPath: posterPath == null && nullToAbsent
          ? const Value.absent()
          : Value(posterPath),
      overview: Value(overview),
      status: Value(status),
      nextEpisodeAirDate: nextEpisodeAirDate == null && nullToAbsent
          ? const Value.absent()
          : Value(nextEpisodeAirDate),
      addedAt: Value(addedAt),
      genres: genres == null && nullToAbsent
          ? const Value.absent()
          : Value(genres),
      castList: castList == null && nullToAbsent
          ? const Value.absent()
          : Value(castList),
      trailerKey: trailerKey == null && nullToAbsent
          ? const Value.absent()
          : Value(trailerKey),
    );
  }

  factory TvShow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TvShow(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      posterPath: serializer.fromJson<String?>(json['posterPath']),
      overview: serializer.fromJson<String>(json['overview']),
      status: serializer.fromJson<String>(json['status']),
      nextEpisodeAirDate: serializer.fromJson<DateTime?>(
        json['nextEpisodeAirDate'],
      ),
      addedAt: serializer.fromJson<DateTime>(json['addedAt']),
      genres: serializer.fromJson<String?>(json['genres']),
      castList: serializer.fromJson<String?>(json['castList']),
      trailerKey: serializer.fromJson<String?>(json['trailerKey']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'posterPath': serializer.toJson<String?>(posterPath),
      'overview': serializer.toJson<String>(overview),
      'status': serializer.toJson<String>(status),
      'nextEpisodeAirDate': serializer.toJson<DateTime?>(nextEpisodeAirDate),
      'addedAt': serializer.toJson<DateTime>(addedAt),
      'genres': serializer.toJson<String?>(genres),
      'castList': serializer.toJson<String?>(castList),
      'trailerKey': serializer.toJson<String?>(trailerKey),
    };
  }

  TvShow copyWith({
    int? id,
    String? title,
    Value<String?> posterPath = const Value.absent(),
    String? overview,
    String? status,
    Value<DateTime?> nextEpisodeAirDate = const Value.absent(),
    DateTime? addedAt,
    Value<String?> genres = const Value.absent(),
    Value<String?> castList = const Value.absent(),
    Value<String?> trailerKey = const Value.absent(),
  }) => TvShow(
    id: id ?? this.id,
    title: title ?? this.title,
    posterPath: posterPath.present ? posterPath.value : this.posterPath,
    overview: overview ?? this.overview,
    status: status ?? this.status,
    nextEpisodeAirDate: nextEpisodeAirDate.present
        ? nextEpisodeAirDate.value
        : this.nextEpisodeAirDate,
    addedAt: addedAt ?? this.addedAt,
    genres: genres.present ? genres.value : this.genres,
    castList: castList.present ? castList.value : this.castList,
    trailerKey: trailerKey.present ? trailerKey.value : this.trailerKey,
  );
  TvShow copyWithCompanion(TvShowsCompanion data) {
    return TvShow(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      posterPath: data.posterPath.present
          ? data.posterPath.value
          : this.posterPath,
      overview: data.overview.present ? data.overview.value : this.overview,
      status: data.status.present ? data.status.value : this.status,
      nextEpisodeAirDate: data.nextEpisodeAirDate.present
          ? data.nextEpisodeAirDate.value
          : this.nextEpisodeAirDate,
      addedAt: data.addedAt.present ? data.addedAt.value : this.addedAt,
      genres: data.genres.present ? data.genres.value : this.genres,
      castList: data.castList.present ? data.castList.value : this.castList,
      trailerKey: data.trailerKey.present
          ? data.trailerKey.value
          : this.trailerKey,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TvShow(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('posterPath: $posterPath, ')
          ..write('overview: $overview, ')
          ..write('status: $status, ')
          ..write('nextEpisodeAirDate: $nextEpisodeAirDate, ')
          ..write('addedAt: $addedAt, ')
          ..write('genres: $genres, ')
          ..write('castList: $castList, ')
          ..write('trailerKey: $trailerKey')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    posterPath,
    overview,
    status,
    nextEpisodeAirDate,
    addedAt,
    genres,
    castList,
    trailerKey,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TvShow &&
          other.id == this.id &&
          other.title == this.title &&
          other.posterPath == this.posterPath &&
          other.overview == this.overview &&
          other.status == this.status &&
          other.nextEpisodeAirDate == this.nextEpisodeAirDate &&
          other.addedAt == this.addedAt &&
          other.genres == this.genres &&
          other.castList == this.castList &&
          other.trailerKey == this.trailerKey);
}

class TvShowsCompanion extends UpdateCompanion<TvShow> {
  final Value<int> id;
  final Value<String> title;
  final Value<String?> posterPath;
  final Value<String> overview;
  final Value<String> status;
  final Value<DateTime?> nextEpisodeAirDate;
  final Value<DateTime> addedAt;
  final Value<String?> genres;
  final Value<String?> castList;
  final Value<String?> trailerKey;
  const TvShowsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.posterPath = const Value.absent(),
    this.overview = const Value.absent(),
    this.status = const Value.absent(),
    this.nextEpisodeAirDate = const Value.absent(),
    this.addedAt = const Value.absent(),
    this.genres = const Value.absent(),
    this.castList = const Value.absent(),
    this.trailerKey = const Value.absent(),
  });
  TvShowsCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    this.posterPath = const Value.absent(),
    required String overview,
    this.status = const Value.absent(),
    this.nextEpisodeAirDate = const Value.absent(),
    this.addedAt = const Value.absent(),
    this.genres = const Value.absent(),
    this.castList = const Value.absent(),
    this.trailerKey = const Value.absent(),
  }) : title = Value(title),
       overview = Value(overview);
  static Insertable<TvShow> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<String>? posterPath,
    Expression<String>? overview,
    Expression<String>? status,
    Expression<DateTime>? nextEpisodeAirDate,
    Expression<DateTime>? addedAt,
    Expression<String>? genres,
    Expression<String>? castList,
    Expression<String>? trailerKey,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (posterPath != null) 'poster_path': posterPath,
      if (overview != null) 'overview': overview,
      if (status != null) 'status': status,
      if (nextEpisodeAirDate != null)
        'next_episode_air_date': nextEpisodeAirDate,
      if (addedAt != null) 'added_at': addedAt,
      if (genres != null) 'genres': genres,
      if (castList != null) 'cast_list': castList,
      if (trailerKey != null) 'trailer_key': trailerKey,
    });
  }

  TvShowsCompanion copyWith({
    Value<int>? id,
    Value<String>? title,
    Value<String?>? posterPath,
    Value<String>? overview,
    Value<String>? status,
    Value<DateTime?>? nextEpisodeAirDate,
    Value<DateTime>? addedAt,
    Value<String?>? genres,
    Value<String?>? castList,
    Value<String?>? trailerKey,
  }) {
    return TvShowsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      posterPath: posterPath ?? this.posterPath,
      overview: overview ?? this.overview,
      status: status ?? this.status,
      nextEpisodeAirDate: nextEpisodeAirDate ?? this.nextEpisodeAirDate,
      addedAt: addedAt ?? this.addedAt,
      genres: genres ?? this.genres,
      castList: castList ?? this.castList,
      trailerKey: trailerKey ?? this.trailerKey,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (posterPath.present) {
      map['poster_path'] = Variable<String>(posterPath.value);
    }
    if (overview.present) {
      map['overview'] = Variable<String>(overview.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (nextEpisodeAirDate.present) {
      map['next_episode_air_date'] = Variable<DateTime>(
        nextEpisodeAirDate.value,
      );
    }
    if (addedAt.present) {
      map['added_at'] = Variable<DateTime>(addedAt.value);
    }
    if (genres.present) {
      map['genres'] = Variable<String>(genres.value);
    }
    if (castList.present) {
      map['cast_list'] = Variable<String>(castList.value);
    }
    if (trailerKey.present) {
      map['trailer_key'] = Variable<String>(trailerKey.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TvShowsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('posterPath: $posterPath, ')
          ..write('overview: $overview, ')
          ..write('status: $status, ')
          ..write('nextEpisodeAirDate: $nextEpisodeAirDate, ')
          ..write('addedAt: $addedAt, ')
          ..write('genres: $genres, ')
          ..write('castList: $castList, ')
          ..write('trailerKey: $trailerKey')
          ..write(')'))
        .toString();
  }
}

class $SeasonsTable extends Seasons with TableInfo<$SeasonsTable, Season> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SeasonsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _showIdMeta = const VerificationMeta('showId');
  @override
  late final GeneratedColumn<int> showId = GeneratedColumn<int>(
    'show_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES tv_shows (id)',
    ),
  );
  static const VerificationMeta _seasonNumberMeta = const VerificationMeta(
    'seasonNumber',
  );
  @override
  late final GeneratedColumn<int> seasonNumber = GeneratedColumn<int>(
    'season_number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _airDateMeta = const VerificationMeta(
    'airDate',
  );
  @override
  late final GeneratedColumn<DateTime> airDate = GeneratedColumn<DateTime>(
    'air_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    showId,
    seasonNumber,
    name,
    airDate,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'seasons';
  @override
  VerificationContext validateIntegrity(
    Insertable<Season> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('show_id')) {
      context.handle(
        _showIdMeta,
        showId.isAcceptableOrUnknown(data['show_id']!, _showIdMeta),
      );
    } else if (isInserting) {
      context.missing(_showIdMeta);
    }
    if (data.containsKey('season_number')) {
      context.handle(
        _seasonNumberMeta,
        seasonNumber.isAcceptableOrUnknown(
          data['season_number']!,
          _seasonNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_seasonNumberMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('air_date')) {
      context.handle(
        _airDateMeta,
        airDate.isAcceptableOrUnknown(data['air_date']!, _airDateMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Season map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Season(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      showId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}show_id'],
      )!,
      seasonNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}season_number'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      airDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}air_date'],
      ),
    );
  }

  @override
  $SeasonsTable createAlias(String alias) {
    return $SeasonsTable(attachedDatabase, alias);
  }
}

class Season extends DataClass implements Insertable<Season> {
  final int id;
  final int showId;
  final int seasonNumber;
  final String name;
  final DateTime? airDate;
  const Season({
    required this.id,
    required this.showId,
    required this.seasonNumber,
    required this.name,
    this.airDate,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['show_id'] = Variable<int>(showId);
    map['season_number'] = Variable<int>(seasonNumber);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || airDate != null) {
      map['air_date'] = Variable<DateTime>(airDate);
    }
    return map;
  }

  SeasonsCompanion toCompanion(bool nullToAbsent) {
    return SeasonsCompanion(
      id: Value(id),
      showId: Value(showId),
      seasonNumber: Value(seasonNumber),
      name: Value(name),
      airDate: airDate == null && nullToAbsent
          ? const Value.absent()
          : Value(airDate),
    );
  }

  factory Season.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Season(
      id: serializer.fromJson<int>(json['id']),
      showId: serializer.fromJson<int>(json['showId']),
      seasonNumber: serializer.fromJson<int>(json['seasonNumber']),
      name: serializer.fromJson<String>(json['name']),
      airDate: serializer.fromJson<DateTime?>(json['airDate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'showId': serializer.toJson<int>(showId),
      'seasonNumber': serializer.toJson<int>(seasonNumber),
      'name': serializer.toJson<String>(name),
      'airDate': serializer.toJson<DateTime?>(airDate),
    };
  }

  Season copyWith({
    int? id,
    int? showId,
    int? seasonNumber,
    String? name,
    Value<DateTime?> airDate = const Value.absent(),
  }) => Season(
    id: id ?? this.id,
    showId: showId ?? this.showId,
    seasonNumber: seasonNumber ?? this.seasonNumber,
    name: name ?? this.name,
    airDate: airDate.present ? airDate.value : this.airDate,
  );
  Season copyWithCompanion(SeasonsCompanion data) {
    return Season(
      id: data.id.present ? data.id.value : this.id,
      showId: data.showId.present ? data.showId.value : this.showId,
      seasonNumber: data.seasonNumber.present
          ? data.seasonNumber.value
          : this.seasonNumber,
      name: data.name.present ? data.name.value : this.name,
      airDate: data.airDate.present ? data.airDate.value : this.airDate,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Season(')
          ..write('id: $id, ')
          ..write('showId: $showId, ')
          ..write('seasonNumber: $seasonNumber, ')
          ..write('name: $name, ')
          ..write('airDate: $airDate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, showId, seasonNumber, name, airDate);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Season &&
          other.id == this.id &&
          other.showId == this.showId &&
          other.seasonNumber == this.seasonNumber &&
          other.name == this.name &&
          other.airDate == this.airDate);
}

class SeasonsCompanion extends UpdateCompanion<Season> {
  final Value<int> id;
  final Value<int> showId;
  final Value<int> seasonNumber;
  final Value<String> name;
  final Value<DateTime?> airDate;
  const SeasonsCompanion({
    this.id = const Value.absent(),
    this.showId = const Value.absent(),
    this.seasonNumber = const Value.absent(),
    this.name = const Value.absent(),
    this.airDate = const Value.absent(),
  });
  SeasonsCompanion.insert({
    this.id = const Value.absent(),
    required int showId,
    required int seasonNumber,
    required String name,
    this.airDate = const Value.absent(),
  }) : showId = Value(showId),
       seasonNumber = Value(seasonNumber),
       name = Value(name);
  static Insertable<Season> custom({
    Expression<int>? id,
    Expression<int>? showId,
    Expression<int>? seasonNumber,
    Expression<String>? name,
    Expression<DateTime>? airDate,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (showId != null) 'show_id': showId,
      if (seasonNumber != null) 'season_number': seasonNumber,
      if (name != null) 'name': name,
      if (airDate != null) 'air_date': airDate,
    });
  }

  SeasonsCompanion copyWith({
    Value<int>? id,
    Value<int>? showId,
    Value<int>? seasonNumber,
    Value<String>? name,
    Value<DateTime?>? airDate,
  }) {
    return SeasonsCompanion(
      id: id ?? this.id,
      showId: showId ?? this.showId,
      seasonNumber: seasonNumber ?? this.seasonNumber,
      name: name ?? this.name,
      airDate: airDate ?? this.airDate,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (showId.present) {
      map['show_id'] = Variable<int>(showId.value);
    }
    if (seasonNumber.present) {
      map['season_number'] = Variable<int>(seasonNumber.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (airDate.present) {
      map['air_date'] = Variable<DateTime>(airDate.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SeasonsCompanion(')
          ..write('id: $id, ')
          ..write('showId: $showId, ')
          ..write('seasonNumber: $seasonNumber, ')
          ..write('name: $name, ')
          ..write('airDate: $airDate')
          ..write(')'))
        .toString();
  }
}

class $EpisodesTable extends Episodes with TableInfo<$EpisodesTable, Episode> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EpisodesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _seasonIdMeta = const VerificationMeta(
    'seasonId',
  );
  @override
  late final GeneratedColumn<int> seasonId = GeneratedColumn<int>(
    'season_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES seasons (id)',
    ),
  );
  static const VerificationMeta _showIdMeta = const VerificationMeta('showId');
  @override
  late final GeneratedColumn<int> showId = GeneratedColumn<int>(
    'show_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES tv_shows (id)',
    ),
  );
  static const VerificationMeta _episodeNumberMeta = const VerificationMeta(
    'episodeNumber',
  );
  @override
  late final GeneratedColumn<int> episodeNumber = GeneratedColumn<int>(
    'episode_number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _airDateMeta = const VerificationMeta(
    'airDate',
  );
  @override
  late final GeneratedColumn<DateTime> airDate = GeneratedColumn<DateTime>(
    'air_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isWatchedMeta = const VerificationMeta(
    'isWatched',
  );
  @override
  late final GeneratedColumn<bool> isWatched = GeneratedColumn<bool>(
    'is_watched',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_watched" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _watchedAtMeta = const VerificationMeta(
    'watchedAt',
  );
  @override
  late final GeneratedColumn<DateTime> watchedAt = GeneratedColumn<DateTime>(
    'watched_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    seasonId,
    showId,
    episodeNumber,
    title,
    airDate,
    isWatched,
    watchedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'episodes';
  @override
  VerificationContext validateIntegrity(
    Insertable<Episode> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('season_id')) {
      context.handle(
        _seasonIdMeta,
        seasonId.isAcceptableOrUnknown(data['season_id']!, _seasonIdMeta),
      );
    } else if (isInserting) {
      context.missing(_seasonIdMeta);
    }
    if (data.containsKey('show_id')) {
      context.handle(
        _showIdMeta,
        showId.isAcceptableOrUnknown(data['show_id']!, _showIdMeta),
      );
    } else if (isInserting) {
      context.missing(_showIdMeta);
    }
    if (data.containsKey('episode_number')) {
      context.handle(
        _episodeNumberMeta,
        episodeNumber.isAcceptableOrUnknown(
          data['episode_number']!,
          _episodeNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_episodeNumberMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('air_date')) {
      context.handle(
        _airDateMeta,
        airDate.isAcceptableOrUnknown(data['air_date']!, _airDateMeta),
      );
    }
    if (data.containsKey('is_watched')) {
      context.handle(
        _isWatchedMeta,
        isWatched.isAcceptableOrUnknown(data['is_watched']!, _isWatchedMeta),
      );
    }
    if (data.containsKey('watched_at')) {
      context.handle(
        _watchedAtMeta,
        watchedAt.isAcceptableOrUnknown(data['watched_at']!, _watchedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Episode map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Episode(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      seasonId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}season_id'],
      )!,
      showId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}show_id'],
      )!,
      episodeNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}episode_number'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      airDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}air_date'],
      ),
      isWatched: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_watched'],
      )!,
      watchedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}watched_at'],
      ),
    );
  }

  @override
  $EpisodesTable createAlias(String alias) {
    return $EpisodesTable(attachedDatabase, alias);
  }
}

class Episode extends DataClass implements Insertable<Episode> {
  final int id;
  final int seasonId;
  final int showId;
  final int episodeNumber;
  final String title;
  final DateTime? airDate;
  final bool isWatched;
  final DateTime? watchedAt;
  const Episode({
    required this.id,
    required this.seasonId,
    required this.showId,
    required this.episodeNumber,
    required this.title,
    this.airDate,
    required this.isWatched,
    this.watchedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['season_id'] = Variable<int>(seasonId);
    map['show_id'] = Variable<int>(showId);
    map['episode_number'] = Variable<int>(episodeNumber);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || airDate != null) {
      map['air_date'] = Variable<DateTime>(airDate);
    }
    map['is_watched'] = Variable<bool>(isWatched);
    if (!nullToAbsent || watchedAt != null) {
      map['watched_at'] = Variable<DateTime>(watchedAt);
    }
    return map;
  }

  EpisodesCompanion toCompanion(bool nullToAbsent) {
    return EpisodesCompanion(
      id: Value(id),
      seasonId: Value(seasonId),
      showId: Value(showId),
      episodeNumber: Value(episodeNumber),
      title: Value(title),
      airDate: airDate == null && nullToAbsent
          ? const Value.absent()
          : Value(airDate),
      isWatched: Value(isWatched),
      watchedAt: watchedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(watchedAt),
    );
  }

  factory Episode.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Episode(
      id: serializer.fromJson<int>(json['id']),
      seasonId: serializer.fromJson<int>(json['seasonId']),
      showId: serializer.fromJson<int>(json['showId']),
      episodeNumber: serializer.fromJson<int>(json['episodeNumber']),
      title: serializer.fromJson<String>(json['title']),
      airDate: serializer.fromJson<DateTime?>(json['airDate']),
      isWatched: serializer.fromJson<bool>(json['isWatched']),
      watchedAt: serializer.fromJson<DateTime?>(json['watchedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'seasonId': serializer.toJson<int>(seasonId),
      'showId': serializer.toJson<int>(showId),
      'episodeNumber': serializer.toJson<int>(episodeNumber),
      'title': serializer.toJson<String>(title),
      'airDate': serializer.toJson<DateTime?>(airDate),
      'isWatched': serializer.toJson<bool>(isWatched),
      'watchedAt': serializer.toJson<DateTime?>(watchedAt),
    };
  }

  Episode copyWith({
    int? id,
    int? seasonId,
    int? showId,
    int? episodeNumber,
    String? title,
    Value<DateTime?> airDate = const Value.absent(),
    bool? isWatched,
    Value<DateTime?> watchedAt = const Value.absent(),
  }) => Episode(
    id: id ?? this.id,
    seasonId: seasonId ?? this.seasonId,
    showId: showId ?? this.showId,
    episodeNumber: episodeNumber ?? this.episodeNumber,
    title: title ?? this.title,
    airDate: airDate.present ? airDate.value : this.airDate,
    isWatched: isWatched ?? this.isWatched,
    watchedAt: watchedAt.present ? watchedAt.value : this.watchedAt,
  );
  Episode copyWithCompanion(EpisodesCompanion data) {
    return Episode(
      id: data.id.present ? data.id.value : this.id,
      seasonId: data.seasonId.present ? data.seasonId.value : this.seasonId,
      showId: data.showId.present ? data.showId.value : this.showId,
      episodeNumber: data.episodeNumber.present
          ? data.episodeNumber.value
          : this.episodeNumber,
      title: data.title.present ? data.title.value : this.title,
      airDate: data.airDate.present ? data.airDate.value : this.airDate,
      isWatched: data.isWatched.present ? data.isWatched.value : this.isWatched,
      watchedAt: data.watchedAt.present ? data.watchedAt.value : this.watchedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Episode(')
          ..write('id: $id, ')
          ..write('seasonId: $seasonId, ')
          ..write('showId: $showId, ')
          ..write('episodeNumber: $episodeNumber, ')
          ..write('title: $title, ')
          ..write('airDate: $airDate, ')
          ..write('isWatched: $isWatched, ')
          ..write('watchedAt: $watchedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    seasonId,
    showId,
    episodeNumber,
    title,
    airDate,
    isWatched,
    watchedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Episode &&
          other.id == this.id &&
          other.seasonId == this.seasonId &&
          other.showId == this.showId &&
          other.episodeNumber == this.episodeNumber &&
          other.title == this.title &&
          other.airDate == this.airDate &&
          other.isWatched == this.isWatched &&
          other.watchedAt == this.watchedAt);
}

class EpisodesCompanion extends UpdateCompanion<Episode> {
  final Value<int> id;
  final Value<int> seasonId;
  final Value<int> showId;
  final Value<int> episodeNumber;
  final Value<String> title;
  final Value<DateTime?> airDate;
  final Value<bool> isWatched;
  final Value<DateTime?> watchedAt;
  const EpisodesCompanion({
    this.id = const Value.absent(),
    this.seasonId = const Value.absent(),
    this.showId = const Value.absent(),
    this.episodeNumber = const Value.absent(),
    this.title = const Value.absent(),
    this.airDate = const Value.absent(),
    this.isWatched = const Value.absent(),
    this.watchedAt = const Value.absent(),
  });
  EpisodesCompanion.insert({
    this.id = const Value.absent(),
    required int seasonId,
    required int showId,
    required int episodeNumber,
    required String title,
    this.airDate = const Value.absent(),
    this.isWatched = const Value.absent(),
    this.watchedAt = const Value.absent(),
  }) : seasonId = Value(seasonId),
       showId = Value(showId),
       episodeNumber = Value(episodeNumber),
       title = Value(title);
  static Insertable<Episode> custom({
    Expression<int>? id,
    Expression<int>? seasonId,
    Expression<int>? showId,
    Expression<int>? episodeNumber,
    Expression<String>? title,
    Expression<DateTime>? airDate,
    Expression<bool>? isWatched,
    Expression<DateTime>? watchedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (seasonId != null) 'season_id': seasonId,
      if (showId != null) 'show_id': showId,
      if (episodeNumber != null) 'episode_number': episodeNumber,
      if (title != null) 'title': title,
      if (airDate != null) 'air_date': airDate,
      if (isWatched != null) 'is_watched': isWatched,
      if (watchedAt != null) 'watched_at': watchedAt,
    });
  }

  EpisodesCompanion copyWith({
    Value<int>? id,
    Value<int>? seasonId,
    Value<int>? showId,
    Value<int>? episodeNumber,
    Value<String>? title,
    Value<DateTime?>? airDate,
    Value<bool>? isWatched,
    Value<DateTime?>? watchedAt,
  }) {
    return EpisodesCompanion(
      id: id ?? this.id,
      seasonId: seasonId ?? this.seasonId,
      showId: showId ?? this.showId,
      episodeNumber: episodeNumber ?? this.episodeNumber,
      title: title ?? this.title,
      airDate: airDate ?? this.airDate,
      isWatched: isWatched ?? this.isWatched,
      watchedAt: watchedAt ?? this.watchedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (seasonId.present) {
      map['season_id'] = Variable<int>(seasonId.value);
    }
    if (showId.present) {
      map['show_id'] = Variable<int>(showId.value);
    }
    if (episodeNumber.present) {
      map['episode_number'] = Variable<int>(episodeNumber.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (airDate.present) {
      map['air_date'] = Variable<DateTime>(airDate.value);
    }
    if (isWatched.present) {
      map['is_watched'] = Variable<bool>(isWatched.value);
    }
    if (watchedAt.present) {
      map['watched_at'] = Variable<DateTime>(watchedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EpisodesCompanion(')
          ..write('id: $id, ')
          ..write('seasonId: $seasonId, ')
          ..write('showId: $showId, ')
          ..write('episodeNumber: $episodeNumber, ')
          ..write('title: $title, ')
          ..write('airDate: $airDate, ')
          ..write('isWatched: $isWatched, ')
          ..write('watchedAt: $watchedAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $MoviesTable movies = $MoviesTable(this);
  late final $TvShowsTable tvShows = $TvShowsTable(this);
  late final $SeasonsTable seasons = $SeasonsTable(this);
  late final $EpisodesTable episodes = $EpisodesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    movies,
    tvShows,
    seasons,
    episodes,
  ];
}

typedef $$MoviesTableCreateCompanionBuilder =
    MoviesCompanion Function({
      Value<int> id,
      required String title,
      Value<String?> posterPath,
      required String overview,
      Value<DateTime?> releaseDate,
      Value<String> status,
      Value<DateTime> addedAt,
      Value<String?> genres,
      Value<String?> castList,
      Value<String?> trailerKey,
    });
typedef $$MoviesTableUpdateCompanionBuilder =
    MoviesCompanion Function({
      Value<int> id,
      Value<String> title,
      Value<String?> posterPath,
      Value<String> overview,
      Value<DateTime?> releaseDate,
      Value<String> status,
      Value<DateTime> addedAt,
      Value<String?> genres,
      Value<String?> castList,
      Value<String?> trailerKey,
    });

class $$MoviesTableFilterComposer
    extends Composer<_$AppDatabase, $MoviesTable> {
  $$MoviesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get posterPath => $composableBuilder(
    column: $table.posterPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get overview => $composableBuilder(
    column: $table.overview,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get releaseDate => $composableBuilder(
    column: $table.releaseDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get addedAt => $composableBuilder(
    column: $table.addedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get genres => $composableBuilder(
    column: $table.genres,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get castList => $composableBuilder(
    column: $table.castList,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get trailerKey => $composableBuilder(
    column: $table.trailerKey,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MoviesTableOrderingComposer
    extends Composer<_$AppDatabase, $MoviesTable> {
  $$MoviesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get posterPath => $composableBuilder(
    column: $table.posterPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get overview => $composableBuilder(
    column: $table.overview,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get releaseDate => $composableBuilder(
    column: $table.releaseDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get addedAt => $composableBuilder(
    column: $table.addedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get genres => $composableBuilder(
    column: $table.genres,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get castList => $composableBuilder(
    column: $table.castList,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get trailerKey => $composableBuilder(
    column: $table.trailerKey,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MoviesTableAnnotationComposer
    extends Composer<_$AppDatabase, $MoviesTable> {
  $$MoviesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get posterPath => $composableBuilder(
    column: $table.posterPath,
    builder: (column) => column,
  );

  GeneratedColumn<String> get overview =>
      $composableBuilder(column: $table.overview, builder: (column) => column);

  GeneratedColumn<DateTime> get releaseDate => $composableBuilder(
    column: $table.releaseDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get addedAt =>
      $composableBuilder(column: $table.addedAt, builder: (column) => column);

  GeneratedColumn<String> get genres =>
      $composableBuilder(column: $table.genres, builder: (column) => column);

  GeneratedColumn<String> get castList =>
      $composableBuilder(column: $table.castList, builder: (column) => column);

  GeneratedColumn<String> get trailerKey => $composableBuilder(
    column: $table.trailerKey,
    builder: (column) => column,
  );
}

class $$MoviesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MoviesTable,
          Movie,
          $$MoviesTableFilterComposer,
          $$MoviesTableOrderingComposer,
          $$MoviesTableAnnotationComposer,
          $$MoviesTableCreateCompanionBuilder,
          $$MoviesTableUpdateCompanionBuilder,
          (Movie, BaseReferences<_$AppDatabase, $MoviesTable, Movie>),
          Movie,
          PrefetchHooks Function()
        > {
  $$MoviesTableTableManager(_$AppDatabase db, $MoviesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MoviesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MoviesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MoviesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> posterPath = const Value.absent(),
                Value<String> overview = const Value.absent(),
                Value<DateTime?> releaseDate = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime> addedAt = const Value.absent(),
                Value<String?> genres = const Value.absent(),
                Value<String?> castList = const Value.absent(),
                Value<String?> trailerKey = const Value.absent(),
              }) => MoviesCompanion(
                id: id,
                title: title,
                posterPath: posterPath,
                overview: overview,
                releaseDate: releaseDate,
                status: status,
                addedAt: addedAt,
                genres: genres,
                castList: castList,
                trailerKey: trailerKey,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String title,
                Value<String?> posterPath = const Value.absent(),
                required String overview,
                Value<DateTime?> releaseDate = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime> addedAt = const Value.absent(),
                Value<String?> genres = const Value.absent(),
                Value<String?> castList = const Value.absent(),
                Value<String?> trailerKey = const Value.absent(),
              }) => MoviesCompanion.insert(
                id: id,
                title: title,
                posterPath: posterPath,
                overview: overview,
                releaseDate: releaseDate,
                status: status,
                addedAt: addedAt,
                genres: genres,
                castList: castList,
                trailerKey: trailerKey,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$MoviesTable, Movie>(table),
                  BaseReferences<_$AppDatabase, $MoviesTable, Movie>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MoviesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MoviesTable,
      Movie,
      $$MoviesTableFilterComposer,
      $$MoviesTableOrderingComposer,
      $$MoviesTableAnnotationComposer,
      $$MoviesTableCreateCompanionBuilder,
      $$MoviesTableUpdateCompanionBuilder,
      (Movie, BaseReferences<_$AppDatabase, $MoviesTable, Movie>),
      Movie,
      PrefetchHooks Function()
    >;
typedef $$TvShowsTableCreateCompanionBuilder =
    TvShowsCompanion Function({
      Value<int> id,
      required String title,
      Value<String?> posterPath,
      required String overview,
      Value<String> status,
      Value<DateTime?> nextEpisodeAirDate,
      Value<DateTime> addedAt,
      Value<String?> genres,
      Value<String?> castList,
      Value<String?> trailerKey,
    });
typedef $$TvShowsTableUpdateCompanionBuilder =
    TvShowsCompanion Function({
      Value<int> id,
      Value<String> title,
      Value<String?> posterPath,
      Value<String> overview,
      Value<String> status,
      Value<DateTime?> nextEpisodeAirDate,
      Value<DateTime> addedAt,
      Value<String?> genres,
      Value<String?> castList,
      Value<String?> trailerKey,
    });

final class $$TvShowsTableReferences
    extends BaseReferences<_$AppDatabase, $TvShowsTable, TvShow> {
  $$TvShowsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$SeasonsTable, List<Season>> _seasonsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.seasons,
    aliasName: 'tv_shows__id__seasons__show_id',
  );

  $$SeasonsTableProcessedTableManager get seasonsRefs {
    final manager = $$SeasonsTableTableManager(
      $_db,
      $_db.seasons,
    ).filter((f) => f.showId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_seasonsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$EpisodesTable, List<Episode>> _episodesRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.episodes,
    aliasName: 'tv_shows__id__episodes__show_id',
  );

  $$EpisodesTableProcessedTableManager get episodesRefs {
    final manager = $$EpisodesTableTableManager(
      $_db,
      $_db.episodes,
    ).filter((f) => f.showId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_episodesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TvShowsTableFilterComposer
    extends Composer<_$AppDatabase, $TvShowsTable> {
  $$TvShowsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get posterPath => $composableBuilder(
    column: $table.posterPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get overview => $composableBuilder(
    column: $table.overview,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get nextEpisodeAirDate => $composableBuilder(
    column: $table.nextEpisodeAirDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get addedAt => $composableBuilder(
    column: $table.addedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get genres => $composableBuilder(
    column: $table.genres,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get castList => $composableBuilder(
    column: $table.castList,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get trailerKey => $composableBuilder(
    column: $table.trailerKey,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> seasonsRefs(
    Expression<bool> Function($$SeasonsTableFilterComposer f) f,
  ) {
    final $$SeasonsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.seasons,
      getReferencedColumn: (t) => t.showId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SeasonsTableFilterComposer(
            $db: $db,
            $table: $db.seasons,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> episodesRefs(
    Expression<bool> Function($$EpisodesTableFilterComposer f) f,
  ) {
    final $$EpisodesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.episodes,
      getReferencedColumn: (t) => t.showId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EpisodesTableFilterComposer(
            $db: $db,
            $table: $db.episodes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TvShowsTableOrderingComposer
    extends Composer<_$AppDatabase, $TvShowsTable> {
  $$TvShowsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get posterPath => $composableBuilder(
    column: $table.posterPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get overview => $composableBuilder(
    column: $table.overview,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get nextEpisodeAirDate => $composableBuilder(
    column: $table.nextEpisodeAirDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get addedAt => $composableBuilder(
    column: $table.addedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get genres => $composableBuilder(
    column: $table.genres,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get castList => $composableBuilder(
    column: $table.castList,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get trailerKey => $composableBuilder(
    column: $table.trailerKey,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TvShowsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TvShowsTable> {
  $$TvShowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get posterPath => $composableBuilder(
    column: $table.posterPath,
    builder: (column) => column,
  );

  GeneratedColumn<String> get overview =>
      $composableBuilder(column: $table.overview, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get nextEpisodeAirDate => $composableBuilder(
    column: $table.nextEpisodeAirDate,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get addedAt =>
      $composableBuilder(column: $table.addedAt, builder: (column) => column);

  GeneratedColumn<String> get genres =>
      $composableBuilder(column: $table.genres, builder: (column) => column);

  GeneratedColumn<String> get castList =>
      $composableBuilder(column: $table.castList, builder: (column) => column);

  GeneratedColumn<String> get trailerKey => $composableBuilder(
    column: $table.trailerKey,
    builder: (column) => column,
  );

  Expression<T> seasonsRefs<T extends Object>(
    Expression<T> Function($$SeasonsTableAnnotationComposer a) f,
  ) {
    final $$SeasonsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.seasons,
      getReferencedColumn: (t) => t.showId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SeasonsTableAnnotationComposer(
            $db: $db,
            $table: $db.seasons,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> episodesRefs<T extends Object>(
    Expression<T> Function($$EpisodesTableAnnotationComposer a) f,
  ) {
    final $$EpisodesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.episodes,
      getReferencedColumn: (t) => t.showId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EpisodesTableAnnotationComposer(
            $db: $db,
            $table: $db.episodes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TvShowsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TvShowsTable,
          TvShow,
          $$TvShowsTableFilterComposer,
          $$TvShowsTableOrderingComposer,
          $$TvShowsTableAnnotationComposer,
          $$TvShowsTableCreateCompanionBuilder,
          $$TvShowsTableUpdateCompanionBuilder,
          (TvShow, $$TvShowsTableReferences),
          TvShow,
          PrefetchHooks Function({bool seasonsRefs, bool episodesRefs})
        > {
  $$TvShowsTableTableManager(_$AppDatabase db, $TvShowsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TvShowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TvShowsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TvShowsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> posterPath = const Value.absent(),
                Value<String> overview = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime?> nextEpisodeAirDate = const Value.absent(),
                Value<DateTime> addedAt = const Value.absent(),
                Value<String?> genres = const Value.absent(),
                Value<String?> castList = const Value.absent(),
                Value<String?> trailerKey = const Value.absent(),
              }) => TvShowsCompanion(
                id: id,
                title: title,
                posterPath: posterPath,
                overview: overview,
                status: status,
                nextEpisodeAirDate: nextEpisodeAirDate,
                addedAt: addedAt,
                genres: genres,
                castList: castList,
                trailerKey: trailerKey,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String title,
                Value<String?> posterPath = const Value.absent(),
                required String overview,
                Value<String> status = const Value.absent(),
                Value<DateTime?> nextEpisodeAirDate = const Value.absent(),
                Value<DateTime> addedAt = const Value.absent(),
                Value<String?> genres = const Value.absent(),
                Value<String?> castList = const Value.absent(),
                Value<String?> trailerKey = const Value.absent(),
              }) => TvShowsCompanion.insert(
                id: id,
                title: title,
                posterPath: posterPath,
                overview: overview,
                status: status,
                nextEpisodeAirDate: nextEpisodeAirDate,
                addedAt: addedAt,
                genres: genres,
                castList: castList,
                trailerKey: trailerKey,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$TvShowsTable, TvShow>(table),
                  $$TvShowsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({seasonsRefs = false, episodesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (seasonsRefs) db.seasons,
                if (episodesRefs) db.episodes,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (seasonsRefs)
                    await $_getPrefetchedData<TvShow, $TvShowsTable, Season>(
                      currentTable: table,
                      referencedTable: $$TvShowsTableReferences
                          ._seasonsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$TvShowsTableReferences(db, table, p0).seasonsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.showId == item.id),
                      typedResults: items,
                    ),
                  if (episodesRefs)
                    await $_getPrefetchedData<TvShow, $TvShowsTable, Episode>(
                      currentTable: table,
                      referencedTable: $$TvShowsTableReferences
                          ._episodesRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$TvShowsTableReferences(db, table, p0).episodesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.showId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$TvShowsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TvShowsTable,
      TvShow,
      $$TvShowsTableFilterComposer,
      $$TvShowsTableOrderingComposer,
      $$TvShowsTableAnnotationComposer,
      $$TvShowsTableCreateCompanionBuilder,
      $$TvShowsTableUpdateCompanionBuilder,
      (TvShow, $$TvShowsTableReferences),
      TvShow,
      PrefetchHooks Function({bool seasonsRefs, bool episodesRefs})
    >;
typedef $$SeasonsTableCreateCompanionBuilder =
    SeasonsCompanion Function({
      Value<int> id,
      required int showId,
      required int seasonNumber,
      required String name,
      Value<DateTime?> airDate,
    });
typedef $$SeasonsTableUpdateCompanionBuilder =
    SeasonsCompanion Function({
      Value<int> id,
      Value<int> showId,
      Value<int> seasonNumber,
      Value<String> name,
      Value<DateTime?> airDate,
    });

final class $$SeasonsTableReferences
    extends BaseReferences<_$AppDatabase, $SeasonsTable, Season> {
  $$SeasonsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $TvShowsTable _showIdTable(_$AppDatabase db) =>
      db.tvShows.createAlias('seasons__show_id__tv_shows__id');

  $$TvShowsTableProcessedTableManager get showId {
    final $_column = $_itemColumn<int>('show_id')!;

    final manager = $$TvShowsTableTableManager(
      $_db,
      $_db.tvShows,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_showIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$EpisodesTable, List<Episode>> _episodesRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.episodes,
    aliasName: 'seasons__id__episodes__season_id',
  );

  $$EpisodesTableProcessedTableManager get episodesRefs {
    final manager = $$EpisodesTableTableManager(
      $_db,
      $_db.episodes,
    ).filter((f) => f.seasonId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_episodesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$SeasonsTableFilterComposer
    extends Composer<_$AppDatabase, $SeasonsTable> {
  $$SeasonsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get seasonNumber => $composableBuilder(
    column: $table.seasonNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get airDate => $composableBuilder(
    column: $table.airDate,
    builder: (column) => ColumnFilters(column),
  );

  $$TvShowsTableFilterComposer get showId {
    final $$TvShowsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.showId,
      referencedTable: $db.tvShows,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TvShowsTableFilterComposer(
            $db: $db,
            $table: $db.tvShows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> episodesRefs(
    Expression<bool> Function($$EpisodesTableFilterComposer f) f,
  ) {
    final $$EpisodesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.episodes,
      getReferencedColumn: (t) => t.seasonId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EpisodesTableFilterComposer(
            $db: $db,
            $table: $db.episodes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SeasonsTableOrderingComposer
    extends Composer<_$AppDatabase, $SeasonsTable> {
  $$SeasonsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get seasonNumber => $composableBuilder(
    column: $table.seasonNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get airDate => $composableBuilder(
    column: $table.airDate,
    builder: (column) => ColumnOrderings(column),
  );

  $$TvShowsTableOrderingComposer get showId {
    final $$TvShowsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.showId,
      referencedTable: $db.tvShows,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TvShowsTableOrderingComposer(
            $db: $db,
            $table: $db.tvShows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SeasonsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SeasonsTable> {
  $$SeasonsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get seasonNumber => $composableBuilder(
    column: $table.seasonNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<DateTime> get airDate =>
      $composableBuilder(column: $table.airDate, builder: (column) => column);

  $$TvShowsTableAnnotationComposer get showId {
    final $$TvShowsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.showId,
      referencedTable: $db.tvShows,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TvShowsTableAnnotationComposer(
            $db: $db,
            $table: $db.tvShows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> episodesRefs<T extends Object>(
    Expression<T> Function($$EpisodesTableAnnotationComposer a) f,
  ) {
    final $$EpisodesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.episodes,
      getReferencedColumn: (t) => t.seasonId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EpisodesTableAnnotationComposer(
            $db: $db,
            $table: $db.episodes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SeasonsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SeasonsTable,
          Season,
          $$SeasonsTableFilterComposer,
          $$SeasonsTableOrderingComposer,
          $$SeasonsTableAnnotationComposer,
          $$SeasonsTableCreateCompanionBuilder,
          $$SeasonsTableUpdateCompanionBuilder,
          (Season, $$SeasonsTableReferences),
          Season,
          PrefetchHooks Function({bool showId, bool episodesRefs})
        > {
  $$SeasonsTableTableManager(_$AppDatabase db, $SeasonsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SeasonsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SeasonsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SeasonsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> showId = const Value.absent(),
                Value<int> seasonNumber = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<DateTime?> airDate = const Value.absent(),
              }) => SeasonsCompanion(
                id: id,
                showId: showId,
                seasonNumber: seasonNumber,
                name: name,
                airDate: airDate,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int showId,
                required int seasonNumber,
                required String name,
                Value<DateTime?> airDate = const Value.absent(),
              }) => SeasonsCompanion.insert(
                id: id,
                showId: showId,
                seasonNumber: seasonNumber,
                name: name,
                airDate: airDate,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SeasonsTable, Season>(table),
                  $$SeasonsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({showId = false, episodesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (episodesRefs) db.episodes],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (showId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.showId,
                                referencedTable: $$SeasonsTableReferences
                                    ._showIdTable(db),
                                referencedColumn: $$SeasonsTableReferences
                                    ._showIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (episodesRefs)
                    await $_getPrefetchedData<Season, $SeasonsTable, Episode>(
                      currentTable: table,
                      referencedTable: $$SeasonsTableReferences
                          ._episodesRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$SeasonsTableReferences(db, table, p0).episodesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.seasonId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$SeasonsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SeasonsTable,
      Season,
      $$SeasonsTableFilterComposer,
      $$SeasonsTableOrderingComposer,
      $$SeasonsTableAnnotationComposer,
      $$SeasonsTableCreateCompanionBuilder,
      $$SeasonsTableUpdateCompanionBuilder,
      (Season, $$SeasonsTableReferences),
      Season,
      PrefetchHooks Function({bool showId, bool episodesRefs})
    >;
typedef $$EpisodesTableCreateCompanionBuilder =
    EpisodesCompanion Function({
      Value<int> id,
      required int seasonId,
      required int showId,
      required int episodeNumber,
      required String title,
      Value<DateTime?> airDate,
      Value<bool> isWatched,
      Value<DateTime?> watchedAt,
    });
typedef $$EpisodesTableUpdateCompanionBuilder =
    EpisodesCompanion Function({
      Value<int> id,
      Value<int> seasonId,
      Value<int> showId,
      Value<int> episodeNumber,
      Value<String> title,
      Value<DateTime?> airDate,
      Value<bool> isWatched,
      Value<DateTime?> watchedAt,
    });

final class $$EpisodesTableReferences
    extends BaseReferences<_$AppDatabase, $EpisodesTable, Episode> {
  $$EpisodesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $SeasonsTable _seasonIdTable(_$AppDatabase db) =>
      db.seasons.createAlias('episodes__season_id__seasons__id');

  $$SeasonsTableProcessedTableManager get seasonId {
    final $_column = $_itemColumn<int>('season_id')!;

    final manager = $$SeasonsTableTableManager(
      $_db,
      $_db.seasons,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_seasonIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $TvShowsTable _showIdTable(_$AppDatabase db) =>
      db.tvShows.createAlias('episodes__show_id__tv_shows__id');

  $$TvShowsTableProcessedTableManager get showId {
    final $_column = $_itemColumn<int>('show_id')!;

    final manager = $$TvShowsTableTableManager(
      $_db,
      $_db.tvShows,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_showIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$EpisodesTableFilterComposer
    extends Composer<_$AppDatabase, $EpisodesTable> {
  $$EpisodesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get episodeNumber => $composableBuilder(
    column: $table.episodeNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get airDate => $composableBuilder(
    column: $table.airDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isWatched => $composableBuilder(
    column: $table.isWatched,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get watchedAt => $composableBuilder(
    column: $table.watchedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$SeasonsTableFilterComposer get seasonId {
    final $$SeasonsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.seasonId,
      referencedTable: $db.seasons,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SeasonsTableFilterComposer(
            $db: $db,
            $table: $db.seasons,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TvShowsTableFilterComposer get showId {
    final $$TvShowsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.showId,
      referencedTable: $db.tvShows,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TvShowsTableFilterComposer(
            $db: $db,
            $table: $db.tvShows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EpisodesTableOrderingComposer
    extends Composer<_$AppDatabase, $EpisodesTable> {
  $$EpisodesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get episodeNumber => $composableBuilder(
    column: $table.episodeNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get airDate => $composableBuilder(
    column: $table.airDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isWatched => $composableBuilder(
    column: $table.isWatched,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get watchedAt => $composableBuilder(
    column: $table.watchedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$SeasonsTableOrderingComposer get seasonId {
    final $$SeasonsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.seasonId,
      referencedTable: $db.seasons,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SeasonsTableOrderingComposer(
            $db: $db,
            $table: $db.seasons,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TvShowsTableOrderingComposer get showId {
    final $$TvShowsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.showId,
      referencedTable: $db.tvShows,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TvShowsTableOrderingComposer(
            $db: $db,
            $table: $db.tvShows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EpisodesTableAnnotationComposer
    extends Composer<_$AppDatabase, $EpisodesTable> {
  $$EpisodesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get episodeNumber => $composableBuilder(
    column: $table.episodeNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<DateTime> get airDate =>
      $composableBuilder(column: $table.airDate, builder: (column) => column);

  GeneratedColumn<bool> get isWatched =>
      $composableBuilder(column: $table.isWatched, builder: (column) => column);

  GeneratedColumn<DateTime> get watchedAt =>
      $composableBuilder(column: $table.watchedAt, builder: (column) => column);

  $$SeasonsTableAnnotationComposer get seasonId {
    final $$SeasonsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.seasonId,
      referencedTable: $db.seasons,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SeasonsTableAnnotationComposer(
            $db: $db,
            $table: $db.seasons,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TvShowsTableAnnotationComposer get showId {
    final $$TvShowsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.showId,
      referencedTable: $db.tvShows,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TvShowsTableAnnotationComposer(
            $db: $db,
            $table: $db.tvShows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EpisodesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EpisodesTable,
          Episode,
          $$EpisodesTableFilterComposer,
          $$EpisodesTableOrderingComposer,
          $$EpisodesTableAnnotationComposer,
          $$EpisodesTableCreateCompanionBuilder,
          $$EpisodesTableUpdateCompanionBuilder,
          (Episode, $$EpisodesTableReferences),
          Episode,
          PrefetchHooks Function({bool seasonId, bool showId})
        > {
  $$EpisodesTableTableManager(_$AppDatabase db, $EpisodesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EpisodesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EpisodesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EpisodesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> seasonId = const Value.absent(),
                Value<int> showId = const Value.absent(),
                Value<int> episodeNumber = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<DateTime?> airDate = const Value.absent(),
                Value<bool> isWatched = const Value.absent(),
                Value<DateTime?> watchedAt = const Value.absent(),
              }) => EpisodesCompanion(
                id: id,
                seasonId: seasonId,
                showId: showId,
                episodeNumber: episodeNumber,
                title: title,
                airDate: airDate,
                isWatched: isWatched,
                watchedAt: watchedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int seasonId,
                required int showId,
                required int episodeNumber,
                required String title,
                Value<DateTime?> airDate = const Value.absent(),
                Value<bool> isWatched = const Value.absent(),
                Value<DateTime?> watchedAt = const Value.absent(),
              }) => EpisodesCompanion.insert(
                id: id,
                seasonId: seasonId,
                showId: showId,
                episodeNumber: episodeNumber,
                title: title,
                airDate: airDate,
                isWatched: isWatched,
                watchedAt: watchedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$EpisodesTable, Episode>(table),
                  $$EpisodesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({seasonId = false, showId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (seasonId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.seasonId,
                                referencedTable: $$EpisodesTableReferences
                                    ._seasonIdTable(db),
                                referencedColumn: $$EpisodesTableReferences
                                    ._seasonIdTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (showId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.showId,
                                referencedTable: $$EpisodesTableReferences
                                    ._showIdTable(db),
                                referencedColumn: $$EpisodesTableReferences
                                    ._showIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$EpisodesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EpisodesTable,
      Episode,
      $$EpisodesTableFilterComposer,
      $$EpisodesTableOrderingComposer,
      $$EpisodesTableAnnotationComposer,
      $$EpisodesTableCreateCompanionBuilder,
      $$EpisodesTableUpdateCompanionBuilder,
      (Episode, $$EpisodesTableReferences),
      Episode,
      PrefetchHooks Function({bool seasonId, bool showId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$MoviesTableTableManager get movies =>
      $$MoviesTableTableManager(_db, _db.movies);
  $$TvShowsTableTableManager get tvShows =>
      $$TvShowsTableTableManager(_db, _db.tvShows);
  $$SeasonsTableTableManager get seasons =>
      $$SeasonsTableTableManager(_db, _db.seasons);
  $$EpisodesTableTableManager get episodes =>
      $$EpisodesTableTableManager(_db, _db.episodes);
}
