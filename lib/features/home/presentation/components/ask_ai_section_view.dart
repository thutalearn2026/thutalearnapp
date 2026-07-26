import 'package:flutter/material.dart';
import 'package:thuta_learn/core/core.dart';
import 'package:thuta_learn/features/home/home.dart';

class AskAiSectionView extends StatelessWidget {
  const AskAiSectionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 20,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Color.fromRGBO(17, 175, 159, 1.0),
            ColorUtils.secondaryColor,
            Color.fromRGBO(17, 175, 159, 1.0),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(1, 1),
          ),
        ],
      ),
      child: Row(
        spacing: 16,
        children: [
          AskAiImageView(),
          Expanded(
            child: AskAiContentView(),
          ),
          Icon(
            Icons.arrow_forward_ios_rounded,
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}

class AskAiContentView extends StatelessWidget {
  const AskAiContentView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TtText(
          StringUtils.askAiTitle,
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
        TtText(
          StringUtils.askAiDesc,
          color: Color.fromRGBO(223, 248, 244, 1.0),
          height: 1.6,
        ),
      ],
    );
  }
}

class AskAiImageView extends StatelessWidget {
  const AskAiImageView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Color.fromRGBO(66, 193, 179, 1.0),
      ),
      child: Image.asset(
        ImageUtils.askAi,
        width: 25,
      ),
    );
  }
}
