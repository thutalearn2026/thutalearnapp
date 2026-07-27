import 'package:flutter/material.dart';
import 'package:thuta_learn/core/core.dart';

class LessonSpecialNotesView extends StatelessWidget {
  const LessonSpecialNotesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TtText(
          'Special Notes',
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        14.gh,
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFFE2E6EB),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Text.rich(
            TextSpan(
              style: TextStyle(
                fontFamily: 'helvetica_neue',
                fontSize: 14,
                height: 1.7,
                color: ColorUtils.greyTextColor,
              ),
              children: [
                TextSpan(
                  text:
                  'In Thai workplaces, polite particles like ',
                ),
                TextSpan(
                  text: 'ครับ (khrap)',
                  style: TextStyle(
                    color: ColorUtils.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(text: ' for men and '),
                TextSpan(
                  text: 'ค่ะ (kha)',
                  style: TextStyle(
                    color: ColorUtils.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text:
                  ' for women are essential. Always pair greetings with a soft wai.',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}