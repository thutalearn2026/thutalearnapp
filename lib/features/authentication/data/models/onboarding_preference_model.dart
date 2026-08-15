import 'package:json_annotation/json_annotation.dart';

part 'onboarding_preference_model.g.dart';

@JsonSerializable(
  fieldRename: FieldRename.snake,
  includeIfNull: true,
)
class OnboardingPreferenceRequest {
  final String? learningReason;
  final String? currentLevel;
  final int? dailyGoalMinutes;

  const OnboardingPreferenceRequest({
    this.learningReason,
    this.currentLevel,
    this.dailyGoalMinutes,
  });

  Map<String, dynamic> toJson() {
    return _$OnboardingPreferenceRequestToJson(this);
  }
}

@JsonSerializable(fieldRename: FieldRename.snake)
class OnboardingPreferenceModel {
  final String userId;
  final String? learningReason;
  final String? currentLevel;
  final int? dailyGoalMinutes;

  const OnboardingPreferenceModel({
    required this.userId,
    this.learningReason,
    this.currentLevel,
    this.dailyGoalMinutes,
  });

  factory OnboardingPreferenceModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return _$OnboardingPreferenceModelFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$OnboardingPreferenceModelToJson(this);
  }
}

@JsonSerializable()
class OnboardingPreferenceResponse {
  final String message;
  final OnboardingPreferenceModel data;

  const OnboardingPreferenceResponse({
    required this.message,
    required this.data,
  });

  factory OnboardingPreferenceResponse.fromJson(
      Map<String, dynamic> json,
      ) {
    return _$OnboardingPreferenceResponseFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$OnboardingPreferenceResponseToJson(this);
  }
}