import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:thuta_learn/core/core.dart';
import 'package:thuta_learn/features/learn/learn.dart';

class QuizPage extends StatelessWidget {
  final QuizDetailArgs args;

  const QuizPage({
    super.key,
    required this.args,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        return getIt<QuizBloc>()
          ..add(
            OnGetQuizDetail(
              chapterId: args.chapterId,
              quizId: args.quizId,
            ),
          );
      },
      child: QuizBody(
        args: args,
      ),
    );
  }
}

class QuizBody extends StatelessWidget {
  final QuizDetailArgs args;

  const QuizBody({
    super.key,
    required this.args,
  });

  void _retry(BuildContext context) {
    context.read<QuizBloc>().add(
      OnGetQuizDetail(
        chapterId: args.chapterId,
        quizId: args.quizId,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
      ),
      body: BlocConsumer<QuizBloc, QuizState>(
        listenWhen: (previous, current) {
          return previous.message !=
              current.message &&
              current.message != null &&
              current.quiz != null;
        },
        listener: (context, state) {
          context.showSnackBar(
            state.message!,
            snackBarType: SnackBarType.error,
          );
        },
        builder: (context, state) {
          if (state.isLoading) {
            return const _QuizLoadingView();
          }

          if (state.status ==
              QuizStatus.failure &&
              state.quiz == null) {
            return _QuizLoadErrorView(
              message:
              state.message ??
                  'Unable to load this quiz.',
              onRetry: () {
                _retry(context);
              },
            );
          }

          if (state.status ==
              QuizStatus.completed) {
            return QuizCompletedView(
              state: state,
            );
          }

          if (state.currentQuestion == null) {
            return const SizedBox.shrink();
          }

          return _QuizQuestionContent(
            state: state,
          );
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

  QuizAnswerVisualState _visualStateForOption(
      QuizQuestionOptionModel option,
      ) {
    if (state.currentSelectedOptionId ==
        option.id) {
      return QuizAnswerVisualState.selected;
    }

    return QuizAnswerVisualState.idle;
  }

  String _formatQuizType(String type) {
    return type
        .trim()
        .replaceAll('_', ' ')
        .split(' ')
        .where((word) => word.isNotEmpty)
        .map(
          (word) {
        return '${word[0].toUpperCase()}'
            '${word.substring(1)}';
      },
    )
        .join(' ');
  }

  @override
  Widget build(BuildContext context) {
    final question = state.currentQuestion!;
    final options = question.options;

    final audioUrl = question.audioFile?.trim();

    final hasAudio =
        audioUrl != null && audioUrl.isNotEmpty;

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
            currentQuestion:
            state.currentQuestionIndex + 1,
            totalQuestions:
            state.questions.length,
            progress: state.progress,
            onClose: () {
              context.pop();
            },
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
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                _QuestionTypeBadge(
                  label: hasAudio
                      ? 'Listening'
                      : _formatQuizType(
                    state.quiz?.type ??
                        'Quiz',
                  ),
                ),
                16.gh,
                TtText(
                  question.question,
                  fontSize: 16,
                  height: 1.3,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                if (hasAudio) ...[
                  18.gh,
                  QuizAudioPrompt(
                    isPlaying:
                    state.isAudioPlaying,
                    onTap: () {
                      context.read<QuizBloc>().add(
                        QuizAudioPressed(),
                      );
                    },
                  ),
                ],
                18.gh,
                ...List.generate(
                  options.length,
                      (index) {
                    final option = options[index];

                    return Padding(
                      padding:
                      const EdgeInsets.only(
                        bottom: 14,
                      ),
                      child: QuizAnswerOptionView(
                        optionIndex: index,
                        answer: option.text,
                        visualState:
                        _visualStateForOption(
                          option,
                        ),
                        onTap: () {
                          context
                              .read<QuizBloc>()
                              .add(
                            QuizAnswerSelected(
                              questionId:
                              question.id,
                              optionId:
                              option.id,
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        if (state.hasSelectedCurrentAnswer)
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                16,
                8,
                16,
                16,
              ),
              child: IgnorePointer(
                ignoring: state.isSubmitting,
                child: SizedBox(
                  width: double.infinity,
                  child: TtButton(
                    onTap: () {
                      if (state.isLastQuestion) {
                        context
                            .read<QuizBloc>()
                            .add(
                          QuizSubmitPressed(),
                        );
                      } else {
                        context
                            .read<QuizBloc>()
                            .add(
                          QuizContinuePressed(),
                        );
                      }
                    },
                    child: state.isSubmitting
                        ? const SizedBox(
                      width: 22,
                      height: 22,
                      child:
                      CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                        : TtText(
                      state.isLastQuestion
                          ? 'Submit Answers'
                          : 'Continue',
                      fontSize: 14,
                      fontWeight:
                      FontWeight.w600,
                      color: Colors.white,
                    ),
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
  final String label;

  const _QuestionTypeBadge({
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color:
        ColorUtils.secondaryBackgroundColor,
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

  String _formatPercentage(num value) {
    if (value % 1 == 0) {
      return value.toInt().toString();
    }

    return value.toStringAsFixed(1);
  }

  @override
  Widget build(BuildContext context) {
    final result = state.attempt;

    if (result == null) {
      return const SizedBox.shrink();
    }

    final resultColor = result.passed
        ? ColorUtils.secondaryColor
        : Colors.red;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight:
            MediaQuery.sizeOf(context).height -
                48,
          ),
          child: Column(
            mainAxisAlignment:
            MainAxisAlignment.center,
            children: [
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  color: resultColor.withValues(
                    alpha: 0.10,
                  ),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  result.passed
                      ? Icons.emoji_events_outlined
                      : Icons.refresh_rounded,
                  size: 52,
                  color: resultColor,
                ),
              ),
              24.gh,
              TtText(
                result.passed
                    ? 'Quiz Passed!'
                    : 'Keep Practicing',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: ColorUtils.primaryColor,
              ),
              12.gh,
              TtText(
                'You answered '
                    '${result.correctAnswers} out of '
                    '${result.totalQuestions} questions '
                    'correctly.',
                fontSize: 14,
                height: 1.4,
                textAlign: TextAlign.center,
                color: ColorUtils.greyTextColor,
              ),
              14.gh,
              TtText(
                '${_formatPercentage(
                  result.scorePercentage,
                )}%',
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: resultColor,
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
                    fontWeight:
                    FontWeight.w600,
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
                  color:
                  ColorUtils.primaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuizLoadingView extends StatelessWidget {
  const _QuizLoadingView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(
            color: ColorUtils.secondaryColor,
          ),
          SizedBox(height: 14),
          TtText(
            'Loading quiz...',
            fontSize: 14,
            color: ColorUtils.greyTextColor,
          ),
        ],
      ),
    );
  }
}

class _QuizLoadErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _QuizLoadErrorView({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.quiz_outlined,
              size: 54,
              color: ColorUtils.greyTextColor,
            ),
            14.gh,
            TtText(
              message,
              fontSize: 14,
              height: 1.4,
              color: ColorUtils.greyTextColor,
              textAlign: TextAlign.center,
            ),
            18.gh,
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(
                Icons.refresh_rounded,
              ),
              label: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }
}