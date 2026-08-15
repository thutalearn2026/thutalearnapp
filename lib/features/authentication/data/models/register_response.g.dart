// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiMessageResponse _$ApiMessageResponseFromJson(Map<String, dynamic> json) =>
    ApiMessageResponse(message: json['message'] as String);

Map<String, dynamic> _$ApiMessageResponseToJson(ApiMessageResponse instance) =>
    <String, dynamic>{'message': instance.message};

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
  id: json['id'] as String,
  name: json['name'] as String,
  email: json['email'] as String,
);

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'email': instance.email,
};

RegisterCompleteResponse _$RegisterCompleteResponseFromJson(
  Map<String, dynamic> json,
) => RegisterCompleteResponse(
  message: json['message'] as String,
  token: json['token'] as String,
  user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
);

Map<String, dynamic> _$RegisterCompleteResponseToJson(
  RegisterCompleteResponse instance,
) => <String, dynamic>{
  'message': instance.message,
  'token': instance.token,
  'user': instance.user,
};
