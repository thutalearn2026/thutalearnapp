import 'package:flutter/material.dart';
import 'package:thuta_learn/core/core.dart';

class QuizFeedbackView extends StatelessWidget {
  final int correctOptionIndex;
  final String explanation;

  const QuizFeedbackView({
    super.key,
    required this.correctOptionIndex,
    required this.explanation,
  });

  @override
  Widget build(BuildContext context) {
    final correctAnswerLetter = String.fromCharCode(
      65 + correctOptionIndex,
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF2F2),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 23,
                height: 23,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close_rounded,
                  size: 16,
                  color: Colors.white,
                ),
              ),
              8.gw,
              Expanded(
                child: TtText(
                  'Not quite — answer is $correctAnswerLetter',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ],
          ),
          8.gh,
          TtText(
            explanation,
            fontSize: 14,
            height: 1.4,
            color: ColorUtils.primaryColor,
          ),
        ],
      ),
    );
  }
}