import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../../core/config/sarvam_config.dart';
import '../../models/app_language.dart';
import 'voice_api.dart';

/// Sarvam's language codes: the app's speech locales, except for Odia, which
/// Flutter calls "or" and Sarvam calls "od-IN".
extension SarvamLanguage on AppLanguage {
  String get sarvamCode => code == 'or' ? 'od-IN' : ttsLocale;
}

/// [VoiceApi] straight to Sarvam, for the coding phase only.
///
/// The key is compiled into the build, and anyone holding the APK can read it
/// back out. That is an acceptable risk for a free-credit development key and
/// for nothing else: a shipped app talks to the speech station, and the key
/// lives only on the server.
///
/// One instance is shared by every caller, so a refusal one of them learns --
/// a bad key, no credits left -- is known to all of them at once.
class SarvamVoiceApi implements VoiceApi {
  SarvamVoiceApi({
    required this._apiKey,
    http.Client? client,
    this.speaker = SarvamConfig.ttsSpeaker,
  }) : _client = client ?? http.Client();

  final String _apiKey;
  final http.Client _client;
  final String speaker;

  bool _refused = false;

  double _spent = 0;

  /// Roughly what this session has spent, in rupees, from the published
  /// rates. Printed to the debug log after every call.
  double get estimatedSpend => _spent;

  @override
  bool get isAvailable => !_refused;

  @override
  String get voiceName => 'sarvam/${SarvamConfig.ttsModel}/$speaker';

  @override
  int get maxSpeakChars => SarvamConfig.maxSpeakChars;

  @override
  Duration get maxClipLength => SarvamConfig.maxClipLength;

  @override
  Future<Transcript> transcribe(
    String path,
    AppLanguage language, {
    bool toEnglish = false,
  }) async {
    final file = File(path);
    if (!await file.exists()) {
      throw VoiceException(VoiceFailure.rejected, 'no recording at $path');
    }

    final request = http.MultipartRequest('POST', _endpoint('speech-to-text'))
      ..headers.addAll(_headers)
      ..fields['model'] = SarvamConfig.sttModel
      ..fields['mode'] = toEnglish ? 'translate' : 'transcribe'
      ..fields['language_code'] = language.sarvamCode
      ..files.add(await http.MultipartFile.fromPath('file', path));

    final body = await _send(request, SarvamConfig.transcribeTimeout);

    // The app records speech at 32 kbps, which is enough to turn the size
    // back into a length for the estimate.
    final seconds = await file.length() * 8 / 32000;
    _charge('transcribe',
        seconds / 3600 * SarvamConfig.rupeesPerTranscribedHour);

    return Transcript(
      text: (body['transcript'] as String? ?? '').trim(),
      languageCode: body['language_code'] as String?,
    );
  }

  @override
  Future<Uint8List> speak(String text, AppLanguage language) async {
    final length = text.runes.length;
    if (length > maxSpeakChars) {
      throw VoiceException(
          VoiceFailure.rejected, '$length characters, over $maxSpeakChars');
    }

    final body = await _send(
      _json('text-to-speech', {
        'text': text,
        // As the reference names it in September 2026. Older versions of the
        // API called this target_language_code: if speech starts coming back
        // 400 or 422, this is the first field to look at.
        'language_code': language.sarvamCode,
        'model': SarvamConfig.ttsModel,
        'speaker': speaker,
        // MP3 rather than the default WAV: about a fifth of the download, and
        // it is what the phone keeps on disk.
        'output_audio_codec': 'mp3',
        'speech_sample_rate': 22050,
      }),
      SarvamConfig.speakTimeout,
    );

    final audios = body['audios'];
    if (audios is! List || audios.isEmpty) {
      throw const VoiceException(VoiceFailure.server, 'no audio came back');
    }
    // Long text can come back in pieces. MP3 frames play straight through
    // when joined, which is why the codec above is not WAV.
    final audio = BytesBuilder(copy: false);
    for (final piece in audios) {
      audio.add(base64Decode(piece as String));
    }

    _charge('speak',
        length / 1000 * SarvamConfig.rupeesPerSpokenThousandChars);
    return audio.takeBytes();
  }

  @override
  Future<String> translate(
    String text, {
    required AppLanguage from,
    required AppLanguage to,
  }) async {
    if (from.code == to.code) return text;
    final length = text.runes.length;
    if (length > SarvamConfig.maxTranslateChars) {
      throw VoiceException(VoiceFailure.rejected,
          '$length characters, over ${SarvamConfig.maxTranslateChars}');
    }

    final body = await _send(
      _json('translate', {
        'input': text,
        'source_language_code': from.sarvamCode,
        'target_language_code': to.sarvamCode,
        'model': SarvamConfig.translateModel,
      }),
      SarvamConfig.translateTimeout,
    );

    _charge('translate',
        length / 1000 * SarvamConfig.rupeesPerTranslatedThousandChars);
    return (body['translated_text'] as String? ?? '').trim();
  }

  Map<String, String> get _headers => {'api-subscription-key': _apiKey};

  Uri _endpoint(String path) => Uri.parse('${SarvamConfig.baseUrl}/$path');

  http.Request _json(String path, Map<String, Object?> body) =>
      http.Request('POST', _endpoint(path))
        ..headers.addAll(_headers)
        // Before the body, so the body is sent as UTF-8: most of what this
        // app says is not Latin script.
        ..headers['content-type'] = 'application/json'
        ..body = jsonEncode(body);

  Future<Map<String, Object?>> _send(
    http.BaseRequest request,
    Duration timeout,
  ) async {
    if (_refused) {
      throw const VoiceException(
          VoiceFailure.unavailable, 'refused earlier this session');
    }

    final http.Response response;
    try {
      response = await _client
          .send(request)
          .then(http.Response.fromStream)
          .timeout(timeout);
    } on TimeoutException {
      throw const VoiceException(VoiceFailure.network, 'timed out');
    } on SocketException catch (error) {
      throw VoiceException(VoiceFailure.network, error.message);
    } on http.ClientException catch (error) {
      throw VoiceException(VoiceFailure.network, error.message);
    }

    if (response.statusCode != 200) throw _refusal(response);

    try {
      return jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, Object?>;
    } catch (_) {
      throw const VoiceException(VoiceFailure.server, 'unreadable response');
    }
  }

  /// Sarvam names the reason in the body, and the reason matters more than
  /// the status: a 429 is either "slow down" or "no credits left", and only
  /// one of those gets better by waiting.
  VoiceException _refusal(http.Response response) {
    String? code;
    String? message;
    try {
      final error =
          (jsonDecode(response.body) as Map<String, Object?>)['error'];
      if (error is Map<String, Object?>) {
        code = error['code'] as String?;
        message = error['message'] as String?;
      }
    } catch (_) {
      // Not JSON -- a proxy's error page, or nothing. The status will do.
    }

    final failure = switch ((response.statusCode, code)) {
      (_, 'insufficient_quota_error') => VoiceFailure.outOfCredits,
      (_, 'invalid_api_key_error' || 'authentication_error') =>
        VoiceFailure.unauthorized,
      (401 || 403, _) => VoiceFailure.unauthorized,
      (429, _) => VoiceFailure.rateLimited,
      (>= 500, _) => VoiceFailure.server,
      _ => VoiceFailure.rejected,
    };

    // Neither of these changes by asking again, and every attempt would be
    // another wait before the phone's own voice gets its turn.
    if (failure == VoiceFailure.unauthorized ||
        failure == VoiceFailure.outOfCredits) {
      _refused = true;
    }

    if (kDebugMode) {
      debugPrint('[sarvam] ${response.statusCode} ${code ?? ''} '
          '${message ?? ''}${_refused ? ' -- off for this session' : ''}');
    }
    return VoiceException(failure, message ?? 'HTTP ${response.statusCode}');
  }

  void _charge(String what, double rupees) {
    _spent += rupees;
    if (kDebugMode) {
      debugPrint('[sarvam] $what ≈ ₹${rupees.toStringAsFixed(2)} '
          '(this session ≈ ₹${_spent.toStringAsFixed(2)})');
    }
  }
}
