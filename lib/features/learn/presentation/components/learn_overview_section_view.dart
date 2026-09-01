import 'package:flutter/material.dart';
import 'package:thuta_learn/core/core.dart';
import 'package:thuta_learn/features/learn/learn.dart';

class LearnOverviewSectionView extends StatelessWidget {
  final WordOfTheDayModel? wordOfTheDay;
  final bool isWordOfTheDayLoading;

  const LearnOverviewSectionView({
    super.key,
    required this.wordOfTheDay,
    required this.isWordOfTheDayLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (isWordOfTheDayLoading) ...[
          const _WordOfTheDayLoadingView(),
          16.gh,
        ] else if (wordOfTheDay != null) ...[
          WordOfTheDaySectionView(
            wordOfTheDay: wordOfTheDay!,
          ),
          16.gh,
        ],
        const CurrentLevelSectionView(),
      ],
    );
  }
}

class WordOfTheDaySectionView
    extends StatelessWidget {
  final WordOfTheDayModel wordOfTheDay;

  const WordOfTheDaySectionView({
    super.key,
    required this.wordOfTheDay,
  });

  @override
  Widget build(BuildContext context) {
    final word = wordOfTheDay.word.trim();
    final romanization =
    wordOfTheDay.romanization.trim();
    final meaning =
    wordOfTheDay.meaning.trim();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 6,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: ColorUtils.secondaryColor,
                  borderRadius:
                  BorderRadius.circular(2),
                ),
                child: const TtText(
                  'Word of the day',
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              6.gh,
              Wrap(
                spacing: 6,
                runSpacing: 4,
                crossAxisAlignment:
                WrapCrossAlignment.center,
                children: [
                  TtText(
                    word,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                  if (romanization.isNotEmpty)
                    TtText(
                      romanization,
                      fontSize: 9,
                      color:
                      ColorUtils.greyTextColor,
                    ),
                  if (meaning.isNotEmpty)
                    TtText(
                      '• $meaning',
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                    ),
                ],
              ),
            ],
          ),
        ),
        12.gw,
        Container(
          width: 40,
          height: 40,
          decoration: const BoxDecoration(
            color: Color(0xFFF0F2F5),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.language_rounded,
            size: 20,
            color: ColorUtils.primaryColor,
          ),
        ),
      ],
    );
  }
}

class _WordOfTheDayLoadingView
    extends StatelessWidget {
  const _WordOfTheDayLoadingView();

  @override
  Widget build(BuildContext context) {
    return TtShimmer(
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Container(
                  width: 130,
                  height: 28,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                    BorderRadius.circular(2),
                  ),
                ),
                8.gh,
                Container(
                  width: 210,
                  height: 18,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                    BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }
}

class CurrentLevelSectionView
    extends StatelessWidget {
  const CurrentLevelSectionView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    const double currentProgress = 0.32;
    const int currentLevelIndex = 0;
    const int levelCount = 3;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color:
        ColorUtils.secondaryBackgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: ColorUtils.secondaryColor
              .withValues(alpha: 0.55),
        ),
      ),
      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.center,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: const BoxDecoration(
              color: ColorUtils.secondaryColor,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.school_outlined,
              color: Colors.white,
              size: 28,
            ),
          ),
          14.gw,
          const Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                TtText(
                  'Current Level',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                SizedBox(height: 12),
                SegmentedLevelProgressView(
                  currentLevelIndex:
                  currentLevelIndex,
                  levelCount: levelCount,
                  currentProgress:
                  currentProgress,
                ),
                SizedBox(height: 12),
                _CurrentLevelInformationView(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SegmentedLevelProgressView
    extends StatelessWidget {
  final int currentLevelIndex;
  final int levelCount;
  final double currentProgress;

  const SegmentedLevelProgressView({
    super.key,
    required this.currentLevelIndex,
    required this.levelCount,
    required this.currentProgress,
  });

  double _progressForLevel(int index) {
    if (index < currentLevelIndex) {
      return 1;
    }

    if (index == currentLevelIndex) {
      return currentProgress.clamp(0, 1);
    }

    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        levelCount,
            (index) {
          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                right:
                index == levelCount - 1
                    ? 0
                    : 8,
              ),
              child: ClipRRect(
                borderRadius:
                BorderRadius.circular(20),
                child: LinearProgressIndicator(
                  value:
                  _progressForLevel(index),
                  minHeight: 7,
                  backgroundColor:
                  const Color(0xFFE2E5E9),
                  valueColor:
                  const AlwaysStoppedAnimation<
                      Color
                  >(
                    ColorUtils.secondaryColor,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _CurrentLevelInformationView
    extends StatelessWidget {
  const _CurrentLevelInformationView();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 6,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius:
            BorderRadius.circular(8),
          ),
          child: const TtText(
            'Beginner',
            fontSize: 14,
            color: ColorUtils.primaryColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        12.gw,
        const Expanded(
          child: TtText(
            '32% to intermediate level',
            fontSize: 14,
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}