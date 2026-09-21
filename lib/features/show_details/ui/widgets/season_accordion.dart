import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/database/database.dart';
import '../../../../core/utils/app_toasts.dart';
import '../../providers/show_details_provider.dart';

class SeasonAccordion extends ConsumerStatefulWidget {
  final Season season;

  const SeasonAccordion({super.key, required this.season});

  @override
  ConsumerState<SeasonAccordion> createState() => _SeasonAccordionState();
}

class _SeasonAccordionState extends ConsumerState<SeasonAccordion> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final episodesAsync = ref.watch(seasonEpisodesProvider(widget.season.id));

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      elevation: 0,
      color: Colors.grey.withValues(alpha: 0.08),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent, // Remove line on expansion
        ),
        child: ExpansionTile(
          onExpansionChanged: (expanded) {
            setState(() {
              _isExpanded = expanded;
            });
          },
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          title: Row(
            crossAxisAlignment: _isExpanded ? CrossAxisAlignment.start : CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  widget.season.name,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  maxLines: _isExpanded ? null : 1,
                  overflow: _isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 12),
              episodesAsync.maybeWhen(
                data: (episodes) {
                  if (episodes.isEmpty) return const SizedBox.shrink();
                  final watchedCount = episodes.where((e) => e.isWatched).length;
                  final totalCount = episodes.length;
                  final isComplete = totalCount > 0 && watchedCount == totalCount;

                  if (isComplete) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.green.withValues(alpha: 0.4)),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.check_circle, size: 12, color: Colors.greenAccent),
                          SizedBox(width: 4),
                          Text(
                            'COMPLETED',
                            style: TextStyle(
                              fontSize: 9,
                              color: Colors.greenAccent,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    );
                  } else if (watchedCount > 0) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Theme.of(context).primaryColor.withValues(alpha: 0.4)),
                      ),
                      child: Text(
                        '$watchedCount / $totalCount watched',
                        style: TextStyle(
                          fontSize: 10,
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  } else {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '$totalCount eps',
                        style: const TextStyle(fontSize: 10, color: Colors.white54),
                      ),
                    );
                  }
                },
                orElse: () => const SizedBox.shrink(),
              ),
            ],
          ),
          children: [
            episodesAsync.when(
              data: (episodes) {
                if (episodes.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text('No episodes found.', style: TextStyle(color: Colors.white54)),
                  );
                }

                final allWatched = episodes.every((ep) => ep.isWatched);

                return Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.2),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
                  ),
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () {
                          ref
                              .read(episodeControllerProvider)
                              .markSeasonWatched(widget.season.id, !allWatched);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 12.0,
                            horizontal: 16.0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Icon(
                                allWatched ? Icons.remove_done : Icons.checklist,
                                size: 18,
                                color: Theme.of(context).primaryColor,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                allWatched ? 'Mark Season Unwatched' : 'Mark Season Watched',
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Divider(height: 1, color: Colors.white12),
                      ...episodes.map((ep) {
                        final isUnaired = ep.airDate != null && ep.airDate!.isAfter(DateTime.now());

                        return ListTile(
                          dense: true,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                          title: Text(
                            'E${ep.episodeNumber}: ${ep.title}',
                            style: TextStyle(
                              color: ep.isWatched 
                                  ? Colors.white54 
                                  : (isUnaired ? Colors.white54 : Colors.white),
                              fontStyle: (isUnaired && !ep.isWatched) ? FontStyle.italic : FontStyle.normal,
                            ),
                          ),
                          subtitle: ep.airDate != null
                              ? Text(
                                  '${isUnaired ? 'Airing' : 'Aired'}: ${ep.airDate!.toLocal().toString().split(' ')[0]}',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Colors.white38,
                                  ),
                                )
                              : null,
                          trailing: InkWell(
                            borderRadius: BorderRadius.circular(20),
                            onTap: () {
                              if (isUnaired && !ep.isWatched) {
                                AppToasts.showInfo(context, 'This hasn\'t aired yet. Long press to mark as watched.');
                                return;
                              }
                              ref
                                  .read(episodeControllerProvider)
                                  .toggleWatched(ep.id, ep.isWatched);
                            },
                            onLongPress: () {
                              if (isUnaired && !ep.isWatched) {
                                ref
                                    .read(episodeControllerProvider)
                                    .toggleWatched(ep.id, ep.isWatched);
                                AppToasts.showSuccess(context, 'Marked unaired episode as watched.');
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                ep.isWatched ? Icons.check_circle : (isUnaired ? Icons.schedule : Icons.circle_outlined),
                                color: ep.isWatched 
                                    ? Theme.of(context).primaryColor 
                                    : (isUnaired ? Colors.white38 : Colors.white38),
                              ),
                            ),
                          ),
                        );
                      }),
                      const SizedBox(height: 8),
                    ],
                  ),
                );
              },
              loading: () => const Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (e, _) => Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('Error: $e'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
