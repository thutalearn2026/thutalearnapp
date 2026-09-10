import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:injectable/injectable.dart';
import 'package:thuta_learn/features/learn/learn.dart';

part 'vocabulary_speech_state.dart';

@Injectable()
class VocabularySpeechCubit
    extends Cubit<VocabularySpeechState> {
  static const String _thaiLocale = 'th-TH';

  final FlutterTts _flutterTts = FlutterTts();

  bool _isReady = false;
  bool _isInitializing = false;

  VocabularySpeechCubit()
      : super(const VocabularySpeechState()) {
    _registerHandlers();
  }

  void _registerHandlers() {
    _flutterTts.setCompletionHandler(() {
      _emitIdle();
    });

    _flutterTts.setCancelHandler(() {
      _emitIdle();
    });

    _flutterTts.setErrorHandler((message) {
      if (isClosed) {
        return;
      }

      emit(
        state.copyWith(
          status: VocabularySpeechStatus.failure,
          message: message.toString().trim().isEmpty
              ? 'Unable to play the pronunciation.'
              : message.toString(),
          clearVocabularyId: true,
        ),
      );
    });
  }

  Future<void> initialize() async {
    if (_isReady || _isInitializing) {
      return;
    }

    _isInitializing = true;

    try {
      final availability =
      await _flutterTts.isLanguageAvailable(
        _thaiLocale,
      );

      final isAvailable =
          availability == true || availability == 1;

      if (!isAvailable) {
        throw StateError(
          'Thai text-to-speech is not available on this device.',
        );
      }

      await _flutterTts.setLanguage(_thaiLocale);

      // A slower rate is usually clearer for language learning.
      await _flutterTts.setSpeechRate(0.42);
      await _flutterTts.setPitch(1.0);
      await _flutterTts.setVolume(1.0);

      // Keeps the state active until speaking finishes.
      await _flutterTts.awaitSpeakCompletion(true);

      _isReady = true;

      if (!isClosed) {
        emit(
          state.copyWith(
            status: VocabularySpeechStatus.initial,
            clearVocabularyId: true,
            clearMessage: true,
          ),
        );
      }
    } catch (error) {
      if (!isClosed) {
        emit(
          state.copyWith(
            status: VocabularySpeechStatus.failure,
            message: _cleanError(error),
            clearVocabularyId: true,
          ),
        );
      }
    } finally {
      _isInitializing = false;
    }
  }

  Future<void> speak(
      VideoVocabularyModel vocabulary,
      ) async {
    if (state.isSpeaking(vocabulary.id)) {
      await stop();
      return;
    }

    if (!_isReady) {
      await initialize();

      if (!_isReady) {
        return;
      }
    }

    final text = _resolveSpeechText(vocabulary);

    if (text == null) {
      emit(
        state.copyWith(
          status: VocabularySpeechStatus.failure,
          message:
          'No pronunciation text is available for this vocabulary.',
          clearVocabularyId: true,
        ),
      );

      return;
    }

    try {
      await _flutterTts.stop();

      if (isClosed) {
        return;
      }

      emit(
        state.copyWith(
          status: VocabularySpeechStatus.speaking,
          speakingVocabularyId: vocabulary.id,
          clearMessage: true,
        ),
      );

      await _flutterTts.speak(text);
    } catch (error) {
      if (!isClosed) {
        emit(
          state.copyWith(
            status: VocabularySpeechStatus.failure,
            message: _cleanError(error),
            clearVocabularyId: true,
          ),
        );
      }
    }
  }

  Future<void> stop() async {
    await _flutterTts.stop();
    _emitIdle();
  }

  String? _resolveSpeechText(
      VideoVocabularyModel vocabulary,
      ) {
    final candidates = [
      vocabulary.word,
      vocabulary.pronunciation,
      vocabulary.definition,
      vocabulary.example,
    ];

    final thaiPattern = RegExp(r'[\u0E00-\u0E7F]');

    // Prefer real Thai-script text.
    for (final candidate in candidates) {
      final text = candidate?.trim();

      if (text != null &&
          text.isNotEmpty &&
          thaiPattern.hasMatch(text)) {
        return text;
      }
    }

    // Temporary fallback until the backend provides
    // Thai-script pronunciation text.
    final pronunciation =
    vocabulary.pronunciation?.trim();

    if (pronunciation != null &&
        pronunciation.isNotEmpty) {
      return pronunciation;
    }

    final word = vocabulary.word.trim();

    return word.isEmpty ? null : word;
  }

  void _emitIdle() {
    if (isClosed) {
      return;
    }

    emit(
      state.copyWith(
        status: VocabularySpeechStatus.initial,
        clearVocabularyId: true,
        clearMessage: true,
      ),
    );
  }

  String _cleanError(Object error) {
    return error
        .toString()
        .replaceFirst('Bad state: ', '')
        .replaceFirst('Exception: ', '');
  }

  @override
  Future<void> close() async {
    await _flutterTts.stop();

    return super.close();
  }
}