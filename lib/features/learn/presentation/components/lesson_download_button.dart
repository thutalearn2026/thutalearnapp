import 'package:flutter/material.dart';
import 'package:thuta_learn/core/core.dart';

class LessonDownloadButton
    extends StatelessWidget {
  final VideoDownloadStatus status;
  final int progress;
  final VoidCallback onPressed;

  const LessonDownloadButton({
    super.key,
    required this.status,
    required this.progress,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    if (status ==
        VideoDownloadStatus.downloading) {
      return IconButton(
        tooltip: 'Pause download',
        onPressed: onPressed,
        icon: SizedBox(
          width: 30,
          height: 30,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CircularProgressIndicator(
                value: progress > 0
                    ? progress / 100
                    : null,
                strokeWidth: 2.5,
                color:
                ColorUtils.secondaryColor,
                backgroundColor:
                ColorUtils.secondaryColor
                    .withValues(alpha: 0.15),
              ),
              const Icon(
                Icons.pause_rounded,
                size: 18,
                color: ColorUtils.primaryColor,
              ),
            ],
          ),
        ),
      );
    }

    if (status ==
        VideoDownloadStatus.queued) {
      return IconButton(
        tooltip: 'Cancel download',
        onPressed: onPressed,
        icon: const Icon(
          Icons.close_rounded,
          color: ColorUtils.primaryColor,
          size: 28,
        ),
      );
    }

    if (status ==
        VideoDownloadStatus.paused) {
      return IconButton(
        tooltip: 'Resume download',
        onPressed: onPressed,
        icon: const Icon(
          Icons.play_circle_outline_rounded,
          color: ColorUtils.secondaryColor,
          size: 30,
        ),
      );
    }

    final isDownloaded =
        status ==
            VideoDownloadStatus.downloaded;

    final hasFailed =
        status == VideoDownloadStatus.failed;

    return IconButton(
      tooltip: isDownloaded
          ? 'Downloaded'
          : hasFailed
          ? 'Retry download'
          : 'Download video',
      onPressed:
      isDownloaded ? null : onPressed,
      icon: Icon(
        isDownloaded
            ? Icons.download_done_rounded
            : hasFailed
            ? Icons.refresh_rounded
            : Icons.file_download_outlined,
        color: isDownloaded
            ? ColorUtils.secondaryColor
            : ColorUtils.primaryColor,
        size: 29,
      ),
    );
  }
}