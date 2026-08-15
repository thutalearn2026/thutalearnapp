import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:thuta_learn/core/core.dart';
import 'package:thuta_learn/features/learn/learn.dart';

part 'course_detail_event.dart';
part 'course_detail_state.dart';

@Injectable()
class CourseDetailBloc
    extends Bloc<CourseDetailEvent, CourseDetailState> {
  final LearnUseCase learnUseCase;

  CourseDetailBloc({
    required this.learnUseCase,
  }) : super(const CourseDetailState()) {
    on<OnGetCourseDetail>(_onGetCourseDetail);
  }

  Future<void> _onGetCourseDetail(
      OnGetCourseDetail event,
      Emitter<CourseDetailState> emit,
      ) async {
    if (state.isLoading) return;

    emit(
      state.copyWith(
        status: CourseDetailStatus.loading,
        clearMessage: true,
      ),
    );

    // Both requests start together.
    final courseFuture = learnUseCase.getCourseDetail(
      courseId: event.courseId,
    );

    final modulesFuture = learnUseCase.getCourseModules(
      courseId: event.courseId,
    );

    final courseResult = await courseFuture;
    final modulesResult = await modulesFuture;

    Failure? requestFailure;
    CourseModel? course;
    List<CourseModuleModel> modules = [];

    courseResult.fold(
          (failure) {
        requestFailure = failure;
      },
          (response) {
        course = response.data;
      },
    );

    modulesResult.fold(
          (failure) {
        requestFailure ??= failure;
      },
          (response) {
        modules = [...response.data]
          ..sort(
                (first, second) {
              return first.rank.compareTo(second.rank);
            },
          );
      },
    );

    if (requestFailure != null || course == null) {
      emit(
        state.copyWith(
          status: CourseDetailStatus.failure,
          message: _failureMessage(requestFailure),
        ),
      );

      return;
    }

    emit(
      state.copyWith(
        status: CourseDetailStatus.success,
        course: course,
        modules: modules,
        clearMessage: true,
      ),
    );
  }

  String _failureMessage(Failure? failure) {
    if (failure is ConnectionFailure) {
      return 'Please check your internet connection and try again.';
    }

    final message = failure?.e?.toString();

    if (message == null || message.isEmpty) {
      return 'Unable to load course details.';
    }

    return message;
  }
}