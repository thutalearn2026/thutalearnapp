import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui' show IsolateNameServer;

import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:thuta_learn/features/learn/learn.dart';

const String videoDownloadPortName = 'thuta_learn_video_download_port';

@pragma('vm:entry-point')
void videoDownloadCallback(
  String taskId,
  int status,
  int progress,
) {
  final sendPort = IsolateNameServer.lookupPortByName(
    videoDownloadPortName,
  );

  sendPort?.send([
    taskId,
    status,
    progress,
  ]);
}

enum VideoDownloadStatus {
  notDownloaded,
  queued,
  downloading,
  paused,
  downloaded,
  failed,
  canceled,
}

class VideoDownloadSnapshot {
  final String videoId;
  final String? taskId;
  final VideoDownloadStatus status;
  final int progress;
  final String? localFilePath;

  const VideoDownloadSnapshot({
    required this.videoId,
    this.taskId,
    this.status = VideoDownloadStatus.notDownloaded,
    this.progress = 0,
    this.localFilePath,
  });

  bool get isDownloading {
    return status == VideoDownloadStatus.queued || status == VideoDownloadStatus.downloading;
  }

  bool get isDownloaded {
    return status == VideoDownloadStatus.downloaded && localFilePath != null;
  }
}

@lazySingleton
class VideoDownloadService {
  static const String _videoMarker = '__video_';

  final Map<String, String> _activeTaskIds = {};

  final StreamController<VideoDownloadSnapshot> _downloadController =
      StreamController<VideoDownloadSnapshot>.broadcast();

  ReceivePort? _receivePort;
  bool _isInitialized = false;

  Stream<VideoDownloadSnapshot> get downloadUpdates {
    return _downloadController.stream;
  }

  Future<void> initialize() async {
    if (_isInitialized) {
      return;
    }

    _isInitialized = true;

    IsolateNameServer.removePortNameMapping(
      videoDownloadPortName,
    );

    _receivePort = ReceivePort();

    IsolateNameServer.registerPortWithName(
      _receivePort!.sendPort,
      videoDownloadPortName,
    );

    _receivePort!.listen((dynamic data) async {
      if (data is! List || data.length < 3) {
        return;
      }

      final taskId = data[0] as String;

      await _publishTaskUpdate(taskId);
    });

    await FlutterDownloader.registerCallback(
      videoDownloadCallback,
      step: 1,
    );
  }

  Future<VideoDownloadSnapshot> getVideoStatus(
    String videoId,
  ) async {
    final tasks = await FlutterDownloader.loadTasks() ?? [];

    DownloadTask? matchingTask;

    for (final task in tasks) {
      final taskVideoId = _extractVideoId(
        task.filename,
      );

      if (taskVideoId != videoId) {
        continue;
      }

      if (matchingTask == null || task.timeCreated > matchingTask.timeCreated) {
        matchingTask = task;
      }
    }

    if (matchingTask != null) {
      _activeTaskIds[videoId] = matchingTask.taskId;

      return _createSnapshot(
        videoId: videoId,
        task: matchingTask,
      );
    }

    // The file can still exist even if the plugin's
    // SQLite task record was removed.
    final directory = await _getVideoDirectory();

    await for (final entity in directory.list()) {
      if (entity is! File) {
        continue;
      }

      final filename = entity.uri.pathSegments.last;

      if (_extractVideoId(filename) == videoId) {
        return VideoDownloadSnapshot(
          videoId: videoId,
          status: VideoDownloadStatus.downloaded,
          progress: 100,
          localFilePath: entity.path,
        );
      }
    }

    return VideoDownloadSnapshot(
      videoId: videoId,
    );
  }

  Future<VideoDownloadSnapshot> startDownload(
    ChapterVideoModel video,
  ) async {
    final existing = await getVideoStatus(video.id);

    if (existing.isDownloaded || existing.isDownloading) {
      return existing;
    }

    if (existing.taskId != null) {
      await FlutterDownloader.remove(
        taskId: existing.taskId!,
        shouldDeleteContent: true,
      );
    }

    final downloadUrl = _getDownloadUrl(video);

    if (downloadUrl == null) {
      throw StateError(
        'This lesson does not contain a downloadable MP4 video.',
      );
    }

    final directory = await _getVideoDirectory();
    final filename = _createFilename(video);

    final taskId = await FlutterDownloader.enqueue(
      url: downloadUrl,
      savedDir: directory.path,
      fileName: filename,

      // Android may display progress as a notification,
      // but the downloaded file remains private.
      showNotification: true,

      // Do not let other applications open the file.
      openFileFromNotification: false,

      // Keep the video out of public Downloads/Gallery.
      saveInPublicStorage: false,

      requiresStorageNotLow: true,
      allowCellular: true,
      timeout: 30000,
    );

    if (taskId == null) {
      throw StateError(
        'Unable to create the video download task.',
      );
    }

    _activeTaskIds[video.id] = taskId;

    final snapshot = VideoDownloadSnapshot(
      videoId: video.id,
      taskId: taskId,
      status: VideoDownloadStatus.queued,
    );

    _downloadController.add(snapshot);

    return snapshot;
  }

  Future<VideoDownloadSnapshot> pauseDownload({
    required String videoId,
    required String taskId,
  }) async {
    await FlutterDownloader.pause(
      taskId: taskId,
    );

    final task = await _waitForTaskStatus(
      taskId: taskId,
      acceptedStatuses: {
        DownloadTaskStatus.paused,
        DownloadTaskStatus.complete,
        DownloadTaskStatus.failed,
      },
    );

    if (task == null) {
      throw StateError(
        'Unable to pause this video download.',
      );
    }

    final snapshot = await _createSnapshot(
      videoId: videoId,
      task: task,
    );

    _activeTaskIds[videoId] = task.taskId;
    _downloadController.add(snapshot);

    return snapshot;
  }

  Future<VideoDownloadSnapshot> resumeDownload({
    required String videoId,
    required String taskId,
  }) async {
    final previousTask = await _findTask(
      taskId,
    );

    final newTaskId = await FlutterDownloader.resume(
      taskId: taskId,
      requiresStorageNotLow: true,
      timeout: 30000,
    );

    if (newTaskId == null) {
      throw StateError(
        'Unable to resume this video download.',
      );
    }

    // resume() creates a completely new task ID.
    _activeTaskIds[videoId] = newTaskId;

    final snapshot = VideoDownloadSnapshot(
      videoId: videoId,
      taskId: newTaskId,
      status: VideoDownloadStatus.queued,
      progress: previousTask?.progress ?? 0,
    );

    _downloadController.add(snapshot);

    return snapshot;
  }

  Future<VideoDownloadSnapshot> cancelDownload({
    required String videoId,
    required String taskId,
  }) async {
    // remove() also cancels an active task. Setting
    // shouldDeleteContent removes its partial file.
    await FlutterDownloader.remove(
      taskId: taskId,
      shouldDeleteContent: true,
    );

    if (_activeTaskIds[videoId] == taskId) {
      _activeTaskIds.remove(videoId);
    }

    final snapshot = VideoDownloadSnapshot(
      videoId: videoId,
      status: VideoDownloadStatus.canceled,
      progress: 0,
    );

    _downloadController.add(snapshot);

    return snapshot;
  }

  Future<DownloadTask?> _findTask(
    String taskId,
  ) async {
    final tasks = await FlutterDownloader.loadTasks() ?? const <DownloadTask>[];

    for (final task in tasks) {
      if (task.taskId == taskId) {
        return task;
      }
    }

    return null;
  }

  Future<DownloadTask?> _waitForTaskStatus({
    required String taskId,
    required Set<DownloadTaskStatus> acceptedStatuses,
  }) async {
    for (var attempt = 0; attempt < 15; attempt++) {
      final task = await _findTask(taskId);

      if (task == null) {
        return null;
      }

      if (acceptedStatuses.contains(
        task.status,
      )) {
        return task;
      }

      await Future<void>.delayed(
        const Duration(
          milliseconds: 100,
        ),
      );
    }

    return null;
  }

  String? _getDownloadUrl(
    ChapterVideoModel video,
  ) {
    final mp4Files =
        video.mp4Files
            .where(
              (file) => file.link.trim().isNotEmpty,
            )
            .toList()
          ..sort(
            (first, second) {
              return (second.height ?? 0).compareTo(
                first.height ?? 0,
              );
            },
          );

    if (mp4Files.isNotEmpty) {
      return mp4Files.first.link.trim();
    }

    final directPath = video.videoPath?.trim();

    if (directPath != null &&
        directPath.isNotEmpty &&
        Uri.tryParse(directPath)?.path.toLowerCase().endsWith('.mp4') == true) {
      return directPath;
    }

    return null;
  }

  Future<Directory> _getVideoDirectory() async {
    // flutter_downloader supports NSDocumentDirectory
    // on iOS, so application documents are used here.
    final documentsDirectory = await getApplicationDocumentsDirectory();

    final directory = Directory(
      '${documentsDirectory.path}/offline_videos',
    );

    if (!await directory.exists()) {
      await directory.create(
        recursive: true,
      );
    }

    return directory;
  }

  String _createFilename(
    ChapterVideoModel video,
  ) {
    final cleanedTitle = video.title
        .trim()
        .replaceAll(
          RegExp(r'[<>:"/\\|?*\x00-\x1F]'),
          '',
        )
        .replaceAll(
          RegExp(r'\s+'),
          '_',
        );

    final safeTitle = cleanedTitle.isEmpty
        ? 'lesson'
        : cleanedTitle.length > 60
        ? cleanedTitle.substring(0, 60)
        : cleanedTitle;

    return '$safeTitle$_videoMarker${video.id}.mp4';
  }

  String? _extractVideoId(
    String? filename,
  ) {
    if (filename == null || !filename.endsWith('.mp4')) {
      return null;
    }

    final markerIndex = filename.lastIndexOf(_videoMarker);

    if (markerIndex < 0) {
      return null;
    }

    final start = markerIndex + _videoMarker.length;
    final end = filename.length - 4;

    if (start >= end) {
      return null;
    }

    return filename.substring(start, end);
  }

  Future<VideoDownloadSnapshot> _createSnapshot({
    required String videoId,
    required DownloadTask task,
  }) async {
    final filename = task.filename;

    String? filePath;

    if (filename != null) {
      final candidatePath = '${task.savedDir}/$filename';

      final candidateFile = File(candidatePath);

      if (await candidateFile.exists()) {
        filePath = candidatePath;
      }
    }

    final status = _mapDownloadStatus(
      task.status,
      fileExists: filePath != null,
    );

    return VideoDownloadSnapshot(
      videoId: videoId,
      taskId: task.taskId,
      status: status,
      progress: task.progress,
      localFilePath: status == VideoDownloadStatus.downloaded ? filePath : null,
    );
  }

  Future<void> _publishTaskUpdate(
    String taskId,
  ) async {
    final tasks = await FlutterDownloader.loadTasks() ?? [];

    DownloadTask? matchingTask;

    for (final task in tasks) {
      if (task.taskId == taskId) {
        matchingTask = task;
        break;
      }
    }

    if (matchingTask == null) {
      return;
    }

    final videoId = _extractVideoId(
      matchingTask.filename,
    );

    if (videoId == null) {
      return;
    }

    final activeTaskId = _activeTaskIds[videoId];

    // Ignore callbacks from the old paused task after
    // resume() creates a new task.
    if (activeTaskId != null && activeTaskId != taskId) {
      return;
    }

    _activeTaskIds[videoId] = taskId;

    final snapshot = await _createSnapshot(
      videoId: videoId,
      task: matchingTask,
    );

    _downloadController.add(snapshot);
  }

  VideoDownloadStatus _mapDownloadStatus(
    DownloadTaskStatus status, {
    required bool fileExists,
  }) {
    switch (status) {
      case DownloadTaskStatus.enqueued:
        return VideoDownloadStatus.queued;

      case DownloadTaskStatus.running:
        return VideoDownloadStatus.downloading;

      case DownloadTaskStatus.complete:
        return fileExists ? VideoDownloadStatus.downloaded : VideoDownloadStatus.failed;

      case DownloadTaskStatus.failed:
        return VideoDownloadStatus.failed;

      case DownloadTaskStatus.canceled:
        return VideoDownloadStatus.canceled;

      case DownloadTaskStatus.paused:
        return VideoDownloadStatus.paused;

      case DownloadTaskStatus.undefined:
        return VideoDownloadStatus.notDownloaded;
    }
  }
}
