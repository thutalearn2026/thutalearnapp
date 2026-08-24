import 'dart:io';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:public_file_saver/public_file_saver.dart';
import 'package:thuta_learn/features/learn/learn.dart';

class ResourceDownloadResult {
  final String fileName;
  final String localFilePath;
  final String? publicPath;
  final String? publicUri;

  const ResourceDownloadResult({
    required this.fileName,
    required this.localFilePath,
    this.publicPath,
    this.publicUri,
  });

  String? get publicLocation {
    return publicPath ?? publicUri;
  }
}

class ResourceDownloadCanceledException implements Exception {
  const ResourceDownloadCanceledException();

  @override
  String toString() {
    return 'Resource download was cancelled.';
  }
}

@lazySingleton
class ResourceDownloadService {
  static const String androidDownloadFolder = 'Thuta Learn/Downloaded Resources';

  final PublicFileSaver _fileSaver = PublicFileSaver();

  // Use a separate Dio instance because resource files
  // may be hosted outside the authenticated API domain.
  final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(minutes: 5),
      followRedirects: true,
    ),
  );

  Future<DownloadedResourceRecord?> getDownloadedResource(
    String resourceId,
  ) {
    return DownloadedResourceBox.read(
      resourceId,
    );
  }

  Future<void> updateResourceMetadata(
    ChapterResourceModel resource,
  ) async {
    final record = await getDownloadedResource(resource.id);

    if (record == null) {
      return;
    }

    await DownloadedResourceBox.save(
      record.copyWith(
        resource: resource,
      ),
    );
  }

  Future<ResourceDownloadResult> download(
    ChapterResourceModel resource,
  ) async {
    final url = resource.fileUrl.trim();

    if (url.isEmpty) {
      throw StateError(
        'This resource does not contain a download URL.',
      );
    }

    final userId = DownloadedResourceBox.currentUserId;

    if (userId == null) {
      throw StateError(
        'Please log in before downloading resources.',
      );
    }

    final fileName = _createFileName(resource);
    final extension = _getFileExtension(resource);
    final mimeType = _getMimeType(resource);

    final documentsDirectory = await getApplicationDocumentsDirectory();

    final privateDirectory = Directory(
      '${documentsDirectory.path}/'
      'downloaded_resources/$userId',
    );

    if (!await privateDirectory.exists()) {
      await privateDirectory.create(
        recursive: true,
      );
    }

    final finalFile = File(
      '${privateDirectory.path}/'
      '${resource.id}.$extension',
    );

    final temporaryFile = File(
      '${privateDirectory.path}/'
      '${resource.id}.$extension.part',
    );

    if (await temporaryFile.exists()) {
      await temporaryFile.delete();
    }

    try {
      await _dio.download(
        url,
        temporaryFile.path,
        deleteOnError: true,
      );

      if (!await temporaryFile.exists() || await temporaryFile.length() == 0) {
        throw StateError(
          'The downloaded resource is empty.',
        );
      }

      final fileBytes = await temporaryFile.readAsBytes();

      final PublicSavedFile? publicFile;

      if (Platform.isAndroid) {
        publicFile = await _fileSaver.saveBytes(
          bytes: fileBytes,
          fileName: fileName,
          mimeType: mimeType,
          subDir: androidDownloadFolder,
        );
      } else {
        publicFile = await _fileSaver.saveBytesWithDialog(
          bytes: fileBytes,
          fileName: fileName,
          mimeType: mimeType,
        );
      }

      if (publicFile == null) {
        throw const ResourceDownloadCanceledException();
      }

      if (!publicFile.isSuccess) {
        throw StateError(
          'Unable to save this resource.',
        );
      }

      if (await finalFile.exists()) {
        await finalFile.delete();
      }

      await temporaryFile.rename(
        finalFile.path,
      );

      final record = DownloadedResourceRecord(
        resource: resource,
        fileName: publicFile.fileName,
        localFilePath: finalFile.path,
        publicPath: publicFile.path,
        publicUri: publicFile.uri,
        downloadedAt: DateTime.now(),
      );

      await DownloadedResourceBox.save(record);

      return ResourceDownloadResult(
        fileName: publicFile.fileName,
        localFilePath: finalFile.path,
        publicPath: publicFile.path,
        publicUri: publicFile.uri,
      );
    } catch (_) {
      if (await temporaryFile.exists()) {
        await temporaryFile.delete();
      }

      rethrow;
    }
  }

  String _createFileName(
    ChapterResourceModel resource,
  ) {
    var title = resource.title.trim().replaceAll('_', ' ');

    if (title.isEmpty) {
      title = 'Thuta Learn Resource';
    }

    title = PublicFileSaver.sanitizeFileName(
      title,
    );

    final extension = _getFileExtension(resource);

    if (title.toLowerCase().endsWith(
      '.$extension',
    )) {
      return title;
    }

    return '$title.$extension';
  }

  String _getFileExtension(
    ChapterResourceModel resource,
  ) {
    final type = resource.fileType.trim().toLowerCase();

    if (type.isNotEmpty && type != 'file') {
      switch (type) {
        case 'word':
          return 'docx';

        case 'audio':
          return 'mp3';

        default:
          return type;
      }
    }

    final uri = Uri.tryParse(
      resource.fileUrl,
    );

    final segments =
        uri?.pathSegments.where((segment) => segment.isNotEmpty).toList() ?? const <String>[];

    if (segments.isNotEmpty && segments.last.contains('.')) {
      final extension = segments.last.split('.').last.trim();

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
