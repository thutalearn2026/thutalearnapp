import 'package:json_annotation/json_annotation.dart';

part 'register_request.g.dart';

@JsonSerializable()
class RegisterInitiateRequest {
  final String name;
  final String email;

  const RegisterInitiateRequest({
    required this.name,
    required this.email,
  });

  Map<String, dynamic> toJson() => _$RegisterInitiateRequestToJson(this);
}

@JsonSerializable()
class RegisterVerifyRequest {
  final String email;
  final String code;

  const RegisterVerifyRequest({
    required this.email,
    required this.code,
  });

  Map<String, dynamic> toJson() => _$RegisterVerifyRequestToJson(this);
}

@JsonSerializable()
class RegisterCompleteRequest {
  final String email;
  final String code;
  final String password;

  @JsonKey(name: 'password_confirmation')
  final String passwordConfirmation;

  const RegisterCompleteRequest({
    required this.email,
    required this.code,
    required this.password,
    required this.passwordConfirmation,
  });

  Map<String, dynamic> toJson() => _$RegisterCompleteRequestToJson(this);
}