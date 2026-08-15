// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onboarding_preference_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OnboardingPreferenceRequest _$OnboardingPreferenceRequestFromJson(
  Map<String, dynamic> json,
) => OnboardingPreferenceRequest(
  learningReason: json['learning_reason'] as String?,
  currentLevel: json['current_level'] as String?,
  dailyGoalMinutes: (json['daily_goal_minutes'] as num?)?.toInt(),
);

Map<String, dynamic> _$OnboardingPreferenceRequestToJson(
  OnboardingPreferenceRequest instance,
) => <String, dynamic>{
  'learning_reason': instance.learningReason,
  'current_level': instance.currentLevel,
  'daily_goal_minutes': instance.dailyGoalMinutes,
};

OnboardingPreferenceModel _$OnboardingPreferenceModelFromJson(
  Map<String, dynamic> json,
) => OnboardingPreferenceModel(
  userId: json['user_id'] as String,
  learningReason: json['learning_reason'] as String?,
  currentLevel: json['current_level'] as String?,
  dailyGoalMinutes: (json['daily_goal_minutes'] as num?)?.toInt(),
);

Map<String, dynamic> _$OnboardingPreferenceModelToJson(
  OnboardingPreferenceModel instance,
) => <String, dynamic>{
  'user_id': instance.userId,
  'learning_reason': instance.learningReason,
  'current_level': instance.currentLevel,
  'daily_goal_minutes': instance.dailyGoalMinutes,
};

OnboardingPreferenceResponse _$OnboardingPreferenceResponseFromJson(
  Map<String, dynamic> json,
) => OnboardingPreferenceResponse(
  message: json['message'] as String,
  data: OnboardingPreferenceModel.fromJson(
    json['data'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$OnboardingPreferenceResponseToJson(
  OnboardingPreferenceResponse instance,
) => <String, dynamic>{'message': instance.message, 'data': instance.data};
