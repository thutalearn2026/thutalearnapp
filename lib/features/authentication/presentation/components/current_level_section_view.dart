import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
        BlocBuilder<AccountSetUpBloc, AccountSetUpState>(
          builder: (context, state) {
            var currentLevels = state.currentLevels ?? [];
            return RadioGroup<String>(
              groupValue: state.selectedCurrentLevel ?? "",
              onChanged: (value) {
                HapticFeedback.mediumImpact();
                context.read<AccountSetUpBloc>().add(OnChooseCurrentLevel(value ?? ""));
              },
              child: ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: currentLevels.length,
                itemBuilder: (context, index) {
                  return CurrentLevelView(
                    index: index,
                    currentLevelModel: currentLevels[index],
                  );
                },
                separatorBuilder: (context, index) {
                  return 16.gh;
                },
              ),
            );
          },
        ),
      ],
    );
  }
}

class CurrentLevelView extends StatelessWidget {
  final CurrentLevelModel? currentLevelModel;
  final int index;

  const CurrentLevelView({
    super.key,
    required this.index,
    required this.currentLevelModel,
  });

  @override
  Widget build(BuildContext context) {
    return RadioListTile(
      visualDensity: VisualDensity(horizontal: -4),
      value: currentLevelModel?.title ?? "",
      title: Row(
        children: [
          Expanded(
            child: TtText(currentLevelModel?.title ?? ""),
          ),
          Row(
            children: List.generate(
              currentLevelModel?.rating ?? 0,
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
