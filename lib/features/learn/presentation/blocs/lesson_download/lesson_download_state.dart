part of 'lesson_download_cubit.dart';

class LessonDownloadState {
  final String? videoId;
  final String? taskId;
  final VideoDownloadStatus status;
  final int progress;
  final String? localFilePath;
  final String? message;
  final bool isChecking;

  const LessonDownloadState({
    this.videoId,
    this.taskId,
    this.status = VideoDownloadStatus.notDownloaded,
    this.progress = 0,
    this.localFilePath,
    this.message,
    this.isChecking = false,
  });

  bool get isDownloading {
    return status == VideoDownloadStatus.queued || status == VideoDownloadStatus.downloading;
  }

  bool get isDownloaded {
    return status == VideoDownloadStatus.downloaded && localFilePath != null;
  }

  bool get isPaused {
    return status == VideoDownloadStatus.paused;
  }

  bool get canCancel {
    return isDownloading || isPaused;
  }

  LessonDownloadState copyWith({
    String? videoId,
    String? taskId,
    VideoDownloadStatus? status,
    int? progress,
    String? localFilePath,
    String? message,
    bool? isChecking,
    bool clearTaskId = false,
    bool clearLocalFilePath = false,
    bool clearMessage = false,
  }) {
    return LessonDownloadState(
      videoId: videoId ?? this.videoId,
      taskId: clearTaskId ? null : taskId ?? this.taskId,
      status: status ?? this.status,
      progress: progress ?? this.progress,
      localFilePath: clearLocalFilePath ? null : localFilePath ?? this.localFilePath,
      message: clearMessage ? null : message ?? this.message,
      isChecking: isChecking ?? this.isChecking,
    );
  }
}
