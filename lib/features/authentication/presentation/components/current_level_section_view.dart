import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thuta_learn/core/core.dart';
import 'package:thuta_learn/features/authentication/authentication.dart';

class CurrentLevelsSectionView extends StatelessWidget {
  const CurrentLevelsSectionView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountSetUpBloc, AccountSetUpState>(
      builder: (context, state) {
        final currentLevels = state.currentLevels;

        return ListView(
          padding: const EdgeInsets.fromLTRB(
            16,
            24,
            16,
            24,
          ),
          children: [
            const TtText(
              'What is your current level?',
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
            16.gh,
            RadioGroup<String>(
              groupValue: state.selectedCurrentLevel?.key,
              onChanged: (value) {
                if (value == null) return;

                final selectedLevel =
                currentLevels.firstWhere(
                      (level) => level.key == value,
                );

                HapticFeedback.mediumImpact();

                context.read<AccountSetUpBloc>().add(
                  OnChooseCurrentLevel(
                    selectedLevel,
                  ),
                );
              },
              child: Column(
                children: List.generate(
                  currentLevels.length,
                      (index) {
                    return Padding(
                      padding: EdgeInsets.only(
                        bottom:
                        index == currentLevels.length - 1
                            ? 0
                            : 16,
                      ),
                      child: CurrentLevelView(
                        currentLevel: currentLevels[index],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class CurrentLevelView extends StatelessWidget {
  final OnboardingOptionModel currentLevel;

  const CurrentLevelView({
    super.key,
    required this.currentLevel,
  });

  @override
  Widget build(BuildContext context) {
    return BlocSelector<
        AccountSetUpBloc,
        AccountSetUpState,
        String?>(
      selector: (state) {
        return state.selectedCurrentLevel?.key;
      },
      builder: (context, selectedKey) {
        final isSelected = selectedKey == currentLevel.key;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: isSelected
                ? Border.all(
              color: ColorUtils.secondaryColor,
              width: 1.5,
            )
                : null,
          ),
          child: Material(
            color: isSelected
                ? const Color(0xFFECF6F5)
                : ColorUtils.surveyBackgroundColor,
            borderRadius: BorderRadius.circular(16),
            clipBehavior: Clip.antiAlias,
            child: RadioListTile<String>(
              value: currentLevel.key,
              visualDensity: const VisualDensity(
                horizontal: -4,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              activeColor: ColorUtils.secondaryColor,
              title: Row(
                children: [
                  Expanded(
                    child: TtText(
                      currentLevel.label,
                      fontSize: 14,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w400,
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(
                      currentLevel.value ?? 0,
                          (_) {
                        return const Icon(
                          Icons.star_rounded,
                          size: 20,
                          color: ColorUtils.secondaryColor,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}