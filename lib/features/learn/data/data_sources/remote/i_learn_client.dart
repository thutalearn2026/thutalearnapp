import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:thuta_learn/core/core.dart';
import 'package:thuta_learn/features/learn/learn.dart';

@Injectable(as: LearnClient)
class ILearnClient implements LearnClient {
  final RestClient client;

  ILearnClient({
    required Dio dio,
    required IConfig config,
  }) : client = RestClient(
         dio,
         baseUrl: config.baseUrl,
       );

  @override
  Future<CoursesResponse> getCourses({
    required int page,
  }) {
    return client.getCourses(page);
  }

  @override
  Future<CourseDetailResponse> getCourseDetail({
    required String courseId,
  }) {
    return client.getCourseDetail(courseId);
  }

  @override
  Future<CourseModulesResponse> getCourseModules({
    required String courseId,
  }) {
    return client.getCourseModules(courseId);
  }

  @override
  Future<ModuleDetailResponse> getModuleDetail({
    required String courseId,
    required String moduleId,
  }) {
    return client.getModuleDetail(
      courseId,
      moduleId,
    );
  }

  @override
  Future<ChapterListResponse> getModuleChapters({
    required String moduleId,
  }) {
    return client.getModuleChapters(moduleId);
  }

  @override
  Future<ChapterDetailResponse> getChapterDetail({
    required String moduleId,
    required String chapterId,
  }) {
    return client.getChapterDetail(
      moduleId,
      chapterId,
    );
  }

  @override
  Future<ChapterVideosResponse> getChapterVideos({
    required String chapterId,
  }) {
    return client.getChapterVideos(chapterId);
  }

  @override
  Future<ChapterVideoDetailResponse> getChapterVideoDetail({
    required String chapterId,
    required String videoId,
  }) {
    return client.getChapterVideoDetail(
      chapterId,
      videoId,
    );
  }

  @override
  Future<ChapterResourcesResponse> getChapterResources({
    required String chapterId,
  }) {
    return client.getChapterResources(
      chapterId,
    );
  }

  @override
  Future<ChapterResourceDetailResponse> getChapterResourceDetail({
    required String chapterId,
    required String resourceId,
  }) {
    return client.getChapterResourceDetail(
      chapterId,
      resourceId,
    );
  }

  @override
  Future<ChapterQuizzesResponse> getChapterQuizzes({
    required String chapterId,
  }) {
    return client.getChapterQuizzes(
      chapterId,
    );
  }

  @override
  Future<QuizDetailResponse> getQuizDetail({
    required String chapterId,
    required String quizId,
  }) {
    return client.getQuizDetail(
      chapterId,
      quizId,
    );
  }

  @override
  Future<QuizAttemptResponse> submitQuizAttempt({
    required String quizId,
    required QuizAttemptRequest request,
  }) {
    return client.submitQuizAttempt(
      quizId,
      request,
    );
  }
}
