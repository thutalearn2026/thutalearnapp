import 'dart:convert';

import 'package:hive_ce/hive.dart';
import 'package:thuta_learn/features/authentication/data/data_sources/box/auth_session_box.dart';
import 'package:thuta_learn/features/learn/data/models/video_vocabulary_model.dart';

class LessonVocabularyCacheBox {
  static const String boxName =
      'lesson_vocabulary_cache_box';

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
    return 'lesson_vocabularies_${userId}_';
  }

  static String _cacheKey({
    required String userId,
    required String videoId,
  }) {
    return '${_userPrefix(userId)}$videoId';
  }

  static Future<List<VideoVocabularyModel>?> read({
    required String videoId,
  }) async {
    final userId = _currentUserId;

    if (userId == null) {
      return null;
    }

    final key = _cacheKey(
      userId: userId,
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

      final rawVocabularies =
      decoded['vocabularies'];

      if (rawVocabularies is! List) {
        await _box.delete(key);
        return null;
      }

      final vocabularies = rawVocabularies
          .whereType<Map>()
          .map(
            (vocabulary) =>
            VideoVocabularyModel.fromJson(
              Map<String, dynamic>.from(
                vocabulary,
              ),
            ),
      )
          .toList()
        ..sort(
              (first, second) {
            return first.rank.compareTo(second.rank);
          },
        );

      return vocabularies;
    } catch (_) {
      await _box.delete(key);
      return null;
    }
  }

  static Future<void> save({
    required String videoId,
    required List<VideoVocabularyModel> vocabularies,
  }) async {
    final userId = _currentUserId;

    if (userId == null) {
      return;
    }

    final payload = <String, dynamic>{
      'vocabularies': vocabularies
          .map(
            (vocabulary) => vocabulary.toJson(),
      )
          .toList(),
      'cached_at': DateTime.now().toIso8601String(),
    };

    try {
      await _box.put(
        _cacheKey(
          userId: userId,
          videoId: videoId,
        ),
        jsonEncode(payload),
      );
    } catch (_) {
      // Do not fail a successful request because of
      // a Hive write error.
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