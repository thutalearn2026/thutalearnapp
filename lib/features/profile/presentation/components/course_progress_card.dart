import 'package:flutter/material.dart';
import 'package:thuta_learn/core/core.dart';
import 'package:thuta_learn/features/profile/profile.dart';

class CourseProgressCard extends StatelessWidget {
  final List<CourseProgressItem> courses;

  const CourseProgressCard({
    super.key,
    required this.courses,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE1E5EA),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: 0.035,
            ),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TtText(
            'Course progress',
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          24.gh,

          if (courses.isEmpty)
            const _EmptyCourseProgressView()
          else
            ...List.generate(
              courses.length,
                  (index) {
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: index == courses.length - 1
                        ? 0
                        : 22,
                  ),
                  child: CourseProgressItemView(
                    course: courses[index],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}

class _EmptyCourseProgressView extends StatelessWidget {
  const _EmptyCourseProgressView();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(
        vertical: 20,
        horizontal: 12,
      ),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.auto_graph_rounded,
              size: 48,
              color: ColorUtils.greyTextColor,
            ),
            SizedBox(height: 12),
            TtText(
              'No learning progress yet',
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: ColorUtils.primaryColor,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            TtText(
              'Start learning a lesson and your course '
                  'progress will appear here.',
              fontSize: 13,
              height: 1.4,
              color: ColorUtils.greyTextColor,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class CourseProgressItemView extends StatelessWidget {
  final CourseProgressItem course;

  const CourseProgressItemView({
    super.key,
    required this.course,
  });

  Color get _progressColor {
    if (course.progress >= 1) {
      return const Color(0xFF16B56F);
    }

    if (course.progress > 0) {
      return ColorUtils.secondaryColor;
    }

    return const Color(0xFFE6E9EE);
  }

  @override
  Widget build(BuildContext context) {
    final percentage = (course.progress * 100).round();

    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: TtText(
                course.title,
                fontSize: 14,
                height: 1.3,
                color: ColorUtils.primaryColor,
              ),
            ),
            12.gw,
            TtText(
              '$percentage%',
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: ColorUtils.greyTextColor,
            ),
          ],
        ),
        10.gh,
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: course.progress.clamp(0.0, 1.0),
            minHeight: 7,
            backgroundColor: const Color(0xFFE6E9EE),
            valueColor: AlwaysStoppedAnimation<Color>(
              _progressColor,
            ),
          ),
        ),
      ],
    );
  }
}