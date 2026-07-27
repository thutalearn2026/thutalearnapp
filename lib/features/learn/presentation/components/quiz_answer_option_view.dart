import 'package:flutter/material.dart';
import 'package:thuta_learn/core/core.dart';

enum QuizAnswerVisualState {
  idle,
  correct,
  incorrect,
}

class QuizAnswerOptionView extends StatelessWidget {
  final int optionIndex;
  final String answer;
  final QuizAnswerVisualState visualState;
  final VoidCallback onTap;

  const QuizAnswerOptionView({
    super.key,
    required this.optionIndex,
    required this.answer,
    required this.visualState,
    required this.onTap,
  });

  Color get _borderColor {
    switch (visualState) {
      case QuizAnswerVisualState.correct:
        return ColorUtils.secondaryColor;
      case QuizAnswerVisualState.incorrect:
        return Colors.red;
      case QuizAnswerVisualState.idle:
        return const Color(0xFFDDE3EA);
    }
  }

  Color get _backgroundColor {
    switch (visualState) {
      case QuizAnswerVisualState.correct:
        return ColorUtils.secondaryBackgroundColor;
      case QuizAnswerVisualState.incorrect:
        return const Color(0xFFFFF1F1);
      case QuizAnswerVisualState.idle:
        return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    return TtZoomTap(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: _backgroundColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: _borderColor,
            width: visualState == QuizAnswerVisualState.idle
                ? 1
                : 2,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(9),
              ),
              child: TtText(
                String.fromCharCode(65 + optionIndex),
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: ColorUtils.greyTextColor,
              ),
            ),
            14.gw,
            Expanded(
              child: TtText(
                answer,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: ColorUtils.primaryColor,
              ),
            ),
            if (visualState ==
                QuizAnswerVisualState.correct)
              Container(
                width: 25,
                height: 25,
                decoration: const BoxDecoration(
                  color: ColorUtils.secondaryColor,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.done_rounded,
                  size: 17,
                  color: Colors.white,
                ),
              ),
            if (visualState ==
                QuizAnswerVisualState.incorrect)
              Container(
                width: 25,
                height: 25,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close_rounded,
                  size: 17,
                  color: Colors.white,
                ),
              ),
          ],
        ),
      ),
    );
  }
}