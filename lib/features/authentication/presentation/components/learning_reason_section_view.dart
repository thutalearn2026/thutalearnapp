import 'package:flutter/material.dart';
import 'package:thuta_learn/core/core.dart';
import 'package:thuta_learn/features/authentication/authentication.dart';

class LearningReasonSectionView extends StatelessWidget {
  const LearningReasonSectionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        24.gh,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TtText(
            "Why are you learning Thai?",
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        16.gh,
        ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 16),
          itemCount: 4,
          itemBuilder: (context, state) {
            return LearningReasonView();
          },
          separatorBuilder: (context, state) {
            return 16.gh;
          },
        ),
      ],
    );
  }
}

class LearningReasonView extends StatelessWidget {
  const LearningReasonView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: ColorUtils.surveyBackgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        spacing: 12,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color.fromRGBO(217, 223, 231, 1.0),
            ),
            child: Icon(
              Icons.work_outline,
              color: ColorUtils.primaryColor,
              size: 20,
            ),
          ),
          Expanded(
            child: Column(
              spacing: 4,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TtText(
                  "For Work",
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
                TtText(
                  "Career & professional growth",
                  color: Color.fromRGBO(100, 115, 139, 1.0),
                  fontSize: 13,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
