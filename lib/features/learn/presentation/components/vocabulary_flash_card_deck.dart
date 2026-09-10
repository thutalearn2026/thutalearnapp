import 'package:flutter/material.dart';
import 'package:thuta_learn/features/learn/learn.dart';

class VocabularyFlashCardDeck extends StatelessWidget {
  final VocabularyFlashCardItem item;
  final bool isFavorite;
  final VoidCallback onFavorite;
  final VoidCallback onAudio;
  final VoidCallback onNext;
  final VoidCallback onPrevious;

  const VocabularyFlashCardDeck({
    super.key,
    required this.item,
    required this.isFavorite,
    required this.onFavorite,
    required this.onAudio,
    required this.onNext,
    required this.onPrevious,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: 18,
          right: 18,
          top: 30,
          bottom: 0,
          child: _BackgroundCard(
            color: Colors.white.withValues(alpha: 0.45),
          ),
        ),
        Positioned(
          left: 10,
          right: 10,
          top: 16,
          bottom: 10,
          child: _BackgroundCard(
            color: Colors.white.withValues(alpha: 0.72),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          top: 0,
          bottom: 20,
          child: VocabularyFlashCardView(
            key: ValueKey(item),
            item: item,
            isFavorite: isFavorite,
            onFavorite: onFavorite,
            onAudio: onAudio,
            onNext: onNext,
            onPrevious: onPrevious,
          ),
        ),
      ],
    );
  }
}

class _BackgroundCard extends StatelessWidget {
  final Color color;

  const _BackgroundCard({
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}