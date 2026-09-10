import 'dart:convert';

import 'package:hive_ce/hive.dart';
import 'package:thuta_learn/core/utils/feature_flags.dart';
import 'package:thuta_learn/features/authentication/data/data_sources/box/auth_session_box.dart';
import 'package:thuta_learn/features/learn/data/models/course_model.dart';

class CoursesCacheSnapshot {
  final List<CourseModel> courses;
  final int currentPage;
  final int lastPage;
  final int total;
  final DateTime cachedAt;

  const CoursesCacheSnapshot({
    required this.courses,
    required this.currentPage,
    required this.lastPage,
    required this.total,
    required this.cachedAt,
  });
}

class CoursesCacheBox {
  static const String boxName = 'learn_courses_box';

  static Box<dynamic> get _box {
    return Hive.box<dynamic>(boxName);
  }

  static String? get _currentUserId {
    final user = AuthSessionBox.user;
    final userId = user?['id'];

    if (userId == null) {
      return null;
    }

    final value = userId.toString().trim();

    return value.isEmpty ? null : value;
  }

  static String _allCoursesCacheKey(String userId) {
    return 'courses_snapshot_$userId';
  }

  static String _enrolledCoursesCacheKey(String userId) {
    return 'enrolled_courses_snapshot_$userId';
  }

  static String _activeCacheKey(String userId) {
    return FeatureFlags.enrolledCoursesOnly
        ? _enrolledCoursesCacheKey(userId)
        : _allCoursesCacheKey(userId);
  }

  static Future<CoursesCacheSnapshot?> read() async {
    final userId = _currentUserId;

    if (userId == null) {
      return null;
    }

    final key = _activeCacheKey(userId);
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

      final rawCourses = decoded['courses'];

      if (rawCourses is! List) {
        await _box.delete(key);
        return null;
      }

      final courses =
          rawCourses
              .whereType<Map>()
              .map(
                (course) => CourseModel.fromJson(
                  Map<String, dynamic>.from(course),
                ),
              )
              .toList()
            ..sort(
              (first, second) {
                return first.rank.compareTo(second.rank);
              },
            );

      return CoursesCacheSnapshot(
        courses: courses,
        currentPage: (decoded['current_page'] as num?)?.toInt() ?? 1,
        lastPage: (decoded['last_page'] as num?)?.toInt() ?? 1,
        total: (decoded['total'] as num?)?.toInt() ?? courses.length,
        cachedAt:
            DateTime.tryParse(
              decoded['cached_at']?.toString() ?? '',
            ) ??
            DateTime.now(),
      );
    } catch (_) {
      // Remove malformed or incompatible cached data.
      await _box.delete(key);
      return null;
    }
  }

  static Future<void> save(
    CoursesCacheSnapshot snapshot,
  ) async {
    final userId = _currentUserId;

    if (userId == null) {
      return;
    }

    final payload = <String, dynamic>{
      'courses': snapshot.courses.map((course) => course.toJson()).toList(),
      'current_page': snapshot.currentPage,
      'last_page': snapshot.lastPage,
      'total': snapshot.total,
      'cached_at': snapshot.cachedAt.toIso8601String(),
    };

    try {
      await _box.put(
        _activeCacheKey(userId),
        jsonEncode(payload),
      );
    } catch (_) {
      // A cache failure must not make a successful API
      // request appear as a failure to the user.
    }
  }

  static Future<void> clearCurrentUser() async {
    final userId = _currentUserId;

    if (userId == null) {
      return;
    }

    try {
      await _box.deleteAll([
        _allCoursesCacheKey(userId),
        _enrolledCoursesCacheKey(userId),
      ]);
    } catch (_) {
      // Do not block logout because of a cache error.
    }
  }
}
