import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:thuta_learn/core/core.dart';
import 'package:thuta_learn/features/learn/learn.dart';

class LessonDetailPage extends StatelessWidget {
  final LessonDetailArgs args;

  const LessonDetailPage({
    super.key,
    required this.args,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) {
            return getIt<LessonDetailBloc>()
              ..add(
                OnGetLessonDetail(
                  chapterId: args.chapterId,
                  videoId: args.videoId,
                ),
              )
              ..add(
                OnGetLessonVocabularies(
                  videoId: args.videoId,
                ),
              );
          },
        ),
        BlocProvider(
          create: (_) {
            return getIt<LessonDownloadCubit>()..initialize(args.videoId);
          },
        ),
        BlocProvider(
          create: (_) {
            return getIt<VocabularySpeechCubit>()..initialize();
          },
        ),
      ],
      child: _LessonDetailView(
        args: args,
      ),
    );
  }
}

class _LessonDetailView extends StatefulWidget {
  final LessonDetailArgs args;

  const _LessonDetailView({
    required this.args,
  });

  @override
  State<_LessonDetailView> createState() {
    return _LessonDetailViewState();
  }
}

class _LessonDetailViewState extends State<_LessonDetailView> {
  bool _isFavorite = false;

  void _retry() {
    context.read<LessonDetailBloc>().add(
      OnGetLessonDetail(
        chapterId: widget.args.chapterId,
        videoId: widget.args.videoId,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LessonDownloadCubit, LessonDownloadState>(
      listenWhen: (previous, current) {
        return previous.message != current.message && current.message != null;
      },
      listener: (context, state) {
        final message = state.message;

        if (message == null) {
          return;
        }

        context.showSnackBar(
          message,
          snackBarType: state.status == VideoDownloadStatus.downloaded
              ? SnackBarType.success
              : SnackBarType.error,
        );
      },
      child: BlocBuilder<LessonDetailBloc, LessonDetailState>(
        builder: (context, state) {
          if (state.isLoading && state.video == null) {
            return const _LessonDetailLoadingPage();
          }

          if (state.status == LessonDetailStatus.failure && state.video == null) {
            return _LessonDetailErrorPage(
              message: state.message ?? 'Unable to load this lesson.',
              onRetry: _retry,
            );
          }

          final video = state.video;

          if (video == null) {
            return const SizedBox.shrink();
          }

          final title = video.title.trim().isEmpty ? 'Untitled Lesson' : video.title.trim();

          return Scaffold(
            backgroundColor: ColorUtils.scaffoldBackgroundColor,
            appBar: AppBar(
              backgroundColor: ColorUtils.scaffoldBackgroundColor,
              surfaceTintColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                onPressed: context.pop,
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: ColorUtils.primaryColor,
                ),
              ),
              actions: [
                BlocBuilder<LessonDownloadCubit, LessonDownloadState>(
                  builder: (context, downloadState) {
                    return LessonDownloadButton(
                      status: downloadState.status,
                      progress: downloadState.progress,
                      onPressed: () {
                        final video = state.video;

                        if (video == null) {
                          return;
                        }

                        context.read<LessonDownloadCubit>().download(video);
                      },
                    );
                  },
                ),
                IconButton(
                  tooltip: _isFavorite ? 'Remove from favorites' : 'Add to favorites',
                  onPressed: () {
                    setState(() {
                      _isFavorite = !_isFavorite;
                    });
                  },
                  icon: Icon(
                    _isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                    color: _isFavorite ? ColorUtils.secondaryColor : ColorUtils.primaryColor,
                    size: 30,
                  ),
                ),
                8.gw,
              ],
            ),
            body: TtFadeIn(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(
                  16,
                  12,
                  16,
                  32,
                ),
                children: [
                  TtText(
                    title,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: ColorUtils.primaryColor,
                  ),
                  8.gh,
                  TtText(
                    video.videoSource == null
                        ? 'Video lesson'
                        : '${video.videoSource!.toUpperCase()} video lesson',
                    fontSize: 14,
                    color: ColorUtils.greyTextColor,
                  ),
                  20.gh,
                  BlocBuilder<LessonDownloadCubit, LessonDownloadState>(
                    buildWhen: (previous, current) {
                      return previous.localFilePath != current.localFilePath ||
                          previous.status != current.status;
                    },

                    builder: (context, downloadState) {
                      return LessonVideoSectionView(
                        video: video,
                        localFilePath: downloadState.isDownloaded
                            ? downloadState.localFilePath
                            : null,
                      );
                    },
                  ),

                  12.gh,
                  BlocBuilder<LessonDownloadCubit, LessonDownloadState>(
                    builder: (context, downloadState) {
                      return LessonDownloadStatusView(
                        status: downloadState.status,
                        progress: downloadState.progress,
                      );
                    },
                  ),

                  // The endpoint currently does not return
                  // transcript, vocabulary or special notes.
                  // These sections can remain as existing
                  // placeholder UI until their APIs are ready.
                  20.gh,
                  const LessonTranscriptSectionView(),
                  24.gh,
                  LessonVocabularySectionView(
                    status: state.vocabularyStatus,
                    vocabularies: state.vocabularies,
                    errorMessage: state.vocabularyMessage,
                    onRetry: () {
                      context.read<LessonDetailBloc>().add(
                        OnGetLessonVocabularies(
                          videoId: widget.args.videoId,
                        ),
                      );
                    },
                  ),
                  28.gh,
                  const LessonSpecialNotesView(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _LessonDetailLoadingPage extends StatelessWidget {
  const _LessonDetailLoadingPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorUtils.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: ColorUtils.scaffoldBackgroundColor,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: context.pop,
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: ColorUtils.primaryColor,
          ),
        ),
      ),
      body: TtShimmer(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Container(
              width: 220,
              height: 24,
              color: Colors.white,
            ),
            20.gh,
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LessonDetailErrorPage extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _LessonDetailErrorPage({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorUtils.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: ColorUtils.scaffoldBackgroundColor,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: context.pop,
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: ColorUtils.primaryColor,
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.video_library_outlined,
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
      ),
    );
  }
}
