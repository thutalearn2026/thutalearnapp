import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:thuta_learn/core/core.dart';
import 'package:thuta_learn/features/learn/learn.dart';

part 'module_detail_event.dart';
part 'module_detail_state.dart';

@Injectable()
class ModuleDetailBloc
    extends Bloc<ModuleDetailEvent, ModuleDetailState> {
  final LearnUseCase learnUseCase;

  ModuleDetailBloc({
    required this.learnUseCase,
  }) : super(const ModuleDetailState()) {
    on<OnGetModuleDetail>(_onGetModuleDetail);
    on<OnGetChapterVideos>(_onGetChapterVideos);
    on<OnGetChapterResources>(
      _onGetChapterResources,
    );
  }

  Future<void> _onGetModuleDetail(
      OnGetModuleDetail event,
      Emitter<ModuleDetailState> emit,
      ) async {
    if (state.isLoading) return;

    emit(
      state.copyWith(
        status: ModuleDetailStatus.loading,
        clearMessage: true,
      ),
    );

    final moduleFuture =
    learnUseCase.getModuleDetail(
      courseId: event.courseId,
      moduleId: event.moduleId,
    );

    final chaptersFuture =
    learnUseCase.getModuleChapters(
      moduleId: event.moduleId,
    );

    final moduleResult = await moduleFuture;
    final chaptersResult = await chaptersFuture;

    Failure? requestFailure;
    CourseModuleModel? module;
    List<ChapterModel> chapters = [];

    moduleResult.fold(
          (failure) {
        requestFailure = failure;
      },
          (response) {
        module = response.data;
      },
    );

    chaptersResult.fold(
          (failure) {
        requestFailure ??= failure;
      },
          (response) {
        chapters = [...response.data]
          ..sort(
                (first, second) {
              return first.rank.compareTo(second.rank);
            },
          );
      },
    );

    if (requestFailure != null || module == null) {
      emit(
        state.copyWith(
          status: ModuleDetailStatus.failure,
          message: _failureMessage(
            requestFailure,
          ),
        ),
      );

      return;
    }

    emit(
      state.copyWith(
        status: ModuleDetailStatus.success,
        module: module,
        chapters: chapters,
        videosByChapter: const {},
        loadingChapterIds: const {},
        chapterVideoErrors: const {},
        resourcesByChapter: const {},
        loadingResourceChapterIds: const {},
        chapterResourceErrors: const {},
        clearMessage: true,
      ),
    );

    // The first chapter is initially expanded.
    for (final chapter in chapters) {
      if (chapter.videosCount > 0) {
        add(
          OnGetChapterVideos(
            chapterId: chapter.id,
          ),
        );
        break;
      }
    }
  }

  Future<void> _onGetChapterVideos(
      OnGetChapterVideos event,
      Emitter<ModuleDetailState> emit,
      ) async {
    if (state.loadingChapterIds.contains(
      event.chapterId,
    ) ||
        state.videosByChapter.containsKey(
          event.chapterId,
        )) {
      return;
    }

    final loadingIds = {
      ...state.loadingChapterIds,
      event.chapterId,
    };

    final errors = {
      ...state.chapterVideoErrors,
    }..remove(event.chapterId);

    emit(
      state.copyWith(
        loadingChapterIds: loadingIds,
        chapterVideoErrors: errors,
      ),
    );

    final result = await learnUseCase.getChapterVideos(
      chapterId: event.chapterId,
    );

    result.fold(
          (failure) {
        final updatedLoadingIds = {
          ...state.loadingChapterIds,
        }..remove(event.chapterId);

        final updatedErrors = {
          ...state.chapterVideoErrors,
          event.chapterId: _failureMessage(failure),
        };

        emit(
          state.copyWith(
            loadingChapterIds: updatedLoadingIds,
            chapterVideoErrors: updatedErrors,
          ),
        );
      },
          (response) {
        final videos = [...response.data]
          ..sort(
                (first, second) {
              return first.rank.compareTo(second.rank);
            },
          );

        final updatedVideos = {
          ...state.videosByChapter,
          event.chapterId: videos,
        };

        final updatedLoadingIds = {
          ...state.loadingChapterIds,
        }..remove(event.chapterId);

        emit(
          state.copyWith(
            videosByChapter: updatedVideos,
            loadingChapterIds: updatedLoadingIds,
          ),
        );
      },
    );
  }

  Future<void> _onGetChapterResources(
      OnGetChapterResources event,
      Emitter<ModuleDetailState> emit,
      ) async {
    final chapterId = event.chapterId;

    if (state.loadingResourceChapterIds.contains(
      chapterId,
    ) ||
        state.resourcesByChapter.containsKey(
          chapterId,
        )) {
      return;
    }

    final loadingIds = {
      ...state.loadingResourceChapterIds,
      chapterId,
    };

    final errors = {
      ...state.chapterResourceErrors,
    }..remove(chapterId);

    emit(
      state.copyWith(
        loadingResourceChapterIds: loadingIds,
        chapterResourceErrors: errors,
      ),
    );

    final result =
    await learnUseCase.getChapterResources(
      chapterId: chapterId,
    );

    result.fold(
          (failure) {
        final updatedLoadingIds = {
          ...state.loadingResourceChapterIds,
        }..remove(chapterId);

        final updatedErrors = {
          ...state.chapterResourceErrors,
          chapterId: _failureMessage(failure),
        };

        emit(
          state.copyWith(
            loadingResourceChapterIds:
            updatedLoadingIds,
            chapterResourceErrors: updatedErrors,
          ),
        );
      },
          (response) {
        final resources = [...response.data]
          ..sort(
                (first, second) {
              return first.rank.compareTo(
                second.rank,
              );
            },
          );

        final updatedResources = {
          ...state.resourcesByChapter,
          chapterId: resources,
        };

        final updatedLoadingIds = {
          ...state.loadingResourceChapterIds,
        }..remove(chapterId);

        emit(
          state.copyWith(
            resourcesByChapter: updatedResources,
            loadingResourceChapterIds:
            updatedLoadingIds,
          ),
        );
      },
    );
  }

  String _failureMessage(Failure? failure) {
    if (failure is ConnectionFailure) {
      return 'Please check your internet connection and try again.';
    }

    final message = failure?.e?.toString();

    if (message == null || message.isEmpty) {
      return 'Unable to load module information.';
    }

    return message;
  }
}