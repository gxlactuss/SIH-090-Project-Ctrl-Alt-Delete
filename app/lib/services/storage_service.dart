import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class StorageService {
  StorageService({Future<Directory> Function()? documentsDirectory})
    : _documents = documentsDirectory ?? getApplicationDocumentsDirectory;

  final Future<Directory> Function() _documents;

  Future<Directory> capturesDirectory() async {
    final root = await _documents();
    return Directory(p.join(root.path, 'captures'));
  }

  Future<int> capturedBytes() async {
    try {
      final dir = await capturesDirectory();
      if (!await dir.exists()) return 0;
      var total = 0;
      await for (final entity in dir.list(
        recursive: true,
        followLinks: false,
      )) {
        if (entity is File) total += await entity.length();
      }
      return total;
    } catch (_) {
      return 0;
    }
  }

  Future<int> clearUploaded({required Set<String> keepIds}) async {
    var freed = 0;
    try {
      final dir = await capturesDirectory();
      if (!await dir.exists()) return 0;

      await for (final entity in dir.list(followLinks: false)) {
        if (entity is! Directory) continue;
        final id = p.basename(entity.path);
        if (keepIds.contains(id)) continue;

        freed += await _sizeOf(entity);
        await entity.delete(recursive: true);
      }
    } catch (_) {}
    return freed;
  }

  Future<int> _sizeOf(Directory dir) async {
    var total = 0;
    await for (final entity in dir.list(recursive: true, followLinks: false)) {
      if (entity is File) total += await entity.length();
    }
    return total;
  }

  static String formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).round()} KB';
    return '${(bytes / (1024 * 1024)).round()} MB';
  }
}
