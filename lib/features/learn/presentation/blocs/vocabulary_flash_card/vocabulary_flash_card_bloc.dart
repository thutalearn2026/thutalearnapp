import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:thuta_learn/features/learn/learn.dart';

part 'vocabulary_flash_card_event.dart';
part 'vocabulary_flash_card_state.dart';

class VocabularyFlashCardBloc extends Bloc<
    VocabularyFlashCardEvent,
    VocabularyFlashCardState> {
  VocabularyFlashCardBloc({
    required List<VocabularyFlashCardItem> cards,
  }) : super(
    VocabularyFlashCardState(
      cards: cards,
      currentIndex: 0,
      favoriteIndexes: const {},
      status: VocabularyFlashCardStatus.inProgress,
    ),
  ) {
    on<VocabularyFlashCardNextPressed>(_onNextPressed);
    on<VocabularyFlashCardPreviousPressed>(
      _onPreviousPressed,
    );
    on<VocabularyFlashCardFavoritePressed>(
      _onFavoritePressed,
    );
    on<VocabularyFlashCardRestartPressed>(
      _onRestartPressed,
    );
  }

  Future<void> _onNextPressed(
      VocabularyFlashCardNextPressed event,
      Emitter<VocabularyFlashCardState> emit,
      ) async {
    final isLastCard =
        state.currentIndex == state.cards.length - 1;

    if (isLastCard) {
      emit(
        state.copyWith(
          status: VocabularyFlashCardStatus.completed,
        ),
      );

      return;
    }

    emit(
      state.copyWith(
        currentIndex: state.currentIndex + 1,
      ),
    );
  }

  Future<void> _onPreviousPressed(
      VocabularyFlashCardPreviousPressed event,
      Emitter<VocabularyFlashCardState> emit,
      ) async {
    if (state.currentIndex == 0) {
      return;
    }

    emit(
      state.copyWith(
        currentIndex: state.currentIndex - 1,
      ),
    );
  }

  Future<void> _onFavoritePressed(
      VocabularyFlashCardFavoritePressed event,
      Emitter<VocabularyFlashCardState> emit,
      ) async {
    final favoriteIndexes = Set<int>.from(
      state.favoriteIndexes,
    );

    if (favoriteIndexes.contains(state.currentIndex)) {
      favoriteIndexes.remove(state.currentIndex);
    } else {
      favoriteIndexes.add(state.currentIndex);
    }

    emit(
      state.copyWith(
        favoriteIndexes: favoriteIndexes,
      ),
    );
  }

  Future<void> _onRestartPressed(
      VocabularyFlashCardRestartPressed event,
      Emitter<VocabularyFlashCardState> emit,
      ) async {
    emit(
      VocabularyFlashCardState(
        cards: state.cards,
        currentIndex: 0,
        favoriteIndexes: const {},
        status: VocabularyFlashCardStatus.inProgress,
      ),
    );
  }
}