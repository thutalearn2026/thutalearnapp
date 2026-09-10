import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:thuta_learn/core/core.dart';
import 'package:thuta_learn/features/learn/learn.dart';

class PronunciationDrillPage extends StatelessWidget {
  const PronunciationDrillPage({super.key});

  static const List<PronunciationDrillItem> _items = [
    PronunciationDrillItem(
      thaiWord: 'สวัสดีครับ',
      pronunciation: 'Sawatdee Khrap',
      meaning: 'Hello (polite, male)',
    ),
    PronunciationDrillItem(
      thaiWord: 'สวัสดีค่ะ',
      pronunciation: 'Sawatdee Kha',
      meaning: 'Hello (polite, female)',
    ),
    PronunciationDrillItem(
      thaiWord: 'ขอบคุณครับ',
      pronunciation: 'Khop Khun Khrap',
      meaning: 'Thank you (polite, male)',
    ),
    PronunciationDrillItem(
      thaiWord: 'ขอบคุณค่ะ',
      pronunciation: 'Khop Khun Kha',
      meaning: 'Thank you (polite, female)',
    ),
    PronunciationDrillItem(
      thaiWord: 'ยินดีที่ได้รู้จัก',
      pronunciation: 'Yin Dee Tee Dai Roo Jak',
      meaning: 'Nice to meet you',
    ),
    PronunciationDrillItem(
      thaiWord: 'คุณชื่ออะไร',
      pronunciation: 'Khun Chue Arai',
      meaning: 'What is your name?',
    ),
    PronunciationDrillItem(
      thaiWord: 'ผมชื่อ...',
      pronunciation: 'Phom Chue...',
      meaning: 'My name is... (male)',
    ),
    PronunciationDrillItem(
      thaiWord: 'ฉันชื่อ...',
      pronunciation: 'Chan Chue...',
      meaning: 'My name is... (female)',
    ),
    PronunciationDrillItem(
      thaiWord: 'ลาก่อน',
      pronunciation: 'La Gon',
      meaning: 'Goodbye',
    ),
    PronunciationDrillItem(
      thaiWord: 'แล้วพบกันใหม่',
      pronunciation: 'Laeo Phop Kan Mai',
      meaning: 'See you again',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PronunciationDrillBloc(
        items: _items,
      ),
      child: const PronunciationDrillBody(),
    );
  }
}

class PronunciationDrillBody extends StatelessWidget {
  const PronunciationDrillBody({super.key});

  Future<void> _handleRecord(
      BuildContext context,
      PronunciationDrillState state,
      ) async {
    final bloc = context.read<PronunciationDrillBloc>();

    if (state.isRecording) {
      bloc.add(PronunciationRecordingCompleted());
      return;
    }

    final permission = await Permission.microphone.request();

    if (!context.mounted) {
      return;
    }

    if (permission.isGranted) {
      bloc.add(PronunciationRecordPressed());
      return;
    }

    context.showSnackBar(
      'Microphone permission is required for this exercise.',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: SafeArea(
        child: BlocBuilder<
            PronunciationDrillBloc,
            PronunciationDrillState>(
          builder: (context, state) {
            if (state.status ==
                PronunciationDrillStatus.completed) {
              return PronunciationCompletedView(state: state);
            }

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    8,
                    8,
                    16,
                    0,
                  ),
                  child: QuizProgressHeader(
                    currentQuestion: state.currentIndex + 1,
                    totalQuestions: state.items.length,
                    progress: state.progress,
                    onClose: context.pop,
                  ),
                ),
                24.gh,
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                    ),
                    child: PronunciationDrillCard(
                      item: state.currentItem,
                      status: state.status,
                      onListen: () {
                        context
                            .read<PronunciationDrillBloc>()
                            .add(
                          PronunciationListenPressed(),
                        );
                      },
                      onRecord: () {
                        _handleRecord(context, state);
                      },
                    ),
                  ),
                ),
                if (state.hasFeedback) ...[
                  16.gh,
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                    ),
                    child: PronunciationFeedbackView(
                      feedback: state.feedback ?? '',
                    ),
                  ),
                  16.gh,
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      16,
                      0,
                      16,
                      16,
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      child: TtButton(
                        onTap: () {
                          context
                              .read<PronunciationDrillBloc>()
                              .add(
                            PronunciationNextPressed(),
                          );
                        },
                        child: TtText(
                          state.currentIndex ==
                              state.items.length - 1
                              ? 'See Results'
                              : 'Next',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ] else
                  16.gh,
              ],
            );
          },
        ),
      ),
    );
  }
}

class PronunciationCompletedView extends StatelessWidget {
  final PronunciationDrillState state;

  const PronunciationCompletedView({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 96,
            height: 96,
            decoration: const BoxDecoration(
              color: ColorUtils.secondaryBackgroundColor,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.record_voice_over_outlined,
              size: 50,
              color: ColorUtils.secondaryColor,
            ),
          ),
          24.gh,
          const TtText(
            'Pronunciation Drill Completed!',
            fontSize: 16,
            fontWeight: FontWeight.bold,
            textAlign: TextAlign.center,
          ),
          12.gh,
          TtText(
            'You practiced ${state.items.length} useful Thai phrases.',
            fontSize: 14,
            height: 1.4,
            textAlign: TextAlign.center,
            color: ColorUtils.greyTextColor,
          ),
          32.gh,
          SizedBox(
            width: double.infinity,
            child: TtButton(
              onTap: context.pop,
              child: const TtText(
                'Finish',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
          12.gh,
          TextButton(
            onPressed: () {
              context.read<PronunciationDrillBloc>().add(
                PronunciationRestartPressed(),
              );
            },
            child: const TtText(
              'Practice Again',
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: ColorUtils.primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}