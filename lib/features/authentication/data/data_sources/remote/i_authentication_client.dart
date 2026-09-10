import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:thuta_learn/core/core.dart';
import 'package:thuta_learn/features/authentication/authentication.dart';

@Injectable(as: AuthenticationClient)
class IAuthenticationClient implements AuthenticationClient {
  final RestClient client;

  IAuthenticationClient({
    required Dio dio,
    required IConfig config,
  }) : client = RestClient(
         dio,
         baseUrl: config.baseUrl,
       );

  @override
  Future<ApiMessageResponse> initiateRegistration(
    RegisterInitiateRequest request,
  ) {
    return client.initiateRegistration(request);
  }

  @override
  Future<ApiMessageResponse> verifyRegistrationCode(
    RegisterVerifyRequest request,
  ) {
    return client.verifyRegistrationCode(request);
  }

  @override
  Future<RegisterCompleteResponse> completeRegistration(
    RegisterCompleteRequest request,
  ) {
    return client.completeRegistration(request);
  }

  @override
  Future<LoginResponse> login(
    LoginRequest request,
  ) {
    return client.login(request);
  }

  @override
  Future<ApiMessageResponse> forgotPassword(
    ForgotPasswordRequest request,
  ) {
    return client.forgotPassword(request);
  }

  @override
  Future<ApiMessageResponse> verifyForgotPasswordCode(
    ForgotPasswordVerifyRequest request,
  ) {
    return client.verifyForgotPasswordCode(request);
  }

  @override
  Future<ApiMessageResponse> resetPassword(
    ResetPasswordRequest request,
  ) {
    return client.resetPassword(request);
  }

  @override
  Future<OnboardingOptionsResponse> getOnboardingOptions() {
    return client.getOnboardingOptions();
  }

  @override
  Future<OnboardingPreferenceResponse> saveOnboardingPreferences(
    OnboardingPreferenceRequest request,
  ) {
    return client.saveOnboardingPreferences(request);
  }

  @override
  Future<ApiMessageResponse> logout() {
    return client.logout();
  }
}
