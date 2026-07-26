import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thuta_learn/core/core.dart';
import 'package:thuta_learn/features/authentication/authentication.dart';

class DailyGoalSectionView extends StatelessWidget {
  const DailyGoalSectionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        24.gh,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TtText(
            "What is your daily goal?",
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        16.gh,
        DailyGoalsSectionView(),
        Spacer(),
        Container(
          width: double.infinity,
          margin: EdgeInsets.symmetric(horizontal: 16),
          child: TtButton(
            onTap: () {},
            child: TtText(
              StringUtils.continueLabel,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        16.gh,
      ],
    );
  }
}

class DailyGoalsSectionView extends StatelessWidget {
  const DailyGoalsSectionView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountSetUpBloc, AccountSetUpState>(
      builder: (context, state) {
        var dailyGoals = state.dailyGoals ?? [];
        var selectedDailyGoal = state.selectedDailyGoal;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            spacing: 8,
            children: List.generate(
              dailyGoals.length,
              (index) {
                return Expanded(
                  child: TtZoomTap(
                    onTap: () {
                      context.read<AccountSetUpBloc>().add(
                        OnChooseDailyGoal(dailyGoals[index]),
                      );
                    },
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      padding: EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: selectedDailyGoal?.min == dailyGoals[index].min
                            ? ColorUtils.secondaryColor
                            : ColorUtils.surveyBackgroundColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TtText(
                            dailyGoals[index].min,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: selectedDailyGoal?.min == dailyGoals[index].min
                                ? Colors.white
                                : Colors.black,
                          ),
                          TtText(
                            "min/day",
                            fontSize: 13,
                            color: selectedDailyGoal?.min == dailyGoals[index].min
                                ? Color.fromRGBO(109, 241, 237, 1.0)
                                : Colors.black.withValues(alpha: 0.5),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
