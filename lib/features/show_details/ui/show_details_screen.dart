import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/show_details_provider.dart';
import 'widgets/show_details_app_bar.dart';
import 'widgets/show_overview_section.dart';
import 'widgets/season_accordion.dart';

class ShowDetailsScreen extends ConsumerWidget {
  final int showId;

  const ShowDetailsScreen({super.key, required this.showId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showAsync = ref.watch(showMetadataProvider(showId));
    final seasonsAsync = ref.watch(showSeasonsProvider(showId));

    return Scaffold(
      body: showAsync.when(
        data: (show) {
          if (show == null) {
            return const CustomScrollView(
              slivers: [
                SliverAppBar(),
                SliverFillRemaining(child: Center(child: Text('Show not found'))),
              ],
            );
          }

          final posterUrl = show.posterPath != null
              ? 'https://image.tmdb.org/t/p/w500${show.posterPath}'
              : null;

          List<dynamic> castList = [];
          if (show.castList != null && show.castList!.isNotEmpty) {
            try {
              castList = jsonDecode(show.castList!);
            } catch (e) {
              // ignore decoding errors
            }
          }

          return CustomScrollView(
            slivers: [
              ShowDetailsAppBar(
                show: show,
                showId: showId,
                posterUrl: posterUrl,
              ),

              // Overview Section
              SliverToBoxAdapter(
                child: ShowOverviewSection(
                  show: show,
                  showId: showId,
                  castList: castList,
                ),
              ),

              // Seasons Title
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                  child: Text(
                    'Seasons',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              // Seasons & Episodes list
              seasonsAsync.when(
                data: (seasons) {
                  final regularSeasons = seasons.where((s) => s.seasonNumber > 0).toList();

                  return SliverPadding(
                    padding: const EdgeInsets.only(bottom: 30),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final season = regularSeasons[index];
                        return SeasonAccordion(season: season);
                      }, childCount: regularSeasons.length),
                    ),
                  );
                },
                loading: () => const SliverToBoxAdapter(
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (e, _) => SliverToBoxAdapter(
                  child: Center(child: Text('Error: $e')),
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
