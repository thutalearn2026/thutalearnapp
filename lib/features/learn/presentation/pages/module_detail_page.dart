import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:thuta_learn/core/core.dart';
import 'package:thuta_learn/features/learn/learn.dart';

class ModuleDetailPage extends StatelessWidget {
  final ModuleDetailArgs args;

  const ModuleDetailPage({
    super.key,
    required this.args,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) {
            return getIt<ModuleDetailBloc>()..add(
              OnGetModuleDetail(
                courseId: args.courseId,
                moduleId: args.moduleId,
              ),
            );
          },
        ),
        BlocProvider(
          create: (_) {
            return getIt<ModuleVideoDownloadsCubit>()..initialize();
          },
        ),
        BlocProvider(
          create: (_) {
            return getIt<ResourceDownloadCubit>();
          },
        ),
      ],
      child: _ModuleDetailView(
        args: args,
      ),
    );
  }
}

class _ModuleDetailView extends StatefulWidget {
  final ModuleDetailArgs args;

  const _ModuleDetailView({
    required this.args,
  });

  @override
  State<_ModuleDetailView> createState() {
    return _ModuleDetailViewState();
  }
}

class _ModuleDetailViewState extends State<_ModuleDetailView>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  int _selectedTabIndex = 0;

  bool get _isLessonsTab {
    return _selectedTabIndex == 0;
  }

  @override
  void initState() {
    super.initState();

    _tabController = TabController(
      length: 3,
      vsync: this,
    );

    _tabController.addListener(
      _handleTabChanged,
    );
  }

  void _handleTabChanged() {
    if (_selectedTabIndex == _tabController.index) {
      return;
    }

    final selectedIndex = _tabController.index;

    setState(() {
      _selectedTabIndex = selectedIndex;
    });

    final state = context.read<ModuleDetailBloc>().state;

    if (state.chapters.isEmpty) {
      return;
    }

    final firstChapter = state.chapters.first;

    if (selectedIndex == 1) {
      _loadChapterQuizzes(firstChapter);
    } else if (selectedIndex == 2) {
      _loadChapterResources(firstChapter);
    }
  }

  void _handleSecondaryAction(
    ModuleDetailState state,
  ) {
    if (_isLessonsTab) {
      return;
    }

    if (_selectedTabIndex != 1) {
      return;
    }

    for (final chapter in state.chapters) {
      final quizzes = state.quizzesByChapter[chapter.id];

      if (quizzes != null && quizzes.isNotEmpty) {
        _openQuizType(
          chapter,
          quizzes.first,
        );

        return;
      }
    }

    context.showSnackBar(
      'Please select a quiz from the Practice tab.',
      snackBarType: SnackBarType.info,
    );
  }

  void _loadChapterVideos(
    ChapterModel chapter,
  ) {
    if (chapter.videosCount == 0) {
      return;
    }

    context.read<ModuleDetailBloc>().add(
      OnGetChapterVideos(
        chapterId: chapter.id,
      ),
    );
  }

  void _loadChapterResources(
    ChapterModel chapter,
  ) {
    context.read<ModuleDetailBloc>().add(
      OnGetChapterResources(
        chapterId: chapter.id,
      ),
    );
  }

  void _loadChapterQuizzes(
    ChapterModel chapter,
  ) {
    context.read<ModuleDetailBloc>().add(
      OnGetChapterQuizzes(
        chapterId: chapter.id,
      ),
    );
  }

  ({
    ChapterModel chapter,
    ChapterVideoModel video,
  })?
  _firstAvailableVideo(
    ModuleDetailState state,
  ) {
    for (final chapter in state.chapters) {
      final videos = state.videosByChapter[chapter.id];

      if (videos != null && videos.isNotEmpty) {
        return (
          chapter: chapter,
          video: videos.first,
        );
      }
    }

    return null;
  }

  void _openVideo(
    ChapterModel chapter,
    ChapterVideoModel video,
  ) {
    context.push(
      Routes.lessonDetail,
      extra: LessonDetailArgs(
        chapterId: chapter.id,
        videoId: video.id,
      ),
    );
  }

  void _handleResume(
    ModuleDetailState state,
  ) {
    final firstLesson = _firstAvailableVideo(state);

    if (firstLesson != null) {
      _openVideo(
        firstLesson.chapter,
        firstLesson.video,
      );

      return;
    }

    ChapterModel? firstChapterWithVideos;

    for (final chapter in state.chapters) {
      if (chapter.videosCount > 0) {
        firstChapterWithVideos = chapter;
        break;
      }
    }

    if (firstChapterWithVideos != null) {
      _loadChapterVideos(
        firstChapterWithVideos,
      );

      context.showSnackBar(
        'Loading the first video...',
        snackBarType: SnackBarType.info,
      );
    }
  }

  void _openQuizType(
    ChapterModel chapter,
    ChapterQuizModel quiz,
  ) {
    final type = quiz.type.trim().toLowerCase().replaceAll('-', '_').replaceAll(' ', '_');

    switch (type) {
      case 'multiple_choice':
      case 'listening':
      case 'reading':
        context.push(
          Routes.quiz,
          extra: QuizDetailArgs(
            chapterId: chapter.id,
            chapterTitle: chapter.title,
            quizId: quiz.id,
          ),
        );
        break;

      case 'pronunciation':
      case 'pronunciation_drill':
        context.push(
          Routes.pronunciationDrill,
        );
        break;

      case 'vocabulary':
      case 'vocab':
      case 'flash_card':
      case 'flash_cards':
        context.push(
          Routes.vocabularyFlashCards,
        );
        break;

      default:
        context.showSnackBar(
          '${quiz.title} is not supported yet.',
          snackBarType: SnackBarType.warning,
        );
    }
  }

  void _openResource(
    ChapterModel chapter,
    ChapterResourceModel resource,
  ) {
    context.push(
      Routes.resourceDetail,
      extra: ResourceDetailArgs(
        chapterId: chapter.id,
        resourceId: resource.id,
      ),
    );
  }

  @override
  void dispose() {
    _tabController
      ..removeListener(
        _handleTabChanged,
      )
      ..dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<ModuleDetailBloc, ModuleDetailState>(
          listenWhen: (previous, current) {
            return previous.videosByChapter != current.videosByChapter;
          },
          listener: (context, state) {
            final videos = state.videosByChapter.values.expand(
              (chapterVideos) => chapterVideos,
            );

            context.read<ModuleVideoDownloadsCubit>().registerVideos(videos);
          },
        ),
        BlocListener<ModuleVideoDownloadsCubit, ModuleVideoDownloadsState>(
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
              snackBarType: state.messageIsError ? SnackBarType.error : SnackBarType.success,
            );
          },
        ),
        BlocListener<
            ResourceDownloadCubit,
            ResourceDownloadState
        >(
          listenWhen: (previous, current) {
            return previous.message !=
                current.message &&
                current.message != null;
          },
          listener: (context, state) {
            final message = state.message;

            if (message == null) {
              return;
            }

            context.showSnackBar(
              message,
              snackBarType: state.messageType,
            );
          },
        ),
        BlocListener<
            ModuleDetailBloc,
            ModuleDetailState
        >(
          listenWhen: (previous, current) {
            return previous.resourcesByChapter !=
                current.resourcesByChapter;
          },
          listener: (context, state) {
            final resources = state
                .resourcesByChapter.values
                .expand(
                  (chapterResources) => chapterResources,
            );

            context
                .read<ResourceDownloadCubit>()
                .registerResources(resources);
          },
        ),
        // BlocListener<
        //     ModuleDetailBloc,
        //     ModuleDetailState
        // >(
        //   listenWhen: (previous, current) {
        //     return previous.message != current.message &&
        //         current.message != null &&
        //         current.module != null;
        //   },
        //   listener: (context, state) {
        //     context.showSnackBar(
        //       state.message!,
        //       snackBarType: SnackBarType.warning,
        //     );
        //   },
        // ),
      ],
      child: BlocBuilder<ModuleDetailBloc, ModuleDetailState>(
        builder: (context, state) {
          if (state.isLoading && state.module == null) {
            return const _ModuleLoadingPage();
          }

          if (state.status == ModuleDetailStatus.failure && state.module == null) {
            return _ModuleErrorPage(
              message: state.message ?? 'Unable to load this module.',
              onRetry: () {
                context.read<ModuleDetailBloc>().add(
                  OnGetModuleDetail(
                    courseId: widget.args.courseId,
                    moduleId: widget.args.moduleId,
                  ),
                );
              },
            );
          }

          final module = state.module;

          if (module == null) {
            return const SizedBox.shrink();
          }

          final headerModule = LearnModuleItem(
            id: module.id,
            slug: module.slug,
            moduleNumber: widget.args.moduleNumber,
            title: module.title,
            description:
                '${module.chaptersCount} chapter'
                '${module.chaptersCount == 1 ? '' : 's'} '
                'available in this module.',
            status: LearnModuleStatus.inProgress,
            progress: 0,
          );

          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: ColorUtils.primaryColor,
              surfaceTintColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                onPressed: context.pop,
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.white,
                ),
              ),
            ),
            body: TtFadeIn(
              child: NestedScrollView(
                headerSliverBuilder:
                    (
                      context,
                      innerBoxIsScrolled,
                    ) {
                      return [
                        SliverToBoxAdapter(
                          child: ModuleDetailHeader(
                            module: headerModule,
                            videoCount: state.totalVideoCount,
                            onResume: () {
                              _handleResume(state);
                            },
                            secondaryActionLabel: _isLessonsTab ? 'Overview' : 'Take Quiz',
                            secondaryActionIcon: _isLessonsTab
                                ? Icons.play_arrow_rounded
                                : Icons.lightbulb_outline_rounded,
                            onSecondaryAction: () {
                              _handleSecondaryAction(
                                state,
                              );
                            },
                          ),
                        ),
                        SliverPersistentHeader(
                          pinned: true,
                          delegate: ModuleTabBarDelegate(
                            tabBar: TabBar(
                              controller: _tabController,
                              labelColor: ColorUtils.primaryColor,
                              unselectedLabelColor: ColorUtils.primaryColor,
                              labelStyle: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              unselectedLabelStyle: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                              indicatorColor: ColorUtils.secondaryColor,
                              indicatorWeight: 3,
                              dividerColor: const Color(
                                0xFFE6E9ED,
                              ),
                              tabs: const [
                                Tab(
                                  text: 'Lessons',
                                ),
                                Tab(
                                  text: 'Practice',
                                ),
                                Tab(
                                  text: 'Resources',
                                ),
                              ],
                            ),
                          ),
                        ),
                      ];
                    },
                body: TabBarView(
                  controller: _tabController,
                  children: [
                    ModuleLessonsTabView(
                      chapters: state.chapters,
                      videosByChapter: state.videosByChapter,
                      loadingChapterIds: state.loadingChapterIds,
                      chapterVideoErrors: state.chapterVideoErrors,
                      onChapterExpanded: _loadChapterVideos,
                      onRetryChapter: _loadChapterVideos,
                      onVideoTap: _openVideo,
                      onVideoDownload: (video) {
                        context.read<ModuleVideoDownloadsCubit>().download(video);
                      },
                    ),
                    ModulePracticeTabView(
                      chapters: state.chapters,
                      quizzesByChapter: state.quizzesByChapter,
                      loadingChapterIds: state.loadingQuizChapterIds,
                      chapterErrors: state.chapterQuizErrors,
                      onChapterExpanded: _loadChapterQuizzes,
                      onRetryChapter: _loadChapterQuizzes,
                      onQuizTap: _openQuizType,
                    ),
                    ModuleResourcesTabView(
                      chapters: state.chapters,
                      resourcesByChapter: state.resourcesByChapter,
                      loadingChapterIds: state.loadingResourceChapterIds,
                      chapterErrors: state.chapterResourceErrors,
                      onChapterExpanded: _loadChapterResources,
                      onRetryChapter: _loadChapterResources,
                      onResourceTap: _openResource,
                      onDownload: (resource) {
                        context
                            .read<ResourceDownloadCubit>()
                            .download(resource);
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class ModuleTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;

  ModuleTabBarDelegate({
    required this.tabBar,
  });

  @override
  double get minExtent {
    return tabBar.preferredSize.height;
  }

  @override
  double get maxExtent {
    return tabBar.preferredSize.height;
  }

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Material(
      color: Colors.white,
      elevation: overlapsContent ? 2 : 0,
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(
    ModuleTabBarDelegate oldDelegate,
  ) {
    return oldDelegate.tabBar != tabBar;
  }
}

class _ModuleLoadingPage extends StatelessWidget {
  const _ModuleLoadingPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: ColorUtils.primaryColor,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: context.pop,
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
          ),
        ),
      ),
      body: TtFadeIn(
        child: TtShimmer(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 360,
                color: Colors.white,
              ),
              const SizedBox(height: 2),
              Container(
                width: double.infinity,
                height: 50,
                color: Colors.white,
              ),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(
                    16,
                  ),
                  itemCount: 3,
                  separatorBuilder: (_, __) {
                    return 14.gh;
                  },
                  itemBuilder: (_, __) {
                    return Container(
                      height: 90,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ModuleErrorPage extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ModuleErrorPage({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: ColorUtils.primaryColor,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: context.pop,
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
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
                Icons.cloud_off_outlined,
                size: 56,
                color: ColorUtils.greyTextColor,
              ),
              16.gh,
              const TtText(
                'Could not load this module',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                textAlign: TextAlign.center,
              ),
              8.gh,
              TtText(
                message,
                fontSize: 14,
                height: 1.4,
                color: ColorUtils.greyTextColor,
                textAlign: TextAlign.center,
              ),
              20.gh,
              ElevatedButton.icon(
                onPressed: onRetry,
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorUtils.primaryColor,
                  foregroundColor: Colors.white,
                ),
                icon: const Icon(
                  Icons.refresh_rounded,
                ),
                label: const TtText(
                  'Try Again',
                  fontSize: 14,
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
