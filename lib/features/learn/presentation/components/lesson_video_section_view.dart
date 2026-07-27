import 'package:flutter/material.dart';
import 'package:thuta_learn/core/core.dart';

class LessonVideoSectionView extends StatelessWidget {
  final int lessonNumber;
  final String currentDuration;
  final String totalDuration;
  final VoidCallback onPlay;

  const LessonVideoSectionView({
    super.key,
    required this.lessonNumber,
    required this.currentDuration,
    required this.totalDuration,
    required this.onPlay,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFE8F3F5),
                Color(0xFF9DB4BE),
              ],
            ),
          ),
          child: Stack(
            children: [
              const Positioned.fill(
                child: Center(
                  child: Icon(
                    Icons.person_rounded,
                    size: 120,
                    color: Colors.white54,
                  ),
                ),
              ),
              Positioned(
                top: 16,
                right: 16,
                child: Container(
                  width: 48,
                  height: 48,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: TtText(
                    '$lessonNumber',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: ColorUtils.primaryColor,
                  ),
                ),
              ),
              Center(
                child: TtZoomTap(
                  onTap: onPlay,
                  child: Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: ColorUtils.primaryColor.withValues(
                        alpha: 0.65,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.play_arrow_rounded,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 14,
                right: 14,
                bottom: 12,
                child: Row(
                  children: [
                    TtText(
                      currentDuration,
                      fontSize: 14,
                      color: Colors.white,
                    ),
                    10.gw,
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: const LinearProgressIndicator(
                          value: 0.12,
                          minHeight: 5,
                          backgroundColor: Colors.white54,
                          valueColor:
                          AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      ),
                    ),
                    10.gw,
                    TtText(
                      totalDuration,
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}