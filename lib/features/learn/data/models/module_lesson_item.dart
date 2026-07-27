class ModuleLessonItem {
  final int lessonNumber;
  final String title;
  final String myanmarTitle;
  final String subtitle;
  final String duration;
  final bool isCompleted;
  final bool isDownloaded;

  const ModuleLessonItem({
    this.lessonNumber = 1,
    required this.title,
    this.myanmarTitle = '',
    required this.subtitle,
    required this.duration,
    this.isCompleted = false,
    this.isDownloaded = false,
  });
}