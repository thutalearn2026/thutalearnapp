import 'package:flutter/material.dart';
import 'package:thuta_learn/core/core.dart';

class QuizProgressHeader extends StatelessWidget {
  final int currentQuestion;
  final int totalQuestions;
  final double progress;
  final VoidCallback onClose;

  const QuizProgressHeader({
    super.key,
    required this.currentQuestion,
    required this.totalQuestions,
    required this.progress,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: onClose,
          icon: const Icon(
            Icons.close_rounded,
            color: ColorUtils.primaryColor,
          ),
        ),
        8.gw,
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 7,
              backgroundColor: const Color(0xFFE8EBEF),
              valueColor: const AlwaysStoppedAnimation<Color>(
                ColorUtils.secondaryColor,
              ),
            ),
          ),
        ),
        12.gw,
        TtText(
          '$currentQuestion/$totalQuestions',
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: ColorUtils.primaryColor,
        ),
      ],
    );
  }
}