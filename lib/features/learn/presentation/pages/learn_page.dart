import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:thuta_learn/core/core.dart';
import 'package:thuta_learn/features/learn/learn.dart';

class LearnPage extends StatelessWidget {
  const LearnPage({super.key});

  static const List<LearnModuleItem> _modules = [
    LearnModuleItem(
      moduleNumber: 1,
      title: 'Thai Pronunciation Essentials',
      description:
          'Build a strong foundation in Thai pronunciation by learning basic sounds, vowels, tones, and polite sentence endings.',
      status: LearnModuleStatus.completed,
      progress: 1,
      quizPassed: true,
    ),
    LearnModuleItem(
      moduleNumber: 2,
      title: 'Greetings and Self-Introduction',
      description:
          'Learn how to greet people, introduce yourself, and participate in basic social conversations.',
      status: LearnModuleStatus.inProgress,
      progress: 0.60,
    ),
    LearnModuleItem(
      moduleNumber: 3,
      title: 'Numbers, Prices and Shopping',
      description:
          'Learn to understand numbers, ask about prices, purchase items, and communicate during everyday shopping situations.',
      status: LearnModuleStatus.locked,
    ),
    LearnModuleItem(
      moduleNumber: 4,
      title: 'Food and Drinks',
      description:
          'Learn useful Thai expressions for ordering food, drinks, and communicating in restaurants and cafés.',
      status: LearnModuleStatus.locked,
    ),
    LearnModuleItem(
      moduleNumber: 5,
      title: 'Time, Dates and Daily Schedule',
      description:
          'Learn how to tell the time, discuss dates, arrange appointments, and describe your daily routine.',
      status: LearnModuleStatus.locked,
    ),
    LearnModuleItem(
      moduleNumber: 6,
      title: 'Places, Transport and Directions',
      description:
          'Learn to ask for locations, understand basic directions, and communicate while using transport in Thailand.',
      status: LearnModuleStatus.locked,
    ),
    LearnModuleItem(
      moduleNumber: 7,
      title: 'Everyday Conversation and Grammar',
      description:
          'Develop more natural everyday conversations using common verbs, question words, connectors, and essential grammar patterns.',
      status: LearnModuleStatus.locked,
    ),
    LearnModuleItem(
      moduleNumber: 8,
      title: 'Weather, Health and Practical Situations',
      description:
          'Learn practical Thai expressions for discussing weather, body parts, simple health concerns, and emergency-related situations.',
      status: LearnModuleStatus.locked,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorUtils.scaffoldBackgroundColor,
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: ColorUtils.scaffoldBackgroundColor,
        surfaceTintColor: Colors.transparent,
      ),
      body: TtFadeIn(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            16,
            12,
            16,
            120,
          ),
          children: [
            const LearnOverviewSectionView(),
            18.gh,
            const _CourseTitleSectionView(),
            12.gh,
            ...List.generate(
              _modules.length,
              (index) {
                final module = _modules[index];

                return LearnModuleView(
                  item: module,
                  isFirst: index == 0,
                  isLast: index == _modules.length - 1,
                  onTap: () {
                    context.push(
                      Routes.moduleDetail,
                      extra: module,
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _CourseTitleSectionView extends StatelessWidget {
  const _CourseTitleSectionView();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(
          child: TtText(
            'Thai for Everyday Communication',
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(width: 12),
        TtText(
          '8 modules',
          fontSize: 14,
          color: ColorUtils.greyTextColor,
        ),
      ],
    );
  }
}
