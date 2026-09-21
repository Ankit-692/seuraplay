import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/movie_details_provider.dart';
import 'widgets/movie_details_app_bar.dart';
import 'widgets/movie_overview_section.dart';

class MovieDetailsScreen extends ConsumerWidget {
  final int movieId;

  const MovieDetailsScreen({super.key, required this.movieId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final movieAsync = ref.watch(movieMetadataProvider(movieId));

    return Scaffold(
      body: movieAsync.when(
        data: (movie) {
          if (movie == null) {
            return const CustomScrollView(
              slivers: [
                SliverAppBar(),
                SliverFillRemaining(child: Center(child: Text('Movie not found'))),
              ],
            );
          }

          final posterUrl = movie.posterPath != null
              ? 'https://image.tmdb.org/t/p/w500${movie.posterPath}'
              : null;

          final isWatched = movie.status == 'watched';
          final isUnreleased = movie.releaseDate != null && movie.releaseDate!.isAfter(DateTime.now());

          List<dynamic> castList = [];
          if (movie.castList != null && movie.castList!.isNotEmpty) {
            try {
              castList = jsonDecode(movie.castList!);
            } catch (e) {
              // ignore decoding errors
            }
          }

          return CustomScrollView(
            slivers: [
              MovieDetailsAppBar(
                movie: movie,
                movieId: movieId,
                posterUrl: posterUrl,
                isUnreleased: isUnreleased,
                isWatched: isWatched,
              ),
              SliverToBoxAdapter(
                child: MovieOverviewSection(
                  movie: movie,
                  movieId: movieId,
                  castList: castList,
                  isWatched: isWatched,
                  isUnreleased: isUnreleased,
                ),
              ),
            ],
          );
        },
        loading: () => const CustomScrollView(
          slivers: [
            SliverAppBar(),
            SliverFillRemaining(child: Center(child: CircularProgressIndicator())),
          ],
        ),
        error: (e, _) => CustomScrollView(
          slivers: [
            const SliverAppBar(),
            SliverFillRemaining(child: Center(child: Text('Error: $e'))),
          ],
        ),
      ),
    );
  }
}
