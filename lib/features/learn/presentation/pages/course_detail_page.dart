import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:thuta_learn/core/core.dart';
import 'package:thuta_learn/features/learn/learn.dart';

class CourseDetailPage extends StatelessWidget {
  final String courseId;

  const CourseDetailPage({
    super.key,
    required this.courseId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        return getIt<CourseDetailBloc>()
          ..add(
            OnGetCourseDetail(
              courseId: courseId,
            ),
          );
      },
      child: _CourseDetailView(
        courseId: courseId,
      ),
    );
  }
}

class _CourseDetailView extends StatelessWidget {
  final String courseId;

  const _CourseDetailView({
    required this.courseId,
  });

  Future<void> _refresh(
      BuildContext context,
      ) async {
    final bloc = context.read<CourseDetailBloc>();

    final completed = bloc.stream.firstWhere(
          (state) {
        return state.status ==
            CourseDetailStatus.success ||
            state.status == CourseDetailStatus.failure;
      },
    );

    bloc.add(
      OnGetCourseDetail(
        courseId: courseId,
      ),
    );

    await completed;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<
        CourseDetailBloc,
        CourseDetailState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor:
          ColorUtils.scaffoldBackgroundColor,
          appBar: AppBar(
            backgroundColor:
            ColorUtils.scaffoldBackgroundColor,
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
              'Course Detail',
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          body: Stack(
            children: [
              _buildBody(
                context,
                state,
              ),
              if (state.isLoading &&
                  state.course != null)
                const Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: LinearProgressIndicator(
                    minHeight: 2,
                    color:
                    ColorUtils.secondaryColor,
                    backgroundColor:
                    Colors.transparent,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBody(
      BuildContext context,
      CourseDetailState state,
      ) {
    if (state.isLoading && state.course == null) {
      return const _CourseDetailLoadingView();
    }

    if (state.status ==
        CourseDetailStatus.failure &&
        state.course == null) {
      return _CourseDetailErrorView(
        message: state.message ??
            'Unable to load course details.',
        onRetry: () {
          context.read<CourseDetailBloc>().add(
            OnGetCourseDetail(
              courseId: courseId,
            ),
          );
        },
      );
    }

    final course = state.course;

    if (course == null) {
      return const SizedBox.shrink();
    }

    return RefreshIndicator(
      color: ColorUtils.secondaryColor,
      onRefresh: () => _refresh(context),
      child: TtFadeIn(
        child: ListView(
          physics:
          const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(
            16,
            8,
            16,
            32,
          ),
          children: [
            // Keep the old UI unchanged.
            const LearnOverviewSectionView(),
            20.gh,

            _CourseTitleSectionView(
              courseTitle: course.title,
              moduleCount: state.modules.length,
            ),
            14.gh,

            if (state.modules.isEmpty)
              const _EmptyModulesView()
            else
              ...List.generate(
                state.modules.length,
                    (index) {
                  final module =
                  state.modules[index];

                  return _ApiModuleTimelineView(
                    module: module,
                    moduleNumber: index + 1,
                    isFirst: index == 0,
                    isLast: index ==
                        state.modules.length - 1,
                    onTap: () {
                      context.push(
                        Routes.moduleDetail,
                        extra: ModuleDetailArgs(
                          courseId: courseId,
                          moduleId: module.id,
                          moduleNumber: index + 1,
                        ),
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

class _CourseTitleSectionView
    extends StatelessWidget {
  final String courseTitle;
  final int moduleCount;

  const _CourseTitleSectionView({
    required this.courseTitle,
    required this.moduleCount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        Expanded(
          child: TtText(
            courseTitle,
            fontSize: 16,
            height: 1.3,
            fontWeight: FontWeight.bold,
          ),
        ),
        12.gw,
        Padding(
          padding:
          const EdgeInsets.only(top: 2),
          child: TtText(
            '$moduleCount module'
                '${moduleCount == 1 ? '' : 's'}',
            fontSize: 14,
            color: ColorUtils.greyTextColor,
          ),
        ),
      ],
    );
  }
}

class _ApiModuleTimelineView
    extends StatelessWidget {
  final CourseModuleModel module;
  final int moduleNumber;
  final bool isFirst;
  final bool isLast;
  final VoidCallback onTap;

  const _ApiModuleTimelineView({
    required this.module,
    required this.moduleNumber,
    required this.isFirst,
    required this.isLast,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 26,
            child: _TimelineIndicator(
              isFirst: isFirst,
              isLast: isLast,
            ),
          ),
          8.gw,
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                bottom: 12,
              ),
              child: TtZoomTap(
                onTap: onTap,
                child: _ApiModuleCard(
                  module: module,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TimelineIndicator extends StatelessWidget {
  final bool isFirst;
  final bool isLast;

  const _TimelineIndicator({
    required this.isFirst,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Container(
            width: 1,
            color: isFirst
                ? Colors.transparent
                : const Color(0xFFD9DEE5),
          ),
        ),
        Container(
          width: 24,
          height: 24,
          decoration: const BoxDecoration(
            color: ColorUtils.primaryColor,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.done_all_rounded,
            size: 14,
            color: Colors.white,
          ),
        ),
        Expanded(
          child: Container(
            width: 1,
            color: isLast
                ? Colors.transparent
                : ColorUtils.secondaryColor,
          ),
        ),
      ],
    );
  }
}

class _ApiModuleCard extends StatelessWidget {
  final CourseModuleModel module;

  const _ApiModuleCard({
    required this.module,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 0,
      borderRadius: BorderRadius.circular(13),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(13),
            border: Border.all(
              color: const Color(0xFFE8EBEF),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(
                  alpha: 0.08,
                ),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              // Temporary UI values until the progress
              // API provides these fields.
              const Row(
                children: [
                  _ModuleStatusBadge(
                    label: 'Completed',
                    foregroundColor:
                    ColorUtils.primaryColor,
                    backgroundColor:
                    Color(0xFFEFF3F8),
                  ),
                  SizedBox(width: 8),
                  _ModuleStatusBadge(
                    label: 'Quiz Passed',
                    foregroundColor:
                    Color(0xFF21A965),
                    backgroundColor:
                    Color(0xFFE7F8ED),
                  ),
                ],
              ),
              10.gh,
              TtText(
                module.title,
                fontSize: 16,
                height: 1.25,
                fontWeight: FontWeight.w600,
              ),
              7.gh,
              TtText(
                'This module contains '
                    '${module.chaptersCount} chapter'
                    '${module.chaptersCount == 1 ? '' : 's'} '
                    'with lessons and learning activities.',
                fontSize: 14,
                height: 1.35,
                color: const Color(0xFF333B44),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ModuleStatusBadge extends StatelessWidget {
  final String label;
  final Color foregroundColor;
  final Color backgroundColor;

  const _ModuleStatusBadge({
    required this.label,
    required this.foregroundColor,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TtText(
        label,
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: foregroundColor,
      ),
    );
  }
}

class _EmptyModulesView extends StatelessWidget {
  const _EmptyModulesView();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 30,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(
          color: const Color(0xFFE8EBEF),
        ),
      ),
      child: const Column(
        children: [
          Icon(
            Icons.menu_book_outlined,
            size: 42,
            color: ColorUtils.greyTextColor,
          ),
          SizedBox(height: 12),
          TtText(
            'No modules are available for this course.',
            fontSize: 14,
            color: ColorUtils.greyTextColor,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _CourseDetailLoadingView
    extends StatelessWidget {
  const _CourseDetailLoadingView();

  @override
  Widget build(BuildContext context) {
    return TtShimmer(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(
          16,
          8,
          16,
          32,
        ),
        children: [
          Container(
            height: 58,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:
              BorderRadius.circular(12),
            ),
          ),
          16.gh,
          Container(
            height: 120,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:
              BorderRadius.circular(16),
            ),
          ),
          20.gh,
          Container(
            width: double.infinity,
            height: 28,
            color: Colors.white,
          ),
          14.gh,
          ...List.generate(
            3,
                (_) {
              return Container(
                height: 120,
                margin:
                const EdgeInsets.only(
                  left: 34,
                  bottom: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                  BorderRadius.circular(13),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _CourseDetailErrorView
    extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _CourseDetailErrorView({
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
              Icons.cloud_off_outlined,
              size: 56,
              color: ColorUtils.greyTextColor,
            ),
            16.gh,
            const TtText(
              'Could not load this course',
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
                backgroundColor:
                ColorUtils.primaryColor,
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
    );
  }
}