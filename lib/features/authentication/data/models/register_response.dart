import 'package:json_annotation/json_annotation.dart';

part 'register_response.g.dart';

@JsonSerializable()
class ApiMessageResponse {
  final String message;

  const ApiMessageResponse({
    required this.message,
  });

  factory ApiMessageResponse.fromJson(Map<String, dynamic> json) {
    return _$ApiMessageResponseFromJson(json);
  }

  Map<String, dynamic> toJson() => _$ApiMessageResponseToJson(this);
}

@JsonSerializable()
class UserModel {
  final String id;
  final String name;
  final String email;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return _$UserModelFromJson(json);
  }

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}

@JsonSerializable()
class RegisterCompleteResponse {
  final String message;
  final String token;
  final UserModel user;

  const RegisterCompleteResponse({
    required this.message,
    required this.token,
    required this.user,
  });

  factory RegisterCompleteResponse.fromJson(Map<String, dynamic> json) {
    return _$RegisterCompleteResponseFromJson(json);
  }

  Map<String, dynamic> toJson() => _$RegisterCompleteResponseToJson(this);
}