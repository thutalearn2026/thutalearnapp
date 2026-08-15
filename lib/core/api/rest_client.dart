import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:thuta_learn/features/authentication/data/models/register_request.dart';
import 'package:thuta_learn/features/authentication/data/models/register_response.dart';
import 'package:thuta_learn/features/authentication/data/models/login_request.dart';
import 'package:thuta_learn/features/authentication/data/models/login_response.dart';
import 'package:thuta_learn/features/authentication/data/models/forgot_password_request.dart';
import 'package:thuta_learn/features/profile/data/models/profile_model.dart';
import 'package:thuta_learn/features/authentication/data/models/onboarding_option_model.dart';
import 'package:thuta_learn/features/authentication/data/models/onboarding_preference_model.dart';
import 'package:thuta_learn/features/profile/data/models/change_password_model.dart';

part 'rest_client.g.dart';

@RestApi()
abstract class RestClient {
  factory RestClient(Dio dio, {String baseUrl}) = _RestClient;

  @POST('register/initiate')
  Future<ApiMessageResponse> initiateRegistration(
    @Body() RegisterInitiateRequest request,
  );

  @POST('register/verify')
  Future<ApiMessageResponse> verifyRegistrationCode(
    @Body() RegisterVerifyRequest request,
  );

  @POST('register/complete')
  Future<RegisterCompleteResponse> completeRegistration(
    @Body() RegisterCompleteRequest request,
  );

  @POST('login')
  Future<LoginResponse> login(
    @Body() LoginRequest request,
  );

  @POST('forgot-password')
  Future<ApiMessageResponse> forgotPassword(
    @Body() ForgotPasswordRequest request,
  );

  @POST('forgot-password/verify')
  Future<ApiMessageResponse> verifyForgotPasswordCode(
    @Body() ForgotPasswordVerifyRequest request,
  );

  @POST('reset-password')
  Future<ApiMessageResponse> resetPassword(
    @Body() ResetPasswordRequest request,
  );

  @GET('profile')
  Future<ProfileResponse> getProfile();

  @PUT('profile')
  @MultiPart()
  Future<UpdateProfileResponse> updateProfile(
    @Part(name: 'name') String name,
    @Part(name: 'email') String email,
    @Part(name: 'photo') MultipartFile? photo,
  );

  @GET('onboarding-options')
  Future<OnboardingOptionsResponse> getOnboardingOptions();

  @POST('onboarding-preferences')
  Future<OnboardingPreferenceResponse> saveOnboardingPreferences(
    @Body() OnboardingPreferenceRequest request,
  );

  @POST('logout')
  Future<ApiMessageResponse> logout();

  @PUT('change-password')
  Future<ChangePasswordResponse> changePassword(
    @Body() ChangePasswordRequest request,
  );
}
