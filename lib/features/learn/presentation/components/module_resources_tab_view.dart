import 'package:flutter/material.dart';
import 'package:thuta_learn/core/core.dart';
import 'package:thuta_learn/features/learn/learn.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

typedef ChapterResourceTapCallback =
    void Function(
      ChapterModel chapter,
      ChapterResourceModel resource,
    );

class ModuleResourcesTabView extends StatelessWidget {
  final List<ChapterModel> chapters;

  final Map<String, List<ChapterResourceModel>> resourcesByChapter;

  final Set<String> loadingChapterIds;

  final Map<String, String> chapterErrors;

  final ValueChanged<ChapterModel> onChapterExpanded;

  final ValueChanged<ChapterModel> onRetryChapter;

  final ValueChanged<ChapterResourceModel> onDownload;

  final ChapterResourceTapCallback onResourceTap;

  const ModuleResourcesTabView({
    super.key,
    required this.chapters,
    required this.resourcesByChapter,
    required this.loadingChapterIds,
    required this.chapterErrors,
    required this.onChapterExpanded,
    required this.onRetryChapter,
    required this.onDownload,
    required this.onResourceTap,
  });

  @override
  Widget build(BuildContext context) {
    if (chapters.isEmpty) {
      return const _EmptyResourcesView();
    }

    return ListView.separated(
      key: const PageStorageKey(
        'module-resources',
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

        return ModuleResourceChapterSection(
          chapter: chapter,
          chapterNumber: index + 1,
          initiallyExpanded: index == 0,
          resources: resourcesByChapter[chapter.id],
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
          onDownload: onDownload,
          onResourceTap: (resource) {
            onResourceTap(
              chapter,
              resource,
            );
          },
        );
      },
    );
  }
}

class ModuleResourceChapterSection extends StatelessWidget {
  final ChapterModel chapter;
  final int chapterNumber;
  final bool initiallyExpanded;
  final List<ChapterResourceModel>? resources;
  final bool isLoading;
  final String? error;
  final VoidCallback onExpanded;
  final VoidCallback onRetry;

  final ValueChanged<ChapterResourceModel> onDownload;
  final ValueChanged<ChapterResourceModel> onResourceTap;

  const ModuleResourceChapterSection({
    super.key,
    required this.chapter,
    required this.chapterNumber,
    required this.initiallyExpanded,
    required this.resources,
    required this.isLoading,
    required this.error,
    required this.onExpanded,
    required this.onRetry,
    required this.onDownload,
    required this.onResourceTap,
  });

  String get _resourceCountText {
    if (isLoading) {
      return 'Loading resources...';
    }

    if (resources == null) {
      return 'Tap to view resources';
    }

    return '${resources!.length} resource'
        '${resources!.length == 1 ? '' : 's'}';
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
          splashColor: ColorUtils.secondaryColor.withValues(
            alpha: 0.08,
          ),
          highlightColor: ColorUtils.secondaryColor.withValues(
            alpha: 0.04,
          ),
        ),
        child: ExpansionTile(
          key: PageStorageKey(
            'resource-chapter-${chapter.id}',
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
              color: ColorUtils.secondaryColor.withValues(
                alpha: 0.45,
              ),
            ),
          ),
          leading: _ResourceChapterNumberView(
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
              _resourceCountText,
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

    if (resources == null) {
      return const _ResourceMessageView(
        icon: Icons.touch_app_outlined,
        message: 'Expand this chapter to load its resources.',
      );
    }

    if (resources!.isEmpty) {
      return const _ResourceMessageView(
        icon: Icons.folder_off_outlined,
        message: 'No resources are available in this chapter.',
      );
    }

    return Column(
      children: List.generate(
        resources!.length,
        (index) {
          final resource = resources![index];

          return Column(
            children: [
              ChapterResourceView(
                resource: resource,
                onTap: () {
                  onResourceTap(resource);
                },
                onDownload: () {
                  onDownload(resource);
                },
              ),
              if (index != resources!.length - 1)
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

class ChapterResourceView extends StatelessWidget {
  final ChapterResourceModel resource;
  final VoidCallback onTap;
  final VoidCallback onDownload;

  const ChapterResourceView({
    super.key,
    required this.resource,
    required this.onTap,
    required this.onDownload,
  });

  String get _fileType {
    return resource.fileType.trim().isEmpty ? 'FILE' : resource.fileType.trim().toUpperCase();
  }

  String get _title {
    return resource.title.trim().replaceAll('_', ' ');
  }

  IconData get _icon {
    switch (resource.fileType.toLowerCase()) {
      case 'pdf':
        return Icons.picture_as_pdf_outlined;

      case 'doc':
      case 'docx':
      case 'word':
        return Icons.description_outlined;

      case 'mp3':
      case 'wav':
      case 'm4a':
      case 'audio':
        return Icons.headphones_outlined;

      case 'zip':
        return Icons.folder_zip_outlined;

      default:
        return Icons.insert_drive_file_outlined;
    }
  }

  Color get _typeColor {
    switch (resource.fileType.toLowerCase()) {
      case 'pdf':
        return const Color(0xFFE34D59);

      case 'doc':
      case 'docx':
      case 'word':
        return ColorUtils.primaryColor;

      case 'mp3':
      case 'wav':
      case 'm4a':
      case 'audio':
        return const Color(0xFFF09A24);

      default:
        return ColorUtils.secondaryColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 16,
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(
                  color: Color(0xFFF0F2F5),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _icon,
                  color: _typeColor,
                  size: 24,
                ),
              ),
              14.gw,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TtText(
                      _title,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: ColorUtils.primaryColor,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    8.gh,
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 9,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: _typeColor.withValues(
                              alpha: 0.10,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: TtText(
                            _fileType,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: _typeColor,
                          ),
                        ),
                        8.gw,
                        const TtText(
                          '•',
                          fontSize: 14,
                          color: ColorUtils.greyTextColor,
                        ),
                        8.gw,
                        Expanded(
                          child: TtText(
                            resource.isFree ? 'Free resource' : 'Course resource',
                            fontSize: 14,
                            color: ColorUtils.greyTextColor,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              8.gw,
              BlocSelector<
                  ResourceDownloadCubit,
                  ResourceDownloadState,
                  ResourceDownloadItemState
              >(
                selector: (state) {
                  return state.downloadFor(
                    resource.id,
                  );
                },
                builder: (context, downloadState) {
                  if (downloadState.isDownloading) {
                    return const SizedBox(
                      width: 48,
                      height: 48,
                      child: Center(
                        child: SizedBox(
                          width: 25,
                          height: 25,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.6,
                            color: ColorUtils.secondaryColor,
                          ),
                        ),
                      ),
                    );
                  }

                  if (downloadState.isDownloaded) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: ColorUtils.secondaryColor.withValues(
                          alpha: 0.10,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.download_done_rounded,
                            size: 18,
                            color: ColorUtils.secondaryColor,
                          ),
                          SizedBox(width: 5),
                          TtText(
                            'Downloaded',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: ColorUtils.secondaryColor,
                          ),
                        ],
                      ),
                    );
                  }

                  return Material(
                    color: ColorUtils.secondaryColor.withValues(
                      alpha: 0.10,
                    ),
                    shape: const CircleBorder(),
                    clipBehavior: Clip.antiAlias,
                    child: IconButton(
                      onPressed: onDownload,
                      tooltip: 'Download resource',
                      icon: const Icon(
                        Icons.download_outlined,
                        size: 24,
                        color: ColorUtils.secondaryColor,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ResourceChapterNumberView extends StatelessWidget {
  final int chapterNumber;

  const _ResourceChapterNumberView({
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

class _ResourceMessageView extends StatelessWidget {
  final IconData icon;
  final String message;

  const _ResourceMessageView({
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

class _EmptyResourcesView extends StatelessWidget {
  const _EmptyResourcesView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.folder_copy_outlined,
              size: 48,
              color: ColorUtils.greyTextColor,
            ),
            SizedBox(height: 12),
            TtText(
              'No chapter resources are available.',
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
