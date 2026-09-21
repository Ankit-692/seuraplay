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
      queryParameters: {'append_to_response': 'credits,videos'},
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
      queryParameters: {'append_to_response': 'credits,videos'},
    );
    return response.data;
  }

  Future<List<dynamic>> getShowVideos(int showId) async {
    try {
      final response = await _dio.get('/tv/$showId/videos');
      return response.data['results'] ?? [];
    } catch (_) {
      return [];
    }
  }

  Future<List<dynamic>> getMovieVideos(int movieId) async {
    try {
      final response = await _dio.get('/movie/$movieId/videos');
      return response.data['results'] ?? [];
    } catch (_) {
      return [];
    }
  }

  Future<List<dynamic>> getPersonCredits(int personId) async {
    try {
      final response = await _dio.get('/person/$personId/combined_credits');
      final cast = response.data['cast'] as List<dynamic>? ?? [];
      
      // Filter out talk shows, documentaries, and appearances as "Self"
      final filteredCast = cast.where((c) {
        final character = (c['character'] as String?)?.toLowerCase() ?? '';
        if (character.contains('self') || character.contains('himself') || character.contains('herself') || character.contains('host') || character.contains('guest')) {
          return false;
        }
        
        final genres = c['genre_ids'] as List<dynamic>? ?? [];
        // 10767: Talk, 10763: News, 10764: Reality, 99: Documentary
        if (genres.contains(10767) || genres.contains(10763) || genres.contains(10764) || genres.contains(99)) {
          return false;
        }
        
        return true;
      }).toList();

      // Sort by popularity so the biggest movies show up first
      filteredCast.sort((a, b) => (b['popularity'] ?? 0).compareTo(a['popularity'] ?? 0));
      return filteredCast;
    } catch (_) {
      return [];
    }
  }
}
