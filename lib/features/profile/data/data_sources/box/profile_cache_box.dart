import 'dart:convert';

import 'package:hive_ce/hive.dart';
import 'package:thuta_learn/features/authentication/data/data_sources/box/auth_session_box.dart';
import 'package:thuta_learn/features/profile/data/models/profile_model.dart';

class ProfileCacheBox {
  static const String boxName = 'profile_cache_box';

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

  static String _cacheKey(String userId) {
    return 'profile_$userId';
  }

  static Future<ProfileModel?> read() async {
    final userId = _currentUserId;

    if (userId == null) {
      return null;
    }

    final key = _cacheKey(userId);
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

      final rawProfile = decoded['profile'];

      if (rawProfile is! Map) {
        await _box.delete(key);
        return null;
      }

      return ProfileModel.fromJson(
        Map<String, dynamic>.from(rawProfile),
      );
    } catch (_) {
      // Remove incompatible or malformed cached data.
      await _box.delete(key);
      return null;
    }
  }

  static Future<void> save(
      ProfileModel profile,
      ) async {
    final userId = _currentUserId;

    if (userId == null) {
      return;
    }

    final payload = <String, dynamic>{
      'profile': profile.toJson(),
      'cached_at': DateTime.now().toIso8601String(),
    };

    try {
      await _box.put(
        _cacheKey(userId),
        jsonEncode(payload),
      );
    } catch (_) {
      // A cache error should not turn a successful
      // API request into a visible failure.
    }
  }

  static Future<void> clearCurrentUser() async {
    final userId = _currentUserId;

    if (userId == null) {
      return;
    }

    try {
      await _box.delete(
        _cacheKey(userId),
      );
    } catch (_) {
      // Do not prevent logout because of a cache error.
    }
  }
}