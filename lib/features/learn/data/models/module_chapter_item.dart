import 'package:thuta_learn/features/learn/data/models/module_lesson_item.dart';

class ModuleChapterItem {
  final String id;
  final String title;
  final String? description;
  final int chapterNumber;
  final List<ModuleLessonItem> lessons;

  const ModuleChapterItem({
    required this.id,
    required this.title,
    this.description,
    required this.chapterNumber,
    required this.lessons,
  });

  int get videoCount => lessons.length;
}