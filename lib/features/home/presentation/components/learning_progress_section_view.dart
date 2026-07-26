import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:thuta_learn/core/core.dart';
import 'package:thuta_learn/features/home/home.dart';

class LearningProgressSectionView extends StatelessWidget {
  const LearningProgressSectionView({super.key});

  @override
  Widget build(BuildContext context) {
    return LearningProgressContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CurrentLessonView(),
          12.gh,
          TtText(
            StringUtils.greetingAtWorkspace,
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.black,
          ),
          8.gh,
          TtText(
            "Thai Daily Conversation • 8 min",
          ),
          12.gh,
          LinearPercentIndicator(
            animation: true,
            lineHeight: 10,
            percent: 0.7,
            progressColor: ColorUtils.secondaryColor,
            padding: EdgeInsets.zero,
            barRadius: Radius.circular(16),
          ),
          12.gh,
          CurrentPercentAndResumeButtonView(),
        ],
      ),
    );
  }
}

class CurrentPercentAndResumeButtonView extends StatelessWidget {
  const CurrentPercentAndResumeButtonView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TtText(
            "60% complete",
            color: ColorUtils.greyTextColor,
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            shadowColor: Colors.transparent,
            padding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            backgroundColor: ColorUtils.primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32),
            ),
          ),
          onPressed: () {
            HapticFeedback.mediumImpact();
          },
          child: Row(
            spacing: 4,
            children: [
              Icon(
                Icons.play_arrow_rounded,
                color: Colors.white,
              ),
              TtText(
                StringUtils.resume,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class CurrentLessonView extends StatelessWidget {
  const CurrentLessonView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 4,
          ),
          decoration: BoxDecoration(
            color: ColorUtils.secondaryBackgroundColor,
            borderRadius: BorderRadius.circular(24),
          ),
          child: TtText(
            "Continue Learning",
            color: ColorUtils.secondaryColor,
          ),
        ),
        Expanded(
          child: TtText(
            "Lesson 7 of 12",
            textAlign: TextAlign.end,
            color: ColorUtils.greyTextColor,
          ),
        ),
      ],
    );
  }
}

class LearningProgressContainer extends StatelessWidget {
  final Widget child;

  const LearningProgressContainer({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 16,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(1, 1),
          ),
        ],
      ),
      child: child,
    );
  }
}
