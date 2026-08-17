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
  final String? message;

  const ResourceDetailState({
    this.status = ResourceDetailStatus.initial,
    this.resource,
    this.message,
  });

  bool get isLoading {
    return status == ResourceDetailStatus.loading;
  }

  ResourceDetailState copyWith({
    ResourceDetailStatus? status,
    ChapterResourceModel? resource,
    String? message,
    bool clearMessage = false,
  }) {
    return ResourceDetailState(
      status: status ?? this.status,
      resource: resource ?? this.resource,
      message: clearMessage
          ? null
          : message ?? this.message,
    );
  }
}