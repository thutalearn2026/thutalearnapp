import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:thuta_learn/core/core.dart';

class ModulePracticeTabView extends StatelessWidget {
  const ModulePracticeTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      key: const PageStorageKey('module-practice'),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      children: [
        PracticeOptionCard(
          title: 'Quizzes',
          description:
          'Start taking quizzes to check your knowledge for this module',
          icon: Icons.lightbulb_outline_rounded,
          iconColor: const Color(0xFFF4C430),
          onTap: () {
            context.push(Routes.quiz);
          },
        ),
        16.gh,
        PracticeOptionCard(
          title: 'Pronunciation Drill',
          description:
          'Record and compare your pronunciation with a native speaker',
          icon: Icons.mic_none_rounded,
          iconColor: Color(0xFFE28B38),
          // isLocked: true,
          onTap: () {
            context.push(Routes.pronunciationDrill);
          },
        ),
        16.gh,
        PracticeOptionCard(
          title: 'Vocabulary Flash Cards',
          description:
          'Use flashcards and start memorizing vocabularies',
          icon: Icons.style_outlined,
          iconColor: Color(0xFF48A9D6),
          // isLocked: true,
          onTap: () {
            context.push(Routes.vocabularyFlashCards);
          },
        ),
      ],
    );
  }
}

class PracticeOptionCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color iconColor;
  final bool isLocked;
  final VoidCallback? onTap;

  const PracticeOptionCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.iconColor,
    this.isLocked = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final card = Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE4E7EB),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      foregroundDecoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: ColorUtils.secondaryColor,
            width: 4,
          ),
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(16),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: const BoxDecoration(
              color: Color(0xFFF3F5F7),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 29,
              color: iconColor,
            ),
          ),
          14.gw,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TtText(
                  title,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: ColorUtils.primaryColor,
                ),
                6.gh,
                TtText(
                  description,
                  fontSize: 14,
                  height: 1.35,
                  color: ColorUtils.primaryColor,
                ),
              ],
            ),
          ),
          10.gw,
          Icon(
            isLocked
                ? Icons.lock_rounded
                : Icons.arrow_forward_ios_rounded,
            size: isLocked ? 20 : 18,
            color: isLocked
                ? const Color(0xFF8190A4)
                : ColorUtils.secondaryColor,
          ),
        ],
      ),
    );

    if (isLocked) {
      return card;
    }

    return TtZoomTap(
      onTap: () {
        onTap?.call();
      },
      child: card,
    );
  }
}