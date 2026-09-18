import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class SpokenAudioCache {
  SpokenAudioCache({Future<Directory> Function()? directory})
    : _directory = directory ?? getApplicationCacheDirectory;

  final Future<Directory> Function() _directory;

  Future<String> resolve({
    required String voice,
    required String languageCode,
    required String text,
    required Future<Uint8List> Function() fetch,
  }) async {
    final root = await _directory();
    final folder = Directory(p.join(root.path, 'spoken'));
    final name = sha1.convert(utf8.encode('$voice|$languageCode|$text'));
    final file = File(p.join(folder.path, '$name.mp3'));

    if (await file.exists() && await file.length() > 0) return file.path;

    final audio = await fetch();
    await folder.create(recursive: true);
    final partial = File('${file.path}.part');
    await partial.writeAsBytes(audio, flush: true);
    await partial.rename(file.path);
    return file.path;
  }
}
