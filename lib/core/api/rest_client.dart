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
import 'package:thuta_learn/features/learn/data/models/course_model.dart';

import '../../features/features.dart';

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

  @GET('courses')
  Future<CoursesResponse> getCourses(
    @Query('page') int page,
  );

  @GET('courses/{course}')
  Future<CourseDetailResponse> getCourseDetail(
    @Path('course') String courseId,
  );

  @GET('courses/{course}/modules')
  Future<CourseModulesResponse> getCourseModules(
    @Path('course') String courseId,
  );

  @GET('courses/{course}/modules/{module}')
  Future<ModuleDetailResponse> getModuleDetail(
    @Path('course') String courseId,
    @Path('module') String moduleId,
  );

  @GET('modules/{module}/chapters')
  Future<ChapterListResponse> getModuleChapters(
    @Path('module') String moduleId,
  );

  @GET('modules/{module}/chapters/{chapter}')
  Future<ChapterDetailResponse> getChapterDetail(
    @Path('module') String moduleId,
    @Path('chapter') String chapterId,
  );

  @GET('chapters/{chapter}/videos')
  Future<ChapterVideosResponse> getChapterVideos(
    @Path('chapter') String chapterId,
  );

  @GET('chapters/{chapter}/videos/{video}')
  Future<ChapterVideoDetailResponse> getChapterVideoDetail(
    @Path('chapter') String chapterId,
    @Path('video') String videoId,
  );

  @GET('chapters/{chapter}/resources')
  Future<ChapterResourcesResponse> getChapterResources(
    @Path('chapter') String chapterId,
  );

  @GET('chapters/{chapter}/resources/{resource}')
  Future<ChapterResourceDetailResponse> getChapterResourceDetail(
    @Path('chapter') String chapterId,
    @Path('resource') String resourceId,
  );

  @GET('chapters/{chapter}/quizzes')
  Future<ChapterQuizzesResponse> getChapterQuizzes(
    @Path('chapter') String chapterId,
  );

  @GET('chapters/{chapter}/quizzes/{quiz}')
  Future<QuizDetailResponse> getQuizDetail(
    @Path('chapter') String chapterId,
    @Path('quiz') String quizId,
  );

  @POST('quizzes/{quiz}/attempts')
  Future<QuizAttemptResponse> submitQuizAttempt(
    @Path('quiz') String quizId,
    @Body() QuizAttemptRequest request,
  );

  @GET('videos/{video}/vocabularies')
  Future<VideoVocabulariesResponse> getVideoVocabularies(
    @Path('video') String videoId,
  );

  @POST('vocabularies/{vocabulary}/save')
  Future<VocabularySaveResponse> saveVocabulary(
    @Path('vocabulary') String vocabularyId,
  );
}
