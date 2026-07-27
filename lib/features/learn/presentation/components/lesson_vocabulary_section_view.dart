import 'package:flutter/material.dart';
import 'package:thuta_learn/core/core.dart';
import 'package:thuta_learn/features/learn/learn.dart';

class LessonVocabularySectionView extends StatefulWidget {
  const LessonVocabularySectionView({super.key});

  @override
  State<LessonVocabularySectionView> createState() =>
      _LessonVocabularySectionViewState();
}

class _LessonVocabularySectionViewState
    extends State<LessonVocabularySectionView> {
  final Set<int> _favoriteIndexes = {};

  static const List<VocabularyItem> _items = [
    VocabularyItem(
      thaiWord: 'สวัสดี',
      pronunciation: 'sa-wat-dee',
      englishMeaning: 'Hello',
      myanmarMeaning: 'မင်္ဂလာပါ',
    ),
    VocabularyItem(
      thaiWord: 'ขอบคุณ',
      pronunciation: 'khop-khun',
      englishMeaning: 'Thank you',
      myanmarMeaning: 'ကျေးဇူးတင်ပါတယ်',
    ),
    VocabularyItem(
      thaiWord: 'ยินดี',
      pronunciation: 'yin-dee',
      englishMeaning: 'Pleased to meet you',
      myanmarMeaning: 'တွေ့ရတာဝမ်းသာပါတယ်',
    ),
    VocabularyItem(
      thaiWord: 'งาน',
      pronunciation: 'ngaan',
      englishMeaning: 'Work / Job',
      myanmarMeaning: 'အလုပ်',
    ),
  ];

  void _toggleFavorite(int index) {
    setState(() {
      if (_favoriteIndexes.contains(index)) {
        _favoriteIndexes.remove(index);
      } else {
        _favoriteIndexes.add(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TtText(
          'Vocabulary in this video',
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        16.gh,
        ListView.separated(
          itemCount: _items.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          separatorBuilder: (context, index) => 18.gh,
          itemBuilder: (context, index) {
            return VocabularyItemView(
              item: _items[index],
              isFavorite: _favoriteIndexes.contains(index),
              onFavorite: () => _toggleFavorite(index),
              onAudio: () {
                // Play vocabulary pronunciation later.
              },
            );
          },
        ),
      ],
    );
  }
}

class VocabularyItemView extends StatelessWidget {
  final VocabularyItem item;
  final bool isFavorite;
  final VoidCallback onFavorite;
  final VoidCallback onAudio;

  const VocabularyItemView({
    super.key,
    required this.item,
    required this.isFavorite,
    required this.onFavorite,
    required this.onAudio,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        TtZoomTap(
          onTap: onAudio,
          child: Container(
            width: 52,
            height: 52,
            decoration: const BoxDecoration(
              color: ColorUtils.secondaryBackgroundColor,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.volume_up_outlined,
              color: ColorUtils.secondaryColor,
              size: 26,
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
              6.gh,
              Wrap(
                spacing: 10,
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
        IconButton(
          onPressed: onFavorite,
          icon: Icon(
            isFavorite
                ? Icons.favorite_rounded
                : Icons.favorite_border_rounded,
            color: isFavorite
                ? ColorUtils.secondaryColor
                : const Color(0xFF8294A9),
          ),
        ),
      ],
    );
  }
}