import 'package:flutter/material.dart';
import 'package:thuta_learn/core/core.dart';
import 'package:thuta_learn/features/home/home.dart';

class ReviewSectionView extends StatelessWidget {
  const ReviewSectionView({super.key});

  @override
  Widget build(BuildContext context) {
    return ShadowContainer(
      child: Row(
        spacing: 12,
        children: [
          ReviewIconView(),
          Expanded(
            child: ReviewContentView(),
          ),
          Icon(
            Icons.arrow_forward_ios_rounded,
            color: Color.fromRGBO(100, 115, 139, 1.0),
          ),
        ],
      ),
    );
  }
}

class ReviewContentView extends StatelessWidget {
  const ReviewContentView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TtText(
          StringUtils.reviewYouLearned,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
        TtText(
          "24 words",
          color: Color.fromRGBO(100, 115, 139, 1.0),
        ),
      ],
    );
  }
}

class ReviewIconView extends StatelessWidget {
  const ReviewIconView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Color.fromRGBO(233, 235, 238, 1.0),
      ),
      child: Icon(
        Icons.edit_note_outlined,
        color: ColorUtils.primaryColor,
        size: 24,
      ),
    );
  }
}
