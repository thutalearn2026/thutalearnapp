import 'package:flutter/material.dart';
import 'package:thuta_learn/core/core.dart';
import 'package:thuta_learn/features/learn/learn.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LessonVocabularySectionView extends StatefulWidget {
  final LessonVocabularyStatus status;
  final List<VideoVocabularyModel> vocabularies;
  final String? errorMessage;
  final VoidCallback onRetry;
  final Set<String> savingVocabularyIds;

  final ValueChanged<VideoVocabularyModel> onSaved;

  const LessonVocabularySectionView({
    super.key,
    required this.status,
    required this.vocabularies,
    required this.errorMessage,
    required this.savingVocabularyIds,
    required this.onRetry,
    required this.onSaved,
  });

  @override
  State<LessonVocabularySectionView> createState() {
    return _LessonVocabularySectionViewState();
  }
}

class _LessonVocabularySectionViewState extends State<LessonVocabularySectionView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TtText(
          'Vocabulary in this video',
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        16.gh,
        _buildContent(),
      ],
    );
  }

  Widget _buildContent() {
    if ((widget.status == LessonVocabularyStatus.initial ||
            widget.status == LessonVocabularyStatus.loading) &&
        widget.vocabularies.isEmpty) {
      return const _VocabularyLoadingView();
    }

    if (widget.status == LessonVocabularyStatus.failure && widget.vocabularies.isEmpty) {
      return _VocabularyErrorView(
        message: widget.errorMessage ?? 'Unable to load the vocabulary list.',
        onRetry: widget.onRetry,
      );
    }

    if (widget.vocabularies.isEmpty) {
      return const _VocabularyEmptyView();
    }

    return ListView.separated(
      itemCount: widget.vocabularies.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      separatorBuilder: (_, __) => 18.gh,
      itemBuilder: (context, index) {
        final vocabulary = widget.vocabularies[index];

        return BlocSelector<VocabularySpeechCubit, VocabularySpeechState, bool>(
          selector: (state) {
            return state.isSpeaking(vocabulary.id);
          },
          builder: (context, isSpeaking) {
            return VocabularyItemView(
              vocabulary: vocabulary,
              isSaved: vocabulary.isSaved,
              isSaving: widget.savingVocabularyIds.contains(vocabulary.id),
              isSpeaking: isSpeaking,
              onSaved: () {
                widget.onSaved(vocabulary);
              },
              onAudio: () {
                context.read<VocabularySpeechCubit>().speak(vocabulary);
              },
            );
          },
        );
      },
    );
  }
}

class VocabularyItemView extends StatelessWidget {
  final VideoVocabularyModel vocabulary;
  final bool isSaved;
  final bool isSpeaking;
  final VoidCallback onSaved;
  final VoidCallback onAudio;
  final bool isSaving;

  const VocabularyItemView({
    super.key,
    required this.vocabulary,
    required this.isSaved,
    required this.isSpeaking,
    required this.onSaved,
    required this.onAudio,
    required this.isSaving,
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
            width: 52,
            height: 52,
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
                color: isSpeaking ? Colors.white : ColorUtils.secondaryColor,
                size: 26,
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
                6.gh,
                TtText(
                  definition,
                  fontSize: 14,
                  height: 1.35,
                  color: ColorUtils.primaryColor,
                ),
              ],
              if (example.isNotEmpty) ...[
                6.gh,
                TtText(
                  example,
                  fontSize: 14,
                  height: 1.35,
                  color: ColorUtils.greyTextColor,
                ),
              ],
            ],
          ),
        ),
        IconButton(
          onPressed: isSaving ? null : onSaved,
          tooltip: isSaved ? 'Remove from saved vocabulary' : 'Save vocabulary',
          icon: AnimatedSwitcher(
            duration: const Duration(
              milliseconds: 200,
            ),
            child: isSaving
                ? const SizedBox(
                    key: ValueKey('saving'),
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: ColorUtils.secondaryColor,
                    ),
                  )
                : Icon(
                    isSaved ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                    key: ValueKey(isSaved),
                    color: isSaved ? ColorUtils.secondaryColor : const Color(0xFF8294A9),
                  ),
          ),
        ),
      ],
    );
  }
}

class _VocabularyLoadingView extends StatelessWidget {
  const _VocabularyLoadingView();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        3,
        (index) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: index == 2 ? 0 : 18,
            ),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: const BoxDecoration(
                    color: Color(0xFFE9EDF2),
                    shape: BoxShape.circle,
                  ),
                ),
                14.gw,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 150,
                        height: 16,
                        color: const Color(0xFFE9EDF2),
                      ),
                      8.gh,
                      Container(
                        width: 220,
                        height: 14,
                        color: const Color(0xFFE9EDF2),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _VocabularyErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _VocabularyErrorView({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF5F5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.error_outline_rounded,
            size: 32,
            color: Colors.red,
          ),
          8.gh,
          TtText(
            message,
            fontSize: 14,
            textAlign: TextAlign.center,
            color: Colors.red,
          ),
          8.gh,
          TextButton.icon(
            onPressed: onRetry,
            icon: const Icon(
              Icons.refresh_rounded,
            ),
            label: const TtText(
              'Try Again',
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _VocabularyEmptyView extends StatelessWidget {
  const _VocabularyEmptyView();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F7FA),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Column(
        children: [
          Icon(
            Icons.menu_book_outlined,
            size: 34,
            color: ColorUtils.greyTextColor,
          ),
          SizedBox(height: 10),
          TtText(
            'No vocabularies are available for this video.',
            fontSize: 14,
            textAlign: TextAlign.center,
            color: ColorUtils.greyTextColor,
          ),
        ],
      ),
    );
  }
}
