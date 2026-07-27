import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:thuta_learn/core/core.dart';
import 'package:thuta_learn/features/learn/learn.dart';

class QuizPage extends StatelessWidget {
  const QuizPage({super.key});

  List<QuizQuestion> _createMockQuestions() {
    return List.generate(10, (index) {
      if (index.isEven) {
        return const QuizQuestion(
          type: QuizQuestionType.listening,
          question: 'What did you hear?',
          audioUrl: '',
          options: [
            QuizOption(answer: 'บ้าน (House)'),
            QuizOption(answer: 'รถ (Car)'),
            QuizOption(answer: 'โรงพยาบาล (Hospital)'),
            QuizOption(answer: 'ร้านอาหาร (Restaurant)'),
          ],
          correctOptionIndex: 2,
          explanation:
          'โรงพยาบาล means “hospital” — used in healthcare conversations.',
        );
      }

      return const QuizQuestion(
        type: QuizQuestionType.reading,
        question:
        'Which of the following sentences correctly asks if a dish is spicy using the question particle “mai”?',
        options: [
          QuizOption(answer: 'อาหารเผ็ดไหม'),
          QuizOption(answer: 'คุณชื่ออะไร'),
          QuizOption(answer: 'ห้องน้ำอยู่ที่ไหน'),
          QuizOption(answer: 'ราคาเท่าไหร่'),
        ],
        correctOptionIndex: 0,
        explanation:
        'อาหารเผ็ดไหม means “Is the food spicy?” and uses ไหม as the question particle.',
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => QuizBloc(
        questions: _createMockQuestions(),
      ),
      child: const QuizBody(),
    );
  }
}

class QuizBody extends StatelessWidget {
  const QuizBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: BlocBuilder<QuizBloc, QuizState>(
        builder: (context, state) {
          if (state.status == QuizStatus.completed) {
            return QuizCompletedView(state: state);
          }

          return _QuizQuestionContent(state: state);
        },
      ),
    );
  }
}

class _QuizQuestionContent extends StatelessWidget {
  final QuizState state;

  const _QuizQuestionContent({
    required this.state,
  });

  QuizAnswerVisualState _visualStateForOption(int index) {
    if (!state.hasAnswered) {
      return QuizAnswerVisualState.idle;
    }

    if (index ==
        state.currentQuestion.correctOptionIndex) {
      return QuizAnswerVisualState.correct;
    }

    if (index == state.selectedOptionIndex) {
      return QuizAnswerVisualState.incorrect;
    }

    return QuizAnswerVisualState.idle;
  }

  @override
  Widget build(BuildContext context) {
    final question = state.currentQuestion;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 16, 0),
          child: QuizProgressHeader(
            currentQuestion: state.currentQuestionIndex + 1,
            totalQuestions: state.questions.length,
            progress: state.progress,
            onClose: context.pop,
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
              16,
              28,
              16,
              24,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _QuestionTypeBadge(type: question.type),
                16.gh,
                TtText(
                  question.question,
                  fontSize: 16,
                  height: 1.3,
                  fontWeight: FontWeight.bold,
                ),
                if (question.type ==
                    QuizQuestionType.listening) ...[
                  18.gh,
                  QuizAudioPrompt(
                    isPlaying: state.isAudioPlaying,
                    onTap: () {
                      context.read<QuizBloc>().add(
                        QuizAudioPressed(),
                      );
                    },
                  ),
                ],
                18.gh,
                ...List.generate(
                  question.options.length,
                      (index) {
                    return Padding(
                      padding: const EdgeInsets.only(
                        bottom: 14,
                      ),
                      child: QuizAnswerOptionView(
                        optionIndex: index,
                        answer:
                        question.options[index].answer,
                        visualState:
                        _visualStateForOption(index),
                        onTap: () {
                          context.read<QuizBloc>().add(
                            QuizAnswerSelected(index),
                          );
                        },
                      ),
                    );
                  },
                ),
                if (state.hasAnswered &&
                    !state.selectedAnswerIsCorrect) ...[
                  4.gh,
                  QuizFeedbackView(
                    correctOptionIndex:
                    question.correctOptionIndex,
                    explanation: question.explanation,
                  ),
                ],
              ],
            ),
          ),
        ),
        if (state.hasAnswered)
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                16,
                8,
                16,
                16,
              ),
              child: SizedBox(
                width: double.infinity,
                child: TtButton(
                  onTap: () {
                    context.read<QuizBloc>().add(
                      QuizContinuePressed(),
                    );
                  },
                  child: TtText(
                    state.currentQuestionIndex ==
                        state.questions.length - 1
                        ? 'See Results'
                        : 'Continue',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _QuestionTypeBadge extends StatelessWidget {
  final QuizQuestionType type;

  const _QuestionTypeBadge({
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    final label = type == QuizQuestionType.listening
        ? 'Listening'
        : 'Reading';

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: ColorUtils.secondaryBackgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: TtText(
        label,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: ColorUtils.secondaryColor,
      ),
    );
  }
}

class QuizCompletedView extends StatelessWidget {
  final QuizState state;

  const QuizCompletedView({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    final percentage =
    (state.score / state.questions.length * 100).round();

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
              Icons.emoji_events_outlined,
              size: 52,
              color: ColorUtils.secondaryColor,
            ),
          ),
          24.gh,
          const TtText(
            'Quiz Completed!',
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          12.gh,
          TtText(
            'You answered ${state.score} out of '
                '${state.questions.length} questions correctly.',
            fontSize: 14,
            height: 1.4,
            textAlign: TextAlign.center,
            color: ColorUtils.greyTextColor,
          ),
          12.gh,
          TtText(
            '$percentage%',
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: ColorUtils.secondaryColor,
          ),
          32.gh,
          SizedBox(
            width: double.infinity,
            child: TtButton(
              onTap: () {
                context.pop();
              },
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
              context.read<QuizBloc>().add(
                QuizRestartPressed(),
              );
            },
            child: const TtText(
              'Try Again',
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