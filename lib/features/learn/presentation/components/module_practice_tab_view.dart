import 'package:flutter/material.dart';
import 'package:thuta_learn/core/core.dart';
import 'package:thuta_learn/features/learn/learn.dart';

typedef ChapterQuizTapCallback = void Function(
    ChapterModel chapter,
    ChapterQuizModel quiz,
    );

class ModulePracticeTabView extends StatelessWidget {
  final List<ChapterModel> chapters;

  final Map<String, List<ChapterQuizModel>>
  quizzesByChapter;

  final Set<String> loadingChapterIds;

  final Map<String, String> chapterErrors;

  final ValueChanged<ChapterModel>
  onChapterExpanded;

  final ValueChanged<ChapterModel> onRetryChapter;

  final ChapterQuizTapCallback onQuizTap;

  const ModulePracticeTabView({
    super.key,
    required this.chapters,
    required this.quizzesByChapter,
    required this.loadingChapterIds,
    required this.chapterErrors,
    required this.onChapterExpanded,
    required this.onRetryChapter,
    required this.onQuizTap,
  });

  @override
  Widget build(BuildContext context) {
    if (chapters.isEmpty) {
      return const _EmptyPracticeView();
    }

    return ListView.separated(
      key: const PageStorageKey(
        'module-practice',
      ),
      padding: const EdgeInsets.fromLTRB(
        16,
        16,
        16,
        32,
      ),
      itemCount: chapters.length,
      separatorBuilder: (_, __) {
        return 14.gh;
      },
      itemBuilder: (context, index) {
        final chapter = chapters[index];

        return _PracticeChapterSection(
          chapter: chapter,
          chapterNumber: index + 1,
          initiallyExpanded: index == 0,
          quizzes: quizzesByChapter[chapter.id],
          isLoading: loadingChapterIds.contains(
            chapter.id,
          ),
          error: chapterErrors[chapter.id],
          onExpanded: () {
            onChapterExpanded(chapter);
          },
          onRetry: () {
            onRetryChapter(chapter);
          },
          onQuizTap: (quiz) {
            onQuizTap(
              chapter,
              quiz,
            );
          },
        );
      },
    );
  }
}

class _PracticeChapterSection
    extends StatelessWidget {
  final ChapterModel chapter;
  final int chapterNumber;
  final bool initiallyExpanded;
  final List<ChapterQuizModel>? quizzes;
  final bool isLoading;
  final String? error;
  final VoidCallback onExpanded;
  final VoidCallback onRetry;
  final ValueChanged<ChapterQuizModel> onQuizTap;

  const _PracticeChapterSection({
    required this.chapter,
    required this.chapterNumber,
    required this.initiallyExpanded,
    required this.quizzes,
    required this.isLoading,
    required this.error,
    required this.onExpanded,
    required this.onRetry,
    required this.onQuizTap,
  });

  String get _subtitle {
    if (isLoading) {
      return 'Loading practice activities...';
    }

    if (quizzes == null) {
      return 'Tap to view practice activities';
    }

    return '${quizzes!.length} activit'
        '${quizzes!.length == 1 ? 'y' : 'ies'}';
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 1,
      shadowColor: Colors.black.withValues(
        alpha: 0.08,
      ),
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
          splashColor:
          ColorUtils.secondaryColor.withValues(
            alpha: 0.08,
          ),
          highlightColor:
          ColorUtils.secondaryColor.withValues(
            alpha: 0.04,
          ),
        ),
        child: ExpansionTile(
          key: PageStorageKey(
            'practice-chapter-${chapter.id}',
          ),
          initiallyExpanded: initiallyExpanded,
          maintainState: true,
          onExpansionChanged: (expanded) {
            if (expanded) {
              onExpanded();
            }
          },
          tilePadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 7,
          ),
          childrenPadding: EdgeInsets.zero,
          collapsedShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(
              color: Color(0xFFE2E7EE),
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color:
              ColorUtils.secondaryColor.withValues(
                alpha: 0.45,
              ),
            ),
          ),
          leading: _ChapterNumberView(
            chapterNumber: chapterNumber,
          ),
          title: TtText(
            chapter.title,
            fontSize: 16,
            height: 1.3,
            fontWeight: FontWeight.bold,
            color: ColorUtils.primaryColor,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 5),
            child: TtText(
              _subtitle,
              fontSize: 14,
              color: ColorUtils.greyTextColor,
            ),
          ),
          iconColor: ColorUtils.primaryColor,
          collapsedIconColor:
          ColorUtils.primaryColor,
          children: [
            const Divider(
              height: 1,
              color: Color(0xFFE7EBF0),
            ),
            _buildContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (isLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(
          vertical: 28,
        ),
        child: Center(
          child: CircularProgressIndicator(
            color: ColorUtils.secondaryColor,
          ),
        ),
      );
    }

    if (error != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 22,
        ),
        child: Column(
          children: [
            const Icon(
              Icons.error_outline_rounded,
              size: 30,
              color: Colors.red,
            ),
            8.gh,
            TtText(
              error!,
              fontSize: 14,
              height: 1.4,
              color: Colors.red,
              textAlign: TextAlign.center,
            ),
            10.gh,
            TextButton.icon(
              onPressed: onRetry,
              icon: const Icon(
                Icons.refresh_rounded,
                color: ColorUtils.primaryColor,
              ),
              label: const TtText(
                'Try Again',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: ColorUtils.primaryColor,
              ),
            ),
          ],
        ),
      );
    }

    if (quizzes == null) {
      return const _PracticeMessageView(
        icon: Icons.touch_app_outlined,
        message:
        'Expand this chapter to load its practice activities.',
      );
    }

    if (quizzes!.isEmpty) {
      return const _PracticeMessageView(
        icon: Icons.quiz_outlined,
        message:
        'No practice activities are available in this chapter.',
      );
    }

    return Padding(
      padding: const EdgeInsets.all(14),
      child: Column(
        children: List.generate(
          quizzes!.length,
              (index) {
            final quiz = quizzes![index];

            return Padding(
              padding: EdgeInsets.only(
                bottom:
                index == quizzes!.length - 1
                    ? 0
                    : 14,
              ),
              child: PracticeOptionCard(
                quiz: quiz,
                onTap: () {
                  onQuizTap(quiz);
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

class PracticeOptionCard extends StatelessWidget {
  final ChapterQuizModel quiz;
  final VoidCallback onTap;

  const PracticeOptionCard({
    super.key,
    required this.quiz,
    required this.onTap,
  });

  String get _normalizedType {
    return quiz.type
        .trim()
        .toLowerCase()
        .replaceAll('-', '_')
        .replaceAll(' ', '_');
  }

  IconData get _icon {
    switch (_normalizedType) {
      case 'pronunciation':
      case 'pronunciation_drill':
        return Icons.mic_none_rounded;

      case 'vocabulary':
      case 'vocab':
      case 'flash_card':
      case 'flash_cards':
        return Icons.style_outlined;

      case 'listening':
        return Icons.headphones_outlined;

      case 'multiple_choice':
      case 'reading':
      default:
        return Icons.lightbulb_outline_rounded;
    }
  }

  Color get _iconColor {
    switch (_normalizedType) {
      case 'pronunciation':
      case 'pronunciation_drill':
        return const Color(0xFFE28B38);

      case 'vocabulary':
      case 'vocab':
      case 'flash_card':
      case 'flash_cards':
        return const Color(0xFF48A9D6);

      case 'listening':
        return const Color(0xFF9C6ADE);

      default:
        return const Color(0xFFF4C430);
    }
  }

  String get _typeLabel {
    return quiz.type
        .trim()
        .replaceAll('_', ' ')
        .split(' ')
        .where((word) => word.isNotEmpty)
        .map(
          (word) {
        return '${word[0].toUpperCase()}'
            '${word.substring(1)}';
      },
    )
        .join(' ');
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 1,
      shadowColor: Colors.black.withValues(
        alpha: 0.06,
      ),
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: ColorUtils.secondaryColor,
                width: 4,
              ),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: const BoxDecoration(
                  color: Color(0xFFF3F5F7),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _icon,
                  size: 29,
                  color: _iconColor,
                ),
              ),
              14.gw,
              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    TtText(
                      quiz.title.trim().isEmpty
                          ? _typeLabel
                          : quiz.title.trim(),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: ColorUtils.primaryColor,
                    ),
                    6.gh,
                    TtText(
                      '${quiz.questionsCount} question'
                          '${quiz.questionsCount == 1 ? '' : 's'}'
                          ' • $_typeLabel',
                      fontSize: 14,
                      height: 1.35,
                      color:
                      ColorUtils.greyTextColor,
                    ),
                  ],
                ),
              ),
              10.gw,
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 18,
                color: ColorUtils.secondaryColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChapterNumberView extends StatelessWidget {
  final int chapterNumber;

  const _ChapterNumberView({
    required this.chapterNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 54,
      height: 54,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF16C6B2),
            Color(0xFF00AD99),
          ],
        ),
      ),
      child: TtText(
        '$chapterNumber',
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }
}

class _PracticeMessageView
    extends StatelessWidget {
  final IconData icon;
  final String message;

  const _PracticeMessageView({
    required this.icon,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 26,
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 34,
            color: ColorUtils.greyTextColor,
          ),
          10.gh,
          TtText(
            message,
            fontSize: 14,
            height: 1.4,
            color: ColorUtils.greyTextColor,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _EmptyPracticeView extends StatelessWidget {
  const _EmptyPracticeView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.quiz_outlined,
              size: 48,
              color: ColorUtils.greyTextColor,
            ),
            SizedBox(height: 12),
            TtText(
              'No practice activities are available.',
              fontSize: 14,
              color: ColorUtils.greyTextColor,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}