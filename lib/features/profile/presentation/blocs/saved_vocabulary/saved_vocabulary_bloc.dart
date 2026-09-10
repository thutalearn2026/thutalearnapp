import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:thuta_learn/core/core.dart';
import 'package:thuta_learn/features/learn/learn.dart';

part 'saved_vocabulary_event.dart';
part 'saved_vocabulary_state.dart';

@Injectable()
class SavedVocabularyBloc
    extends Bloc<
        SavedVocabularyEvent,
        SavedVocabularyState> {
  final LearnUseCase learnUseCase;

  SavedVocabularyBloc({
    required this.learnUseCase,
  }) : super(const SavedVocabularyState()) {
    on<OnGetSavedVocabularies>(
      _onGetSavedVocabularies,
    );

    on<OnSortSavedVocabularies>(
      _onSortSavedVocabularies,
    );

    on<OnRemoveSavedVocabulary>(
      _onRemoveSavedVocabulary,
    );
  }

  Future<void> _onGetSavedVocabularies(
      OnGetSavedVocabularies event,
      Emitter<SavedVocabularyState> emit,
      ) async {
    if (state.status ==
        SavedVocabularyStatus.loading) {
      return;
    }

    emit(
      state.copyWith(
        status: SavedVocabularyStatus.loading,
        clearMessage: true,
      ),
    );

    final result =
    await learnUseCase.getSavedVocabularies();

    result.fold(
          (failure) {
        emit(
          state.copyWith(
            status: SavedVocabularyStatus.failure,
            message: _failureMessage(failure),
          ),
        );
      },
          (response) {
        final vocabularies = response.data
            .map(
              (vocabulary) {
            // Because these records came from the
            // saved-vocabularies endpoint, they must
            // initially be shown as saved.
            return vocabulary.copyWith(
              isSaved: true,
            );
          },
        )
            .toList(growable: false)
          ..sort(
                (first, second) {
              return first.rank.compareTo(
                second.rank,
              );
            },
          );

        emit(
          state.copyWith(
            status: SavedVocabularyStatus.success,
            vocabularies: vocabularies,
            clearMessage: true,
          ),
        );
      },
    );
  }

  void _onSortSavedVocabularies(
      OnSortSavedVocabularies event,
      Emitter<SavedVocabularyState> emit,
      ) {
    final alphabeticallySorted =
    !state.isAlphabeticallySorted;

    final vocabularies = [
      ...state.vocabularies,
    ];

    _sortVocabularies(
      vocabularies,
      alphabetically:
      alphabeticallySorted,
    );

    emit(
      state.copyWith(
        vocabularies: vocabularies,
        isAlphabeticallySorted:
        alphabeticallySorted,
      ),
    );
  }

  Future<void> _onRemoveSavedVocabulary(
      OnRemoveSavedVocabulary event,
      Emitter<SavedVocabularyState> emit,
      ) async {
    if (state.removingVocabularyIds.contains(
      event.vocabulary.id,
    )) {
      return;
    }

    final originalVocabulary = event.vocabulary;

    final optimisticVocabularies =
    state.vocabularies
        .where(
          (vocabulary) =>
      vocabulary.id !=
          originalVocabulary.id,
    )
        .toList(growable: true);

    final removingIds = Set<String>.from(
      state.removingVocabularyIds,
    )..add(originalVocabulary.id);

    emit(
      state.copyWith(
        vocabularies: optimisticVocabularies,
        removingVocabularyIds: removingIds,
        actionStatus:
        SavedVocabularyActionStatus.loading,
        clearMessage: true,
      ),
    );

    final result =
    await learnUseCase.saveVocabulary(
      vocabularyId: originalVocabulary.id,
    );

    await result.fold<Future<void>>(
          (failure) async {
        final restoredVocabularies =
        _restoreVocabulary(
          originalVocabulary,
        );

        final updatedRemovingIds =
        Set<String>.from(
          state.removingVocabularyIds,
        )..remove(originalVocabulary.id);

        emit(
          state.copyWith(
            vocabularies: restoredVocabularies,
            removingVocabularyIds:
            updatedRemovingIds,
            actionStatus:
            SavedVocabularyActionStatus.failure,
            message: _removeFailureMessage(
              failure,
            ),
          ),
        );
      },
          (response) async {
        final updatedRemovingIds =
        Set<String>.from(
          state.removingVocabularyIds,
        )..remove(originalVocabulary.id);

        if (response.saved) {
          // If the backend still says saved=true,
          // restore it because the server remains the
          // source of truth.
          final restoredVocabularies =
          _restoreVocabulary(
            originalVocabulary,
          );

          emit(
            state.copyWith(
              vocabularies:
              restoredVocabularies,
              removingVocabularyIds:
              updatedRemovingIds,
              actionStatus:
              SavedVocabularyActionStatus.failure,
              message:
              'This vocabulary is still saved. The server did not remove it.',
            ),
          );

          return;
        }

        emit(
          state.copyWith(
            removingVocabularyIds:
            updatedRemovingIds,
            actionStatus:
            SavedVocabularyActionStatus.success,
            message:
            '${originalVocabulary.word} removed from saved vocabulary.',
          ),
        );
      },
    );
  }

  List<VideoVocabularyModel> _restoreVocabulary(
      VideoVocabularyModel vocabulary,
      ) {
    final restored = [
      ...state.vocabularies,
      vocabulary.copyWith(
        isSaved: true,
      ),
    ];

    _sortVocabularies(
      restored,
      alphabetically:
      state.isAlphabeticallySorted,
    );

    return restored;
  }

  void _sortVocabularies(
      List<VideoVocabularyModel> vocabularies, {
        required bool alphabetically,
      }) {
    if (alphabetically) {
      vocabularies.sort(
            (first, second) {
          return first.word
              .toLowerCase()
              .compareTo(
            second.word.toLowerCase(),
          );
        },
      );

      return;
    }

    vocabularies.sort(
          (first, second) {
        return first.rank.compareTo(
          second.rank,
        );
      },
    );
  }

  String _failureMessage(Failure failure) {
    if (failure is ConnectionFailure) {
      return 'Please check your internet connection and try again.';
    }

    final message = failure.e?.toString().trim();

    if (message == null || message.isEmpty) {
      return 'Unable to load saved vocabularies.';
    }

    return message;
  }

  String _removeFailureMessage(
      Failure failure,
      ) {
    if (failure is ConnectionFailure) {
      return 'Unable to remove the vocabulary. Please check your internet connection.';
    }

    final message = failure.e?.toString().trim();

    if (message == null || message.isEmpty) {
      return 'Unable to remove the saved vocabulary.';
    }

    return message;
  }
}