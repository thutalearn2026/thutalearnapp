import 'package:flutter/material.dart';
import 'package:thuta_learn/core/core.dart';
import 'package:thuta_learn/features/home/home.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
  });

  static const String _demoBannerUrl =
      'https://learnthailikealocal.com/'
      'wp-content/uploads/2024/07/'
      'colorful-notepad-sight-words-flashcards10.png'
      '?w=1024';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorUtils.scaffoldBackgroundColor,
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: ColorUtils.scaffoldBackgroundColor,
            automaticallyImplyLeading: false,
            expandedHeight: 412,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  const LetsLearnTodaySectionView(),
                  const Positioned(
                    left: 16,
                    right: 16,
                    bottom: 16,
                    child: LearningProgressSectionView(),
                  ),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                HomeBannerSectionView(
                  imageUrls: const [
                    _demoBannerUrl,
                    _demoBannerUrl,
                    _demoBannerUrl,
                  ],
                  onBannerTap: (index) {
                    // Handle banner navigation after
                    // the API supplies target actions.
                  },
                ),
                14.gh,

                // New Quick Menu section
                const QuickMenuSectionView(
                  savedVocabularyCount: 178,
                ),

                18.gh,
                const AskAiSectionView(),
                16.gh,
                const CurrentLearningSectionView(),
                16.gh,
                const ReviewSectionView(),
                100.gh,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
