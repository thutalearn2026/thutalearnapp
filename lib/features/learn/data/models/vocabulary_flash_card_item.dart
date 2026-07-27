class VocabularyFlashCardItem {
  final String thaiWord;
  final String pronunciation;
  final String partOfSpeech;
  final String definition;
  final String thaiExample;
  final String pronunciationExample;
  final String englishExample;
  final String? imagePath;

  const VocabularyFlashCardItem({
    required this.thaiWord,
    required this.pronunciation,
    required this.partOfSpeech,
    required this.definition,
    required this.thaiExample,
    required this.pronunciationExample,
    required this.englishExample,
    this.imagePath,
  });
}