import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:just_audio/just_audio.dart';

import '../data/models/app_language.dart';
import '../data/remote/voice/voice_api.dart';
import 'spoken_audio_cache.dart';

class SpeechService extends ChangeNotifier {
  SpeechService({FlutterTts? tts, this._voice, SpokenAudioCache? cache})
    : _tts = tts ?? FlutterTts(),
      _cache = cache ?? SpokenAudioCache();

  final FlutterTts _tts;

  final VoiceApi? _voice;
  final SpokenAudioCache _cache;

  AudioPlayer? _cloudPlayer;

  bool _cloudPlaybackBroken = false;

  Future<void> Function()? onBeforeSpeak;

  static const Duration _engineTimeout = Duration(seconds: 3);

  bool _ready = false;
  bool _available = true;

  String? _speakingKey;
  String? get speakingKey => _speakingKey;
  bool get isSpeaking => _speakingKey != null;

  bool get isAvailable => _available || _cloudUsable;

  bool get _cloudUsable =>
      (_voice?.isAvailable ?? false) && !_cloudPlaybackBroken;

  double _speed = 0.85;
  double get speed => _speed;

  bool _autoReadScreens = false;
  bool get autoReadScreens => _autoReadScreens;

  static const double _volume = 1.0;

  AppLanguage _language = AppLanguage.fallback;
  AppLanguage get language => _language;

  Future<void> init({
    AppLanguage? language,
    double? speed,
    bool? autoReadScreens,
  }) async {
    _language = language ?? _language;
    _speed = speed ?? _speed;
    _autoReadScreens = autoReadScreens ?? _autoReadScreens;

    try {
      await _tts.awaitSpeakCompletion(true).timeout(_engineTimeout);
      await _applyAudioAttributes();
      _tts.setCompletionHandler(_clearSpeaking);
      _tts.setCancelHandler(_clearSpeaking);
      _tts.setErrorHandler((_) => _clearSpeaking());
      await _applyVoice();
      _ready = _available;
    } catch (_) {
      _available = false;
    }
    notifyListeners();
  }

  Future<void> setLanguage(AppLanguage language) async {
    if (_language.code == language.code) return;
    _language = language;
    await stop();
    await _applyVoice();
    notifyListeners();
  }

  Future<void> setSpeed(double speed) async {
    _speed = speed.clamp(0.4, 1.4);
    await _applyVoice();
    await _applyToCloudPlayer();
    notifyListeners();
  }

  void setAutoReadScreens(bool value) {
    if (_autoReadScreens == value) return;
    _autoReadScreens = value;
    notifyListeners();
  }

  Future<void> speak(String text, {String? key}) async {
    if (!isAvailable || text.trim().isEmpty) return;
    final id = key ?? text;

    if (_speakingKey == id) {
      await stop();
      return;
    }

    await stop();
    await onBeforeSpeak?.call();
    _speakingKey = id;
    notifyListeners();

    if (!await _speakWithCloud(text, _language, id) && _available) {
      try {
        if (!_ready) await init();
        await _tts.speak(text);
      } catch (_) {
        _available = false;
      }
    }
    if (_speakingKey == id) _clearSpeaking();
  }

  Future<void> speakAll(Iterable<String?> lines, {String? key}) {
    final text = lines
        .whereType<String>()
        .map((l) => l.trim())
        .where((l) => l.isNotEmpty)
        .join('. ');
    return speak(text, key: key);
  }

  Future<void> speakIn(AppLanguage language, String text, {String? key}) async {
    if (!isAvailable || text.trim().isEmpty) return;
    final id = key ?? '${language.code}:$text';

    if (_speakingKey == id) {
      await stop();
      return;
    }

    await stop();
    _speakingKey = id;
    notifyListeners();

    if (!await _speakWithCloud(text, language, id) && _available) {
      try {
        if (!_ready) await init();
        await _tts.setLanguage(language.ttsLocale);
        await _tts.speak(text);
      } catch (_) {
        _available = false;
      } finally {
        await _applyVoice();
      }
    }
    if (_speakingKey == id) _clearSpeaking();
  }

  Future<void> stop() async {
    if (_speakingKey == null) return;
    try {
      await _tts.stop();
    } catch (_) {}
    try {
      await _cloudPlayer?.pause();
    } catch (_) {}
    _clearSpeaking();
  }

  Future<bool> _speakWithCloud(
    String text,
    AppLanguage language,
    String id,
  ) async {
    final voice = _voice;
    if (voice == null || !_cloudUsable) return false;
    if (text.runes.length > voice.maxSpeakChars) return false;

    final String path;
    try {
      path = await _cache.resolve(
        voice: voice.voiceName,
        languageCode: language.code,
        text: text,
        fetch: () => voice.speak(text, language),
      );
    } catch (error) {
      if (kDebugMode) debugPrint('[speech] cloud voice: $error');
      return false;
    }

    try {
      if (_speakingKey != id) return true;
      final player = _cloudPlayer ??= AudioPlayer();
      await player.setFilePath(path);
      await _applyToCloudPlayer();
      if (_speakingKey != id) return true;
      await player.play();
      return true;
    } catch (error) {
      if (kDebugMode) {
        debugPrint('[speech] cannot play generated audio: $error');
      }
      _cloudPlaybackBroken = true;
      return false;
    }
  }

  Future<void> _applyToCloudPlayer() async {
    final player = _cloudPlayer;
    if (player == null) return;
    try {
      await player.setVolume(_volume);
      await player.setSpeed(_speed);
    } catch (_) {}
  }

  Future<void> _applyVoice() async {
    if (!_available) return;
    try {
      await _tts.setLanguage(_language.ttsLocale).timeout(_engineTimeout);
      await _tts.setSpeechRate(_speed * 0.5).timeout(_engineTimeout);
      await _tts.setPitch(1.0).timeout(_engineTimeout);
      await _tts.setVolume(_volume).timeout(_engineTimeout);
    } catch (_) {
      _available = false;
    }
  }

  Future<void> _applyAudioAttributes() async {
    try {
      await _tts.setAudioAttributesForNavigation().timeout(_engineTimeout);
    } catch (_) {}
  }

  Future<void> speakIfAuto(Iterable<String?> lines, {String? key}) {
    if (!_autoReadScreens) return Future<void>.value();
    return speakAll(lines, key: key);
  }

  void _clearSpeaking() {
    if (_speakingKey == null) return;
    _speakingKey = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _tts.stop();
    _cloudPlayer?.dispose();
    super.dispose();
  }
}
