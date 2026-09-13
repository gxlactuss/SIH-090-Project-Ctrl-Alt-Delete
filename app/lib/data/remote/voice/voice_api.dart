import 'dart:typed_data';

import '../../models/app_language.dart';

/// Speech in both directions, and translation between the app's languages.
///
/// Shaped like the speech station's `transcribe(path, lang)` and
/// `speak(text, lang)`, so the app can call Sarvam directly while the station
/// is being built and move onto the backend later without a screen noticing.
/// [SarvamVoiceApi] is the only implementation today.
abstract interface class VoiceApi {
  /// False once the service has refused us for the rest of the session: a
  /// wrong key, or no credits left. Callers go back to the phone's own
  /// engines rather than asking again for the same answer.
  bool get isAvailable;

  /// Which voice [speak] produces. Part of the name generated audio is kept
  /// under, so changing the voice never replays the old one.
  String get voiceName;

  /// The longest text one [speak] call accepts.
  int get maxSpeakChars;

  /// The longest recording one [transcribe] call accepts.
  Duration get maxClipLength;

  /// The words in the recording at [path], in [language] -- or in English
  /// when [toEnglish] is set, which is one call rather than a transcription
  /// followed by a translation.
  Future<Transcript> transcribe(
    String path,
    AppLanguage language, {
    bool toEnglish = false,
  });

  /// [text] read aloud in [language], as MP3 bytes.
  Future<Uint8List> speak(String text, AppLanguage language);

  Future<String> translate(
    String text, {
    required AppLanguage from,
    required AppLanguage to,
  });
}

class Transcript {
  const Transcript({required this.text, this.languageCode});

  /// Trimmed, and empty when nothing was heard.
  final String text;

  /// The language the service heard, which is not always the one it was
  /// told to expect.
  final String? languageCode;
}

enum VoiceFailure {
  /// No signal, a timeout, or a connection that dropped. Worth a retry.
  network,

  /// The key was refused. Nothing works again until it is replaced.
  unauthorized,

  /// The account has no credits left.
  outOfCredits,

  /// Too many requests at once. Worth a retry in a moment.
  rateLimited,

  /// The request itself was wrong: too long, an unreadable recording.
  rejected,

  /// The service failed on its side.
  server,

  /// Refused earlier in this session, so this call was never sent.
  unavailable,
}

class VoiceException implements Exception {
  const VoiceException(this.failure, [this.message]);

  final VoiceFailure failure;
  final String? message;

  @override
  String toString() => 'VoiceException(${failure.name}: ${message ?? ''})';
}
