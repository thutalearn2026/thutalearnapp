import 'package:thuta_learn/features/learn/data/models/learn_module_item.dart';

class LearnCourseItem {
  final String id;
  final String title;
  final String description;
  final String level;
  final String icon;
  final double progress;
  final List<LearnModuleItem> modules;

  const LearnCourseItem({
    required this.id,
    required this.title,
    required this.description,
    required this.level,
    required this.icon,
    required this.progress,
    required this.modules,
  });

  int get moduleCount => modules.length;
}