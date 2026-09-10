import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:thuta_learn/core/core.dart';
import 'package:thuta_learn/features/learn/learn.dart';
import 'package:thuta_learn/features/profile/profile.dart';

class SavedVocabularyPage extends StatelessWidget {
  const SavedVocabularyPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) {
            return getIt<SavedVocabularyBloc>()..add(
              OnGetSavedVocabularies(),
            );
          },
        ),
        BlocProvider(
          create: (_) {
            return getIt<VocabularySpeechCubit>()..initialize();
          },
        ),
      ],
      child: const _SavedVocabularyView(),
    );
  }
}

class _SavedVocabularyView extends StatelessWidget {
  const _SavedVocabularyView();

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<SavedVocabularyBloc, SavedVocabularyState>(
          listenWhen: (previous, current) {
            return previous.message != current.message &&
                current.message != null &&
                current.actionStatus != SavedVocabularyActionStatus.loading;
          },
          listener: (context, state) {
            final message = state.message;

            if (message == null) {
              return;
            }

            context.showSnackBar(
              message,
              snackBarType: state.actionStatus == SavedVocabularyActionStatus.success
                  ? SnackBarType.success
                  : SnackBarType.error,
            );
          },
        ),
        BlocListener<VocabularySpeechCubit, VocabularySpeechState>(
          listenWhen: (previous, current) {
            return previous.message != current.message && current.message != null;
          },
          listener: (context, state) {
            context.showSnackBar(
              state.message!,
              snackBarType: SnackBarType.error,
            );
          },
        ),
      ],
      child: BlocBuilder<SavedVocabularyBloc, SavedVocabularyState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: ColorUtils.scaffoldBackgroundColor,
            appBar: AppBar(
              backgroundColor: ColorUtils.scaffoldBackgroundColor,
              surfaceTintColor: Colors.transparent,
              elevation: 0,
              centerTitle: true,
              leading: IconButton(
                onPressed: context.pop,
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: ColorUtils.primaryColor,
                ),
              ),
              title: const TtText(
                'Saved Vocabulary',
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              actions: [
                IconButton(
                  tooltip: state.isAlphabeticallySorted
                      ? 'Restore saved order'
                      : 'Sort alphabetically',
                  onPressed: state.vocabularies.isEmpty
                      ? null
                      : () {
                          context.read<SavedVocabularyBloc>().add(
                            OnSortSavedVocabularies(),
                          );
                        },
                  icon: Icon(
                    state.isAlphabeticallySorted
                        ? Icons.sort_by_alpha_rounded
                        : Icons.sort_rounded,
                    size: 29,
                    color: ColorUtils.primaryColor,
                  ),
                ),
                8.gw,
              ],
            ),
            body: _buildBody(
              context,
              state,
            ),
          );
        },
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    SavedVocabularyState state,
  ) {
    if (state.isInitialLoading) {
      return const _SavedVocabularyLoadingView();
    }

    if (state.status == SavedVocabularyStatus.failure && state.vocabularies.isEmpty) {
      return _SavedVocabularyErrorView(
        message: state.message ?? 'Unable to load saved vocabularies.',
        onRetry: () {
          context.read<SavedVocabularyBloc>().add(
            OnGetSavedVocabularies(),
          );
        },
      );
    }

    if (state.vocabularies.isEmpty) {
      return const SavedVocabularyEmptyView();
    }

    return RefreshIndicator(
      color: ColorUtils.secondaryColor,
      onRefresh: () async {
        final bloc = context.read<SavedVocabularyBloc>();

        bloc.add(
          OnGetSavedVocabularies(),
        );

        await bloc.stream.firstWhere(
          (state) => state.status != SavedVocabularyStatus.loading,
        );
      },
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(
          16,
          22,
          16,
          32,
        ),
        itemCount: state.vocabularies.length,
        separatorBuilder: (_, __) => 22.gh,
        itemBuilder: (context, index) {
          final vocabulary = state.vocabularies[index];

          return BlocSelector<VocabularySpeechCubit, VocabularySpeechState, bool>(
            selector: (speechState) {
              return speechState.isSpeaking(
                vocabulary.id,
              );
            },
            builder: (context, isSpeaking) {
              return SavedVocabularyItemView(
                key: ValueKey(vocabulary.id),
                vocabulary: vocabulary,
                isSpeaking: isSpeaking,
                isRemoving: state.isRemoving(
                  vocabulary.id,
                ),
                onAudio: () {
                  context.read<VocabularySpeechCubit>().speak(vocabulary);
                },
                onRemove: () {
                  context.read<SavedVocabularyBloc>().add(
                    OnRemoveSavedVocabulary(
                      vocabulary: vocabulary,
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class SavedVocabularyEmptyView extends StatelessWidget {
  const SavedVocabularyEmptyView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: const BoxDecoration(
                color: ColorUtils.secondaryBackgroundColor,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.favorite_border_rounded,
                size: 44,
                color: ColorUtils.secondaryColor,
              ),
            ),
            20.gh,
            const TtText(
              'No saved vocabulary',
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            10.gh,
            const TtText(
              'Tap the heart icon on vocabulary words '
              'to save them for later.',
              fontSize: 14,
              height: 1.4,
              textAlign: TextAlign.center,
              color: ColorUtils.greyTextColor,
            ),
          ],
        ),
      ),
    );
  }
}

class _SavedVocabularyLoadingView extends StatelessWidget {
  const _SavedVocabularyLoadingView();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(
        16,
        22,
        16,
        32,
      ),
      itemCount: 5,
      separatorBuilder: (_, __) => 22.gh,
      itemBuilder: (_, __) {
        return Row(
          children: [
            Container(
              width: 56,
              height: 56,
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
                    width: 160,
                    height: 18,
                    color: const Color(
                      0xFFE9EDF2,
                    ),
                  ),
                  9.gh,
                  Container(
                    width: 230,
                    height: 15,
                    color: const Color(
                      0xFFE9EDF2,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _SavedVocabularyErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _SavedVocabularyErrorView({
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
              Icons.menu_book_outlined,
              size: 54,
              color: ColorUtils.greyTextColor,
            ),
            14.gh,
            TtText(
              message,
              fontSize: 14,
              height: 1.4,
              textAlign: TextAlign.center,
              color: ColorUtils.greyTextColor,
            ),
            18.gh,
            TtButton(
              onTap: onRetry,
              child: const TtText(
                'Try Again',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
