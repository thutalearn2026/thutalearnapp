class SavedVocabularyItem {
  final int id;
  final int originalOrder;
  final String thaiWord;
  final String pronunciation;
  final String englishMeaning;
  final String myanmarMeaning;

  const SavedVocabularyItem({
    required this.id,
    required this.originalOrder,
    required this.thaiWord,
    required this.pronunciation,
    required this.englishMeaning,
    required this.myanmarMeaning,
  });
}