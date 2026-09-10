import 'package:flutter/material.dart';
import 'package:thuta_learn/core/core.dart';

class QuizAudioPrompt extends StatelessWidget {
  final bool isPlaying;
  final VoidCallback onTap;

  const QuizAudioPrompt({
    super.key,
    required this.isPlaying,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TtZoomTap(
      onTap: onTap,
      child: Container(
        height: 58,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        decoration: BoxDecoration(
          color: ColorUtils.secondaryColor,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isPlaying
                  ? Icons.pause_rounded
                  : Icons.volume_up_outlined,
              color: Colors.white,
              size: 25,
            ),
            12.gw,
            if (!isPlaying)
              const TtText(
                'Tap to play the audio',
                fontSize: 14,
                fontStyle: FontStyle.italic,
                color: Colors.white,
              )
            else
              const Expanded(
                child: QuizAudioWaveView(),
              ),
          ],
        ),
      ),
    );
  }
}

class QuizAudioWaveView extends StatelessWidget {
  const QuizAudioWaveView({super.key});

  @override
  Widget build(BuildContext context) {
    const heights = <double>[
      10,
      18,
      25,
      14,
      30,
      20,
      12,
      26,
      18,
      32,
      16,
      24,
      12,
      28,
      20,
      14,
      30,
      18,
      24,
      12,
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: heights.map((height) {
        return Container(
          width: 2,
          height: height,
          margin: const EdgeInsets.symmetric(horizontal: 2),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }).toList(),
    );
  }
}