import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dio_provider.dart';

final tmdbRepositoryProvider = Provider<TmdbRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return TmdbRepository(dio);
});

class TmdbRepository {
  final Dio _dio;

  TmdbRepository(this._dio);

  Future<List<dynamic>> search(String query) async {
    final response = await _dio.get(
      '/search/multi',
      queryParameters: {'query': query, 'language': 'en-US'},
    );
    return response.data['results'];
  }

  Future<Map<String, dynamic>> getShowDetails(int showId) async {
    final response = await _dio.get(
      '/tv/$showId',
      queryParameters: {'append_to_response': 'credits'},
    );
    return response.data;
  }

  Future<List<dynamic>> getSeasonEpisodes(int showId, int seasonNumber) async {
    final response = await _dio.get('/tv/$showId/season/$seasonNumber');
    return response.data['episodes'];
  }

  Future<Map<String, dynamic>> getMovieDetails(int movieId) async {
    final response = await _dio.get(
      '/movie/$movieId',
      queryParameters: {'append_to_response': 'credits'},
    );
    return response.data;
  }
}
