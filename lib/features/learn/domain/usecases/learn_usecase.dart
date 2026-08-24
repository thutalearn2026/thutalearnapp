import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:thuta_learn/core/core.dart';
import 'package:thuta_learn/features/learn/learn.dart';

@Injectable()
class LearnUseCase {
  final LearnRepo learnRepo;

  LearnUseCase({
    required this.learnRepo,
  });

  Future<Either<Failure, CoursesResponse>> getCourses({
    int page = 1,
  }) {
    return learnRepo.getCourses(
      page: page,
    );
  }

  Future<Either<Failure, CourseDetailResponse>> getCourseDetail({
    required String courseId,
  }) {
    return learnRepo.getCourseDetail(
      courseId: courseId,
    );
  }

  Future<Either<Failure, CourseModulesResponse>> getCourseModules({
    required String courseId,
  }) {
    return learnRepo.getCourseModules(
      courseId: courseId,
    );
  }

  Future<Either<Failure, ModuleDetailResponse>> getModuleDetail({
    required String courseId,
    required String moduleId,
  }) {
    return learnRepo.getModuleDetail(
      courseId: courseId,
      moduleId: moduleId,
    );
  }

  Future<Either<Failure, ChapterListResponse>> getModuleChapters({
    required String moduleId,
  }) {
    return learnRepo.getModuleChapters(
      moduleId: moduleId,
    );
  }

  Future<Either<Failure, ChapterDetailResponse>> getChapterDetail({
    required String moduleId,
    required String chapterId,
  }) {
    return learnRepo.getChapterDetail(
      moduleId: moduleId,
      chapterId: chapterId,
    );
  }

  Future<Either<Failure, ChapterVideosResponse>> getChapterVideos({
    required String chapterId,
  }) {
    return learnRepo.getChapterVideos(
      chapterId: chapterId,
    );
  }

  Future<Either<Failure, ChapterVideoDetailResponse>> getChapterVideoDetail({
    required String chapterId,
    required String videoId,
  }) {
    return learnRepo.getChapterVideoDetail(
      chapterId: chapterId,
      videoId: videoId,
    );
  }

  Future<Either<Failure, ChapterResourcesResponse>> getChapterResources({
    required String chapterId,
  }) {
    return learnRepo.getChapterResources(
      chapterId: chapterId,
    );
  }

  Future<Either<Failure, ChapterResourceDetailResponse>> getChapterResourceDetail({
    required String chapterId,
    required String resourceId,
  }) {
    return learnRepo.getChapterResourceDetail(
      chapterId: chapterId,
      resourceId: resourceId,
    );
  }

  Future<Either<Failure, ChapterQuizzesResponse>> getChapterQuizzes({
    required String chapterId,
  }) {
    return learnRepo.getChapterQuizzes(
      chapterId: chapterId,
    );
  }

  Future<Either<Failure, QuizDetailResponse>> getQuizDetail({
    required String chapterId,
    required String quizId,
  }) {
    return learnRepo.getQuizDetail(
      chapterId: chapterId,
      quizId: quizId,
    );
  }

  Future<Either<Failure, QuizAttemptResponse>> submitQuizAttempt({
    required String quizId,
    required QuizAttemptRequest request,
  }) {
    return learnRepo.submitQuizAttempt(
      quizId: quizId,
      request: request,
    );
  }

  Future<CoursesCacheSnapshot?> getCachedCourses() {
    return learnRepo.getCachedCourses();
  }

  Future<void> saveCoursesCache(
    CoursesCacheSnapshot snapshot,
  ) {
    return learnRepo.saveCoursesCache(
      snapshot,
    );
  }

  Future<CourseDetailCacheSnapshot?> getCachedCourseDetail({
    required String courseId,
  }) {
    return learnRepo.getCachedCourseDetail(
      courseId: courseId,
    );
  }

  Future<void> saveCourseDetailCache(
    CourseDetailCacheSnapshot snapshot,
  ) {
    return learnRepo.saveCourseDetailCache(
      snapshot,
    );
  }

  Future<ModuleLessonsCacheSnapshot?> getCachedModuleLessons({
    required String moduleId,
  }) {
    return learnRepo.getCachedModuleLessons(
      moduleId: moduleId,
    );
  }

  Future<void> saveModuleLessonsCache(
    ModuleLessonsCacheSnapshot snapshot,
  ) {
    return learnRepo.saveModuleLessonsCache(
      snapshot,
    );
  }

  Future<void> saveChapterVideosCache({
    required String moduleId,
    required String chapterId,
    required List<ChapterVideoModel> videos,
  }) {
    return learnRepo.saveChapterVideosCache(
      moduleId: moduleId,
      chapterId: chapterId,
      videos: videos,
    );
  }

  Future<void> pruneChapterVideosCache({
    required String moduleId,
    required Set<String> validChapterIds,
  }) {
    return learnRepo.pruneChapterVideosCache(
      moduleId: moduleId,
      validChapterIds: validChapterIds,
    );
  }

  Future<ChapterVideoModel?> getCachedLessonDetail({
    required String chapterId,
    required String videoId,
  }) {
    return learnRepo.getCachedLessonDetail(
      chapterId: chapterId,
      videoId: videoId,
    );
  }

  Future<void> saveLessonDetailCache({
    required String chapterId,
    required ChapterVideoModel video,
  }) {
    return learnRepo.saveLessonDetailCache(
      chapterId: chapterId,
      video: video,
    );
  }

  Future<List<ChapterResourceModel>?> getCachedChapterResources({
    required String moduleId,
    required String chapterId,
  }) {
    return learnRepo.getCachedChapterResources(
      moduleId: moduleId,
      chapterId: chapterId,
    );
  }

  Future<void> saveChapterResourcesCache({
    required String moduleId,
    required String chapterId,
    required List<ChapterResourceModel> resources,
  }) {
    return learnRepo.saveChapterResourcesCache(
      moduleId: moduleId,
      chapterId: chapterId,
      resources: resources,
    );
  }

  Future<void> pruneChapterResourcesCache({
    required String moduleId,
    required Set<String> validChapterIds,
  }) {
    return learnRepo.pruneChapterResourcesCache(
      moduleId: moduleId,
      validChapterIds: validChapterIds,
    );
  }

  Future<Either<Failure, VideoVocabulariesResponse>> getVideoVocabularies({
    required String videoId,
  }) {
    return learnRepo.getVideoVocabularies(
      videoId: videoId,
    );
  }

  Future<List<VideoVocabularyModel>?> getCachedVideoVocabularies({
    required String videoId,
  }) {
    return learnRepo.getCachedVideoVocabularies(
      videoId: videoId,
    );
  }

  Future<void> saveVideoVocabulariesCache({
    required String videoId,
    required List<VideoVocabularyModel> vocabularies,
  }) {
    return learnRepo.saveVideoVocabulariesCache(
      videoId: videoId,
      vocabularies: vocabularies,
    );
  }

  Future<Either<Failure, VocabularySaveResponse>> saveVocabulary({
    required String vocabularyId,
  }) {
    return learnRepo.saveVocabulary(
      vocabularyId: vocabularyId,
    );
  }
}
