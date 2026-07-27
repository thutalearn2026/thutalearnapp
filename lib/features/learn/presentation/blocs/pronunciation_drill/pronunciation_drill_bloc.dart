import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:thuta_learn/features/learn/learn.dart';

part 'pronunciation_drill_event.dart';
part 'pronunciation_drill_state.dart';

class PronunciationDrillBloc extends Bloc<
    PronunciationDrillEvent,
    PronunciationDrillState> {
  PronunciationDrillBloc({
    required List<PronunciationDrillItem> items,
  }) : super(
    PronunciationDrillState(
      items: items,
      currentIndex: 0,
      status: PronunciationDrillStatus.idle,
    ),
  ) {
    on<PronunciationListenPressed>(_onListenPressed);
    on<PronunciationRecordPressed>(_onRecordPressed);
    on<PronunciationRecordingCompleted>(
      _onRecordingCompleted,
    );
    on<PronunciationNextPressed>(_onNextPressed);
    on<PronunciationRestartPressed>(_onRestartPressed);
  }

  Future<void> _onListenPressed(
      PronunciationListenPressed event,
      Emitter<PronunciationDrillState> emit,
      ) async {
    final isListening =
        state.status == PronunciationDrillStatus.listening;

    emit(
      state.copyWith(
        status: isListening
            ? PronunciationDrillStatus.idle
            : PronunciationDrillStatus.listening,
        clearFeedback: true,
      ),
    );

    // Connect audio playback here later.
  }

  Future<void> _onRecordPressed(
      PronunciationRecordPressed event,
      Emitter<PronunciationDrillState> emit,
      ) async {
    emit(
      state.copyWith(
        status: PronunciationDrillStatus.recording,
        clearFeedback: true,
      ),
    );

    // Start the microphone recorder here later.
  }

  Future<void> _onRecordingCompleted(
      PronunciationRecordingCompleted event,
      Emitter<PronunciationDrillState> emit,
      ) async {
    emit(
      state.copyWith(
        status: PronunciationDrillStatus.feedback,
        feedback:
        'Good attempt! Your pronunciation is clear. '
            'Try making the final sound slightly softer.',
      ),
    );

    // Replace this feedback with the API result later.
  }

  Future<void> _onNextPressed(
      PronunciationNextPressed event,
      Emitter<PronunciationDrillState> emit,
      ) async {
    if (state.status != PronunciationDrillStatus.feedback) {
      return;
    }

    final isLastItem =
        state.currentIndex == state.items.length - 1;

    if (isLastItem) {
      emit(
        state.copyWith(
          status: PronunciationDrillStatus.completed,
        ),
      );

      return;
    }

    emit(
      state.copyWith(
        currentIndex: state.currentIndex + 1,
        status: PronunciationDrillStatus.idle,
        clearFeedback: true,
      ),
    );
  }

  Future<void> _onRestartPressed(
      PronunciationRestartPressed event,
      Emitter<PronunciationDrillState> emit,
      ) async {
    emit(
      PronunciationDrillState(
        items: state.items,
        currentIndex: 0,
        status: PronunciationDrillStatus.idle,
      ),
    );
  }
}