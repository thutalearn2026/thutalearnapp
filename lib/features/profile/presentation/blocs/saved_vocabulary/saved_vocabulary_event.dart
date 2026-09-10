part of 'saved_vocabulary_bloc.dart';

@immutable
sealed class SavedVocabularyEvent {}

class OnGetSavedVocabularies extends SavedVocabularyEvent {}

class OnSortSavedVocabularies extends SavedVocabularyEvent {}

class OnRemoveSavedVocabulary extends SavedVocabularyEvent {
  final VideoVocabularyModel vocabulary;

  OnRemoveSavedVocabulary({
    required this.vocabulary,
  });
}
