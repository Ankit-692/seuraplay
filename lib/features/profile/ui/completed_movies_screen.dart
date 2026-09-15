import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../library/providers/library_providers.dart';
import '../../movie_details/ui/movie_details_screen.dart';

class CompletedMoviesScreen extends ConsumerStatefulWidget {
  const CompletedMoviesScreen({super.key});

  @override
  ConsumerState<CompletedMoviesScreen> createState() => _CompletedMoviesScreenState();
}

class _CompletedMoviesScreenState extends ConsumerState<CompletedMoviesScreen> {
  String? _selectedGenre;

  @override
  Widget build(BuildContext context) {
    final moviesAsync = ref.watch(savedMoviesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Completed Movies'),
      ),
      body: moviesAsync.when(
        data: (movies) {
          final watchedMovies = movies.where((m) => m.status == 'watched').toList();
          
          if (watchedMovies.isEmpty) {
            return const Center(child: Text('No completed movies.'));
          }

          // Extract unique genres for dropdown
          final Set<String> genres = {};
          for (final m in watchedMovies) {
            if (m.genres != null && m.genres!.isNotEmpty) {
              genres.addAll(m.genres!.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty));
            }
          }
          final genreList = genres.toList()..sort();

          // Filter by selected genre
          final filteredMovies = _selectedGenre == null 
              ? watchedMovies 
              : watchedMovies.where((m) => m.genres != null && m.genres!.contains(_selectedGenre!)).toList();
          
          // Sort Alphabetically
          filteredMovies.sort((a, b) => a.title.compareTo(b.title));

          return Column(
            children: [
              if (genreList.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: DropdownButtonFormField<String>(
                    value: _selectedGenre,
                    decoration: InputDecoration(
                      labelText: 'Filter by Genre',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    items: [
                      const DropdownMenuItem<String>(
                        value: null,
                        child: Text('All Genres'),
                      ),
                      ...genreList.map((g) => DropdownMenuItem(
                        value: g,
                        child: Text(g),
                      )),
                    ],
                    onChanged: (val) {
                      setState(() {
                        _selectedGenre = val;
                      });
                    },
                  ),
                ),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 0.55,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: filteredMovies.length,
                  itemBuilder: (context, index) {
                    final movie = filteredMovies[index];
                    return InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (_) => MovieDetailsScreen(movieId: movie.id)
                        ));
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: movie.posterPath != null
                                  ? CachedNetworkImage(
                                      imageUrl: 'https://image.tmdb.org/t/p/w300${movie.posterPath}',
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      errorWidget: (_, __, ___) => Container(color: Colors.grey[800], child: const Icon(Icons.movie, color: Colors.white54)),
                                    )
                                  : Container(color: Colors.grey[800], child: const Icon(Icons.movie, color: Colors.white54)),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            movie.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
