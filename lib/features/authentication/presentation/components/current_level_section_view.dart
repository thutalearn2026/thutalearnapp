import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:thuta_learn/core/core.dart';
import 'package:thuta_learn/features/authentication/authentication.dart';

class CurrentLevelSectionView extends StatelessWidget {
  const CurrentLevelSectionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        24.gh,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TtText(
            "What is your current level?",
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        16.gh,
        RadioGroup<int>(
          groupValue: 0,
          onChanged: (value) {
            HapticFeedback.mediumImpact();
          },
          child: ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: 3,
            itemBuilder: (context, index) {
              return CurrentLevelView(
                index: index,
              );
            },
            separatorBuilder: (context, index) {
              return 16.gh;
            },
          ),
        ),
      ],
    );
  }
}

class CurrentLevelView extends StatelessWidget {
  final int index;

  const CurrentLevelView({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return RadioListTile(
      visualDensity: VisualDensity(horizontal: -4),
      value: index,
      title: Row(
        children: [
          Expanded(
            child: TtText("Beginner"),
          ),
          Row(
            children: List.generate(
              2,
              (index) {
                return Icon(
                  Icons.star,
                  color: ColorUtils.secondaryColor,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
