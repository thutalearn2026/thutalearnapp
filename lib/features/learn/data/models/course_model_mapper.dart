import 'package:thuta_learn/features/learn/learn.dart';

extension CourseModelMapper on CourseModel {
  LearnCourseItem toLearnCourseItem() {
    return LearnCourseItem(
      id: id,
      title: title,
      description: _plainTextDescription(
        aboutProgram?.isNotEmpty == true
            ? aboutProgram!
            : outline ?? '',
      ),
      level: level?.title ?? 'All Levels',
      icon: _courseIconKey(
        category?.slug,
      ),
      progress: 0,
      modules: modules.asMap().entries.map(
            (entry) {
          final index = entry.key;
          final module = entry.value;

          return LearnModuleItem(
            moduleNumber: index + 1,
            title: module.title,
            description:
            '${module.chaptersCount} chapter'
                '${module.chaptersCount == 1 ? '' : 's'} '
                'available in this module.',
            status: LearnModuleStatus.inProgress,
            progress: 0,
          );
        },
      ).toList(),
    );
  }
}

String _plainTextDescription(String html) {
  if (html.trim().isEmpty) {
    return 'Explore the lessons and learning resources '
        'available in this course.';
  }

  return html
      .replaceAll(RegExp(r'<[^>]*>'), ' ')
      .replaceAll('&nbsp;', ' ')
      .replaceAll('&amp;', '&')
      .replaceAll('&quot;', '"')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();
}

String _courseIconKey(String? categorySlug) {
  switch (categorySlug) {
    case 'ai-courses':
      return 'education';

    case 'business':
      return 'work';

    case 'travel':
      return 'travel';

    case 'thai':
    default:
      return 'conversation';
  }
}