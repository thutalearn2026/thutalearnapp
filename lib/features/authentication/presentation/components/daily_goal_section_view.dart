import 'package:flutter/material.dart';
import 'package:thuta_learn/core/core.dart';
import 'package:thuta_learn/features/authentication/authentication.dart';

class DailyGoalSectionView extends StatelessWidget {
  const DailyGoalSectionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        24.gh,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TtText(
            "What is your current level?",
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        16.gh,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            spacing: 8,
            children: List.generate(
              4,
              (index) {
                return Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: ColorUtils.surveyBackgroundColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TtText(
                          "5",
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                        TtText(
                          "min/day",
                          fontSize: 13,
                          color: Colors.black.withValues(alpha: 0.5),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
