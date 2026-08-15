import 'package:hive_ce/hive.dart';
import 'package:thuta_learn/features/authentication/data/models/register_response.dart';

class AuthSessionBox {
  static const String boxName = 'auth_session_box';

  static const String _tokenKey = 'access_token';
  static const String _userKey = 'authenticated_user';

  static Box<dynamic> get _box => Hive.box<dynamic>(boxName);

  static String? get token {
    return _box.get(_tokenKey) as String?;
  }

  static Map<String, dynamic>? get user {
    final value = _box.get(_userKey);

    if (value is Map) {
      return Map<String, dynamic>.from(value);
    }

    return null;
  }

  static bool get isLoggedIn {
    final savedToken = token;
    return savedToken != null && savedToken.isNotEmpty;
  }

  static Future<void> save({
    required String token,
    required UserModel user,
  }) async {
    await _box.put(_tokenKey, token);
    await _box.put(_userKey, user.toJson());
  }

  static Future<void> saveSession(
      RegisterCompleteResponse response,
      ) {
    return save(
      token: response.token,
      user: response.user,
    );
  }

  static Future<void> clearSession() async {
    await _box.delete(_tokenKey);
    await _box.delete(_userKey);
  }
}