part of 'module_video_downloads_cubit.dart';

class ModuleVideoDownloadsState {
  final Map<String, VideoDownloadSnapshot> downloads;

  final String? message;
  final bool messageIsError;
  final String? lastUpdatedVideoId;

  const ModuleVideoDownloadsState({
    this.downloads = const {},
    this.message,
    this.messageIsError = false,
    this.lastUpdatedVideoId,
  });

  VideoDownloadSnapshot? downloadFor(
    String videoId,
  ) {
    return downloads[videoId];
  }

  ModuleVideoDownloadsState copyWith({
    Map<String, VideoDownloadSnapshot>? downloads,
    String? message,
    bool? messageIsError,
    String? lastUpdatedVideoId,
    bool clearMessage = false,
  }) {
    return ModuleVideoDownloadsState(
      downloads: downloads ?? this.downloads,
      message: clearMessage ? null : message ?? this.message,
      messageIsError: messageIsError ?? this.messageIsError,
      lastUpdatedVideoId: lastUpdatedVideoId ?? this.lastUpdatedVideoId,
    );
  }
}
