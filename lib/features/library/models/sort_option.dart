enum SortOption {
  recentlyAdded,
  alphabetical,
}

extension SortOptionExtension on SortOption {
  String get label {
    switch (this) {
      case SortOption.recentlyAdded:
        return 'Recently Added';
      case SortOption.alphabetical:
        return 'Alphabetical (A-Z)';
    }
  }
}
