part of 'saved_vocabulary_bloc.dart';

enum SavedVocabularyStatus {
  initial,
  loading,
  success,
  failure,
}

enum SavedVocabularyActionStatus {
  initial,
  loading,
  success,
  failure,
}

class SavedVocabularyState {
  final SavedVocabularyStatus status;
  final List<VideoVocabularyModel> vocabularies;

  final bool isAlphabeticallySorted;

  final Set<String> removingVocabularyIds;

  final SavedVocabularyActionStatus actionStatus;

  final String? message;

  const SavedVocabularyState({
    this.status = SavedVocabularyStatus.initial,
    this.vocabularies = const [],
    this.isAlphabeticallySorted = false,
    this.removingVocabularyIds = const <String>{},
    this.actionStatus = SavedVocabularyActionStatus.initial,
    this.message,
  });

  bool get isInitialLoading {
    return (status == SavedVocabularyStatus.initial ||
            status == SavedVocabularyStatus.loading) &&
        vocabularies.isEmpty;
  }

  bool isRemoving(String vocabularyId) {
    return removingVocabularyIds.contains(
      vocabularyId,
    );
  }

  SavedVocabularyState copyWith({
    SavedVocabularyStatus? status,
    List<VideoVocabularyModel>? vocabularies,
    bool? isAlphabeticallySorted,
    Set<String>? removingVocabularyIds,
    SavedVocabularyActionStatus? actionStatus,
    String? message,
    bool clearMessage = false,
  }) {
    return SavedVocabularyState(
      status: status ?? this.status,
      vocabularies: vocabularies ?? this.vocabularies,
      isAlphabeticallySorted: isAlphabeticallySorted ?? this.isAlphabeticallySorted,
      removingVocabularyIds: removingVocabularyIds ?? this.removingVocabularyIds,
      actionStatus: actionStatus ?? this.actionStatus,
      message: clearMessage ? null : message ?? this.message,
    );
  }
}
