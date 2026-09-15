import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../library/providers/library_providers.dart';
import '../../show_details/ui/show_details_screen.dart';

class CompletedShowsScreen extends ConsumerStatefulWidget {
  const CompletedShowsScreen({super.key});

  @override
  ConsumerState<CompletedShowsScreen> createState() => _CompletedShowsScreenState();
}

class _CompletedShowsScreenState extends ConsumerState<CompletedShowsScreen> {
  String? _selectedGenre;

  @override
  Widget build(BuildContext context) {
    final showsAsync = ref.watch(savedShowsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Completed Shows'),
      ),
      body: showsAsync.when(
        data: (shows) {
          final watchedShows = shows.where((s) => s.status == 'watched').toList();
          
          if (watchedShows.isEmpty) {
            return const Center(child: Text('No completed shows.'));
          }

          final Set<String> genres = {};
          for (final s in watchedShows) {
            if (s.genres != null && s.genres!.isNotEmpty) {
              genres.addAll(s.genres!.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty));
            }
          }
          final genreList = genres.toList()..sort();

          final filteredShows = _selectedGenre == null 
              ? watchedShows 
              : watchedShows.where((s) => s.genres != null && s.genres!.contains(_selectedGenre!)).toList();
          
          filteredShows.sort((a, b) => a.title.compareTo(b.title));

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
                  itemCount: filteredShows.length,
                  itemBuilder: (context, index) {
                    final show = filteredShows[index];
                    return InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (_) => ShowDetailsScreen(showId: show.id)
                        ));
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: show.posterPath != null
                                  ? CachedNetworkImage(
                                      imageUrl: 'https://image.tmdb.org/t/p/w300${show.posterPath}',
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      errorWidget: (_, __, ___) => Container(color: Colors.grey[800], child: const Icon(Icons.tv, color: Colors.white54)),
                                    )
                                  : Container(color: Colors.grey[800], child: const Icon(Icons.tv, color: Colors.white54)),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            show.title,
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
