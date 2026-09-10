part of 'resource_detail_bloc.dart';

enum ResourceDetailStatus {
  initial,
  loading,
  success,
  failure,
}

class ResourceDetailState {
  final ResourceDetailStatus status;
  final ChapterResourceModel? resource;
  final String? localFilePath;
  final bool isRefreshing;
  final String? message;

  const ResourceDetailState({
    this.status = ResourceDetailStatus.initial,
    this.resource,
    this.localFilePath,
    this.isRefreshing = false,
    this.message,
  });

  bool get isLoading {
    return (status == ResourceDetailStatus.initial ||
        status == ResourceDetailStatus.loading) &&
        resource == null;
  }

  bool get isDownloaded {
    return localFilePath != null;
  }

  ResourceDetailState copyWith({
    ResourceDetailStatus? status,
    ChapterResourceModel? resource,
    String? localFilePath,
    bool? isRefreshing,
    String? message,
    bool clearLocalFilePath = false,
    bool clearMessage = false,
  }) {
    return ResourceDetailState(
      status: status ?? this.status,
      resource: resource ?? this.resource,
      localFilePath: clearLocalFilePath
          ? null
          : localFilePath ?? this.localFilePath,
      isRefreshing:
      isRefreshing ?? this.isRefreshing,
      message:
      clearMessage ? null : message ?? this.message,
    );
  }
}