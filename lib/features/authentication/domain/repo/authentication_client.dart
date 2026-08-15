import 'package:thuta_learn/features/authentication/data/models/register_request.dart';
import 'package:thuta_learn/features/authentication/data/models/register_response.dart';
import 'package:thuta_learn/features/authentication/data/models/login_request.dart';
import 'package:thuta_learn/features/authentication/data/models/login_response.dart';
import 'package:thuta_learn/features/authentication/data/models/forgot_password_request.dart';

import '../../../features.dart';

abstract class AuthenticationClient {
  Future<ApiMessageResponse> initiateRegistration(
    RegisterInitiateRequest request,
  );

  Future<ApiMessageResponse> verifyRegistrationCode(
    RegisterVerifyRequest request,
  );

  Future<RegisterCompleteResponse> completeRegistration(
    RegisterCompleteRequest request,
  );

  Future<LoginResponse> login(
    LoginRequest request,
  );

  Future<ApiMessageResponse> forgotPassword(
    ForgotPasswordRequest request,
  );

  Future<ApiMessageResponse> verifyForgotPasswordCode(
    ForgotPasswordVerifyRequest request,
  );

  Future<ApiMessageResponse> resetPassword(
    ResetPasswordRequest request,
  );

  Future<OnboardingOptionsResponse> getOnboardingOptions();

  Future<OnboardingPreferenceResponse> saveOnboardingPreferences(
    OnboardingPreferenceRequest request,
  );

  Future<ApiMessageResponse> logout();
}
