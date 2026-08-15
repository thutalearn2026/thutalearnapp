import 'package:hive_ce/hive.dart';

class OnboardingBox {
  static const String boxName = 'onboarding_box';
  static const String _completedKey =
      'has_completed_onboarding';

  static Box<dynamic> get _box {
    return Hive.box<dynamic>(boxName);
  }

  static bool get hasCompletedOnboarding {
    return _box.get(
      _completedKey,
      defaultValue: false,
    ) as bool;
  }

  static Future<void> completeOnboarding() async {
    await _box.put(
      _completedKey,
      true,
    );
  }

  static Future<void> resetOnboarding() async {
    await _box.delete(_completedKey);
  }
}