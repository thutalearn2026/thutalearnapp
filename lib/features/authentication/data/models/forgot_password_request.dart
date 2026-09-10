import 'package:json_annotation/json_annotation.dart';

part 'forgot_password_request.g.dart';

@JsonSerializable()
class ForgotPasswordRequest {
  final String email;

  const ForgotPasswordRequest({
    required this.email,
  });

  Map<String, dynamic> toJson() => _$ForgotPasswordRequestToJson(this);
}

@JsonSerializable()
class ForgotPasswordVerifyRequest {
  final String email;
  final String code;

  const ForgotPasswordVerifyRequest({
    required this.email,
    required this.code,
  });

  Map<String, dynamic> toJson() =>
      _$ForgotPasswordVerifyRequestToJson(this);
}

@JsonSerializable()
class ResetPasswordRequest {
  final String email;
  final String code;
  final String password;

  @JsonKey(name: 'password_confirmation')
  final String passwordConfirmation;

  const ResetPasswordRequest({
    required this.email,
    required this.code,
    required this.password,
    required this.passwordConfirmation,
  });

  Map<String, dynamic> toJson() => _$ResetPasswordRequestToJson(this);
}