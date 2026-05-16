import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../core/constants/app_identity.dart';

enum StorageBucket {
  hurufImages('images/huruf'),
  bendaImages('images/benda'),
  badgeImages('images/badge'),
  profileImages('images/profile'),
  hurufAudio('audio/huruf'),
  angkaAudio('audio/angka'),
  iqraAudio('audio/iqra'),
  songVideos('video/lagu_anak'),
  cache('cache');

  const StorageBucket(this.relativePath);

  final String relativePath;
}

class LocalStorageService {
  LocalStorageService._();

  static final instance = LocalStorageService._();

  Directory? _rootDirectory;

  Future<Directory> rootDirectory() async {
    final existing = _rootDirectory;
    if (existing != null) return existing;
    final base = await getApplicationSupportDirectory();
    final root = Directory(p.join(base.path, AppIdentity.storageRoot));
    await root.create(recursive: true);
    _rootDirectory = root;
    return root;
  }

  Future<void> ensureReady() async {
    if (kIsWeb) return;
    await rootDirectory();
    for (final bucket in StorageBucket.values) {
      await bucketDirectory(bucket);
    }
  }

  Future<Directory> bucketDirectory(StorageBucket bucket) async {
    final root = await rootDirectory();
    final dir = Directory(p.join(root.path, bucket.relativePath));
    await dir.create(recursive: true);
    return dir;
  }

  Future<String> saveBytes({
    required Uint8List bytes,
    required StorageBucket bucket,
    required String fileName,
  }) async {
    if (kIsWeb) {
      final mime = _mimeTypeFromFileName(fileName);
      return 'data:$mime;base64,${base64Encode(bytes)}';
    }
    await ensureReady();
    final dir = await bucketDirectory(bucket);
    final safeName = _safeFileName(fileName);
    final path = p.join(dir.path, safeName);
    final file = File(path);
    await file.writeAsBytes(bytes, flush: true);
    return file.path;
  }

  Future<String> ensureAssetFile({
    required String assetPath,
    required StorageBucket bucket,
    required String fileName,
  }) async {
    if (kIsWeb) {
      return assetPath;
    }
    final dir = await bucketDirectory(bucket);
    final path = p.join(dir.path, _safeFileName(fileName));
    final file = File(path);
    if (await file.exists()) return file.path;
    final data = await rootBundle.load(assetPath);
    await file.writeAsBytes(data.buffer.asUint8List(), flush: true);
    return file.path;
  }

  Future<String?> persistDataUri(
    String dataUri, {
    required StorageBucket bucket,
    required String fileName,
  }) async {
    if (!dataUri.startsWith('data:') || !dataUri.contains(',')) return null;
    if (kIsWeb) return dataUri;
    try {
      final payload = dataUri.split(',').last;
      final bytes = base64Decode(payload);
      return saveBytes(bytes: bytes, bucket: bucket, fileName: fileName);
    } catch (_) {
      return null;
    }
  }

  Future<void> deleteFile(String path) async {
    if (kIsWeb) return;
    if (path.isEmpty) return;
    final file = File(path);
    if (await file.exists()) {
      await file.delete();
    }
  }

  String _mimeTypeFromFileName(String fileName) {
    final lower = fileName.toLowerCase();
    if (lower.endsWith('.png')) return 'image/png';
    if (lower.endsWith('.jpg') || lower.endsWith('.jpeg')) return 'image/jpeg';
    if (lower.endsWith('.webp')) return 'image/webp';
    if (lower.endsWith('.gif')) return 'image/gif';
    if (lower.endsWith('.mp3')) return 'audio/mpeg';
    if (lower.endsWith('.wav')) return 'audio/wav';
    if (lower.endsWith('.ogg')) return 'audio/ogg';
    if (lower.endsWith('.m4a')) return 'audio/mp4';
    if (lower.endsWith('.mp4')) return 'video/mp4';
    if (lower.endsWith('.webm')) return 'video/webm';
    return 'application/octet-stream';
  }

  String _safeFileName(String fileName) {
    final cleaned = fileName.trim().replaceAll(RegExp(r'[^A-Za-z0-9._-]'), '_');
    return cleaned.isEmpty
        ? 'file_${DateTime.now().millisecondsSinceEpoch}'
        : cleaned;
  }
}
