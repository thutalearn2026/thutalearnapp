// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'forgot_password_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ForgotPasswordRequest _$ForgotPasswordRequestFromJson(
  Map<String, dynamic> json,
) => ForgotPasswordRequest(email: json['email'] as String);

Map<String, dynamic> _$ForgotPasswordRequestToJson(
  ForgotPasswordRequest instance,
) => <String, dynamic>{'email': instance.email};

ForgotPasswordVerifyRequest _$ForgotPasswordVerifyRequestFromJson(
  Map<String, dynamic> json,
) => ForgotPasswordVerifyRequest(
  email: json['email'] as String,
  code: json['code'] as String,
);

Map<String, dynamic> _$ForgotPasswordVerifyRequestToJson(
  ForgotPasswordVerifyRequest instance,
) => <String, dynamic>{'email': instance.email, 'code': instance.code};

ResetPasswordRequest _$ResetPasswordRequestFromJson(
  Map<String, dynamic> json,
) => ResetPasswordRequest(
  email: json['email'] as String,
  code: json['code'] as String,
  password: json['password'] as String,
  passwordConfirmation: json['password_confirmation'] as String,
);

Map<String, dynamic> _$ResetPasswordRequestToJson(
  ResetPasswordRequest instance,
) => <String, dynamic>{
  'email': instance.email,
  'code': instance.code,
  'password': instance.password,
  'password_confirmation': instance.passwordConfirmation,
};
