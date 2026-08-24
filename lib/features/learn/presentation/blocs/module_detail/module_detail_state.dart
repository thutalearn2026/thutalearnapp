part of 'module_detail_bloc.dart';

enum ModuleDetailStatus {
  initial,
  loading,
  success,
  failure,
}

class ModuleDetailState {
  final ModuleDetailStatus status;
  final CourseModuleModel? module;
  final List<ChapterModel> chapters;

  final bool isRefreshing;

  final Map<String, List<ChapterVideoModel>> videosByChapter;

  // Used when no cached videos are available.
  final Set<String> loadingChapterIds;

  // Includes background refreshes when cached videos
  // are already visible.
  final Set<String> refreshingVideoChapterIds;

  // Prevents another network request after a chapter
  // has already been refreshed during this page session.
  final Set<String> refreshedVideoChapterIds;

  final Map<String, String> chapterVideoErrors;

  final Map<String, List<ChapterResourceModel>> resourcesByChapter;

  final Set<String> loadingResourceChapterIds;

  final Set<String> refreshingResourceChapterIds;

  final Set<String> refreshedResourceChapterIds;

  final Map<String, String> chapterResourceErrors;

  final Map<String, List<ChapterQuizModel>> quizzesByChapter;

  final Set<String> loadingQuizChapterIds;

  final Map<String, String> chapterQuizErrors;

  final String? message;

  const ModuleDetailState({
    this.status = ModuleDetailStatus.initial,
    this.module,
    this.chapters = const [],
    this.isRefreshing = false,
    this.videosByChapter = const {},
    this.loadingChapterIds = const {},
    this.refreshingVideoChapterIds = const {},
    this.refreshedVideoChapterIds = const {},
    this.chapterVideoErrors = const {},
    this.resourcesByChapter = const {},
    this.loadingResourceChapterIds = const {},
    this.refreshingResourceChapterIds = const {},
    this.refreshedResourceChapterIds = const {},
    this.chapterResourceErrors = const {},
    this.quizzesByChapter = const {},
    this.loadingQuizChapterIds = const {},
    this.chapterQuizErrors = const {},
    this.message,
  });

  bool get isLoading {
    return (status == ModuleDetailStatus.initial || status == ModuleDetailStatus.loading) &&
        module == null;
  }

  bool get isShowingCachedData {
    return module != null && isRefreshing;
  }

  int get totalVideoCount {
    return chapters.fold<int>(
      0,
      (total, chapter) {
        return total + chapter.videosCount;
      },
    );
  }

  ModuleDetailState copyWith({
    ModuleDetailStatus? status,
    CourseModuleModel? module,
    List<ChapterModel>? chapters,
    bool? isRefreshing,
    Map<String, List<ChapterVideoModel>>? videosByChapter,
    Set<String>? loadingChapterIds,
    Set<String>? refreshingVideoChapterIds,
    Set<String>? refreshedVideoChapterIds,
    Map<String, String>? chapterVideoErrors,
    Map<String, List<ChapterResourceModel>>? resourcesByChapter,
    Set<String>? loadingResourceChapterIds,
    Map<String, String>? chapterResourceErrors,
    Map<String, List<ChapterQuizModel>>? quizzesByChapter,
    Set<String>? loadingQuizChapterIds,
    Map<String, String>? chapterQuizErrors,
    String? message,
    Set<String>? refreshingResourceChapterIds,
    Set<String>? refreshedResourceChapterIds,
    bool clearMessage = false,
  }) {
    return ModuleDetailState(
      status: status ?? this.status,
      module: module ?? this.module,
      chapters: chapters ?? this.chapters,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      videosByChapter: videosByChapter ?? this.videosByChapter,
      loadingChapterIds: loadingChapterIds ?? this.loadingChapterIds,
      refreshingVideoChapterIds: refreshingVideoChapterIds ?? this.refreshingVideoChapterIds,
      refreshedVideoChapterIds: refreshedVideoChapterIds ?? this.refreshedVideoChapterIds,
      chapterVideoErrors: chapterVideoErrors ?? this.chapterVideoErrors,
      resourcesByChapter: resourcesByChapter ?? this.resourcesByChapter,
      loadingResourceChapterIds: loadingResourceChapterIds ?? this.loadingResourceChapterIds,
      chapterResourceErrors: chapterResourceErrors ?? this.chapterResourceErrors,
      quizzesByChapter: quizzesByChapter ?? this.quizzesByChapter,
      loadingQuizChapterIds: loadingQuizChapterIds ?? this.loadingQuizChapterIds,
      chapterQuizErrors: chapterQuizErrors ?? this.chapterQuizErrors,
      message: clearMessage ? null : message ?? this.message,

      refreshingResourceChapterIds:
      refreshingResourceChapterIds ??
          this.refreshingResourceChapterIds,

      refreshedResourceChapterIds:
      refreshedResourceChapterIds ??
          this.refreshedResourceChapterIds,
    );
  }
}
