import 'package:json_annotation/json_annotation.dart';

part 'profile_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ProfileModel {
  final String id;
  final String name;
  final String email;
  final String? photo;
  final String? emailVerifiedAt;
  final String createdAt;
  final String updatedAt;

  const ProfileModel({
    required this.id,
    required this.name,
    required this.email,
    this.photo,
    this.emailVerifiedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return _$ProfileModelFromJson(json);
  }

  Map<String, dynamic> toJson() => _$ProfileModelToJson(this);
}

@JsonSerializable()
class ProfileResponse {
  final ProfileModel data;

  const ProfileResponse({
    required this.data,
  });

  factory ProfileResponse.fromJson(Map<String, dynamic> json) {
    return _$ProfileResponseFromJson(json);
  }

  Map<String, dynamic> toJson() => _$ProfileResponseToJson(this);
}

@JsonSerializable()
class UpdateProfileResponse {
  final String message;
  final ProfileModel data;

  const UpdateProfileResponse({
    required this.message,
    required this.data,
  });

  factory UpdateProfileResponse.fromJson(
      Map<String, dynamic> json,
      ) {
    return _$UpdateProfileResponseFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$UpdateProfileResponseToJson(this);
  }
}