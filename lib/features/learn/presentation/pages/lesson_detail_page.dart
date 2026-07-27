import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:thuta_learn/core/core.dart';
import 'package:thuta_learn/features/learn/learn.dart';

class LessonDetailPage extends StatefulWidget {
  final ModuleLessonItem lesson;

  const LessonDetailPage({
    super.key,
    required this.lesson,
  });

  @override
  State<LessonDetailPage> createState() =>
      _LessonDetailPageState();
}

class _LessonDetailPageState extends State<LessonDetailPage> {
  bool _isFavorite = false;

  @override
  Widget build(BuildContext context) {
    final lesson = widget.lesson;

    return Scaffold(
      backgroundColor: ColorUtils.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: ColorUtils.scaffoldBackgroundColor,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: context.pop,
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: ColorUtils.primaryColor,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _isFavorite = !_isFavorite;
              });
            },
            icon: Icon(
              _isFavorite
                  ? Icons.favorite_rounded
                  : Icons.favorite_border_rounded,
              color: _isFavorite
                  ? ColorUtils.secondaryColor
                  : ColorUtils.primaryColor,
              size: 30,
            ),
          ),
          8.gw,
        ],
      ),
      body: TtFadeIn(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
          children: [
            TtText(
              lesson.title,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: ColorUtils.primaryColor,
            ),
            if (lesson.myanmarTitle.isNotEmpty) ...[
              10.gh,
              TtText(
                lesson.myanmarTitle,
                fontSize: 14,
                family: TtFontFamily.myanmar_mn,
                color: ColorUtils.primaryColor,
              ),
            ],
            20.gh,
            LessonVideoSectionView(
              lessonNumber: lesson.lessonNumber,
              currentDuration: '0:32',
              totalDuration: lesson.duration,
              onPlay: () {
                // Initialize or play the video later.
              },
            ),
            20.gh,
            const LessonTranscriptSectionView(),
            24.gh,
            const LessonVocabularySectionView(),
            28.gh,
            const LessonSpecialNotesView(),
          ],
        ),
      ),
    );
  }
}