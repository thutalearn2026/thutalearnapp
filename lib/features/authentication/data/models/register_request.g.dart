// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegisterInitiateRequest _$RegisterInitiateRequestFromJson(
  Map<String, dynamic> json,
) => RegisterInitiateRequest(
  name: json['name'] as String,
  email: json['email'] as String,
);

Map<String, dynamic> _$RegisterInitiateRequestToJson(
  RegisterInitiateRequest instance,
) => <String, dynamic>{'name': instance.name, 'email': instance.email};

RegisterVerifyRequest _$RegisterVerifyRequestFromJson(
  Map<String, dynamic> json,
) => RegisterVerifyRequest(
  email: json['email'] as String,
  code: json['code'] as String,
);

Map<String, dynamic> _$RegisterVerifyRequestToJson(
  RegisterVerifyRequest instance,
) => <String, dynamic>{'email': instance.email, 'code': instance.code};

RegisterCompleteRequest _$RegisterCompleteRequestFromJson(
  Map<String, dynamic> json,
) => RegisterCompleteRequest(
  email: json['email'] as String,
  code: json['code'] as String,
  password: json['password'] as String,
  passwordConfirmation: json['password_confirmation'] as String,
);

Map<String, dynamic> _$RegisterCompleteRequestToJson(
  RegisterCompleteRequest instance,
) => <String, dynamic>{
  'email': instance.email,
  'code': instance.code,
  'password': instance.password,
  'password_confirmation': instance.passwordConfirmation,
};
