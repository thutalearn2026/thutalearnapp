import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:thuta_learn/core/core.dart';
import 'package:thuta_learn/features/learn/learn.dart';

part 'resource_download_state.dart';

@Injectable()
class ResourceDownloadCubit extends Cubit<ResourceDownloadState> {
  final ResourceDownloadService downloadService;

  ResourceDownloadCubit({
    required this.downloadService,
  }) : super(
         const ResourceDownloadState(),
       );

  Future<void> download(
    ChapterResourceModel resource,
  ) async {
    final current = state.downloadFor(resource.id);

    if (current.isDownloading) {
      return;
    }

    emit(
      state.copyWith(
        downloads: {
          ...state.downloads,
          resource.id: const ResourceDownloadItemState(
            status: ResourceDownloadStatus.downloading,
          ),
        },
        clearMessage: true,
      ),
    );

    try {
      final result = await downloadService.download(
        resource,
      );

      if (isClosed) {
        return;
      }

      emit(
        state.copyWith(
          downloads: {
            ...state.downloads,
            resource.id: ResourceDownloadItemState(
              status: ResourceDownloadStatus.success,
              savedLocation: result.location,
            ),
          },
          message: Platform.isAndroid
              ? 'Saved to Downloads/Thuta Learn/Downloaded Resources.'
              : '${result.fileName} was saved successfully.',
          messageType: SnackBarType.success,
        ),
      );
    } on ResourceDownloadCanceledException {
      if (isClosed) {
        return;
      }

      emit(
        state.copyWith(
          downloads: {
            ...state.downloads,
            resource.id: const ResourceDownloadItemState(
              status: ResourceDownloadStatus.canceled,
            ),
          },
          message: 'Resource download was cancelled.',
          messageType: SnackBarType.info,
        ),
      );
    } catch (error) {
      if (isClosed) {
        return;
      }

      var message = error.toString();

      message = message.replaceFirst('Bad state: ', '').replaceFirst('Exception: ', '');

      emit(
        state.copyWith(
          downloads: {
            ...state.downloads,
            resource.id: const ResourceDownloadItemState(
              status: ResourceDownloadStatus.failure,
            ),
          },
          message: message,
          messageType: SnackBarType.error,
        ),
      );
    }
  }
}
