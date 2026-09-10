import 'package:flutter/material.dart';
import 'package:thuta_learn/core/core.dart';

class SearchVocabularyResultView extends StatelessWidget {
  final String thaiWord;
  final String pronunciation;
  final String englishMeaning;
  final String myanmarMeaning;
  final bool isSaved;
  final VoidCallback onAudio;
  final VoidCallback onFavorite;

  const SearchVocabularyResultView({
    super.key,
    required this.thaiWord,
    required this.pronunciation,
    required this.englishMeaning,
    required this.myanmarMeaning,
    required this.isSaved,
    required this.onAudio,
    required this.onFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        TtZoomTap(
          onTap: onAudio,
          child: Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              color: ColorUtils.secondaryBackgroundColor,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.volume_up_outlined,
              color: ColorUtils.secondaryColor,
              size: 24,
            ),
          ),
        ),
        14.gw,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 10,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  TtText(
                    thaiWord,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: ColorUtils.primaryColor,
                  ),
                  TtText(
                    pronunciation,
                    fontSize: 14,
                    color: ColorUtils.greyTextColor,
                  ),
                ],
              ),
              6.gh,
              Wrap(
                spacing: 10,
                runSpacing: 4,
                children: [
                  TtText(
                    englishMeaning,
                    fontSize: 14,
                  ),
                  const TtText(
                    '•',
                    fontSize: 14,
                  ),
                  TtText(
                    myanmarMeaning,
                    fontSize: 14,
                    family: TtFontFamily.myanmar_mn,
                  ),
                ],
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: onFavorite,
          icon: Icon(
            isSaved
                ? Icons.favorite_rounded
                : Icons.favorite_border_rounded,
            color: isSaved
                ? ColorUtils.secondaryColor
                : const Color(0xFF8393A7),
          ),
        ),
      ],
    );
  }
}

class SearchLessonResultView extends StatelessWidget {
  final String title;
  final String subtitle;
  final String duration;
  final VoidCallback onTap;
  final VoidCallback onDownload;

  const SearchLessonResultView({
    super.key,
    required this.title,
    required this.subtitle,
    required this.duration,
    required this.onTap,
    required this.onDownload,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        TtZoomTap(
          onTap: onTap,
          child: Container(
            width: 125,
            height: 78,
            decoration: BoxDecoration(
              color: const Color(0xFFB76A62),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Stack(
              children: [
                const Center(
                  child: Icon(
                    Icons.play_circle_fill_rounded,
                    size: 36,
                    color: Colors.white,
                  ),
                ),
                Positioned(
                  right: 6,
                  bottom: 5,
                  child: TtText(
                    duration,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
        14.gw,
        Expanded(
          child: TtZoomTap(
            onTap: onTap,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TtText(
                  title,
                  fontSize: 16,
                  height: 1.3,
                  fontWeight: FontWeight.bold,
                  color: ColorUtils.primaryColor,
                ),
                7.gh,
                TtText(
                  subtitle,
                  fontSize: 14,
                  height: 1.35,
                  fontStyle: FontStyle.italic,
                  color: ColorUtils.primaryColor,
                ),
              ],
            ),
          ),
        ),
        IconButton(
          onPressed: onDownload,
          icon: const Icon(
            Icons.download_outlined,
            color: ColorUtils.primaryColor,
          ),
        ),
      ],
    );
  }
}

class SearchScenarioCard extends StatelessWidget {
  final int index;
  final VoidCallback onTap;

  const SearchScenarioCard({
    super.key,
    required this.index,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const colors = [
      Color(0xFFB27474),
      Color(0xFF779B82),
      Color(0xFF8F769E),
    ];

    return TtZoomTap(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: colors[index % colors.length],
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(
          child: Icon(
            Icons.smart_display_rounded,
            size: 45,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}