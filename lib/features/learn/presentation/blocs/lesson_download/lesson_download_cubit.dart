import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:thuta_learn/core/core.dart';
import 'package:thuta_learn/features/learn/learn.dart';

part 'lesson_download_state.dart';

@Injectable()
class LessonDownloadCubit
    extends Cubit<LessonDownloadState> {
  final VideoDownloadService downloadService;

  StreamSubscription<VideoDownloadSnapshot>?
  _subscription;

  LessonDownloadCubit({
    required this.downloadService,
  }) : super(const LessonDownloadState());

  Future<void> initialize(
      String videoId,
      ) async {
    await _subscription?.cancel();

    _subscription = downloadService
        .downloadUpdates
        .where(
          (snapshot) =>
      snapshot.videoId == videoId,
    )
        .listen(
          (snapshot) {
        _applySnapshot(
          snapshot,
          notifyUser: true,
        );
      },
    );

    emit(
      state.copyWith(
        videoId: videoId,
        isChecking: true,
        clearMessage: true,
      ),
    );

    final snapshot =
    await downloadService.getVideoStatus(
      videoId,
    );

    _applySnapshot(
      snapshot,
      notifyUser: false,
    );
  }

  Future<void> download(
      ChapterVideoModel video,
      ) async {
    if (state.isDownloading ||
        state.isDownloaded) {
      return;
    }

    emit(
      state.copyWith(
        status: VideoDownloadStatus.queued,
        progress: 0,
        clearMessage: true,
      ),
    );

    try {
      final snapshot =
      await downloadService.startDownload(
        video,
      );

      _applySnapshot(
        snapshot,
        notifyUser: false,
      );
    } catch (error) {
      var message = error.toString();

      message = message
          .replaceFirst('Bad state: ', '')
          .replaceFirst('Exception: ', '');

      emit(
        state.copyWith(
          status: VideoDownloadStatus.failed,
          message: message,
          isChecking: false,
        ),
      );
    }
  }

  void _applySnapshot(
      VideoDownloadSnapshot snapshot, {
        required bool notifyUser,
      }) {
    String? message;

    if (notifyUser &&
        snapshot.status ==
            VideoDownloadStatus.downloaded) {
      message =
      'Video downloaded. It is now available offline.';
    }

    if (notifyUser &&
        snapshot.status ==
            VideoDownloadStatus.failed) {
      message =
      'The video download failed. Please try again.';
    }

    emit(
      state.copyWith(
        videoId: snapshot.videoId,
        taskId: snapshot.taskId,
        status: snapshot.status,
        progress: snapshot.progress,
        localFilePath: snapshot.localFilePath,
        message: message,
        isChecking: false,
        clearLocalFilePath:
        snapshot.localFilePath == null,
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