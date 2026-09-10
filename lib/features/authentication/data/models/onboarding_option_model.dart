import 'package:json_annotation/json_annotation.dart';

part 'onboarding_option_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class OnboardingOptionModel {
  final String id;
  final String type;
  final String key;
  final String label;
  final String? description;
  final String? icon;
  final int? value;
  final int sortOrder;

  const OnboardingOptionModel({
    required this.id,
    required this.type,
    required this.key,
    required this.label,
    this.description,
    this.icon,
    this.value,
    required this.sortOrder,
  });

  factory OnboardingOptionModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return _$OnboardingOptionModelFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$OnboardingOptionModelToJson(this);
  }
}

@JsonSerializable()
class OnboardingOptionsData {
  @JsonKey(name: 'learning_reason')
  final List<OnboardingOptionModel> learningReasons;

  @JsonKey(name: 'current_level')
  final List<OnboardingOptionModel> currentLevels;

  @JsonKey(name: 'daily_goal')
  final List<OnboardingOptionModel> dailyGoals;

  const OnboardingOptionsData({
    required this.learningReasons,
    required this.currentLevels,
    required this.dailyGoals,
  });

  factory OnboardingOptionsData.fromJson(
      Map<String, dynamic> json,
      ) {
    return _$OnboardingOptionsDataFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$OnboardingOptionsDataToJson(this);
  }
}

@JsonSerializable()
class OnboardingOptionsResponse {
  final OnboardingOptionsData data;

  const OnboardingOptionsResponse({
    required this.data,
  });

  factory OnboardingOptionsResponse.fromJson(
      Map<String, dynamic> json,
      ) {
    return _$OnboardingOptionsResponseFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$OnboardingOptionsResponseToJson(this);
  }
}