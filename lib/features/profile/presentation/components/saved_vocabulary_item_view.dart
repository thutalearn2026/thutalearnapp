import 'package:flutter/material.dart';
import 'package:thuta_learn/core/core.dart';
import 'package:thuta_learn/features/learn/learn.dart';

class SavedVocabularyItemView extends StatelessWidget {
  final VideoVocabularyModel vocabulary;
  final bool isSpeaking;
  final bool isRemoving;
  final VoidCallback onAudio;
  final VoidCallback onRemove;

  const SavedVocabularyItemView({
    super.key,
    required this.vocabulary,
    required this.isSpeaking,
    required this.isRemoving,
    required this.onAudio,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final word = vocabulary.word.trim().isEmpty
        ? 'Untitled vocabulary'
        : vocabulary.word.trim();

    final pronunciation = vocabulary.pronunciation?.trim() ?? '';

    final definition = vocabulary.definition?.trim() ?? '';

    final example = vocabulary.example?.trim() ?? '';

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TtZoomTap(
          onTap: onAudio,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: isSpeaking
                  ? ColorUtils.secondaryColor
                  : ColorUtils.secondaryBackgroundColor,
              shape: BoxShape.circle,
            ),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                isSpeaking ? Icons.stop_rounded : Icons.volume_up_outlined,
                key: ValueKey(isSpeaking),
                size: 28,
                color: isSpeaking ? Colors.white : ColorUtils.secondaryColor,
              ),
            ),
          ),
        ),
        14.gw,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 10,
                runSpacing: 4,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  TtText(
                    word,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: ColorUtils.primaryColor,
                  ),
                  if (pronunciation.isNotEmpty)
                    TtText(
                      pronunciation,
                      fontSize: 14,
                      color: ColorUtils.greyTextColor,
                    ),
                ],
              ),
              if (definition.isNotEmpty) ...[
                7.gh,
                TtText(
                  definition,
                  fontSize: 14,
                  height: 1.4,
                  color: ColorUtils.primaryColor,
                ),
              ],
              if (example.isNotEmpty) ...[
                6.gh,
                TtText(
                  example,
                  fontSize: 14,
                  height: 1.4,
                  color: ColorUtils.greyTextColor,
                ),
              ],
            ],
          ),
        ),
        12.gw,
        SizedBox(
          width: 42,
          height: 42,
          child: isRemoving
              ? const Padding(
                  padding: EdgeInsets.all(11),
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: ColorUtils.secondaryColor,
                  ),
                )
              : IconButton(
                  onPressed: onRemove,
                  tooltip: 'Remove from saved vocabulary',
                  icon: const Icon(
                    Icons.favorite_rounded,
                    size: 30,
                    color: ColorUtils.secondaryColor,
                  ),
                ),
        ),
      ],
    );
  }
}
