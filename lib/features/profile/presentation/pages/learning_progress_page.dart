import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:thuta_learn/core/core.dart';
import 'package:thuta_learn/features/profile/profile.dart';

class LearningProgressPage extends StatelessWidget {
  const LearningProgressPage({super.key});

  static const List<LearningProgressMetric> _metrics = [
    LearningProgressMetric(
      value: '47',
      label: 'Lessons Done',
      icon: Icons.menu_book_outlined,
    ),
    LearningProgressMetric(
      value: '312',
      label: 'Words Learned',
      icon: Icons.bookmark_border_rounded,
    ),
    LearningProgressMetric(
      value: '12',
      label: 'Day Streak',
      icon: Icons.event_available_outlined,
    ),
  ];

  static const List<WeeklyActivityItem> _weeklyActivity = [
    WeeklyActivityItem(day: 'M', minutes: 38),
    WeeklyActivityItem(day: 'T', minutes: 52),
    WeeklyActivityItem(day: 'W', minutes: 45),
    WeeklyActivityItem(
      day: 'T',
      minutes: 67,
      isCurrentDay: true,
    ),
    WeeklyActivityItem(day: 'F', minutes: 41),
    WeeklyActivityItem(day: 'S', minutes: 29),
    WeeklyActivityItem(day: 'S', minutes: 20),
  ];

  static const List<CourseProgressItem> _courses = [
    CourseProgressItem(
      title: 'Thai Pronunciation Essentials',
      progress: 1,
    ),
    CourseProgressItem(
      title: 'Greetings and Self-Introduction',
      progress: 0.58,
    ),
    CourseProgressItem(
      title: 'Numbers, Prices and Shopping',
      progress: 0,
    ),
    CourseProgressItem(
      title: 'Food and Drinks',
      progress: 0,
    ),
    CourseProgressItem(
      title: 'Time, Dates and Daily Schedule',
      progress: 0,
    ),
    CourseProgressItem(
      title: 'Places, Transport and Directions',
      progress: 0,
    ),
    CourseProgressItem(
      title: 'Everyday Conversation and Grammar',
      progress: 0,
    ),
    CourseProgressItem(
      title: 'Weather, Health and Practical Situations',
      progress: 0,
    ),
  ];

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
            totalMinutes: 67,
            percentageChange: 18,
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