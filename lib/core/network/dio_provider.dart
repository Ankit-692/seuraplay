import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final secureStorageProvider = Provider((ref) => const FlutterSecureStorage());

final dioProvider = Provider<Dio>((ref) {
  final storage = ref.watch(secureStorageProvider);

  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.tmdb.org/3',
      headers: {'accept': 'application/json'},
    ),
  );

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        final userTmdbToken = await storage.read(key: 'user_tmdb_token') ?? '';
        options.headers['Authorization'] = 'Bearer $userTmdbToken';
        return handler.next(options);
      },
    ),
  );

  return dio;
});
