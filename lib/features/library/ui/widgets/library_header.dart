import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/sort_option.dart';
import '../../providers/library_view_provider.dart';

class LibraryHeader extends ConsumerWidget {
  final TextEditingController searchController;
  final String searchQuery;
  final SortOption currentSort;
  final Function(String) onSearchChanged;
  final VoidCallback onClearSearch;
  final Function(SortOption) onSortChanged;
  final LibraryViewMode viewMode;
  final String hintText;

  const LibraryHeader({
    super.key,
    required this.searchController,
    required this.searchQuery,
    required this.currentSort,
    required this.onSearchChanged,
    required this.onClearSearch,
    required this.onSortChanged,
    required this.viewMode,
    this.hintText = 'Search...',
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: searchController,
                  onChanged: onSearchChanged,
                  decoration: InputDecoration(
                    hintText: hintText,
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    suffixIcon: searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, color: Colors.grey),
                            onPressed: onClearSearch,
                          )
                        : null,
                    filled: true,
                    fillColor: Colors.white.withValues(alpha: 0.05),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 0,
                      horizontal: 16,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: Icon(
                    viewMode == LibraryViewMode.grid
                        ? Icons.list
                        : Icons.grid_view,
                  ),
                  onPressed: () => ref.read(libraryViewProvider.notifier).toggle(),
                  tooltip: 'Toggle View',
                ),
              ),
              const SizedBox(width: 8),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: PopupMenuButton<SortOption>(
                  icon: const Icon(Icons.sort),
                  tooltip: 'Sort Options',
                  onSelected: onSortChanged,
                  itemBuilder: (BuildContext context) => SortOption.values.map((option) {
                    return PopupMenuItem<SortOption>(
                      value: option,
                      child: Row(
                        children: [
                          Icon(
                            currentSort == option ? Icons.check : Icons.circle,
                            color: currentSort == option
                                ? Theme.of(context).primaryColor
                                : Colors.transparent,
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Text(option.label),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
