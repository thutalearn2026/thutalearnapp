part of 'vocabulary_flash_card_bloc.dart';

sealed class VocabularyFlashCardEvent {}

class VocabularyFlashCardNextPressed
    extends VocabularyFlashCardEvent {}

class VocabularyFlashCardPreviousPressed
    extends VocabularyFlashCardEvent {}

class VocabularyFlashCardFavoritePressed
    extends VocabularyFlashCardEvent {}

class VocabularyFlashCardRestartPressed
    extends VocabularyFlashCardEvent {}