class ModuleLessonItem {
  final String? id;
  final int lessonNumber;
  final String title;
  final String myanmarTitle;
  final String subtitle;
  final String duration;
  final String? thumbnailUrl;
  final String? playerUrl;
  final String? videoSource;
  final bool isFree;
  final bool isCompleted;
  final bool isDownloaded;

  const ModuleLessonItem({
    this.id,
    this.lessonNumber = 1,
    required this.title,
    this.myanmarTitle = '',
    required this.subtitle,
    required this.duration,
    this.thumbnailUrl,
    this.playerUrl,
    this.videoSource,
    this.isFree = false,
    this.isCompleted = false,
    this.isDownloaded = false,
  });
}