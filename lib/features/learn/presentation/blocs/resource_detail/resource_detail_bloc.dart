import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:thuta_learn/core/core.dart';
import 'package:thuta_learn/features/learn/learn.dart';

part 'resource_detail_event.dart';
part 'resource_detail_state.dart';

@Injectable()
class ResourceDetailBloc
    extends Bloc<
        ResourceDetailEvent,
        ResourceDetailState
    > {
  final LearnUseCase learnUseCase;

  ResourceDetailBloc({
    required this.learnUseCase,
  }) : super(const ResourceDetailState()) {
    on<OnGetResourceDetail>(
      _onGetResourceDetail,
    );
  }

  Future<void> _onGetResourceDetail(
      OnGetResourceDetail event,
      Emitter<ResourceDetailState> emit,
      ) async {
    if (state.isLoading) {
      return;
    }

    emit(
      state.copyWith(
        status: ResourceDetailStatus.loading,
        clearMessage: true,
      ),
    );

    final result =
    await learnUseCase.getChapterResourceDetail(
      chapterId: event.chapterId,
      resourceId: event.resourceId,
    );

    result.fold(
          (failure) {
        emit(
          state.copyWith(
            status: ResourceDetailStatus.failure,
            message: _failureMessage(failure),
          ),
        );
      },
          (response) {
        emit(
          state.copyWith(
            status: ResourceDetailStatus.success,
            resource: response.data,
            clearMessage: true,
          ),
        );
      },
    );
  }

  String _failureMessage(Failure failure) {
    if (failure is ConnectionFailure) {
      return 'Please check your internet connection and try again.';
    }

    final message = failure.e?.toString();

    if (message == null ||
        message.trim().isEmpty) {
      return 'Unable to load this resource.';
    }

    return message;
  }
}