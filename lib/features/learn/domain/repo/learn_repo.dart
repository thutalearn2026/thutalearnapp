import 'package:dartz/dartz.dart';
import 'package:thuta_learn/core/core.dart';
import 'package:thuta_learn/features/learn/learn.dart';

abstract class LearnRepo {
  Future<Either<Failure, CoursesResponse>> getCourses({
    required int page,
  });

  Future<Either<Failure, CourseDetailResponse>> getCourseDetail({
    required String courseId,
  });

  Future<Either<Failure, CourseModulesResponse>> getCourseModules({
    required String courseId,
  });

  Future<Either<Failure, ModuleDetailResponse>> getModuleDetail({
    required String courseId,
    required String moduleId,
  });

  Future<Either<Failure, ChapterListResponse>> getModuleChapters({
    required String moduleId,
  });

  Future<Either<Failure, ChapterDetailResponse>> getChapterDetail({
    required String moduleId,
    required String chapterId,
  });

  Future<Either<Failure, ChapterVideosResponse>> getChapterVideos({
    required String chapterId,
  });

  Future<Either<Failure, ChapterVideoDetailResponse>> getChapterVideoDetail({
    required String chapterId,
    required String videoId,
  });

  Future<Either<Failure, ChapterResourcesResponse>> getChapterResources({
    required String chapterId,
  });

  Future<Either<Failure, ChapterResourceDetailResponse>> getChapterResourceDetail({
    required String chapterId,
    required String resourceId,
  });

  Future<Either<Failure, ChapterQuizzesResponse>> getChapterQuizzes({
    required String chapterId,
  });

  Future<Either<Failure, QuizDetailResponse>> getQuizDetail({
    required String chapterId,
    required String quizId,
  });

  Future<Either<Failure, QuizAttemptResponse>> submitQuizAttempt({
    required String quizId,
    required QuizAttemptRequest request,
  });
}
