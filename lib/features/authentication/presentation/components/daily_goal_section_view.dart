import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thuta_learn/core/core.dart';
import 'package:thuta_learn/features/authentication/authentication.dart';

class DailyGoalSectionView extends StatelessWidget {
  const DailyGoalSectionView({super.key});

  void _submit(BuildContext context) {
    final bloc = context.read<AccountSetUpBloc>();
    final state = bloc.state;

    if (state.isSubmitting) return;

    if (state.selectedLearningReason == null) {
      context.showSnackBar(
        'Please select your learning reason.',
        snackBarType: SnackBarType.warning,
      );
      return;
    }

    if (state.selectedCurrentLevel == null) {
      context.showSnackBar(
        'Please select your current level.',
        snackBarType: SnackBarType.warning,
      );
      return;
    }

    if (state.selectedDailyGoal == null) {
      context.showSnackBar(
        'Please select your daily goal.',
        snackBarType: SnackBarType.warning,
      );
      return;
    }

    bloc.add(
      OnSubmitOnboardingPreferences(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        24.gh,
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: TtText(
            'What is your daily goal?',
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        16.gh,
        const DailyGoalsSectionView(),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: BlocSelector<AccountSetUpBloc, AccountSetUpState, bool>(
            selector: (state) {
              return state.isSubmitting;
            },
            builder: (context, isSubmitting) {
              return SizedBox(
                width: double.infinity,
                child: TtButton(
                  onTap: () {
                    _submit(context);
                  },
                  child: isSubmitting
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : TtText(
                          StringUtils.continueLabel,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                ),
              );
            },
          ),
        ),
        16.gh,
      ],
    );
  }
}

class DailyGoalsSectionView extends StatelessWidget {
  const DailyGoalsSectionView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountSetUpBloc, AccountSetUpState>(
      builder: (context, state) {
        final dailyGoals = state.dailyGoals;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: List.generate(
              dailyGoals.length,
              (index) {
                final dailyGoal = dailyGoals[index];

                final isSelected = state.selectedDailyGoal?.key == dailyGoal.key;

                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: index == dailyGoals.length - 1 ? 0 : 8,
                    ),
                    child: TtZoomTap(
                      onTap: () {
                        if (state.isSubmitting) return;

                        context.read<AccountSetUpBloc>().add(
                          OnChooseDailyGoal(
                            dailyGoal,
                          ),
                        );
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? ColorUtils.secondaryColor
                              : ColorUtils.surveyBackgroundColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TtText(
                              '${dailyGoal.value ?? 0}',
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: isSelected ? Colors.white : Colors.black,
                            ),
                            TtText(
                              'min/day',
                              fontSize: 14,
                              color: isSelected
                                  ? const Color.fromRGBO(
                                      109,
                                      241,
                                      237,
                                      1,
                                    )
                                  : Colors.black.withValues(
                                      alpha: 0.5,
                                    ),
                            ),
                          ],
                        ),
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
