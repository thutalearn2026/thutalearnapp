import 'package:flutter/material.dart';
import 'package:thuta_learn/core/core.dart';

class OnboardingContentView extends StatelessWidget {
  final String image;
  final String title;
  final String subtitle;
  final String content;

  const OnboardingContentView({
    super.key,
    required this.image,
    required this.title,
    required this.subtitle,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 36),
      child: Column(
        children: [
          Image.asset(
            image,
            width: 55,
            height: 55,
          ),
          8.gh,
          TtText(
            title,
            fontSize: 24,
            fontWeight: FontWeight.w500,
          ),
          4.gh,
          TtText(
            subtitle,
            family: TtFontFamily.myanmar_mn,
            fontSize: 16,
          ),
          8.gh,
          TtText(
            content,
            textAlign: TextAlign.center,
            height: 1.6,
          ),
        ],
      ),
    );
  }
}
