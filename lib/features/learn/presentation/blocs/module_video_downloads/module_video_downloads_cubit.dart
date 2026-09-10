import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:thuta_learn/core/core.dart';
import 'package:thuta_learn/features/learn/learn.dart';

part 'module_video_downloads_state.dart';

@Injectable()
class ModuleVideoDownloadsCubit
    extends Cubit<ModuleVideoDownloadsState> {
  final VideoDownloadService downloadService;

  StreamSubscription<VideoDownloadSnapshot>?
  _subscription;

  final Set<String> _registeredVideoIds = {};

  ModuleVideoDownloadsCubit({
    required this.downloadService,
  }) : super(
    const ModuleVideoDownloadsState(),
  );

  Future<void> initialize() async {
    await _subscription?.cancel();

    _subscription = downloadService
        .downloadUpdates
        .listen(_handleDownloadUpdate);
  }

  Future<void> registerVideos(
      Iterable<ChapterVideoModel> videos,
      ) async {
    for (final video in videos) {
      if (_registeredVideoIds.contains(
        video.id,
      )) {
        continue;
      }

      _registeredVideoIds.add(video.id);

      try {
        final snapshot =
        await downloadService.getVideoStatus(
          video.id,
        );

        if (isClosed) {
          return;
        }

        _applySnapshot(
          snapshot,
          notifyUser: false,
        );
      } catch (_) {
        // A status-check failure should not prevent
        // other lesson cards from loading.
      }
    }
  }

  Future<void> download(
      ChapterVideoModel video,
      ) async {
    final current =
    state.downloads[video.id];

    if (current?.isDownloading == true ||
        current?.isDownloaded == true) {
      return;
    }

    _applySnapshot(
      VideoDownloadSnapshot(
        videoId: video.id,
        status: VideoDownloadStatus.queued,
        progress: 0,
      ),
      notifyUser: false,
    );

    try {
      final snapshot =
      await downloadService.startDownload(
        video,
      );

      if (isClosed) {
        return;
      }

      _applySnapshot(
        snapshot,
        notifyUser: false,
      );
    } catch (error) {
      if (isClosed) {
        return;
      }

      var message = error.toString();

      message = message
          .replaceFirst('Bad state: ', '')
          .replaceFirst('Exception: ', '');

      final failedSnapshot =
      VideoDownloadSnapshot(
        videoId: video.id,
        status: VideoDownloadStatus.failed,
        progress: 0,
      );

      final updatedDownloads = {
        ...state.downloads,
        video.id: failedSnapshot,
      };

      emit(
        state.copyWith(
          downloads: updatedDownloads,
          message: message,
          messageIsError: true,
          lastUpdatedVideoId: video.id,
        ),
      );
    }
  }

  void _handleDownloadUpdate(
      VideoDownloadSnapshot snapshot,
      ) {
    if (!_registeredVideoIds.contains(
      snapshot.videoId,
    )) {
      return;
    }

    _applySnapshot(
      snapshot,
      notifyUser: true,
    );
  }

  void _applySnapshot(
      VideoDownloadSnapshot snapshot, {
        required bool notifyUser,
      }) {
    final previous =
    state.downloads[snapshot.videoId];

    String? message;
    var messageIsError = false;

    final justCompleted =
        snapshot.isDownloaded &&
            previous?.isDownloaded != true;

    final justFailed =
        snapshot.status ==
            VideoDownloadStatus.failed &&
            previous?.status !=
                VideoDownloadStatus.failed;

    if (notifyUser && justCompleted) {
      message =
      'Video downloaded. It is now available offline.';
    }

    if (notifyUser && justFailed) {
      message =
      'The video download failed. Please try again.';

      messageIsError = true;
    }

    final updatedDownloads = {
      ...state.downloads,
      snapshot.videoId: snapshot,
    };

    emit(
      state.copyWith(
        downloads: updatedDownloads,
        message: message,
        messageIsError: messageIsError,
        lastUpdatedVideoId:
        snapshot.videoId,
        clearMessage: message == null,
      ),
    );
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();

    return super.close();
  }
}