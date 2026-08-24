import 'dart:convert';

import 'package:hive_ce/hive.dart';
import 'package:thuta_learn/features/authentication/data/data_sources/box/auth_session_box.dart';
import 'package:thuta_learn/features/learn/data/models/course_model.dart';

class CourseDetailCacheSnapshot {
  final CourseModel course;
  final List<CourseModuleModel> modules;
  final DateTime cachedAt;

  const CourseDetailCacheSnapshot({
    required this.course,
    required this.modules,
    required this.cachedAt,
  });
}

class CourseDetailCacheBox {
  static const String boxName =
      'course_detail_cache_box';

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
    return 'course_detail_${userId}_';
  }

  static String _cacheKey({
    required String userId,
    required String courseId,
  }) {
    return '${_userPrefix(userId)}$courseId';
  }

  static Future<CourseDetailCacheSnapshot?> read({
    required String courseId,
  }) async {
    final userId = _currentUserId;

    if (userId == null) {
      return null;
    }

    final key = _cacheKey(
      userId: userId,
      courseId: courseId,
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

      final rawCourse = decoded['course'];
      final rawModules = decoded['modules'];

      if (rawCourse is! Map || rawModules is! List) {
        await _box.delete(key);
        return null;
      }

      final course = CourseModel.fromJson(
        Map<String, dynamic>.from(rawCourse),
      );

      // Protect against an incorrect cache key or
      // malformed cached data.
      if (course.id != courseId) {
        await _box.delete(key);
        return null;
      }

      final modules = rawModules
          .whereType<Map>()
          .map(
            (module) => CourseModuleModel.fromJson(
          Map<String, dynamic>.from(module),
        ),
      )
          .toList()
        ..sort(
              (first, second) {
            return first.rank.compareTo(second.rank);
          },
        );

      return CourseDetailCacheSnapshot(
        course: course,
        modules: modules,
        cachedAt:
        DateTime.tryParse(
          decoded['cached_at']?.toString() ?? '',
        ) ??
            DateTime.now(),
      );
    } catch (_) {
      await _box.delete(key);
      return null;
    }
  }

  static Future<void> save(
      CourseDetailCacheSnapshot snapshot,
      ) async {
    final userId = _currentUserId;

    if (userId == null) {
      return;
    }

    final payload = <String, dynamic>{
      'course': snapshot.course.toJson(),
      'modules': snapshot.modules
          .map((module) => module.toJson())
          .toList(),
      'cached_at': snapshot.cachedAt.toIso8601String(),
    };

    try {
      await _box.put(
        _cacheKey(
          userId: userId,
          courseId: snapshot.course.id,
        ),
        jsonEncode(payload),
      );
    } catch (_) {
      // Cache errors must not turn successful API
      // requests into visible failures.
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
      // Do not block logout because of a cache error.
    }
  }
}