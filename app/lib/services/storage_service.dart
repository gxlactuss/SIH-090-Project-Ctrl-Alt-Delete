import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// What 8.10 reports: how much of the phone this app is using, and what can
/// safely be cleared.
///
/// "Safely" is the whole design. A capture that has not been uploaded lives
/// in the same folder as one that has, and clearing the wrong one loses a
/// morning's work that exists nowhere else. So this only ever deletes the
/// folders of captures the queue says are already on the server.
class StorageService {
  StorageService({Future<Directory> Function()? documentsDirectory})
      : _documents = documentsDirectory ?? getApplicationDocumentsDirectory;

  final Future<Directory> Function() _documents;

  /// Where section 3 writes: one folder per capture, named by its id.
  Future<Directory> capturesDirectory() async {
    final root = await _documents();
    return Directory(p.join(root.path, 'captures'));
  }

  /// Total bytes under the captures folder. Zero when nothing has been
  /// captured, which is also what a phone that refuses the read reports --
  /// a storage screen is not worth an error dialog.
  Future<int> capturedBytes() async {
    try {
      final dir = await capturesDirectory();
      if (!await dir.exists()) return 0;
      var total = 0;
      await for (final entity in dir.list(recursive: true, followLinks: false)) {
        if (entity is File) total += await entity.length();
      }
      return total;
    } catch (_) {
      return 0;
    }
  }

  /// Deletes the folders of captures that are already on the server.
  ///
  /// [keepIds] is every capture the queue still has work to do on -- pending,
  /// failed, or being retried. Anything else on disk is a copy of something
  /// the server already has.
  ///
  /// Returns how many bytes went.
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
    } catch (_) {
      // Whatever was deleted before the failure is still freed, and the
      // screen reads the size again afterwards rather than trusting this.
    }
    return freed;
  }

  Future<int> _sizeOf(Directory dir) async {
    var total = 0;
    await for (final entity in dir.list(recursive: true, followLinks: false)) {
      if (entity is File) total += await entity.length();
    }
    return total;
  }

  /// Bytes as a person would say them. Whole numbers only: nobody needs
  /// 12.37 MB, and a decimal point is one more thing on the screen.
  static String formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).round()} KB';
    return '${(bytes / (1024 * 1024)).round()} MB';
  }
}
