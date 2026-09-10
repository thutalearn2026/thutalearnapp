import 'package:flutter/material.dart';
import 'package:thuta_learn/core/core.dart';
import 'package:thuta_learn/features/profile/profile.dart';

class LearningProgressMetricCard extends StatelessWidget {
  final LearningProgressMetric metric;

  const LearningProgressMetricCard({
    super.key,
    required this.metric,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 174,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: ColorUtils.secondaryBackgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: ColorUtils.secondaryColor.withValues(
            alpha: 0.55,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: const BoxDecoration(
              color: ColorUtils.secondaryColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              metric.icon,
              size: 27,
              color: Colors.white,
            ),
          ),
          8.gh,
          TtText(
            metric.value,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          7.gh,
          TtText(
            metric.label,
            fontSize: 14,
            maxLines: 2,
            color: ColorUtils.greyTextColor,
          ),
        ],
      ),
    );
  }
}