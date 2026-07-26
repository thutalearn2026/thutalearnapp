import 'package:flutter/material.dart';
import 'package:thuta_learn/core/core.dart';
import 'package:thuta_learn/features/home/home.dart';

class CurrentLearningSectionView extends StatelessWidget {
  const CurrentLearningSectionView({super.key});

  @override
  Widget build(BuildContext context) {
    return ShadowContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TtText(
            "Expressing feelings",
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
          8.gh,
          TtNetworkImage(
            imageUrl: "https://i.ytimg.com/vi/j1bIdWfeutI/maxresdefault.jpg",
            width: double.infinity,
            height: 200,
            borderRadius: BorderRadius.circular(8),
          ),
          8.gh,
          TtText(
            "Beginner level",
          ),
        ],
      ),
    );
  }
}


