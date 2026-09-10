import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:thuta_learn/core/core.dart';
import 'package:thuta_learn/features/learn/learn.dart';

part 'lesson_detail_event.dart';
part 'lesson_detail_state.dart';

@Injectable()
class LessonDetailBloc extends Bloc<LessonDetailEvent, LessonDetailState> {
  final LearnUseCase learnUseCase;

  LessonDetailBloc({
    required this.learnUseCase,
  }) : super(const LessonDetailState()) {
    on<OnGetLessonDetail>(_onGetLessonDetail);
    on<OnGetLessonVocabularies>(_onGetLessonVocabularies);
    on<OnToggleVocabularySaved>(_onToggleVocabularySaved);
  }

  Future<void> _onGetLessonDetail(
    OnGetLessonDetail event,
    Emitter<LessonDetailState> emit,
  ) async {
    if (state.isRefreshing) {
      return;
    }

    final cachedVideo = await learnUseCase.getCachedLessonDetail(
      chapterId: event.chapterId,
      videoId: event.videoId,
    );

    final visibleVideo = cachedVideo ?? state.video;

    final hasCachedData = visibleVideo != null;

    emit(
      state.copyWith(
        status: hasCachedData ? LessonDetailStatus.success : LessonDetailStatus.loading,
        video: visibleVideo,
        isRefreshing: true,
        clearMessage: true,
      ),
    );

    final result = await learnUseCase.getChapterVideoDetail(
      chapterId: event.chapterId,
      videoId: event.videoId,
    );

    await result.fold<Future<void>>(
      (failure) async {
        if (hasCachedData) {
          // Silently retain cached lesson metadata.
          emit(
            state.copyWith(
              status: LessonDetailStatus.success,
              video: visibleVideo,
              isRefreshing: false,
              clearMessage: true,
            ),
          );

          return;
        }

        emit(
          state.copyWith(
            status: LessonDetailStatus.failure,
            isRefreshing: false,
            message: _failureMessage(failure),
          ),
        );
      },
      (response) async {
        await learnUseCase.saveLessonDetailCache(
          chapterId: event.chapterId,
          video: response.data,
        );

        emit(
          state.copyWith(
            status: LessonDetailStatus.success,
            video: response.data,
            isRefreshing: false,
            clearMessage: true,
          ),
        );
      },
    );
  }

  Future<void> _onGetLessonVocabularies(
    OnGetLessonVocabularies event,
    Emitter<LessonDetailState> emit,
  ) async {
    if (state.isVocabularyRefreshing) {
      return;
    }

    final cachedVocabularies = await learnUseCase.getCachedVideoVocabularies(
      videoId: event.videoId,
    );

    final visibleVocabularies = cachedVocabularies ?? state.vocabularies;

    final hasCachedData = cachedVocabularies != null;

    emit(
      state.copyWith(
        vocabularyStatus: hasCachedData
            ? LessonVocabularyStatus.success
            : LessonVocabularyStatus.loading,
        vocabularies: visibleVocabularies,
        isVocabularyRefreshing: true,
        clearVocabularyMessage: true,
      ),
    );

    final result = await learnUseCase.getVideoVocabularies(
      videoId: event.videoId,
    );

    await result.fold<Future<void>>(
      (failure) async {
        if (hasCachedData) {
          // Silently retain cached vocabularies.
          emit(
            state.copyWith(
              vocabularyStatus: LessonVocabularyStatus.success,
              vocabularies: visibleVocabularies,
              isVocabularyRefreshing: false,
              clearVocabularyMessage: true,
            ),
          );

          return;
        }

        emit(
          state.copyWith(
            vocabularyStatus: LessonVocabularyStatus.failure,
            isVocabularyRefreshing: false,
            vocabularyMessage: _vocabularyFailureMessage(failure),
          ),
        );
      },
      (response) async {
        final vocabularies = [...response.data]
          ..sort(
            (first, second) {
              return first.rank.compareTo(second.rank);
            },
          );

        await learnUseCase.saveVideoVocabulariesCache(
          videoId: event.videoId,
          vocabularies: vocabularies,
        );

        emit(
          state.copyWith(
            vocabularyStatus: LessonVocabularyStatus.success,
            vocabularies: vocabularies,
            isVocabularyRefreshing: false,
            clearVocabularyMessage: true,
          ),
        );
      },
    );
  }

  String _vocabularyFailureMessage(
    Failure failure,
  ) {
    if (failure is ConnectionFailure) {
      return 'Please check your internet connection and try again.';
    }

    final message = failure.e?.toString();

    if (message == null || message.trim().isEmpty) {
      return 'Unable to load the vocabulary list.';
    }

    return message;
  }

  String _failureMessage(Failure failure) {
    if (failure is ConnectionFailure) {
      return 'Please check your internet connection and try again.';
    }

    final message = failure.e?.toString();

    if (message == null || message.trim().isEmpty) {
      return 'Unable to load this lesson.';
    }

    return message;
  }

  Future<void> _onToggleVocabularySaved(
    OnToggleVocabularySaved event,
    Emitter<LessonDetailState> emit,
  ) async {
    if (state.isVocabularySaving(
      event.vocabularyId,
    )) {
      return;
    }

    VideoVocabularyModel? selectedVocabulary;

    for (final vocabulary in state.vocabularies) {
      if (vocabulary.id == event.vocabularyId) {
        selectedVocabulary = vocabulary;
        break;
      }
    }

    if (selectedVocabulary == null) {
      return;
    }

    final originalSavedStatus = selectedVocabulary.isSaved;

    final optimisticSavedStatus = !originalSavedStatus;

    final optimisticVocabularies = _updateVocabularySavedStatus(
      vocabularies: state.vocabularies,
      vocabularyId: event.vocabularyId,
      isSaved: optimisticSavedStatus,
    );

    final savingIds = Set<String>.from(state.savingVocabularyIds)..add(event.vocabularyId);

    emit(
      state.copyWith(
        vocabularies: optimisticVocabularies,
        savingVocabularyIds: savingIds,
        vocabularySaveStatus: VocabularySaveStatus.loading,
        clearVocabularyActionMessage: true,
      ),
    );

    final result = await learnUseCase.saveVocabulary(
      vocabularyId: event.vocabularyId,
    );

    await result.fold<Future<void>>(
      (failure) async {
        // Roll back only this vocabulary. This avoids
        // changing other concurrent favorite requests.
        final rolledBackVocabularies = _updateVocabularySavedStatus(
          vocabularies: state.vocabularies,
          vocabularyId: event.vocabularyId,
          isSaved: originalSavedStatus,
        );

        final updatedSavingIds = Set<String>.from(
          state.savingVocabularyIds,
        )..remove(event.vocabularyId);

        emit(
          state.copyWith(
            vocabularies: rolledBackVocabularies,
            savingVocabularyIds: updatedSavingIds,
            vocabularySaveStatus: VocabularySaveStatus.failure,
            vocabularyActionMessage: _vocabularySaveFailureMessage(
              failure,
            ),
          ),
        );
      },
      (response) async {
        // Always use the backend response as the
        // final source of truth.
        final updatedVocabularies = _updateVocabularySavedStatus(
          vocabularies: state.vocabularies,
          vocabularyId: event.vocabularyId,
          isSaved: response.saved,
        );

        await learnUseCase.saveVideoVocabulariesCache(
          videoId: event.videoId,
          vocabularies: updatedVocabularies,
        );

        final updatedSavingIds = Set<String>.from(
          state.savingVocabularyIds,
        )..remove(event.vocabularyId);

        emit(
          state.copyWith(
            vocabularies: updatedVocabularies,
            savingVocabularyIds: updatedSavingIds,
            vocabularySaveStatus: VocabularySaveStatus.success,
            vocabularyActionMessage: response.saved
                ? 'Vocabulary saved.'
                : 'Vocabulary removed from saved items.',
          ),
        );
      },
    );
  }

  List<VideoVocabularyModel> _updateVocabularySavedStatus({
    required List<VideoVocabularyModel> vocabularies,
    required String vocabularyId,
    required bool isSaved,
  }) {
    return vocabularies
        .map((vocabulary) {
          if (vocabulary.id != vocabularyId) {
            return vocabulary;
          }

          return vocabulary.copyWith(
            isSaved: isSaved,
          );
        })
        .toList(growable: false);
  }

  String _vocabularySaveFailureMessage(
    Failure failure,
  ) {
    if (failure is ConnectionFailure) {
      return 'Unable to update the vocabulary. Please check your internet connection.';
    }

    final message = failure.e?.toString().trim();

    if (message == null || message.isEmpty) {
      return 'Unable to update the saved vocabulary.';
    }

    return message;
  }
}
