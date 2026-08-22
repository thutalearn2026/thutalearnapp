import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thuta_learn/core/core.dart';
import 'package:thuta_learn/features/learn/learn.dart';

typedef ChapterVideoTapCallback =
    void Function(
      ChapterModel chapter,
      ChapterVideoModel video,
    );

class ModuleLessonsTabView extends StatelessWidget {
  final List<ChapterModel> chapters;

  final Map<String, List<ChapterVideoModel>> videosByChapter;

  final Set<String> loadingChapterIds;

  final Map<String, String> chapterVideoErrors;

  final ValueChanged<ChapterModel> onChapterExpanded;

  final ValueChanged<ChapterModel> onRetryChapter;

  final ChapterVideoTapCallback onVideoTap;

  final ValueChanged<ChapterVideoModel> onVideoDownload;

  const ModuleLessonsTabView({
    super.key,
    required this.chapters,
    required this.videosByChapter,
    required this.loadingChapterIds,
    required this.chapterVideoErrors,
    required this.onChapterExpanded,
    required this.onRetryChapter,
    required this.onVideoTap,
    required this.onVideoDownload,
  });

  @override
  Widget build(BuildContext context) {
    if (chapters.isEmpty) {
      return const _EmptyChaptersView();
    }

    return CustomScrollView(
      key: const PageStorageKey(
        'module-lessons',
      ),
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(
            16,
            16,
            16,
            0,
          ),
          sliver: SliverList.separated(
            itemCount: chapters.length,
            separatorBuilder: (_, __) {
              return 14.gh;
            },
            itemBuilder: (context, index) {
              final chapter = chapters[index];

              final videos = videosByChapter[chapter.id];

              final isLoading = loadingChapterIds.contains(
                chapter.id,
              );

              final error = chapterVideoErrors[chapter.id];

              return ModuleChapterSectionView(
                chapter: chapter,
                chapterNumber: index + 1,
                initiallyExpanded: index == 0,
                videos: videos,
                isLoading: isLoading,
                error: error,
                onExpanded: () {
                  onChapterExpanded(chapter);
                },
                onRetry: () {
                  onRetryChapter(chapter);
                },
                onVideoTap: (video) {
                  onVideoTap(
                    chapter,
                    video,
                  );
                },
                onVideoDownload: onVideoDownload,
              );
            },
          ),
        ),
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              16,
              24,
              16,
              16,
            ),
            child: TtText(
              'Real-life Scenarios',
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(
            16,
            0,
            16,
            32,
          ),
          sliver: SliverGrid.builder(
            itemCount: 5,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 0.62,
            ),
            itemBuilder: (context, index) {
              return RealLifeScenarioView(
                index: index,
              );
            },
          ),
        ),
      ],
    );
  }
}

class ModuleChapterSectionView extends StatelessWidget {
  final ChapterModel chapter;
  final int chapterNumber;
  final bool initiallyExpanded;
  final List<ChapterVideoModel>? videos;
  final bool isLoading;
  final String? error;
  final VoidCallback onExpanded;
  final VoidCallback onRetry;

  final ValueChanged<ChapterVideoModel> onVideoTap;

  final ValueChanged<ChapterVideoModel> onVideoDownload;

  const ModuleChapterSectionView({
    super.key,
    required this.chapter,
    required this.chapterNumber,
    required this.initiallyExpanded,
    required this.videos,
    required this.isLoading,
    required this.error,
    required this.onExpanded,
    required this.onRetry,
    required this.onVideoTap,
    required this.onVideoDownload,
  });

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
          splashColor: ColorUtils.secondaryColor.withValues(
            alpha: 0.08,
          ),
          highlightColor: ColorUtils.secondaryColor.withValues(
            alpha: 0.04,
          ),
        ),
        child: ExpansionTile(
          key: PageStorageKey(
            'module-chapter-${chapter.id}',
          ),
          initiallyExpanded: initiallyExpanded,
          maintainState: true,
          onExpansionChanged: (expanded) {
            if (expanded && chapter.videosCount > 0) {
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
              color: ColorUtils.secondaryColor.withValues(
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
            padding: const EdgeInsets.only(
              top: 5,
            ),
            child: TtText(
              '${chapter.videosCount} video'
              '${chapter.videosCount == 1 ? '' : 's'}',
              fontSize: 14,
              color: ColorUtils.greyTextColor,
            ),
          ),
          iconColor: ColorUtils.primaryColor,
          collapsedIconColor: ColorUtils.primaryColor,
          children: [
            const Divider(
              height: 1,
              color: Color(0xFFE7EBF0),
            ),
            _buildChapterContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildChapterContent() {
    if (chapter.videosCount == 0) {
      return const _ChapterMessageView(
        icon: Icons.video_library_outlined,
        message: 'No videos are available in this chapter.',
      );
    }

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

    if (videos == null) {
      return const _ChapterMessageView(
        icon: Icons.touch_app_outlined,
        message: 'Expand this chapter to load its videos.',
      );
    }

    if (videos!.isEmpty) {
      return const _ChapterMessageView(
        icon: Icons.video_library_outlined,
        message: 'No videos are available in this chapter.',
      );
    }

    return Column(
      children: List.generate(
        videos!.length,
        (index) {
          final video = videos![index];

          return Column(
            children: [
              ChapterVideoView(
                video: video,
                onTap: () {
                  onVideoTap(video);
                },
                onDownload: () {
                  onVideoDownload(video);
                },
              ),
              if (index != videos!.length - 1)
                const Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 14,
                  ),
                  child: Divider(
                    height: 1,
                    color: Color(0xFFE7EBF0),
                  ),
                ),
            ],
          );
        },
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
      width: 46,
      height: 46,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            ColorUtils.secondaryColor,
            Color(0xFF10A896),
          ],
        ),
        borderRadius: BorderRadius.circular(13),
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

class ChapterVideoView extends StatelessWidget {
  final ChapterVideoModel video;
  final VoidCallback onTap;
  final VoidCallback onDownload;

  const ChapterVideoView({
    super.key,
    required this.video,
    required this.onTap,
    required this.onDownload,
  });

  @override
  Widget build(BuildContext context) {
    final title = video.title.trim().isEmpty ? 'Untitled video' : video.title.trim();

    return Padding(
      padding: const EdgeInsets.all(14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: TtZoomTap(
              onTap: onTap,
              child: Row(
                children: [
                  _ChapterVideoThumbnail(
                    imageUrl: video.thumbnail,
                  ),
                  14.gw,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TtText(
                          title,
                          fontSize: 14,
                          height: 1.3,
                          fontWeight: FontWeight.bold,
                          color: ColorUtils.primaryColor,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        8.gh,
                        Row(
                          children: [
                            const Icon(
                              Icons.smart_display_outlined,
                              size: 18,
                              color: ColorUtils.greyTextColor,
                            ),
                            5.gw,
                            Expanded(
                              child: TtText(
                                video.videoSource == null
                                    ? 'Video lesson'
                                    : '${video.videoSource!.toUpperCase()} video',
                                fontSize: 14,
                                color: ColorUtils.greyTextColor,
                              ),
                            ),
                          ],
                        ),
                        7.gh,
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: video.isFree
                                ? ColorUtils.secondaryColor.withValues(
                                    alpha: 0.12,
                                  )
                                : const Color(
                                    0xFFF0F3F7,
                                  ),
                            borderRadius: BorderRadius.circular(
                              10,
                            ),
                          ),
                          child: TtText(
                            video.isFree ? 'Free video' : 'Course video',
                            fontSize: 12,
                            color: video.isFree
                                ? ColorUtils.secondaryColor
                                : ColorUtils.greyTextColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          8.gw,
          BlocSelector<
            ModuleVideoDownloadsCubit,
            ModuleVideoDownloadsState,
            VideoDownloadSnapshot?
          >(
            selector: (state) {
              return state.downloadFor(
                video.id,
              );
            },
            builder: (context, download) {
              return _VideoDownloadControl(
                download: download,
                onPressed: onDownload,
              );
            },
          ),
        ],
      ),
    );
  }
}

class _VideoDownloadControl extends StatelessWidget {
  final VideoDownloadSnapshot? download;
  final VoidCallback onPressed;

  const _VideoDownloadControl({
    required this.download,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final status = download?.status ?? VideoDownloadStatus.notDownloaded;

    final progress = download?.progress ?? 0;

    final isDownloading =
        status == VideoDownloadStatus.queued || status == VideoDownloadStatus.downloading;

    final isDownloaded = download?.isDownloaded == true;

    final hasFailed = status == VideoDownloadStatus.failed;

    if (isDownloading) {
      return SizedBox(
        width: 58,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 38,
              height: 38,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CircularProgressIndicator(
                    value: progress > 0 ? progress / 100 : null,
                    strokeWidth: 3,
                    color: ColorUtils.secondaryColor,
                    backgroundColor: ColorUtils.secondaryColor.withValues(
                      alpha: 0.15,
                    ),
                  ),
                  if (progress > 0)
                    TtText(
                      '$progress',
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: ColorUtils.primaryColor,
                    )
                  else
                    const Icon(
                      Icons.downloading_rounded,
                      size: 18,
                      color: ColorUtils.secondaryColor,
                    ),
                ],
              ),
            ),
            5.gh,
            TtText(
              status == VideoDownloadStatus.queued ? 'Waiting' : '$progress%',
              fontSize: 11,
              color: ColorUtils.greyTextColor,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    if (isDownloaded) {
      return SizedBox(
        width: 66,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 42,
              height: 42,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: ColorUtils.secondaryColor.withValues(
                  alpha: 0.12,
                ),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.download_done_rounded,
                size: 24,
                color: ColorUtils.secondaryColor,
              ),
            ),
            5.gh,
            const TtText(
              'Downloaded',
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: ColorUtils.secondaryColor,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return SizedBox(
      width: 58,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Material(
            color: hasFailed
                ? Colors.red.withValues(
                    alpha: 0.10,
                  )
                : ColorUtils.secondaryColor.withValues(
                    alpha: 0.10,
                  ),
            shape: const CircleBorder(),
            clipBehavior: Clip.antiAlias,
            child: IconButton(
              onPressed: onPressed,
              tooltip: hasFailed ? 'Retry download' : 'Download video',
              icon: Icon(
                hasFailed ? Icons.refresh_rounded : Icons.download_outlined,
                size: 24,
                color: hasFailed ? Colors.red : ColorUtils.secondaryColor,
              ),
            ),
          ),
          5.gh,
          TtText(
            hasFailed ? 'Retry' : 'Download',
            fontSize: 11,
            color: hasFailed ? Colors.red : ColorUtils.greyTextColor,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _ChapterVideoThumbnail extends StatelessWidget {
  final String? imageUrl;

  const _ChapterVideoThumbnail({
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final hasThumbnail = imageUrl != null && imageUrl!.trim().isNotEmpty;

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: SizedBox(
        width: 100,
        height: 78,
        child: hasThumbnail
            ? Stack(
                fit: StackFit.expand,
                children: [
                  TtNetworkImage(
                    imageUrl: imageUrl!,
                    width: 125,
                    height: 78,
                  ),
                  Container(
                    color: Colors.black.withValues(
                      alpha: 0.12,
                    ),
                  ),
                  const Center(
                    child: Icon(
                      Icons.play_circle_fill_rounded,
                      size: 36,
                      color: Colors.white,
                    ),
                  ),
                ],
              )
            : Container(
                color: const Color(0xFFDCE8ED),
                child: const Stack(
                  children: [
                    Center(
                      child: Icon(
                        Icons.video_library_outlined,
                        size: 34,
                        color: ColorUtils.primaryColor,
                      ),
                    ),
                    Positioned(
                      right: 7,
                      bottom: 7,
                      child: Icon(
                        Icons.play_circle_fill_rounded,
                        size: 25,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

class _ChapterMessageView extends StatelessWidget {
  final IconData icon;
  final String message;

  const _ChapterMessageView({
    required this.icon,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 24,
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 32,
            color: ColorUtils.greyTextColor,
          ),
          8.gh,
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

class _EmptyChaptersView extends StatelessWidget {
  const _EmptyChaptersView();

  @override
  Widget build(BuildContext context) {
    return const CustomScrollView(
      physics: AlwaysScrollableScrollPhysics(),
      slivers: [
        SliverFillRemaining(
          hasScrollBody: false,
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.menu_book_outlined,
                    size: 48,
                    color: ColorUtils.greyTextColor,
                  ),
                  SizedBox(height: 12),
                  TtText(
                    'No chapters are available '
                    'in this module.',
                    fontSize: 14,
                    color: ColorUtils.greyTextColor,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
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
        // Real-life scenario integration later.
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
