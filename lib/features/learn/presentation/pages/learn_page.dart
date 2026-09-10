import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:thuta_learn/core/core.dart';
import 'package:thuta_learn/features/learn/learn.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LearnPage extends StatelessWidget {
  const LearnPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        return getIt<CoursesBloc>()..add(OnGetCourses());
      },
      child: const _LearnCoursesView(),
    );
  }
}

class _LearnCoursesView extends StatefulWidget {
  const _LearnCoursesView();

  @override
  State<_LearnCoursesView> createState() {
    return _LearnCoursesViewState();
  }
}

class _LearnCoursesViewState extends State<_LearnCoursesView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(
      _onScroll,
    );
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    if (_scrollController.position.extentAfter < 350) {
      context.read<CoursesBloc>().add(
        OnLoadMoreCourses(),
      );
    }
  }

  Future<void> _refreshCourses() async {
    final bloc = context.read<CoursesBloc>();

    // If the initial background refresh is still running,
    // wait for it rather than dispatching a duplicate request.
    if (bloc.state.isRefreshing) {
      await bloc.stream.firstWhere(
        (state) => !state.isRefreshing,
      );
      return;
    }

    final completed = bloc.stream.firstWhere(
      (state) {
        return !state.isRefreshing &&
            (state.status == CoursesStatus.success ||
                state.status == CoursesStatus.failure);
      },
    );

    bloc.add(OnGetCourses());

    await completed;
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CoursesBloc, CoursesState>(
      listenWhen: (previous, current) {
        return previous.message != current.message &&
            current.message != null &&
            current.courses.isNotEmpty;
      },
      listener: (context, state) {
        context.showSnackBar(
          state.message!,
          margin: const EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: 100,
          ),
          snackBarType: SnackBarType.error,
        );
      },
      builder: (context, state) {
        if (state.isLoading) {
          return const _CoursesLoadingView();
        }

        if (state.status == CoursesStatus.failure && state.courses.isEmpty) {
          return _CoursesErrorView(
            message: state.message ?? 'Unable to load courses.',
            onRetry: () {
              context.read<CoursesBloc>().add(
                OnGetCourses(),
              );
            },
          );
        }

        return Scaffold(
          backgroundColor: ColorUtils.scaffoldBackgroundColor,
          appBar: AppBar(
            toolbarHeight: 0,
            backgroundColor: ColorUtils.scaffoldBackgroundColor,
            surfaceTintColor: Colors.transparent,
          ),
          body: RefreshIndicator(
            color: ColorUtils.secondaryColor,
            onRefresh: _refreshCourses,
            child: TtFadeIn(
              child: CustomScrollView(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(
                      16,
                      20,
                      16,
                      16,
                    ),
                    sliver: SliverToBoxAdapter(
                      child: _CoursesHeaderView(
                        courseCount: state.total,
                      ),
                    ),
                  ),
                  if (state.courses.isEmpty)
                    const SliverFillRemaining(
                      hasScrollBody: false,
                      child: _CoursesEmptyView(),
                    )
                  else
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(
                        16,
                        0,
                        16,
                        16,
                      ),
                      sliver: SliverGrid(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final course = state.courses[index];

                            return LearnCourseCard(
                              course: course,
                              index: index,
                              onTap: () {
                                context.push(
                                  Routes.courseDetail,
                                  extra: course.id,
                                );
                              },
                            );
                          },
                          childCount: state.courses.length,
                        ),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 14,
                          childAspectRatio: Platform.isAndroid ? 0.5 : 0.56,
                        ),
                      ),
                    ),
                  if (state.isLoadingMore)
                    const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: 8,
                          bottom: 120,
                        ),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: ColorUtils.secondaryColor,
                          ),
                        ),
                      ),
                    )
                  else
                    const SliverToBoxAdapter(
                      child: SizedBox(height: 120),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _CoursesLoadingView extends StatelessWidget {
  const _CoursesLoadingView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorUtils.scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: TtShimmer(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  height: 235,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                16.gh,
                Expanded(
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 4,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 14,
                          childAspectRatio: 0.58,
                        ),
                    itemBuilder: (_, __) {
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CoursesErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _CoursesErrorView({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorUtils.scaffoldBackgroundColor,
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
                'Could not load courses',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                textAlign: TextAlign.center,
              ),
              8.gh,
              TtText(
                message,
                fontSize: 14,
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

class _CoursesEmptyView extends StatelessWidget {
  const _CoursesEmptyView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.only(
          left: 32,
          right: 32,
          bottom: 120,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.menu_book_outlined,
              size: 54,
              color: ColorUtils.greyTextColor,
            ),
            SizedBox(height: 14),
            TtText(
              FeatureFlags.enrolledCoursesOnly
                  ? 'No enrolled courses yet.'
                  : 'No courses available yet.',
              fontSize: 16,
              fontWeight: FontWeight.bold,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 6),
            TtText(
              FeatureFlags.enrolledCoursesOnly
                  ? 'Courses you purchase will appear here.'
                  : 'Please check again later.',
              fontSize: 14,
              color: ColorUtils.greyTextColor,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _CoursesHeaderView extends StatelessWidget {
  final int courseCount;

  const _CoursesHeaderView({
    required this.courseCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            ColorUtils.primaryColor,
            Color(0xFF28578E),
            Color(0xFF197F91),
          ],
          stops: [
            0,
            0.58,
            1,
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: ColorUtils.primaryColor.withValues(
              alpha: 0.22,
            ),
            blurRadius: 20,
            offset: const Offset(0, 9),
          ),
        ],
      ),
      child: Stack(
        children: [
          const Positioned(
            right: -34,
            top: -42,
            child: _HeaderDecorationCircle(
              size: 135,
              opacity: 0.08,
            ),
          ),
          const Positioned(
            right: 42,
            bottom: -58,
            child: _HeaderDecorationCircle(
              size: 125,
              opacity: 0.06,
            ),
          ),
          const Positioned(
            left: -38,
            bottom: -50,
            child: _HeaderDecorationCircle(
              size: 105,
              opacity: 0.05,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    _ExploreBadge(),
                    Spacer(),
                    _HeaderBookIcon(),
                  ],
                ),
                18.gh,
                const TtText(
                  'Choose your next\nlearning journey',
                  fontSize: 20,
                  height: 1.2,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                10.gh,
                TtText(
                  'Explore practical Thai courses designed '
                  'to help you learn step by step.',
                  fontSize: 14,
                  height: 1.4,
                  color: Colors.white.withValues(
                    alpha: 0.82,
                  ),
                ),
                18.gh,
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    _HeaderInformationChip(
                      icon: Icons.menu_book_outlined,
                      label: '$courseCount courses',
                    ),
                    const _HeaderInformationChip(
                      icon: Icons.school_outlined,
                      label: 'Multiple levels',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ExploreBadge extends StatelessWidget {
  const _ExploreBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 11,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
        ),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.auto_awesome_rounded,
            size: 17,
            color: ColorUtils.secondaryColor,
          ),
          SizedBox(width: 6),
          TtText(
            'Explore Courses',
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}

class _HeaderBookIcon extends StatelessWidget {
  const _HeaderBookIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.14),
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.18),
        ),
      ),
      child: const Icon(
        Icons.local_library_outlined,
        size: 26,
        color: Colors.white,
      ),
    );
  }
}

class _HeaderInformationChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _HeaderInformationChip({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 11,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.13),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.14),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 17,
            color: Colors.white,
          ),
          6.gw,
          TtText(
            label,
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}

class _HeaderDecorationCircle extends StatelessWidget {
  final double size;
  final double opacity;

  const _HeaderDecorationCircle({
    required this.size,
    required this.opacity,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white.withValues(
          alpha: opacity,
        ),
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white.withValues(
            alpha: opacity + 0.03,
          ),
        ),
      ),
    );
  }
}
