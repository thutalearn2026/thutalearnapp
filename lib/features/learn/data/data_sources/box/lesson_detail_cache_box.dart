import 'dart:convert';

import 'package:hive_ce/hive.dart';
import 'package:thuta_learn/features/authentication/data/data_sources/box/auth_session_box.dart';
import 'package:thuta_learn/features/learn/data/models/module_content_model.dart';

class LessonDetailCacheBox {
  static const String boxName =
      'lesson_detail_cache_box';

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

  static String _userPrefix(String userId) {
    return 'lesson_detail_${userId}_';
  }

  static String _cacheKey({
    required String userId,
    required String chapterId,
    required String videoId,
  }) {
    return '${_userPrefix(userId)}'
        '${chapterId}_$videoId';
  }

  static Future<ChapterVideoModel?> read({
    required String chapterId,
    required String videoId,
  }) async {
    final userId = _currentUserId;

    if (userId == null) {
      return null;
    }

    final key = _cacheKey(
      userId: userId,
      chapterId: chapterId,
      videoId: videoId,
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

      final rawVideo = decoded['video'];

      if (rawVideo is! Map) {
        await _box.delete(key);
        return null;
      }

      final video = ChapterVideoModel.fromJson(
        Map<String, dynamic>.from(rawVideo),
      );

      if (video.id != videoId) {
        await _box.delete(key);
        return null;
      }

      return video;
    } catch (_) {
      await _box.delete(key);
      return null;
    }
  }

  static Future<void> save({
    required String chapterId,
    required ChapterVideoModel video,
  }) async {
    final userId = _currentUserId;

    if (userId == null) {
      return;
    }

    final payload = <String, dynamic>{
      'video': video.toJson(),
      'cached_at': DateTime.now().toIso8601String(),
    };

    try {
      await _box.put(
        _cacheKey(
          userId: userId,
          chapterId: chapterId,
          videoId: video.id,
        ),
        jsonEncode(payload),
      );
    } catch (_) {
      // Do not turn a successful API response into
      // a failure because Hive could not be updated.
    }
  }

  static Future<void> clearCurrentUser() async {
    final userId = _currentUserId;

    if (userId == null) {
      return;
    }

    final prefix = _userPrefix(userId);

    final keys = _box.keys.where((key) {
      return key is String && key.startsWith(prefix);
    }).toList();

    if (keys.isEmpty) {
      return;
    }

    try {
      await _box.deleteAll(keys);
    } catch (_) {
      // Do not prevent logout because of cache errors.
    }
  }
}