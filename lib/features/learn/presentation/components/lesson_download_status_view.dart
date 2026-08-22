import 'package:flutter/material.dart';
import 'package:thuta_learn/core/core.dart';

class LessonDownloadStatusView
    extends StatelessWidget {
  final VideoDownloadStatus status;
  final int progress;

  const LessonDownloadStatusView({
    super.key,
    required this.status,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    if (status ==
        VideoDownloadStatus.downloaded) {
      return Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          color: ColorUtils.secondaryColor
              .withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: ColorUtils.secondaryColor
                .withValues(alpha: 0.35),
          ),
        ),
        child: const Row(
          children: [
            Icon(
              Icons.offline_pin_rounded,
              color: ColorUtils.secondaryColor,
              size: 22,
            ),
            SizedBox(width: 10),
            Expanded(
              child: TtText(
                'Downloaded • Available offline',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: ColorUtils.secondaryColor,
              ),
            ),
          ],
        ),
      );
    }

    if (status == VideoDownloadStatus.queued ||
        status ==
            VideoDownloadStatus.downloading) {
      return Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFF4F7FA),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Row(
              children: [
                const Icon(
                  Icons.downloading_rounded,
                  color: ColorUtils.primaryColor,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TtText(
                    status ==
                        VideoDownloadStatus
                            .queued
                        ? 'Waiting to download...'
                        : 'Downloading video...',
                    fontSize: 14,
                    color:
                    ColorUtils.primaryColor,
                  ),
                ),
                TtText(
                  '$progress%',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color:
                  ColorUtils.primaryColor,
                ),
              ],
            ),
            const SizedBox(height: 10),
            LinearProgressIndicator(
              value: progress > 0
                  ? progress / 100
                  : null,
              minHeight: 6,
              borderRadius:
              BorderRadius.circular(10),
              color: ColorUtils.secondaryColor,
              backgroundColor:
              const Color(0xFFE3E8EF),
            ),
          ],
        ),
      );
    }

    return const SizedBox.shrink();
  }
}