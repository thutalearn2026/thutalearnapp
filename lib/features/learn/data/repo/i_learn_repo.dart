import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:thuta_learn/core/core.dart';
import 'package:thuta_learn/features/learn/learn.dart';

@Injectable(as: LearnRepo)
class ILearnRepo implements LearnRepo {
  final LearnClient client;

  ILearnRepo({
    required this.client,
  });

  @override
  Future<Either<Failure, CoursesResponse>> getCourses({
    required int page,
  }) {
    return _request(
      () => client.getCourses(
        page: page,
      ),
    );
  }

  @override
  Future<Either<Failure, CourseDetailResponse>> getCourseDetail({
    required String courseId,
  }) {
    return _request(
      () => client.getCourseDetail(
        courseId: courseId,
      ),
    );
  }

  @override
  Future<Either<Failure, CourseModulesResponse>> getCourseModules({
    required String courseId,
  }) {
    return _request(
      () => client.getCourseModules(
        courseId: courseId,
      ),
    );
  }

  Future<Either<Failure, T>> _request<T>(
    Future<T> Function() request,
  ) async {
    try {
      final response = await request();

      return Right(response);
    } on DioException catch (error) {
      if (checkConnectionFailure(error)) {
        return Left(ConnectionFailure());
      }

      return Left(
        ServerFailure(
          e: getApiErrorMessage(error),
        ),
      );
    } catch (error) {
      return Left(
        ServerFailure(
          e: error.toString(),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, ModuleDetailResponse>> getModuleDetail({
    required String courseId,
    required String moduleId,
  }) {
    return _request(
      () => client.getModuleDetail(
        courseId: courseId,
        moduleId: moduleId,
      ),
    );
  }

  @override
  Future<Either<Failure, ChapterListResponse>> getModuleChapters({
    required String moduleId,
  }) {
    return _request(
      () => client.getModuleChapters(
        moduleId: moduleId,
      ),
    );
  }

  @override
  Future<Either<Failure, ChapterDetailResponse>> getChapterDetail({
    required String moduleId,
    required String chapterId,
  }) {
    return _request(
      () => client.getChapterDetail(
        moduleId: moduleId,
        chapterId: chapterId,
      ),
    );
  }

  @override
  Future<Either<Failure, ChapterVideosResponse>> getChapterVideos({
    required String chapterId,
  }) {
    return _request(
      () => client.getChapterVideos(
        chapterId: chapterId,
      ),
    );
  }

  @override
  Future<Either<Failure, ChapterVideoDetailResponse>> getChapterVideoDetail({
    required String chapterId,
    required String videoId,
  }) {
    return _request(
      () => client.getChapterVideoDetail(
        chapterId: chapterId,
        videoId: videoId,
      ),
    );
  }

  @override
  Future<Either<Failure, ChapterResourcesResponse>> getChapterResources({
    required String chapterId,
  }) {
    return _request(
      () => client.getChapterResources(
        chapterId: chapterId,
      ),
    );
  }

  @override
  Future<Either<Failure, ChapterResourceDetailResponse>> getChapterResourceDetail({
    required String chapterId,
    required String resourceId,
  }) {
    return _request(
      () => client.getChapterResourceDetail(
        chapterId: chapterId,
        resourceId: resourceId,
      ),
    );
  }

  @override
  Future<Either<Failure, ChapterQuizzesResponse>> getChapterQuizzes({
    required String chapterId,
  }) {
    return _request(
      () => client.getChapterQuizzes(
        chapterId: chapterId,
      ),
    );
  }

  @override
  Future<Either<Failure, QuizDetailResponse>> getQuizDetail({
    required String chapterId,
    required String quizId,
  }) {
    return _request(
      () => client.getQuizDetail(
        chapterId: chapterId,
        quizId: quizId,
      ),
    );
  }

  @override
  Future<Either<Failure, QuizAttemptResponse>> submitQuizAttempt({
    required String quizId,
    required QuizAttemptRequest request,
  }) {
    return _request(
      () => client.submitQuizAttempt(
        quizId: quizId,
        request: request,
      ),
    );
  }

  @override
  Future<CoursesCacheSnapshot?> getCachedCourses() {
    return CoursesCacheBox.read();
  }

  @override
  Future<void> saveCoursesCache(
    CoursesCacheSnapshot snapshot,
  ) {
    return CoursesCacheBox.save(snapshot);
  }

  @override
  Future<CourseDetailCacheSnapshot?> getCachedCourseDetail({
    required String courseId,
  }) {
    return CourseDetailCacheBox.read(
      courseId: courseId,
    );
  }

  @override
  Future<void> saveCourseDetailCache(
    CourseDetailCacheSnapshot snapshot,
  ) {
    return CourseDetailCacheBox.save(snapshot);
  }

  @override
  Future<ModuleLessonsCacheSnapshot?> getCachedModuleLessons({
    required String moduleId,
  }) {
    return ModuleLessonsCacheBox.read(
      moduleId: moduleId,
    );
  }

  @override
  Future<void> saveModuleLessonsCache(
    ModuleLessonsCacheSnapshot snapshot,
  ) {
    return ModuleLessonsCacheBox.saveModuleSnapshot(
      snapshot,
    );
  }

  @override
  Future<void> saveChapterVideosCache({
    required String moduleId,
    required String chapterId,
    required List<ChapterVideoModel> videos,
  }) {
    return ModuleLessonsCacheBox.saveChapterVideos(
      moduleId: moduleId,
      chapterId: chapterId,
      videos: videos,
    );
  }

  @override
  Future<void> pruneChapterVideosCache({
    required String moduleId,
    required Set<String> validChapterIds,
  }) {
    return ModuleLessonsCacheBox.pruneChapterVideos(
      moduleId: moduleId,
      validChapterIds: validChapterIds,
    );
  }

  @override
  Future<ChapterVideoModel?> getCachedLessonDetail({
    required String chapterId,
    required String videoId,
  }) {
    return LessonDetailCacheBox.read(
      chapterId: chapterId,
      videoId: videoId,
    );
  }

  @override
  Future<void> saveLessonDetailCache({
    required String chapterId,
    required ChapterVideoModel video,
  }) {
    return LessonDetailCacheBox.save(
      chapterId: chapterId,
      video: video,
    );
  }

  @override
  Future<List<ChapterResourceModel>?> getCachedChapterResources({
    required String moduleId,
    required String chapterId,
  }) {
    return ModuleResourcesCacheBox.read(
      moduleId: moduleId,
      chapterId: chapterId,
    );
  }

  @override
  Future<void> saveChapterResourcesCache({
    required String moduleId,
    required String chapterId,
    required List<ChapterResourceModel> resources,
  }) {
    return ModuleResourcesCacheBox.save(
      moduleId: moduleId,
      chapterId: chapterId,
      resources: resources,
    );
  }

  @override
  Future<void> pruneChapterResourcesCache({
    required String moduleId,
    required Set<String> validChapterIds,
  }) {
    return ModuleResourcesCacheBox.prune(
      moduleId: moduleId,
      validChapterIds: validChapterIds,
    );
  }

  @override
  Future<Either<Failure, VideoVocabulariesResponse>> getVideoVocabularies({
    required String videoId,
  }) {
    return _request(
      () => client.getVideoVocabularies(
        videoId: videoId,
      ),
    );
  }

  @override
  Future<List<VideoVocabularyModel>?> getCachedVideoVocabularies({
    required String videoId,
  }) {
    return LessonVocabularyCacheBox.read(
      videoId: videoId,
    );
  }

  @override
  Future<void> saveVideoVocabulariesCache({
    required String videoId,
    required List<VideoVocabularyModel> vocabularies,
  }) {
    return LessonVocabularyCacheBox.save(
      videoId: videoId,
      vocabularies: vocabularies,
    );
  }

  @override
  Future<Either<Failure, VocabularySaveResponse>> saveVocabulary({
    required String vocabularyId,
  }) {
    return _request(
      () => client.saveVocabulary(
        vocabularyId: vocabularyId,
      ),
    );
  }

  @override
  Future<Either<Failure, SavedVocabulariesResponse>> getSavedVocabularies() {
    return _request(
      () => client.getSavedVocabularies(),
    );
  }

  @override
  Future<Either<Failure, WordOfTheDayResponse>> getWordOfTheDay() {
    return _request(
      () => client.getWordOfTheDay(),
    );
  }
}
