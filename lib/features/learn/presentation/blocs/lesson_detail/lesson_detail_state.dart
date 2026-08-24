part of 'lesson_detail_bloc.dart';

enum LessonDetailStatus {
  initial,
  loading,
  success,
  failure,
}

enum VocabularySaveStatus {
  initial,
  loading,
  success,
  failure,
}

enum LessonVocabularyStatus {
  initial,
  loading,
  success,
  failure,
}

class LessonDetailState {
  final LessonDetailStatus status;
  final ChapterVideoModel? video;
  final bool isRefreshing;
  final String? message;

  final Set<String> savingVocabularyIds;
  final VocabularySaveStatus vocabularySaveStatus;
  final String? vocabularyActionMessage;

  final LessonVocabularyStatus vocabularyStatus;

  final List<VideoVocabularyModel> vocabularies;

  final bool isVocabularyRefreshing;

  final String? vocabularyMessage;

  const LessonDetailState({
    this.status = LessonDetailStatus.initial,
    this.video,
    this.isRefreshing = false,
    this.message,
    this.vocabularyStatus = LessonVocabularyStatus.initial,
    this.vocabularies = const [],
    this.isVocabularyRefreshing = false,
    this.vocabularyMessage,
    this.savingVocabularyIds = const <String>{},
    this.vocabularySaveStatus = VocabularySaveStatus.initial,
    this.vocabularyActionMessage,
  });

  bool get isLoading {
    return (status == LessonDetailStatus.initial || status == LessonDetailStatus.loading) &&
        video == null;
  }

  bool get isShowingCachedData {
    return video != null && isRefreshing;
  }

  bool get isVocabularyLoading {
    return (vocabularyStatus == LessonVocabularyStatus.initial ||
            vocabularyStatus == LessonVocabularyStatus.loading) &&
        vocabularies.isEmpty;
  }

  bool isVocabularySaving(String vocabularyId) {
    return savingVocabularyIds.contains(
      vocabularyId,
    );
  }

  LessonDetailState copyWith({
    LessonDetailStatus? status,
    ChapterVideoModel? video,
    bool? isRefreshing,
    String? message,
    bool clearMessage = false,
    LessonVocabularyStatus? vocabularyStatus,
    List<VideoVocabularyModel>? vocabularies,
    bool? isVocabularyRefreshing,
    String? vocabularyMessage,
    bool clearVocabularyMessage = false,
    Set<String>? savingVocabularyIds,
    VocabularySaveStatus? vocabularySaveStatus,
    String? vocabularyActionMessage,
    bool clearVocabularyActionMessage = false,
  }) {
    return LessonDetailState(
      status: status ?? this.status,
      video: video ?? this.video,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      message: clearMessage ? null : message ?? this.message,
      vocabularyStatus: vocabularyStatus ?? this.vocabularyStatus,
      vocabularies: vocabularies ?? this.vocabularies,
      isVocabularyRefreshing: isVocabularyRefreshing ?? this.isVocabularyRefreshing,
      vocabularyMessage: clearVocabularyMessage
          ? null
          : vocabularyMessage ?? this.vocabularyMessage,
      savingVocabularyIds: savingVocabularyIds ?? this.savingVocabularyIds,
      vocabularySaveStatus: vocabularySaveStatus ?? this.vocabularySaveStatus,
      vocabularyActionMessage: clearVocabularyActionMessage
          ? null
          : vocabularyActionMessage ?? this.vocabularyActionMessage,
    );
  }
}
