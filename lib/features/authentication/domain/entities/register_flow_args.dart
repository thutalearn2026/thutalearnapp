class RegisterVerifyArgs {
  final String name;
  final String email;

  const RegisterVerifyArgs({
    required this.name,
    required this.email,
  });
}

class RegisterCompleteArgs {
  final String email;
  final String code;

  const RegisterCompleteArgs({
    required this.email,
    required this.code,
  });
}