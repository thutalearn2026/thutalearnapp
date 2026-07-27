import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:thuta_learn/core/core.dart';
import 'package:thuta_learn/features/profile/profile.dart';

class SavedVocabularyPage extends StatefulWidget {
  const SavedVocabularyPage({super.key});

  @override
  State<SavedVocabularyPage> createState() =>
      _SavedVocabularyPageState();
}

class _SavedVocabularyPageState
    extends State<SavedVocabularyPage> {
  bool _isAlphabeticallySorted = false;

  final List<SavedVocabularyItem> _items = [
    const SavedVocabularyItem(
      id: 1,
      originalOrder: 1,
      thaiWord: 'สวัสดี',
      pronunciation: 'sa-wat-dee',
      englishMeaning: 'Hello',
      myanmarMeaning: 'မင်္ဂလာပါ',
    ),
    const SavedVocabularyItem(
      id: 2,
      originalOrder: 2,
      thaiWord: 'ขอบคุณ',
      pronunciation: 'khop-khun',
      englishMeaning: 'Thank you',
      myanmarMeaning: 'ကျေးဇူးတင်ပါတယ်',
    ),
    const SavedVocabularyItem(
      id: 3,
      originalOrder: 3,
      thaiWord: 'ยินดี',
      pronunciation: 'yin-dee',
      englishMeaning: 'Pleased to meet you',
      myanmarMeaning: 'တွေ့ရတာဝမ်းသာပါတယ်',
    ),
    const SavedVocabularyItem(
      id: 4,
      originalOrder: 4,
      thaiWord: 'งาน',
      pronunciation: 'ngaan',
      englishMeaning: 'Work / Job',
      myanmarMeaning: 'အလုပ်',
    ),
    const SavedVocabularyItem(
      id: 5,
      originalOrder: 5,
      thaiWord: 'สวัสดีครับ',
      pronunciation: 'sa-wat-dee khrap',
      englishMeaning: 'Hello',
      myanmarMeaning: 'မင်္ဂလာပါ',
    ),
    const SavedVocabularyItem(
      id: 6,
      originalOrder: 6,
      thaiWord: 'ขอบคุณครับ',
      pronunciation: 'khop-khun khrap',
      englishMeaning: 'Thank you',
      myanmarMeaning: 'ကျေးဇူးတင်ပါတယ်',
    ),
    const SavedVocabularyItem(
      id: 7,
      originalOrder: 7,
      thaiWord: 'ลาก่อน',
      pronunciation: 'la-gon',
      englishMeaning: 'Goodbye',
      myanmarMeaning: 'နှုတ်ဆက်ပါတယ်',
    ),
    const SavedVocabularyItem(
      id: 8,
      originalOrder: 8,
      thaiWord: 'อาหาร',
      pronunciation: 'aa-harn',
      englishMeaning: 'Food',
      myanmarMeaning: 'အစားအစာ',
    ),
  ];

  void _sortItems() {
    setState(() {
      _isAlphabeticallySorted =
      !_isAlphabeticallySorted;

      if (_isAlphabeticallySorted) {
        _items.sort(
              (first, second) => first.pronunciation.compareTo(
            second.pronunciation,
          ),
        );
      } else {
        _items.sort(
              (first, second) => first.originalOrder.compareTo(
            second.originalOrder,
          ),
        );
      }
    });
  }

  void _removeItem(SavedVocabularyItem item) {
    final removedIndex = _items.indexOf(item);

    setState(() {
      _items.remove(item);
    });

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: TtText(
            '${item.thaiWord} removed from saved vocabulary',
            fontSize: 14,
            color: Colors.white,
          ),
          action: SnackBarAction(
            label: 'Undo',
            textColor: ColorUtils.secondaryColor,
            onPressed: () {
              setState(() {
                final insertIndex = removedIndex.clamp(
                  0,
                  _items.length,
                );

                _items.insert(insertIndex, item);

                if (_isAlphabeticallySorted) {
                  _items.sort(
                        (first, second) =>
                        first.pronunciation.compareTo(
                          second.pronunciation,
                        ),
                  );
                }
              });
            },
          ),
        ),
      );
  }

  void _playAudio(SavedVocabularyItem item) {
    // Play item pronunciation audio here later.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorUtils.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: ColorUtils.scaffoldBackgroundColor,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: context.pop,
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: ColorUtils.primaryColor,
          ),
        ),
        title: const TtText(
          'Saved Vocabulary',
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        actions: [
          IconButton(
            tooltip: _isAlphabeticallySorted
                ? 'Restore saved order'
                : 'Sort alphabetically',
            onPressed: _sortItems,
            icon: Icon(
              _isAlphabeticallySorted
                  ? Icons.sort_by_alpha_rounded
                  : Icons.sort_rounded,
              size: 29,
              color: ColorUtils.primaryColor,
            ),
          ),
          8.gw,
        ],
      ),
      body: _items.isEmpty
          ? const SavedVocabularyEmptyView()
          : ListView.separated(
        padding: const EdgeInsets.fromLTRB(
          16,
          22,
          16,
          32,
        ),
        itemCount: _items.length,
        separatorBuilder: (context, index) {
          return 22.gh;
        },
        itemBuilder: (context, index) {
          final item = _items[index];

          return SavedVocabularyItemView(
            key: ValueKey(item.id),
            item: item,
            onAudio: () {
              _playAudio(item);
            },
            onRemove: () {
              _removeItem(item);
            },
          );
        },
      ),
    );
  }
}

class SavedVocabularyEmptyView extends StatelessWidget {
  const SavedVocabularyEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: const BoxDecoration(
                color: ColorUtils.secondaryBackgroundColor,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.favorite_border_rounded,
                size: 44,
                color: ColorUtils.secondaryColor,
              ),
            ),
            20.gh,
            const TtText(
              'No saved vocabulary',
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            10.gh,
            const TtText(
              'Tap the heart icon on vocabulary words to '
                  'save them for later.',
              fontSize: 14,
              height: 1.4,
              textAlign: TextAlign.center,
              color: ColorUtils.greyTextColor,
            ),
          ],
        ),
      ),
    );
  }
}