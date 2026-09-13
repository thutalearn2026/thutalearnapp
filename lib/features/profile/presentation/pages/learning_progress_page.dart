import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:thuta_learn/core/core.dart';
import 'package:thuta_learn/features/profile/profile.dart';

class LearningProgressPage extends StatelessWidget {
  const LearningProgressPage({
    super.key,
  });

  static const List<LearningProgressMetric> _metrics = [
    LearningProgressMetric(
      value: '0',
      label: 'Lessons Done',
      icon: Icons.menu_book_outlined,
    ),
    LearningProgressMetric(
      value: '0',
      label: 'Words Learned',
      icon: Icons.bookmark_border_rounded,
    ),
    LearningProgressMetric(
      value: '0',
      label: 'Day Streak',
      icon: Icons.event_available_outlined,
    ),
  ];

  static const List<WeeklyActivityItem> _weeklyActivity = [
    WeeklyActivityItem(
      day: 'M',
      minutes: 0,
    ),
    WeeklyActivityItem(
      day: 'T',
      minutes: 0,
    ),
    WeeklyActivityItem(
      day: 'W',
      minutes: 0,
    ),
    WeeklyActivityItem(
      day: 'T',
      minutes: 0,
    ),
    WeeklyActivityItem(
      day: 'F',
      minutes: 0,
    ),
    WeeklyActivityItem(
      day: 'S',
      minutes: 0,
    ),
    WeeklyActivityItem(
      day: 'S',
      minutes: 0,
    ),
  ];

  static const List<CourseProgressItem> _courses = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorUtils.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: ColorUtils.scaffoldBackgroundColor,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: context.pop,
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: ColorUtils.primaryColor,
          ),
        ),
        title: const TtText(
          'Learning Progress',
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          16,
          20,
          16,
          32,
        ),
        children: [
          Row(
            children: List.generate(
              _metrics.length,
                  (index) {
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: index == _metrics.length - 1
                          ? 0
                          : 10,
                    ),
                    child: LearningProgressMetricCard(
                      metric: _metrics[index],
                    ),
                  ),
                );
              },
            ),
          ),
          16.gh,
          const WeeklyActivityCard(
            activities: _weeklyActivity,
            totalMinutes: 0,
            percentageChange: 0,
          ),
          16.gh,
          const CourseProgressCard(
            courses: _courses,
          ),
        ],
      ),
    );
  }
}