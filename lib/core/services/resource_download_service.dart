import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:public_file_saver/public_file_saver.dart';
import 'package:thuta_learn/features/learn/learn.dart';

class ResourceDownloadResult {
  final String fileName;
  final String? path;
  final String? uri;

  const ResourceDownloadResult({
    required this.fileName,
    this.path,
    this.uri,
  });

  String? get location {
    return path ?? uri;
  }
}

class ResourceDownloadCanceledException
    implements Exception {
  const ResourceDownloadCanceledException();

  @override
  String toString() {
    return 'Resource download was cancelled.';
  }
}

@lazySingleton
class ResourceDownloadService {
  static const String androidDownloadFolder =
      'Thuta Learn/Downloaded Resources';

  final PublicFileSaver _fileSaver =
  PublicFileSaver();

  Future<ResourceDownloadResult> download(
      ChapterResourceModel resource,
      ) async {
    final url = resource.fileUrl.trim();

    if (url.isEmpty) {
      throw StateError(
        'This resource does not contain a download URL.',
      );
    }

    final fileName = _createFileName(resource);
    final mimeType = _getMimeType(resource);

    final PublicSavedFile? savedFile;

    if (Platform.isAndroid) {
      savedFile = await _fileSaver.saveFromUrl(
        url: url,
        fileName: fileName,
        mimeType: mimeType,
        subDir: androidDownloadFolder,
        useDialog: false,
      );
    } else if (Platform.isIOS) {
      // iOS uses the native Save to Files dialog.
      // This avoids exposing the private video directory.
      savedFile = await _fileSaver.saveFromUrl(
        url: url,
        fileName: fileName,
        mimeType: mimeType,
        useDialog: true,
      );
    } else {
      savedFile = await _fileSaver.saveFromUrl(
        url: url,
        fileName: fileName,
        mimeType: mimeType,
        useDialog: true,
      );
    }

    if (savedFile == null) {
      throw const ResourceDownloadCanceledException();
    }

    if (!savedFile.isSuccess) {
      throw StateError(
        'Unable to save this resource.',
      );
    }

    return ResourceDownloadResult(
      fileName: savedFile.fileName,
      path: savedFile.path,
      uri: savedFile.uri,
    );
  }

  String _createFileName(
      ChapterResourceModel resource,
      ) {
    var title = resource.title
        .trim()
        .replaceAll('_', ' ');

    if (title.isEmpty) {
      title = 'Thuta Learn Resource';
    }

    title = PublicFileSaver.sanitizeFileName(
      title,
    );

    final extension =
    _getFileExtension(resource);

    final lowerTitle = title.toLowerCase();

    if (lowerTitle.endsWith(
      '.$extension',
    )) {
      return title;
    }

    return '$title.$extension';
  }

  String _getFileExtension(
      ChapterResourceModel resource,
      ) {
    final fileType =
    resource.fileType.trim().toLowerCase();

    if (fileType.isNotEmpty &&
        fileType != 'file') {
      switch (fileType) {
        case 'word':
          return 'docx';

        case 'audio':
          return 'mp3';

        default:
          return fileType;
      }
    }

    final uri = Uri.tryParse(
      resource.fileUrl,
    );

    final path = uri?.path ?? '';

    final lastSegment = path
        .split('/')
        .where((segment) => segment.isNotEmpty)
        .lastOrNull;

    if (lastSegment != null &&
        lastSegment.contains('.')) {
      final extension =
          lastSegment.split('.').last;

      if (extension.isNotEmpty) {
        return extension.toLowerCase();
      }
    }

    return 'pdf';
  }

  String _getMimeType(
      ChapterResourceModel resource,
      ) {
    switch (_getFileExtension(resource)) {
      case 'pdf':
        return 'application/pdf';

      case 'doc':
        return 'application/msword';

      case 'docx':
        return 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';

      case 'xls':
        return 'application/vnd.ms-excel';

      case 'xlsx':
        return 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';

      case 'ppt':
        return 'application/vnd.ms-powerpoint';

      case 'pptx':
        return 'application/vnd.openxmlformats-officedocument.presentationml.presentation';

      case 'mp3':
        return 'audio/mpeg';

      case 'wav':
        return 'audio/wav';

      case 'm4a':
        return 'audio/mp4';

      case 'zip':
        return 'application/zip';

      case 'txt':
        return 'text/plain';

      default:
        return 'application/octet-stream';
    }
  }
}