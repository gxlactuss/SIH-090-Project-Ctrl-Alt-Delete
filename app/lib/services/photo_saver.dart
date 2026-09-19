import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart' show rootBundle;
import 'package:gal/gal.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

enum PhotoSaveResult { saved, denied, failed }

class PhotoSaver {
  const PhotoSaver({http.Client? client}) : _client = client;

  final http.Client? _client;

  Future<PhotoSaveResult> save(
    String source, {
    Map<String, String>? headers,
    String? album,
  }) async {
    try {
      if (!await Gal.hasAccess(toAlbum: album != null)) {
        if (!await Gal.requestAccess(toAlbum: album != null)) {
          return PhotoSaveResult.denied;
        }
      }

      if (!source.startsWith('http') && !source.startsWith('assets/')) {
        final file = File(source);
        if (!file.existsSync()) return PhotoSaveResult.failed;
        await Gal.putImage(file.path, album: album);
        return PhotoSaveResult.saved;
      }

      final bytes = source.startsWith('assets/')
          ? (await rootBundle.load(source)).buffer.asUint8List()
          : await _download(source, headers);
      if (bytes == null || bytes.isEmpty) return PhotoSaveResult.failed;

      final cache = await getTemporaryDirectory();
      final name = p.basename(Uri.parse(source).path);
      final scratch = File(
        p.join(
          cache.path,
          name.contains('.')
              ? name
              : 'kirtikar-${DateTime.now().millisecondsSinceEpoch}.jpg',
        ),
      );
      await scratch.writeAsBytes(bytes, flush: true);
      try {
        await Gal.putImage(scratch.path, album: album);
      } finally {
        try {
          if (scratch.existsSync()) await scratch.delete();
        } catch (_) {}
      }
      return PhotoSaveResult.saved;
    } on GalException catch (error) {
      return error.type == GalExceptionType.accessDenied
          ? PhotoSaveResult.denied
          : PhotoSaveResult.failed;
    } catch (_) {
      return PhotoSaveResult.failed;
    }
  }

  Future<Uint8List?> _download(String url, Map<String, String>? headers) async {
    final client = _client ?? http.Client();
    try {
      final response = await client
          .get(Uri.parse(url), headers: headers)
          .timeout(const Duration(seconds: 30));
      if (response.statusCode != 200) return null;
      return response.bodyBytes;
    } catch (_) {
      return null;
    } finally {
      if (_client == null) client.close();
    }
  }
}
