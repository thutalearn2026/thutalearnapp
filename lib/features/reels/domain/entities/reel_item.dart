class ReelItem {
  final String id;
  final String title;
  final String videoUrl;
  final String? thumbnailUrl;

  const ReelItem({
    required this.id,
    required this.title,
    required this.videoUrl,
    this.thumbnailUrl,
  });
}