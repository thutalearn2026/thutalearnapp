import 'package:flutter/material.dart';
import 'package:thuta_learn/core/core.dart';
import 'package:thuta_learn/features/profile/profile.dart';

class SavedVocabularyItemView extends StatelessWidget {
  final SavedVocabularyItem item;
  final VoidCallback onAudio;
  final VoidCallback onRemove;

  const SavedVocabularyItemView({
    super.key,
    required this.item,
    required this.onAudio,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        TtZoomTap(
          onTap: onAudio,
          child: Container(
            width: 56,
            height: 56,
            decoration: const BoxDecoration(
              color: ColorUtils.secondaryBackgroundColor,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.volume_up_outlined,
              size: 28,
              color: ColorUtils.secondaryColor,
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
                runSpacing: 4,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  TtText(
                    item.thaiWord,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: ColorUtils.primaryColor,
                  ),
                  TtText(
                    item.pronunciation,
                    fontSize: 14,
                    color: ColorUtils.greyTextColor,
                  ),
                ],
              ),
              7.gh,
              Wrap(
                spacing: 10,
                runSpacing: 5,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  TtText(
                    item.englishMeaning,
                    fontSize: 14,
                    color: ColorUtils.primaryColor,
                  ),
                  const TtText(
                    '•',
                    fontSize: 14,
                    color: ColorUtils.primaryColor,
                  ),
                  TtText(
                    item.myanmarMeaning,
                    fontSize: 14,
                    family: TtFontFamily.myanmar_mn,
                    color: ColorUtils.primaryColor,
                  ),
                ],
              ),
            ],
          ),
        ),
        12.gw,
        TtZoomTap(
          onTap: onRemove,
          child: const Padding(
            padding: EdgeInsets.all(6),
            child: Icon(
              Icons.favorite_rounded,
              size: 30,
              color: ColorUtils.secondaryColor,
            ),
          ),
        ),
      ],
    );
  }
}