import 'package:dartz/dartz.dart';
import 'package:thuta_learn/core/core.dart';
import 'package:thuta_learn/features/learn/learn.dart';

abstract class LearnRepo {
  Future<Either<Failure, CoursesResponse>> getCourses({
    required int page,
  });

  Future<Either<Failure, EnrolledCoursesResponse>> getEnrolledCourses();

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

  Future<Either<Failure, ChapterResourceDetailResponse>>
  getChapterResourceDetail({
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

  Future<CoursesCacheSnapshot?> getCachedCourses();

  Future<void> saveCoursesCache(
    CoursesCacheSnapshot snapshot,
  );

  Future<CourseDetailCacheSnapshot?> getCachedCourseDetail({
    required String courseId,
  });

  Future<void> saveCourseDetailCache(
    CourseDetailCacheSnapshot snapshot,
  );

  Future<ModuleLessonsCacheSnapshot?> getCachedModuleLessons({
    required String moduleId,
  });

  Future<void> saveModuleLessonsCache(
    ModuleLessonsCacheSnapshot snapshot,
  );

  Future<void> saveChapterVideosCache({
    required String moduleId,
    required String chapterId,
    required List<ChapterVideoModel> videos,
  });

  Future<void> pruneChapterVideosCache({
    required String moduleId,
    required Set<String> validChapterIds,
  });

  Future<ChapterVideoModel?> getCachedLessonDetail({
    required String chapterId,
    required String videoId,
  });

  Future<void> saveLessonDetailCache({
    required String chapterId,
    required ChapterVideoModel video,
  });

  Future<List<ChapterResourceModel>?> getCachedChapterResources({
    required String moduleId,
    required String chapterId,
  });

  Future<void> saveChapterResourcesCache({
    required String moduleId,
    required String chapterId,
    required List<ChapterResourceModel> resources,
  });

  Future<void> pruneChapterResourcesCache({
    required String moduleId,
    required Set<String> validChapterIds,
  });

  Future<Either<Failure, VideoVocabulariesResponse>> getVideoVocabularies({
    required String videoId,
  });

  Future<List<VideoVocabularyModel>?> getCachedVideoVocabularies({
    required String videoId,
  });

  Future<void> saveVideoVocabulariesCache({
    required String videoId,
    required List<VideoVocabularyModel> vocabularies,
  });

  Future<Either<Failure, VocabularySaveResponse>> saveVocabulary({
    required String vocabularyId,
  });

  Future<Either<Failure, SavedVocabulariesResponse>> getSavedVocabularies();

  Future<Either<Failure, WordOfTheDayResponse>> getWordOfTheDay();
}
