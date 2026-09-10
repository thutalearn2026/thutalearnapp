import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:thuta_learn/core/core.dart';
import 'package:thuta_learn/features/search/search.dart';

class SearchResultsPage extends StatefulWidget {
  final String query;

  const SearchResultsPage({
    super.key,
    required this.query,
  });

  @override
  State<SearchResultsPage> createState() =>
      _SearchResultsPageState();
}

class _SearchResultsPageState
    extends State<SearchResultsPage> {
  final Set<int> _savedVocabularyIndexes = {};

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
        title: TtText(
          widget.query,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          16,
          16,
          16,
          32,
        ),
        children: [
          const TtText(
            'Vocabs',
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          16.gh,
          ...List.generate(
            3,
                (index) {
              const words = [
                (
                thai: 'สวัสดี',
                pronunciation: 'sa-wat-dee',
                english: 'Hello',
                myanmar: 'မင်္ဂလာပါ',
                ),
                (
                thai: 'ขอบคุณ',
                pronunciation: 'khop-khun',
                english: 'Thank you',
                myanmar: 'ကျေးဇူးတင်ပါတယ်',
                ),
                (
                thai: 'ยินดี',
                pronunciation: 'yin-dee',
                english: 'Pleased to meet you',
                myanmar: 'တွေ့ရတာဝမ်းသာပါတယ်',
                ),
              ];

              final word = words[index];

              return Padding(
                padding: const EdgeInsets.only(bottom: 18),
                child: SearchVocabularyResultView(
                  thaiWord: word.thai,
                  pronunciation: word.pronunciation,
                  englishMeaning: word.english,
                  myanmarMeaning: word.myanmar,
                  isSaved:
                  _savedVocabularyIndexes.contains(index),
                  onAudio: () {
                    // Play pronunciation later.
                  },
                  onFavorite: () {
                    setState(() {
                      if (_savedVocabularyIndexes
                          .contains(index)) {
                        _savedVocabularyIndexes.remove(index);
                      } else {
                        _savedVocabularyIndexes.add(index);
                      }
                    });
                  },
                ),
              );
            },
          ),
          16.gh,
          const TtText(
            'Lessons',
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          16.gh,
          SearchLessonResultView(
            title: 'Asking Someone’s Name',
            subtitle:
            'Polite and Systematic Greetings in Thai',
            duration: '8:06',
            onTap: () {
              // Navigate to LessonDetailPage.
            },
            onDownload: () {
              // Download lesson later.
            },
          ),
          16.gh,
          SearchLessonResultView(
            title: 'Thai Personal Pronouns',
            subtitle:
            'Polite and Systematic Greetings in Thai',
            duration: '8:06',
            onTap: () {
              // Navigate to LessonDetailPage.
            },
            onDownload: () {
              // Download lesson later.
            },
          ),
          26.gh,
          const TtText(
            'Real-life Scenarios',
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          16.gh,
          GridView.builder(
            itemCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 0.72,
            ),
            itemBuilder: (context, index) {
              return SearchScenarioCard(
                index: index,
                onTap: () {
                  // Open the scenario video later.
                },
              );
            },
          ),
        ],
      ),
    );
  }
}