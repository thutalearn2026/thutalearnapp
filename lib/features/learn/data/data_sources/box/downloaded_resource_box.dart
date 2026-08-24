import 'dart:convert';
import 'dart:io';

import 'package:hive_ce/hive.dart';
import 'package:thuta_learn/features/authentication/data/data_sources/box/auth_session_box.dart';
import 'package:thuta_learn/features/learn/data/models/module_content_model.dart';

class DownloadedResourceRecord {
  final ChapterResourceModel resource;
  final String fileName;
  final String localFilePath;
  final String? publicPath;
  final String? publicUri;
  final DateTime downloadedAt;

  const DownloadedResourceRecord({
    required this.resource,
    required this.fileName,
    required this.localFilePath,
    this.publicPath,
    this.publicUri,
    required this.downloadedAt,
  });

  String? get publicLocation {
    return publicPath ?? publicUri;
  }

  DownloadedResourceRecord copyWith({
    ChapterResourceModel? resource,
    String? fileName,
    String? localFilePath,
    String? publicPath,
    String? publicUri,
    DateTime? downloadedAt,
  }) {
    return DownloadedResourceRecord(
      resource: resource ?? this.resource,
      fileName: fileName ?? this.fileName,
      localFilePath:
      localFilePath ?? this.localFilePath,
      publicPath: publicPath ?? this.publicPath,
      publicUri: publicUri ?? this.publicUri,
      downloadedAt:
      downloadedAt ?? this.downloadedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'resource': resource.toJson(),
      'file_name': fileName,
      'local_file_path': localFilePath,
      'public_path': publicPath,
      'public_uri': publicUri,
      'downloaded_at':
      downloadedAt.toIso8601String(),
    };
  }

  factory DownloadedResourceRecord.fromJson(
      Map<String, dynamic> json,
      ) {
    return DownloadedResourceRecord(
      resource: ChapterResourceModel.fromJson(
        Map<String, dynamic>.from(
          json['resource'] as Map,
        ),
      ),
      fileName: json['file_name'] as String,
      localFilePath:
      json['local_file_path'] as String,
      publicPath: json['public_path'] as String?,
      publicUri: json['public_uri'] as String?,
      downloadedAt:
      DateTime.tryParse(
        json['downloaded_at']?.toString() ?? '',
      ) ??
          DateTime.now(),
    );
  }
}

class DownloadedResourceBox {
  static const String boxName =
      'downloaded_resource_box';

  static Box<dynamic> get _box {
    return Hive.box<dynamic>(boxName);
  }

  static String? get currentUserId {
    final userId = AuthSessionBox.user?['id'];

    if (userId == null) {
      return null;
    }

    final value = userId.toString().trim();

    return value.isEmpty ? null : value;
  }

  static String _userPrefix(String userId) {
    return 'downloaded_resource_${userId}_';
  }

  static String _cacheKey({
    required String userId,
    required String resourceId,
  }) {
    return '${_userPrefix(userId)}$resourceId';
  }

  static Future<DownloadedResourceRecord?> read(
      String resourceId,
      ) async {
    final userId = currentUserId;

    if (userId == null) {
      return null;
    }

    final key = _cacheKey(
      userId: userId,
      resourceId: resourceId,
    );

    final rawValue = _box.get(key);

    if (rawValue is! String || rawValue.isEmpty) {
      return null;
    }

    try {
      final decoded = jsonDecode(rawValue);

      if (decoded is! Map<String, dynamic>) {
        await _box.delete(key);
        return null;
      }

      final record =
      DownloadedResourceRecord.fromJson(decoded);

      if (record.resource.id != resourceId) {
        await _box.delete(key);
        return null;
      }

      final localFile = File(
        record.localFilePath,
      );

      if (!await localFile.exists()) {
        await _box.delete(key);
        return null;
      }

      return record;
    } catch (_) {
      await _box.delete(key);
      return null;
    }
  }

  static Future<void> save(
      DownloadedResourceRecord record,
      ) async {
    final userId = currentUserId;

    if (userId == null) {
      throw StateError(
        'An authenticated user is required.',
      );
    }

    await _box.put(
      _cacheKey(
        userId: userId,
        resourceId: record.resource.id,
      ),
      jsonEncode(record.toJson()),
    );
  }

  static Future<void> clearCurrentUser({
    bool deletePrivateFiles = true,
  }) async {
    final userId = currentUserId;

    if (userId == null) {
      return;
    }

    final prefix = _userPrefix(userId);

    final keys = _box.keys.where((key) {
      return key is String && key.startsWith(prefix);
    }).toList();

    if (deletePrivateFiles) {
      for (final key in keys) {
        final rawValue = _box.get(key);

        if (rawValue is! String) {
          continue;
        }

        try {
          final decoded = jsonDecode(rawValue);

          if (decoded is! Map<String, dynamic>) {
            continue;
          }

          final path =
          decoded['local_file_path']?.toString();

          if (path == null || path.isEmpty) {
            continue;
          }

          final file = File(path);

          if (await file.exists()) {
            await file.delete();
          }
        } catch (_) {
          // Continue clearing other records.
        }
      }
    }

    if (keys.isNotEmpty) {
      await _box.deleteAll(keys);
    }
  }
}