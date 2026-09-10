import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:thuta_learn/core/core.dart';
import 'package:thuta_learn/features/authentication/authentication.dart';

@Injectable()
class AuthenticationUseCase {
  final AuthenticationRepo authenticationRepo;

  AuthenticationUseCase({
    required this.authenticationRepo,
  });

  Future<Either<Failure, ApiMessageResponse>> initiateRegistration({
    required String name,
    required String email,
  }) {
    return authenticationRepo.initiateRegistration(
      RegisterInitiateRequest(
        name: name,
        email: email,
      ),
    );
  }

  Future<Either<Failure, ApiMessageResponse>> verifyRegistrationCode({
    required String email,
    required String code,
  }) {
    return authenticationRepo.verifyRegistrationCode(
      RegisterVerifyRequest(
        email: email,
        code: code,
      ),
    );
  }

  Future<Either<Failure, RegisterCompleteResponse>> completeRegistration({
    required String email,
    required String code,
    required String password,
    required String passwordConfirmation,
  }) {
    return authenticationRepo.completeRegistration(
      RegisterCompleteRequest(
        email: email,
        code: code,
        password: password,
        passwordConfirmation: passwordConfirmation,
      ),
    );
  }

  Future<Either<Failure, LoginResponse>> login({
    required String email,
    required String password,
  }) {
    return authenticationRepo.login(
      LoginRequest(
        email: email,
        password: password,
      ),
    );
  }

  Future<Either<Failure, ApiMessageResponse>> forgotPassword({
    required String email,
  }) {
    return authenticationRepo.forgotPassword(
      ForgotPasswordRequest(
        email: email,
      ),
    );
  }

  Future<Either<Failure, ApiMessageResponse>> verifyForgotPasswordCode({
    required String email,
    required String code,
  }) {
    return authenticationRepo.verifyForgotPasswordCode(
      ForgotPasswordVerifyRequest(
        email: email,
        code: code,
      ),
    );
  }

  Future<Either<Failure, ApiMessageResponse>> resetPassword({
    required String email,
    required String code,
    required String password,
    required String passwordConfirmation,
  }) {
    return authenticationRepo.resetPassword(
      ResetPasswordRequest(
        email: email,
        code: code,
        password: password,
        passwordConfirmation: passwordConfirmation,
      ),
    );
  }

  Future<Either<Failure, OnboardingOptionsResponse>> getOnboardingOptions() {
    return authenticationRepo.getOnboardingOptions();
  }

  Future<Either<Failure, OnboardingPreferenceResponse>> saveOnboardingPreferences({
    String? learningReason,
    String? currentLevel,
    int? dailyGoalMinutes,
  }) {
    return authenticationRepo.saveOnboardingPreferences(
      OnboardingPreferenceRequest(
        learningReason: learningReason,
        currentLevel: currentLevel,
        dailyGoalMinutes: dailyGoalMinutes,
      ),
    );
  }

  Future<Either<Failure, ApiMessageResponse>> logout() {
    return authenticationRepo.logout();
  }
}
