import 'package:flutter/material.dart';
import 'package:thuta_learn/core/core.dart';

class LessonDownloadButton extends StatelessWidget {
  final VideoDownloadStatus status;
  final int progress;
  final VoidCallback onPressed;

  const LessonDownloadButton({
    super.key,
    required this.status,
    required this.progress,
    required this.onPressed,
  });

  bool get _isDownloading {
    return status == VideoDownloadStatus.queued ||
        status ==
            VideoDownloadStatus.downloading;
  }

  @override
  Widget build(BuildContext context) {
    if (_isDownloading) {
      return SizedBox(
        width: 48,
        height: 48,
        child: Center(
          child: SizedBox(
            width: 27,
            height: 27,
            child: CircularProgressIndicator(
              value: progress > 0
                  ? progress / 100
                  : null,
              strokeWidth: 2.6,
              color: ColorUtils.secondaryColor,
              backgroundColor:
              ColorUtils.secondaryColor
                  .withValues(alpha: 0.15),
            ),
          ),
        ),
      );
    }

    final isDownloaded =
        status == VideoDownloadStatus.downloaded;

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