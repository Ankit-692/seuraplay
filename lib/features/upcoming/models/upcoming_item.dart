class UpcomingItem {
  final int id;
  final String title;
  final String? posterPath;
  final DateTime date;
  final bool isMovie;

  UpcomingItem({
    required this.id,
    required this.title,
    required this.posterPath,
    required this.date,
    required this.isMovie,
  });
}
