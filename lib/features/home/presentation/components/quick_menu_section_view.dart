import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:thuta_learn/core/core.dart';

class QuickMenuSectionView extends StatelessWidget {
  final int savedVocabularyCount;

  const QuickMenuSectionView({
    super.key,
    this.savedVocabularyCount = 178,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TtText(
            'Quick Menu',
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: ColorUtils.homePageTitleColor,
          ),
          10.gh,
          QuickMenuItemView(
            imagePath: ImageUtils.reviewVocabularies,
            title: 'Review Vocabularies',
            description:
                'You saved $savedVocabularyCount '
                'vocabularies in total. Review Now!',
            onTap: () {
              HapticFeedback.lightImpact();

              context.push(
                Routes.savedVocabulary,
              );
            },
          ),
          10.gh,
          QuickMenuItemView(
            imagePath: ImageUtils.learningJourney,
            title: 'Your Learning Journey',
            description:
                'Discover the milestones you\'ve '
                'achieved along the way.',
            onTap: () {
              HapticFeedback.lightImpact();

              context.push(
                Routes.learningProgress,
              );
            },
          ),
        ],
      ),
    );
  }
}

class QuickMenuItemView extends StatelessWidget {
  final String imagePath;
  final String title;
  final String description;
  final VoidCallback onTap;

  const QuickMenuItemView({
    super.key,
    required this.imagePath,
    required this.title,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TtZoomTap(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFFE1E7EF),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(
                alpha: 0.05,
              ),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            QuickMenuImageView(
              imagePath: imagePath,
            ),
            12.gw,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TtText(
                    title,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: ColorUtils.primaryColor,
                  ),
                  4.gh,
                  TtText(
                    description,
                    fontSize: 14,
                    height: 1.3,
                    color: ColorUtils.greyTextColor,
                  ),
                ],
              ),
            ),
            8.gw,
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 19,
              color: ColorUtils.primaryColor,
            ),
            4.gw,
          ],
        ),
      ),
    );
  }
}

class QuickMenuImageView extends StatelessWidget {
  final String imagePath;

  const QuickMenuImageView({
    super.key,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 78,
      height: 78,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: ColorUtils.secondaryBackgroundColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Image.asset(
        imagePath,
        width: 62,
        height: 62,
        fit: BoxFit.contain,
        errorBuilder:
            (
              context,
              error,
              stackTrace,
            ) {
              // Temporary placeholder until you add
              // the exported Figma assets.
              return const Icon(
                Icons.auto_stories_outlined,
                size: 36,
                color: ColorUtils.secondaryColor,
              );
            },
      ),
    );
  }
}
