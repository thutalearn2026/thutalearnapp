class ForgotPasswordVerifyArgs {
  final String email;

  const ForgotPasswordVerifyArgs({
    required this.email,
  });
}

class ResetPasswordArgs {
  final String email;
  final String code;

  const ResetPasswordArgs({
    required this.email,
    required this.code,
  });
}