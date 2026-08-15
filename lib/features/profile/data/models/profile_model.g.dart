// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfileModel _$ProfileModelFromJson(Map<String, dynamic> json) => ProfileModel(
  id: json['id'] as String,
  name: json['name'] as String,
  email: json['email'] as String,
  photo: json['photo'] as String?,
  emailVerifiedAt: json['email_verified_at'] as String?,
  createdAt: json['created_at'] as String,
  updatedAt: json['updated_at'] as String,
);

Map<String, dynamic> _$ProfileModelToJson(ProfileModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'photo': instance.photo,
      'email_verified_at': instance.emailVerifiedAt,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };

ProfileResponse _$ProfileResponseFromJson(Map<String, dynamic> json) =>
    ProfileResponse(
      data: ProfileModel.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ProfileResponseToJson(ProfileResponse instance) =>
    <String, dynamic>{'data': instance.data};

UpdateProfileResponse _$UpdateProfileResponseFromJson(
  Map<String, dynamic> json,
) => UpdateProfileResponse(
  message: json['message'] as String,
  data: ProfileModel.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$UpdateProfileResponseToJson(
  UpdateProfileResponse instance,
) => <String, dynamic>{'message': instance.message, 'data': instance.data};
