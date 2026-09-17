import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Generated speech kept on the phone, one file per sentence per voice.
///
/// Nearly everything the app says is a fixed string, so only the first press
/// of a speaker button is paid for. Every press after that costs no credits,
/// needs no signal and starts at once.
///
/// Lives in the cache directory, which the system may empty when the phone
/// runs short of space. Losing it costs a few paise to rebuild; nothing the
/// seller made is ever in here.
class SpokenAudioCache {
  SpokenAudioCache({Future<Directory> Function()? directory})
      : _directory = directory ?? getApplicationCacheDirectory;

  final Future<Directory> Function() _directory;

  /// The path of the audio for [text], calling [fetch] only if it is not
  /// already on disk.
  ///
  /// [voice] is part of the name, so a different speaker is a different file
  /// rather than yesterday's voice replayed.
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
    // Written aside and then renamed, so an app killed mid-write leaves no
    // half a sentence to be played back as if it were the whole one.
    final partial = File('${file.path}.part');
    await partial.writeAsBytes(audio, flush: true);
    await partial.rename(file.path);
    return file.path;
  }
}
