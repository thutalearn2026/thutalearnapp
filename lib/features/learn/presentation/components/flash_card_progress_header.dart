import 'package:flutter/material.dart';
import 'package:thuta_learn/core/core.dart';

class FlashCardProgressHeader extends StatelessWidget {
  final int currentCard;
  final int totalCards;
  final double progress;
  final VoidCallback onClose;

  const FlashCardProgressHeader({
    super.key,
    required this.currentCard,
    required this.totalCards,
    required this.progress,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: onClose,
          icon: const Icon(
            Icons.close_rounded,
            color: Colors.white,
            size: 28,
          ),
        ),
        8.gw,
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 7,
              backgroundColor: Colors.white,
              valueColor: const AlwaysStoppedAnimation<Color>(
                ColorUtils.secondaryColor,
              ),
            ),
          ),
        ),
        12.gw,
        TtText(
          '$currentCard/$totalCards',
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ],
    );
  }
}