import 'package:dartz/dartz.dart';
import 'package:thuta_learn/core/core.dart';
import 'package:thuta_learn/features/authentication/data/models/register_request.dart';
import 'package:thuta_learn/features/authentication/data/models/register_response.dart';
import 'package:thuta_learn/features/authentication/data/models/login_request.dart';
import 'package:thuta_learn/features/authentication/data/models/login_response.dart';
import 'package:thuta_learn/features/authentication/data/models/forgot_password_request.dart';

import '../../../features.dart';

abstract class AuthenticationRepo {
  Future<Either<Failure, ApiMessageResponse>> initiateRegistration(
    RegisterInitiateRequest request,
  );

  Future<Either<Failure, ApiMessageResponse>> verifyRegistrationCode(
    RegisterVerifyRequest request,
  );

  Future<Either<Failure, RegisterCompleteResponse>> completeRegistration(
    RegisterCompleteRequest request,
  );

  Future<Either<Failure, LoginResponse>> login(
    LoginRequest request,
  );

  Future<Either<Failure, ApiMessageResponse>> forgotPassword(
    ForgotPasswordRequest request,
  );

  Future<Either<Failure, ApiMessageResponse>> verifyForgotPasswordCode(
    ForgotPasswordVerifyRequest request,
  );

  Future<Either<Failure, ApiMessageResponse>> resetPassword(
    ResetPasswordRequest request,
  );

  Future<Either<Failure, OnboardingOptionsResponse>> getOnboardingOptions();

  Future<Either<Failure, OnboardingPreferenceResponse>> saveOnboardingPreferences(
    OnboardingPreferenceRequest request,
  );

  Future<Either<Failure, ApiMessageResponse>> logout();
}
