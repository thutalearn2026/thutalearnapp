import 'package:flutter/material.dart';
import 'package:thuta_learn/core/core.dart';
import 'package:thuta_learn/features/home/home.dart';

class HomePage extends StatelessWidget {
  final VoidCallback? onExploreCourses;

  const HomePage({
    super.key,
    this.onExploreCourses,
  });

  static const String _demoBannerUrl =
      'https://learnthailikealocal.com/'
      'wp-content/uploads/2024/07/'
      'colorful-notepad-sight-words-flashcards10.png'
      '?w=1024';

  @override
  Widget build(BuildContext context) {
    const headerHeight = FeatureFlags.homePersonalStatsEnabled ? 200.0 : 112.0;

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
            expandedHeight: FeatureFlags.continueLearningEnabled
                ? headerHeight + 212
                : headerHeight,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  const LetsLearnTodaySectionView(),

                  if (FeatureFlags.continueLearningEnabled)
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
                if (FeatureFlags.homeBannersEnabled) ...[
                  16.gh,
                  HomeBannerSectionView(
                    imageUrls: const [
                      _demoBannerUrl,
                    ],
                  ),
                ],
                if (FeatureFlags.homeQuickMenuEnabled) ...[
                  14.gh,
                  const QuickMenuSectionView(),
                ],
                18.gh,
                _ExploreCoursesSectionView(
                  onTap: onExploreCourses,
                ),
                if (FeatureFlags.homeAiAssistantEnabled) ...[
                  18.gh,
                  const AskAiSectionView(),
                ],
                if (FeatureFlags.homeCurrentLearningEnabled) ...[
                  16.gh,
                  const CurrentLearningSectionView(),
                ],
                if (FeatureFlags.homeReviewEnabled) ...[
                  16.gh,
                  const ReviewSectionView(),
                ],
                100.gh,
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ExploreCoursesSectionView extends StatelessWidget {
  final VoidCallback? onTap;

  const _ExploreCoursesSectionView({
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(18),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Ink(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 18,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              gradient: const LinearGradient(
                colors: [
                  ColorUtils.primaryColor,
                  Color(0xFF256B86),
                ],
              ),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.menu_book_rounded,
                  color: Colors.white,
                  size: 34,
                ),
                SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TtText(
                        'Explore Thai Courses',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      SizedBox(height: 4),
                      TtText(
                        'Browse lessons, videos, quizzes and resources.',
                        fontSize: 13,
                        height: 1.3,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 10),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.white,
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
