import 'dart:convert';

import 'package:hive_ce/hive.dart';
import 'package:thuta_learn/features/authentication/data/data_sources/box/auth_session_box.dart';
import 'package:thuta_learn/features/learn/data/models/course_model.dart';
import 'package:thuta_learn/features/learn/data/models/module_content_model.dart';

class ModuleLessonsCacheSnapshot {
  final CourseModuleModel module;
  final List<ChapterModel> chapters;

  final Map<String, List<ChapterVideoModel>>
  videosByChapter;

  final DateTime cachedAt;

  const ModuleLessonsCacheSnapshot({
    required this.module,
    required this.chapters,
    required this.videosByChapter,
    required this.cachedAt,
  });
}

class ModuleLessonsCacheBox {
  static const String boxName =
      'module_lessons_cache_box';

  static Box<dynamic> get _box {
    return Hive.box<dynamic>(boxName);
  }

  static String? get _currentUserId {
    final userId = AuthSessionBox.user?['id'];

    if (userId == null) {
      return null;
    }

    final value = userId.toString().trim();

    return value.isEmpty ? null : value;
  }

  static String _modulePrefix(String userId) {
    return 'module_lessons_${userId}_';
  }

  static String _moduleKey({
    required String userId,
    required String moduleId,
  }) {
    return '${_modulePrefix(userId)}$moduleId';
  }

  static String _videoUserPrefix(String userId) {
    return 'chapter_videos_${userId}_';
  }

  static String _videoModulePrefix({
    required String userId,
    required String moduleId,
  }) {
    return '${_videoUserPrefix(userId)}${moduleId}_';
  }

  static String _videoKey({
    required String userId,
    required String moduleId,
    required String chapterId,
  }) {
    return '${_videoModulePrefix(
      userId: userId,
      moduleId: moduleId,
    )}$chapterId';
  }

  static Future<ModuleLessonsCacheSnapshot?> read({
    required String moduleId,
  }) async {
    final userId = _currentUserId;

    if (userId == null) {
      return null;
    }

    final moduleKey = _moduleKey(
      userId: userId,
      moduleId: moduleId,
    );

    final rawValue = _box.get(moduleKey);

    if (rawValue is! String || rawValue.isEmpty) {
      return null;
    }

    try {
      final decoded = jsonDecode(rawValue);

      if (decoded is! Map<String, dynamic>) {
        await _box.delete(moduleKey);
        return null;
      }

      final rawModule = decoded['module'];
      final rawChapters = decoded['chapters'];

      if (rawModule is! Map ||
          rawChapters is! List) {
        await _box.delete(moduleKey);
        return null;
      }

      final module = CourseModuleModel.fromJson(
        Map<String, dynamic>.from(rawModule),
      );

      if (module.id != moduleId) {
        await _box.delete(moduleKey);
        return null;
      }

      final chapters = rawChapters
          .whereType<Map>()
          .map(
            (chapter) => ChapterModel.fromJson(
          Map<String, dynamic>.from(chapter),
        ),
      )
          .toList()
        ..sort(
              (first, second) {
            return first.rank.compareTo(second.rank);
          },
        );

      final videosByChapter =
      <String, List<ChapterVideoModel>>{};

      for (final chapter in chapters) {
        final videos = await _readChapterVideos(
          userId: userId,
          moduleId: moduleId,
          chapterId: chapter.id,
        );

        if (videos != null) {
          videosByChapter[chapter.id] = videos;
        }
      }

      return ModuleLessonsCacheSnapshot(
        module: module,
        chapters: chapters,
        videosByChapter: videosByChapter,
        cachedAt:
        DateTime.tryParse(
          decoded['cached_at']?.toString() ?? '',
        ) ??
            DateTime.now(),
      );
    } catch (_) {
      await _box.delete(moduleKey);
      return null;
    }
  }

  static Future<List<ChapterVideoModel>?>
  _readChapterVideos({
    required String userId,
    required String moduleId,
    required String chapterId,
  }) async {
    final key = _videoKey(
      userId: userId,
      moduleId: moduleId,
      chapterId: chapterId,
    );

    final rawValue = _box.get(key);

    if (rawValue is! String || rawValue.isEmpty) {
      return null;
    }

    try {
      final decoded = jsonDecode(rawValue);

      if (decoded is! Map<String, dynamic>) {
        await _box.delete(key);
        return null;
      }

      final rawVideos = decoded['videos'];

      if (rawVideos is! List) {
        await _box.delete(key);
        return null;
      }

      final videos = rawVideos
          .whereType<Map>()
          .map(
            (video) => ChapterVideoModel.fromJson(
          Map<String, dynamic>.from(video),
        ),
      )
          .toList()
        ..sort(
              (first, second) {
            return first.rank.compareTo(second.rank);
          },
        );

      return videos;
    } catch (_) {
      await _box.delete(key);
      return null;
    }
  }

  static Future<void> saveModuleSnapshot(
      ModuleLessonsCacheSnapshot snapshot,
      ) async {
    final userId = _currentUserId;

    if (userId == null) {
      return;
    }

    final payload = <String, dynamic>{
      'module': snapshot.module.toJson(),
      'chapters': snapshot.chapters
          .map((chapter) => chapter.toJson())
          .toList(),
      'cached_at': snapshot.cachedAt.toIso8601String(),
    };

    try {
      await _box.put(
        _moduleKey(
          userId: userId,
          moduleId: snapshot.module.id,
        ),
        jsonEncode(payload),
      );
    } catch (_) {
      // Do not fail a successful API request because
      // writing the cache failed.
    }
  }

  static Future<void> saveChapterVideos({
    required String moduleId,
    required String chapterId,
    required List<ChapterVideoModel> videos,
  }) async {
    final userId = _currentUserId;

    if (userId == null) {
      return;
    }

    final payload = <String, dynamic>{
      'videos': videos
          .map((video) => video.toJson())
          .toList(),
      'cached_at': DateTime.now().toIso8601String(),
    };

    try {
      await _box.put(
        _videoKey(
          userId: userId,
          moduleId: moduleId,
          chapterId: chapterId,
        ),
        jsonEncode(payload),
      );
    } catch (_) {
      // Do not fail the request because of cache errors.
    }
  }

  static Future<void> pruneChapterVideos({
    required String moduleId,
    required Set<String> validChapterIds,
  }) async {
    final userId = _currentUserId;

    if (userId == null) {
      return;
    }

    final prefix = _videoModulePrefix(
      userId: userId,
      moduleId: moduleId,
    );

    final obsoleteKeys = _box.keys.where((key) {
      if (key is! String || !key.startsWith(prefix)) {
        return false;
      }

      final chapterId = key.substring(prefix.length);

      return !validChapterIds.contains(chapterId);
    }).toList();

    if (obsoleteKeys.isEmpty) {
      return;
    }

    try {
      await _box.deleteAll(obsoleteKeys);
    } catch (_) {
      // Ignore cache cleanup errors.
    }
  }

  static Future<void> clearCurrentUser() async {
    final userId = _currentUserId;

    if (userId == null) {
      return;
    }

    final modulePrefix = _modulePrefix(userId);
    final videoPrefix = _videoUserPrefix(userId);

    final keys = _box.keys.where((key) {
      return key is String &&
          (key.startsWith(modulePrefix) ||
              key.startsWith(videoPrefix));
    }).toList();

    if (keys.isEmpty) {
      return;
    }

    try {
      await _box.deleteAll(keys);
    } catch (_) {
      // Do not block logout because of a cache error.
    }
  }
}