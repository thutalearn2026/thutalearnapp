part of 'vocabulary_speech_cubit.dart';

enum VocabularySpeechStatus {
  initial,
  speaking,
  failure,
}

class VocabularySpeechState {
  final VocabularySpeechStatus status;
  final String? speakingVocabularyId;
  final String? message;

  const VocabularySpeechState({
    this.status = VocabularySpeechStatus.initial,
    this.speakingVocabularyId,
    this.message,
  });

  bool isSpeaking(String vocabularyId) {
    return status ==
        VocabularySpeechStatus.speaking &&
        speakingVocabularyId == vocabularyId;
  }

  VocabularySpeechState copyWith({
    VocabularySpeechStatus? status,
    String? speakingVocabularyId,
    String? message,
    bool clearVocabularyId = false,
    bool clearMessage = false,
  }) {
    return VocabularySpeechState(
      status: status ?? this.status,
      speakingVocabularyId: clearVocabularyId
          ? null
          : speakingVocabularyId ??
          this.speakingVocabularyId,
      message:
      clearMessage ? null : message ?? this.message,
    );
  }
}