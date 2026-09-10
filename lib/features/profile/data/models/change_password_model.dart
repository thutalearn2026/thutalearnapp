import 'package:json_annotation/json_annotation.dart';

part 'change_password_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ChangePasswordRequest {
  final String currentPassword;
  final String password;
  final String passwordConfirmation;

  const ChangePasswordRequest({
    required this.currentPassword,
    required this.password,
    required this.passwordConfirmation,
  });

  Map<String, dynamic> toJson() {
    return _$ChangePasswordRequestToJson(this);
  }
}

@JsonSerializable()
class ChangePasswordResponse {
  final String message;

  const ChangePasswordResponse({
    required this.message,
  });

  factory ChangePasswordResponse.fromJson(
      Map<String, dynamic> json,
      ) {
    return _$ChangePasswordResponseFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$ChangePasswordResponseToJson(this);
  }
}