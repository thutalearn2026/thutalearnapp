part of 'resource_detail_bloc.dart';

@immutable
sealed class ResourceDetailEvent {}

class OnGetResourceDetail
    extends ResourceDetailEvent {
  final String chapterId;
  final String resourceId;

  OnGetResourceDetail({
    required this.chapterId,
    required this.resourceId,
  });
}