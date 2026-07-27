import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:thuta_learn/core/core.dart';
import 'package:thuta_learn/features/learn/learn.dart';

class ModuleLessonsTabView extends StatelessWidget {
  const ModuleLessonsTabView({super.key});

  static const List<ModuleLessonItem> _lessons = [
    ModuleLessonItem(
      title: 'Common Thai Greetings',
      subtitle: 'Polite and Systematic Greetings in Thai',
      duration: '8:06',
      isCompleted: true,
      isDownloaded: true,
    ),
    ModuleLessonItem(
      title: 'Saying Your Name',
      subtitle: 'Polite and Systematic Greetings in Thai',
      duration: '8:06',
      isCompleted: true,
      isDownloaded: true,
    ),
    ModuleLessonItem(
      lessonNumber: 3,
      title: 'Asking Someone’s Name',
      myanmarTitle: 'တစ်စုံတစ်ယောက်အား နာမည်မေးမြန်းခြင်း',
      subtitle: 'Polite and Systematic Greetings in Thai',
      duration: '4:18',
    ),
    ModuleLessonItem(
      title: 'Basic Small Talk',
      subtitle: 'Polite and Systematic Greetings in Thai',
      duration: '8:06',
    ),
    ModuleLessonItem(
      title: 'Module Conversation Practice',
      subtitle: 'Polite and Systematic Greetings in Thai',
      duration: '8:06',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      key: const PageStorageKey('module-lessons'),
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          sliver: SliverList.builder(
            itemCount: _lessons.length,
            itemBuilder: (context, index) {
              return ModuleLessonView(
                lesson: _lessons[index],
                thumbnailIndex: index,
                onTap: () {
                  context.push(
                    Routes.lessonDetail,
                    extra: _lessons[index],
                  );
                },
                onDownload: () {
                  // Add download functionality later.
                },
              );
            },
          ),
        ),
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: TtText(
              'Real-life Scenarios',
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
          sliver: SliverGrid.builder(
            itemCount: 5,
            gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 0.62,
            ),
            itemBuilder: (context, index) {
              return RealLifeScenarioView(index: index);
            },
          ),
        ),
      ],
    );
  }
}

class ModuleLessonView extends StatelessWidget {
  final ModuleLessonItem lesson;
  final int thumbnailIndex;
  final VoidCallback onTap;
  final VoidCallback onDownload;

  const ModuleLessonView({
    super.key,
    required this.lesson,
    required this.thumbnailIndex,
    required this.onTap,
    required this.onDownload,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TtZoomTap(
            onTap: onTap,
            child: _TemporaryVideoThumbnail(
              index: thumbnailIndex,
              duration: lesson.duration,
              isCompleted: lesson.isCompleted,
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
                    lesson.title,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: ColorUtils.primaryColor,
                  ),
                  8.gh,
                  TtText(
                    lesson.subtitle,
                    fontSize: 14,
                    height: 1.35,
                    fontStyle: FontStyle.italic,
                    color: ColorUtils.primaryColor,
                  ),
                ],
              ),
            ),
          ),
          8.gw,
          IconButton(
            onPressed: onDownload,
            icon: lesson.isDownloaded
                ? Container(
              width: 30,
              height: 30,
              decoration: const BoxDecoration(
                color: ColorUtils.secondaryColor,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_downward_rounded,
                size: 18,
                color: Colors.white,
              ),
            )
                : const Icon(
              Icons.download_outlined,
              size: 28,
              color: ColorUtils.primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _TemporaryVideoThumbnail extends StatelessWidget {
  final int index;
  final String duration;
  final bool isCompleted;

  const _TemporaryVideoThumbnail({
    required this.index,
    required this.duration,
    required this.isCompleted,
  });

  @override
  Widget build(BuildContext context) {
    const colors = [
      Color(0xFF9B2830),
      Color(0xFF7996A7),
      Color(0xFFDCE8ED),
      Color(0xFFBBD4C2),
      Color(0xFFDB7659),
    ];

    return Container(
      width: 125,
      height: 78,
      decoration: BoxDecoration(
        color: colors[index % colors.length],
        borderRadius: BorderRadius.circular(10),
        border: Border(
          bottom: BorderSide(
            color: isCompleted
                ? ColorUtils.secondaryColor
                : Colors.transparent,
            width: 4,
          ),
        ),
      ),
      child: Stack(
        children: [
          const Center(
            child: Icon(
              Icons.play_circle_fill_rounded,
              color: Colors.white,
              size: 36,
            ),
          ),
          Positioned(
            right: 6,
            bottom: 7,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 5,
                vertical: 2,
              ),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.65),
                borderRadius: BorderRadius.circular(4),
              ),
              child: TtText(
                duration,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RealLifeScenarioView extends StatelessWidget {
  final int index;

  const RealLifeScenarioView({
    super.key,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    const colors = [
      Color(0xFFC9876D),
      Color(0xFF6B9F9D),
      Color(0xFF819D63),
      Color(0xFFB98080),
      Color(0xFF9B7A95),
    ];

    return TtZoomTap(
      onTap: () {
        // Open the real-life scenario later.
      },
      child: Container(
        decoration: BoxDecoration(
          color: colors[index % colors.length],
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Stack(
          children: [
            Center(
              child: Icon(
                Icons.smart_display_rounded,
                size: 38,
                color: Colors.white,
              ),
            ),
            Positioned(
              left: 8,
              right: 8,
              bottom: 10,
              child: TtText(
                'Real conversation',
                fontSize: 14,
                color: Colors.white,
                textAlign: TextAlign.center,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}