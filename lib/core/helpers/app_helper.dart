import 'package:flutter/material.dart';
import 'package:thuta_learn/features/features.dart';

class AppHelper {
  List<LearningReasonModel> get learningReasons {
    return [
      LearningReasonModel(
        iconData: Icons.work_outline,
        title: "For Work",
        subtitle: "Career & professional growth",
        isSelected: false,
      ),
      LearningReasonModel(
        iconData: Icons.coffee,
        title: "Daily Life",
        subtitle: "Conversations & errands",
        isSelected: false,
      ),
      LearningReasonModel(
        iconData: Icons.airplanemode_active,
        title: "Daily Life",
        subtitle: "Conversations & errands",
        isSelected: false,
      ),
      LearningReasonModel(
        iconData: Icons.newspaper,
        title: "Studies",
        subtitle: "Academic & exams",
        isSelected: false,
      ),
    ];
  }

  List<DailyGoalModel> get dailyGoals {
    return [
      DailyGoalModel(
        min: "5",
        isSelected: false,
      ),
      DailyGoalModel(
        min: "10",
        isSelected: false,
      ),
      DailyGoalModel(
        min: "15",
        isSelected: false,
      ),
      DailyGoalModel(
        min: "30",
        isSelected: false,
      ),
    ];
  }
}
