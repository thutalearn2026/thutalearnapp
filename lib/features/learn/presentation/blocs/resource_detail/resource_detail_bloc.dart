import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:thuta_learn/core/core.dart';
import 'package:thuta_learn/features/learn/learn.dart';

part 'resource_detail_event.dart';
part 'resource_detail_state.dart';

@Injectable()
class ResourceDetailBloc extends Bloc<
    ResourceDetailEvent,
    ResourceDetailState> {
  final LearnUseCase learnUseCase;
  final ResourceDownloadService downloadService;

  ResourceDetailBloc({
    required this.learnUseCase,
    required this.downloadService,
  }) : super(const ResourceDetailState()) {
    on<OnGetResourceDetail>(
      _onGetResourceDetail,
    );
  }

  Future<void> _onGetResourceDetail(
      OnGetResourceDetail event,
      Emitter<ResourceDetailState> emit,
      ) async {
    if (state.isRefreshing) {
      return;
    }

    final downloadedRecord =
    await downloadService.getDownloadedResource(
      event.resourceId,
    );

    final visibleResource =
        downloadedRecord?.resource ?? state.resource;

    final localFilePath =
        downloadedRecord?.localFilePath ??
            state.localFilePath;

    final hasOfflineData =
        visibleResource != null &&
            localFilePath != null;

    emit(
      state.copyWith(
        status: visibleResource != null
            ? ResourceDetailStatus.success
            : ResourceDetailStatus.loading,
        resource: visibleResource,
        localFilePath: localFilePath,
        isRefreshing: true,
        clearMessage: true,
      ),
    );

    final result =
    await learnUseCase.getChapterResourceDetail(
      chapterId: event.chapterId,
      resourceId: event.resourceId,
    );

    await result.fold<Future<void>>(
          (failure) async {
        if (hasOfflineData) {
          // Silently keep the downloaded local file.
          emit(
            state.copyWith(
              status: ResourceDetailStatus.success,
              resource: visibleResource,
              localFilePath: localFilePath,
              isRefreshing: false,
              clearMessage: true,
            ),
          );

          return;
        }

        emit(
          state.copyWith(
            status: ResourceDetailStatus.failure,
            isRefreshing: false,
            message: _failureMessage(failure),
          ),
        );
      },
          (response) async {
        if (downloadedRecord != null) {
          await downloadService.updateResourceMetadata(
            response.data,
          );
        }

        emit(
          state.copyWith(
            status: ResourceDetailStatus.success,
            resource: response.data,
            localFilePath: localFilePath,
            isRefreshing: false,
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

    if (message == null || message.trim().isEmpty) {
      return 'Unable to load this resource.';
    }

    return message;
  }
}