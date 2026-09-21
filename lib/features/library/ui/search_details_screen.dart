import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/tmdb_repository.dart';

import 'widgets/search_details_app_bar.dart';
import 'widgets/search_details_content.dart';

final searchDetailsProvider = FutureProvider.family.autoDispose<Map<String, dynamic>?, ({int id, bool isMovie})>((ref, args) async {
  // Keep the result cached for 5 minutes after leaving the screen
  final link = ref.keepAlive();
  final timer = Timer(const Duration(minutes: 5), () {
    link.close();
  });
  ref.onDispose(() => timer.cancel());

  final tmdb = ref.read(tmdbRepositoryProvider);
  try {
    if (args.isMovie) {
      return await tmdb.getMovieDetails(args.id);
    } else {
      return await tmdb.getShowDetails(args.id);
    }
  } catch (_) {
    return null;
  }
});

class SearchDetailsScreen extends ConsumerStatefulWidget {
  final dynamic item;
  final bool isMovie;
  final bool isAdded;
  final String? title;
  final dynamic year;
  final String? imageUrl;

  const SearchDetailsScreen({
    super.key,
    required this.item,
    required this.isMovie,
    required this.isAdded,
    required this.title,
    required this.year,
    required this.imageUrl,
  });

  @override
  ConsumerState<SearchDetailsScreen> createState() => _SearchDetailsScreenState();
}

class _SearchDetailsScreenState extends ConsumerState<SearchDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SearchDetailsAppBar(
            item: widget.item,
            isMovie: widget.isMovie,
            title: widget.title,
            year: widget.year,
            posterUrl: widget.imageUrl,
          ),
          SliverToBoxAdapter(
            child: SearchDetailsContent(
              item: widget.item,
              isMovie: widget.isMovie,
              isAdded: widget.isAdded,
              title: widget.title,
            ),
          ),
        ],
      ),
    );
  }
}
