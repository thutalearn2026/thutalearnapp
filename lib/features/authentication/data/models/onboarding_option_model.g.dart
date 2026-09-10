// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onboarding_option_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OnboardingOptionModel _$OnboardingOptionModelFromJson(
  Map<String, dynamic> json,
) => OnboardingOptionModel(
  id: json['id'] as String,
  type: json['type'] as String,
  key: json['key'] as String,
  label: json['label'] as String,
  description: json['description'] as String?,
  icon: json['icon'] as String?,
  value: (json['value'] as num?)?.toInt(),
  sortOrder: (json['sort_order'] as num).toInt(),
);

Map<String, dynamic> _$OnboardingOptionModelToJson(
  OnboardingOptionModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'type': instance.type,
  'key': instance.key,
  'label': instance.label,
  'description': instance.description,
  'icon': instance.icon,
  'value': instance.value,
  'sort_order': instance.sortOrder,
};

OnboardingOptionsData _$OnboardingOptionsDataFromJson(
  Map<String, dynamic> json,
) => OnboardingOptionsData(
  learningReasons: (json['learning_reason'] as List<dynamic>)
      .map((e) => OnboardingOptionModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  currentLevels: (json['current_level'] as List<dynamic>)
      .map((e) => OnboardingOptionModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  dailyGoals: (json['daily_goal'] as List<dynamic>)
      .map((e) => OnboardingOptionModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$OnboardingOptionsDataToJson(
  OnboardingOptionsData instance,
) => <String, dynamic>{
  'learning_reason': instance.learningReasons,
  'current_level': instance.currentLevels,
  'daily_goal': instance.dailyGoals,
};

OnboardingOptionsResponse _$OnboardingOptionsResponseFromJson(
  Map<String, dynamic> json,
) => OnboardingOptionsResponse(
  data: OnboardingOptionsData.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$OnboardingOptionsResponseToJson(
  OnboardingOptionsResponse instance,
) => <String, dynamic>{'data': instance.data};
