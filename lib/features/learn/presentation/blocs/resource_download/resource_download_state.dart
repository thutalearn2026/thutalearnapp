part of 'resource_download_cubit.dart';

enum ResourceDownloadStatus {
  initial,
  downloading,
  success,
  canceled,
  failure,
}

class ResourceDownloadItemState {
  final ResourceDownloadStatus status;
  final String? savedLocation;

  const ResourceDownloadItemState({
    this.status =
        ResourceDownloadStatus.initial,
    this.savedLocation,
  });

  bool get isDownloading {
    return status ==
        ResourceDownloadStatus.downloading;
  }

  bool get isDownloaded {
    return status ==
        ResourceDownloadStatus.success;
  }
}

class ResourceDownloadState {
  final Map<String, ResourceDownloadItemState>
  downloads;

  final String? message;
  final SnackBarType messageType;

  const ResourceDownloadState({
    this.downloads = const {},
    this.message,
    this.messageType = SnackBarType.success,
  });

  ResourceDownloadItemState downloadFor(
      String resourceId,
      ) {
    return downloads[resourceId] ??
        const ResourceDownloadItemState();
  }

  ResourceDownloadState copyWith({
    Map<String, ResourceDownloadItemState>?
    downloads,
    String? message,
    SnackBarType? messageType,
    bool clearMessage = false,
  }) {
    return ResourceDownloadState(
      downloads: downloads ?? this.downloads,
      message: clearMessage
          ? null
          : message ?? this.message,
      messageType:
      messageType ?? this.messageType,
    );
  }
}