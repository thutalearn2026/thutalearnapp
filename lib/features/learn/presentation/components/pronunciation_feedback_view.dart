import 'package:flutter/material.dart';
import 'package:thuta_learn/core/core.dart';

class PronunciationFeedbackView extends StatelessWidget {
  final String feedback;

  const PronunciationFeedbackView({
    super.key,
    required this.feedback,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF9EB),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.stars_rounded,
                size: 24,
                color: Color(0xFFFFB800),
              ),
              SizedBox(width: 8),
              TtText(
                'Feedback',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFFA800),
              ),
            ],
          ),
          10.gh,
          TtText(
            feedback,
            fontSize: 14,
            height: 1.45,
            color: ColorUtils.primaryColor,
          ),
        ],
      ),
    );
  }
}