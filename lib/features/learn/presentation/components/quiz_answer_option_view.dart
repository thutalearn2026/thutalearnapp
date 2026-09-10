import 'package:flutter/material.dart';
import 'package:thuta_learn/core/core.dart';

enum QuizAnswerVisualState {
  idle,
  selected,
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
      case QuizAnswerVisualState.idle:
        return const Color(0xFFDDE3EA);

      case QuizAnswerVisualState.selected:
      case QuizAnswerVisualState.correct:
        return ColorUtils.secondaryColor;

      case QuizAnswerVisualState.incorrect:
        return Colors.red;
    }
  }

  Color get _backgroundColor {
    switch (visualState) {
      case QuizAnswerVisualState.idle:
        return Colors.white;

      case QuizAnswerVisualState.selected:
      case QuizAnswerVisualState.correct:
        return ColorUtils.secondaryBackgroundColor;

      case QuizAnswerVisualState.incorrect:
        return const Color(0xFFFFF1F1);
    }
  }

  Widget? get _trailingIcon {
    switch (visualState) {
      case QuizAnswerVisualState.idle:
        return null;

      case QuizAnswerVisualState.selected:
        return _StatusIcon(
          backgroundColor:
          ColorUtils.secondaryColor,
          icon: Icons.check_rounded,
        );

      case QuizAnswerVisualState.correct:
        return _StatusIcon(
          backgroundColor:
          ColorUtils.secondaryColor,
          icon: Icons.done_rounded,
        );

      case QuizAnswerVisualState.incorrect:
        return const _StatusIcon(
          backgroundColor: Colors.red,
          icon: Icons.close_rounded,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return TtZoomTap(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(
          milliseconds: 200,
        ),
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: _backgroundColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: _borderColor,
            width:
            visualState ==
                QuizAnswerVisualState.idle
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
                borderRadius:
                BorderRadius.circular(9),
              ),
              child: TtText(
                String.fromCharCode(
                  65 + optionIndex,
                ),
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
                height: 1.35,
                fontWeight: FontWeight.w600,
                color: ColorUtils.primaryColor,
              ),
            ),
            if (_trailingIcon != null) ...[
              10.gw,
              _trailingIcon!,
            ],
          ],
        ),
      ),
    );
  }
}

class _StatusIcon extends StatelessWidget {
  final Color backgroundColor;
  final IconData icon;

  const _StatusIcon({
    required this.backgroundColor,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 25,
      height: 25,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        size: 17,
        color: Colors.white,
      ),
    );
  }
}