import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thuta_learn/core/core.dart';
import 'package:thuta_learn/features/authentication/authentication.dart';

class LearningReasonSectionView extends StatelessWidget {
  const LearningReasonSectionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        24.gh,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TtText(
            "Why are you learning Thai?",
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        16.gh,
        BlocBuilder<AccountSetUpBloc, AccountSetUpState>(
          builder: (context, state) {
            var learningReasons = state.learningReasons ?? [];
            return ListView.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 16),
              itemCount: learningReasons.length,
              itemBuilder: (context, index) {
                return LearningReasonView(
                  learningReasonModel: learningReasons[index],
                  onTap: (LearningReasonModel? learningReason) {
                    context.read<AccountSetUpBloc>().add(
                      OnChooseLearningReason(learningReason),
                    );
                  },
                );
              },
              separatorBuilder: (context, index) {
                return 16.gh;
              },
            );
          },
        ),
      ],
    );
  }
}

class LearningReasonView extends StatelessWidget {
  final LearningReasonModel? learningReasonModel;
  final Function(LearningReasonModel?) onTap;

  const LearningReasonView({
    super.key,
    required this.learningReasonModel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountSetUpBloc, AccountSetUpState>(
      builder: (context, state) {
        var selectedLearningReason = state.selectedLearningReason;
        var isSelectedItem = learningReasonModel?.title == selectedLearningReason?.title;

        return TtZoomTap(
          onTap: () {
            onTap(learningReasonModel);
          },
          child: AnimatedContainer(
            duration: Duration(milliseconds: 300),
            padding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            decoration: BoxDecoration(
              color: isSelectedItem
                  ? Color.fromRGBO(236, 246, 245, 1.0)
                  : ColorUtils.surveyBackgroundColor,
              borderRadius: BorderRadius.circular(16),
              border: isSelectedItem
                  ? Border.all(color: ColorUtils.secondaryColor, width: 1.5)
                  : null,
            ),
            child: Row(
              spacing: 12,
              children: [
                AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelectedItem
                        ? Color.fromRGBO(214, 240, 237, 1.0)
                        : Color.fromRGBO(217, 223, 231, 1.0),
                  ),
                  child: Icon(
                    learningReasonModel?.iconData,
                    color: ColorUtils.primaryColor,
                    size: 20,
                  ),
                ),
                Expanded(
                  child: Column(
                    spacing: 4,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TtText(
                        learningReasonModel?.title ?? "",
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                      TtText(
                        learningReasonModel?.subtitle ?? "",
                        color: Color.fromRGBO(100, 115, 139, 1.0),
                        fontSize: 13,
                      ),
                    ],
                  ),
                ),
                isSelectedItem
                    ? TtFadeIn(
                        isAnimatedScale: true,
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: ColorUtils.secondaryColor,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.done,
                            color: Colors.white,
                          ),
                        ),
                      )
                    : SizedBox.shrink(),
              ],
            ),
          ),
        );
      },
    );
  }
}
