part of 'vocabulary_flash_card_bloc.dart';

enum VocabularyFlashCardStatus {
  inProgress,
  completed,
}

class VocabularyFlashCardState {
  final List<VocabularyFlashCardItem> cards;
  final int currentIndex;
  final Set<int> favoriteIndexes;
  final VocabularyFlashCardStatus status;

  const VocabularyFlashCardState({
    required this.cards,
    required this.currentIndex,
    required this.favoriteIndexes,
    required this.status,
  });

  VocabularyFlashCardItem get currentCard {
    return cards[currentIndex];
  }

  bool get currentCardIsFavorite {
    return favoriteIndexes.contains(currentIndex);
  }

  double get progress {
    if (cards.isEmpty) {
      return 0;
    }

    return (currentIndex + 1) / cards.length;
  }

  VocabularyFlashCardState copyWith({
    int? currentIndex,
    Set<int>? favoriteIndexes,
    VocabularyFlashCardStatus? status,
  }) {
    return VocabularyFlashCardState(
      cards: cards,
      currentIndex: currentIndex ?? this.currentIndex,
      favoriteIndexes:
      favoriteIndexes ?? this.favoriteIndexes,
      status: status ?? this.status,
    );
  }
}