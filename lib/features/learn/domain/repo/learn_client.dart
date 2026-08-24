import 'package:thuta_learn/features/learn/learn.dart';

abstract class LearnClient {
  Future<CoursesResponse> getCourses({
    required int page,
  });

  Future<CourseDetailResponse> getCourseDetail({
    required String courseId,
  });

  Future<CourseModulesResponse> getCourseModules({
    required String courseId,
  });

  Future<ModuleDetailResponse> getModuleDetail({
    required String courseId,
    required String moduleId,
  });

  Future<ChapterListResponse> getModuleChapters({
    required String moduleId,
  });

  Future<ChapterDetailResponse> getChapterDetail({
    required String moduleId,
    required String chapterId,
  });

  Future<ChapterVideosResponse> getChapterVideos({
    required String chapterId,
  });
  Future<ChapterVideoDetailResponse> getChapterVideoDetail({
    required String chapterId,
    required String videoId,
  });

  Future<ChapterResourcesResponse> getChapterResources({
    required String chapterId,
  });

  Future<ChapterResourceDetailResponse> getChapterResourceDetail({
    required String chapterId,
    required String resourceId,
  });

  Future<ChapterQuizzesResponse> getChapterQuizzes({
    required String chapterId,
  });

  Future<QuizDetailResponse> getQuizDetail({
    required String chapterId,
    required String quizId,
  });

  Future<QuizAttemptResponse> submitQuizAttempt({
    required String quizId,
    required QuizAttemptRequest request,
  });

  Future<VideoVocabulariesResponse> getVideoVocabularies({
    required String videoId,
  });

  Future<VocabularySaveResponse> saveVocabulary({
    required String vocabularyId,
  });
}
