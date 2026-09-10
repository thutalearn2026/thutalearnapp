import 'package:flutter/material.dart';

class LearningProgressMetric {
  final String value;
  final String label;
  final IconData icon;

  const LearningProgressMetric({
    required this.value,
    required this.label,
    required this.icon,
  });
}

class WeeklyActivityItem {
  final String day;
  final int minutes;
  final bool isCurrentDay;

  const WeeklyActivityItem({
    required this.day,
    required this.minutes,
    this.isCurrentDay = false,
  });
}

class CourseProgressItem {
  final String title;
  final double progress;

  const CourseProgressItem({
    required this.title,
    required this.progress,
  });
}