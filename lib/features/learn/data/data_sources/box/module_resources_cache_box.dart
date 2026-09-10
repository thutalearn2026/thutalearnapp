import 'dart:convert';

import 'package:hive_ce/hive.dart';
import 'package:thuta_learn/features/authentication/data/data_sources/box/auth_session_box.dart';
import 'package:thuta_learn/features/learn/data/models/module_content_model.dart';

class ModuleResourcesCacheBox {
  static const String boxName =
      'module_resources_cache_box';

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
    return 'chapter_resources_${userId}_';
  }

  static String _modulePrefix({
    required String userId,
    required String moduleId,
  }) {
    return '${_userPrefix(userId)}${moduleId}_';
  }

  static String _cacheKey({
    required String userId,
    required String moduleId,
    required String chapterId,
  }) {
    return '${_modulePrefix(
      userId: userId,
      moduleId: moduleId,
    )}$chapterId';
  }

  static Future<List<ChapterResourceModel>?> read({
    required String moduleId,
    required String chapterId,
  }) async {
    final userId = _currentUserId;

    if (userId == null) {
      return null;
    }

    final key = _cacheKey(
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

      final rawResources = decoded['resources'];

      if (rawResources is! List) {
        await _box.delete(key);
        return null;
      }

      final resources = rawResources
          .whereType<Map>()
          .map(
            (resource) =>
            ChapterResourceModel.fromJson(
              Map<String, dynamic>.from(resource),
            ),
      )
          .toList()
        ..sort(
              (first, second) {
            return first.rank.compareTo(second.rank);
          },
        );

      return resources;
    } catch (_) {
      await _box.delete(key);
      return null;
    }
  }

  static Future<void> save({
    required String moduleId,
    required String chapterId,
    required List<ChapterResourceModel> resources,
  }) async {
    final userId = _currentUserId;

    if (userId == null) {
      return;
    }

    final payload = <String, dynamic>{
      'resources': resources
          .map((resource) => resource.toJson())
          .toList(),
      'cached_at': DateTime.now().toIso8601String(),
    };

    try {
      await _box.put(
        _cacheKey(
          userId: userId,
          moduleId: moduleId,
          chapterId: chapterId,
        ),
        jsonEncode(payload),
      );
    } catch (_) {
      // Cache errors must not make successful API
      // requests appear to have failed.
    }
  }

  static Future<void> prune({
    required String moduleId,
    required Set<String> validChapterIds,
  }) async {
    final userId = _currentUserId;

    if (userId == null) {
      return;
    }

    final prefix = _modulePrefix(
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
      // Ignore cache-cleanup errors.
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