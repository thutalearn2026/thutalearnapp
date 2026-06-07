import 'package:flutter/material.dart';

class LearningReasonModel {
  final IconData iconData;
  final String title;
  final String subtitle;
  final bool isSelected;

  LearningReasonModel({
    required this.iconData,
    required this.title,
    required this.subtitle,
    required this.isSelected,
  });
}
