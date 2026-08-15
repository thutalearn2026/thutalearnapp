import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thuta_learn/core/core.dart';
import 'package:thuta_learn/features/authentication/authentication.dart';

class LearningReasonSectionView extends StatelessWidget {
  const LearningReasonSectionView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountSetUpBloc, AccountSetUpState>(
      builder: (context, state) {
        return ListView(
          padding: const EdgeInsets.fromLTRB(
            16,
            24,
            16,
            24,
          ),
          children: [
            const TtText(
              'Why are you learning Thai?',
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
            16.gh,
            ...List.generate(
              state.learningReasons.length,
                  (index) {
                final learningReason =
                state.learningReasons[index];

                return Padding(
                  padding: EdgeInsets.only(
                    bottom: index ==
                        state.learningReasons.length - 1
                        ? 0
                        : 16,
                  ),
                  child: LearningReasonView(
                    learningReason: learningReason,
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}

class LearningReasonView extends StatelessWidget {
  final OnboardingOptionModel learningReason;

  const LearningReasonView({
    super.key,
    required this.learningReason,
  });

  @override
  Widget build(BuildContext context) {
    return BlocSelector<
        AccountSetUpBloc,
        AccountSetUpState,
        String?>(
      selector: (state) {
        return state.selectedLearningReason?.key;
      },
      builder: (context, selectedKey) {
        final isSelected = selectedKey == learningReason.key;

        return TtZoomTap(
          onTap: () {
            context.read<AccountSetUpBloc>().add(
              OnChooseLearningReason(
                learningReason,
              ),
            );
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color.fromRGBO(236, 246, 245, 1)
                  : ColorUtils.surveyBackgroundColor,
              borderRadius: BorderRadius.circular(16),
              border: isSelected
                  ? Border.all(
                color: ColorUtils.secondaryColor,
                width: 1.5,
              )
                  : null,
            ),
            child: Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected
                        ? const Color.fromRGBO(
                      214,
                      240,
                      237,
                      1,
                    )
                        : const Color.fromRGBO(
                      217,
                      223,
                      231,
                      1,
                    ),
                  ),
                  child: Icon(
                    _getOnboardingIcon(
                      learningReason.icon,
                    ),
                    color: ColorUtils.primaryColor,
                    size: 20,
                  ),
                ),
                12.gw,
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      TtText(
                        learningReason.label,
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                      if (learningReason.description != null &&
                          learningReason
                              .description!.isNotEmpty) ...[
                        4.gh,
                        TtText(
                          learningReason.description!,
                          color: const Color.fromRGBO(
                            100,
                            115,
                            139,
                            1,
                          ),
                          fontSize: 14,
                        ),
                      ],
                    ],
                  ),
                ),
                if (isSelected) ...[
                  12.gw,
                  TtFadeIn(
                    isAnimatedScale: true,
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: const BoxDecoration(
                        color: ColorUtils.secondaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.done,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  IconData _getOnboardingIcon(String? icon) {
    switch (icon) {
      case 'briefcase':
        return Icons.work_outline_rounded;

      case 'travel':
      case 'plane':
      case 'home':
        return Icons.flight_takeoff_rounded;

      case 'education':
      case 'school':
      case 'academic-cap':
        return Icons.school_outlined;

      case 'conversation':
      case 'chat':
        return Icons.chat_bubble_outline_rounded;

      case 'family':
        return Icons.family_restroom_rounded;

      default:
        return Icons.menu_book_outlined;
    }
  }
}