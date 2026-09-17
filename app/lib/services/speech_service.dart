import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:just_audio/just_audio.dart';

import '../data/models/app_language.dart';
import '../data/remote/voice/voice_api.dart';
import 'spoken_audio_cache.dart';

/// Reads text aloud. The single most load-bearing service in the app.
///
/// Every speaker button, every spoken prompt and every "read this screen
/// aloud on open" goes through this one instance, so that starting a new
/// utterance always stops the previous one -- two voices at once is worse
/// than no voice at all.
///
/// Two voices sit behind it. The cloud voice, when the build has a key, is
/// tried first: it speaks all eleven languages naturally, where many phones
/// have no Odia or Punjabi voice at all. The phone's own engine takes over
/// whenever the cloud cannot -- no key, no signal, no credits left.
///
/// Nothing here ever throws at the UI. A phone with no TTS engine, or with no
/// voice data for the chosen language, degrades to a silent app rather than a
/// broken one.
class SpeechService extends ChangeNotifier {
  SpeechService({FlutterTts? tts, this._voice, SpokenAudioCache? cache})
      : _tts = tts ?? FlutterTts(),
        _cache = cache ?? SpokenAudioCache();

  final FlutterTts _tts;

  /// Null without a key, which is every test and every build not given one:
  /// the app then speaks exactly as it did before there was a cloud voice.
  final VoiceApi? _voice;
  final SpokenAudioCache _cache;

  /// Plays what [_voice] generated. Built on first use, like
  /// [PlayerService]'s, because constructing one reaches for the platform.
  AudioPlayer? _cloudPlayer;

  /// Set when this phone cannot play generated audio. Every later utterance
  /// then goes straight to the engine, rather than paying for audio that
  /// will never be heard.
  bool _cloudPlaybackBroken = false;

  /// The other half of the rule in [PlayerService]: anything else playing is
  /// stopped before the app says a word. Optional, because most of the app
  /// has no player anywhere near it.
  Future<void> Function()? onBeforeSpeak;

  /// How long we wait for the engine to answer before deciding it is not
  /// there. A missing or wedged TTS engine must never hold up a screen: the
  /// app has to draw silently instead of not drawing at all.
  static const Duration _engineTimeout = Duration(seconds: 3);

  bool _ready = false;
  bool _available = true;

  /// Which utterance is playing, so the button that started it can animate
  /// and the rest of the screen can stay still. Null when silent.
  String? _speakingKey;
  String? get speakingKey => _speakingKey;
  bool get isSpeaking => _speakingKey != null;

  /// True while either voice can still speak. Screens use it to hide speaker
  /// buttons that would do nothing.
  bool get isAvailable => _available || _cloudUsable;

  bool get _cloudUsable =>
      (_voice?.isAvailable ?? false) && !_cloudPlaybackBroken;

  /// Generated speech is too fast for a first-time user, so the default sits
  /// below normal and 8.8 Voice settings can lower it further.
  double _speed = 0.85;
  double get speed => _speed;

  /// "Read this screen aloud on open".
  ///
  /// Off by default. Speech that starts on its own talks over the seller,
  /// keeps talking while they read, and gives them nothing to press to stop
  /// it -- so the voice now waits to be asked. Every screen still carries a
  /// speaker button, and 8.8 can turn this back on for a seller who wants it.
  bool _autoReadScreens = false;
  bool get autoReadScreens => _autoReadScreens;

  /// Playback volume, 0 to 1. Full by default: this is the loudest the
  /// engine will go, and the seller is often outdoors or near a loom.
  double _volume = 1.0;
  double get volume => _volume;

  AppLanguage _language = AppLanguage.fallback;
  AppLanguage get language => _language;

  Future<void> init({
    AppLanguage? language,
    double? speed,
    bool? autoReadScreens,
    double? volume,
  }) async {
    _language = language ?? _language;
    _speed = speed ?? _speed;
    _autoReadScreens = autoReadScreens ?? _autoReadScreens;
    _volume = volume ?? _volume;

    try {
      await _tts.awaitSpeakCompletion(true).timeout(_engineTimeout);
      // Android plays TTS on the media stream by default, which sits at
      // whatever the seller last left their music at -- often near silent.
      // Navigation attributes move it to the guidance stream, which ducks
      // other audio and is what turn-by-turn apps use to be heard in a
      // noisy room.
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

  Future<void> setVolume(double volume) async {
    _volume = volume.clamp(0.0, 1.0);
    await _applyVoice();
    await _applyToCloudPlayer();
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

  /// Speaks [text], stopping whatever was already speaking.
  ///
  /// [key] identifies the utterance so the widget that owns it can show a
  /// playing state. Pass the same key to [speak] again to stop it, which is
  /// what tapping a speaker button twice should do.
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
    // awaitSpeakCompletion means we are back here when the voice finishes,
    // but the cancel handler may have beaten us to it.
    if (_speakingKey == id) _clearSpeaking();
  }

  /// Speaks several lines as one utterance, which is what "read this screen
  /// aloud" means: title, then body, then the action.
  Future<void> speakAll(Iterable<String?> lines, {String? key}) {
    final text = lines
        .whereType<String>()
        .map((l) => l.trim())
        .where((l) => l.isNotEmpty)
        .join('. ');
    return speak(text, key: key);
  }

  /// Speaks [text] in [language] whatever the app language is, then puts the
  /// engine back. This is what the speaker beside each tile on the language
  /// picker needs: "मराठी" has to be said in Marathi, by definition.
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
    } catch (_) {
      // Stopping a silent engine is not an error worth surfacing.
    }
    try {
      // Pausing is what ends the play() that _speakWithCloud is waiting on.
      await _cloudPlayer?.pause();
    } catch (_) {
      // As above.
    }
    _clearSpeaking();
  }

  /// Speaks [text] with the cloud voice.
  ///
  /// Returns false when the engine should have a go instead -- no key, no
  /// signal, no credits, too long -- and true once the utterance is over,
  /// including when it was stopped part way: a seller who pressed stop does
  /// not want the other voice to start.
  ///
  /// The audio is always generated at normal pace and slowed by the player.
  /// Generating it at the seller's speed would make every nudge of 8.8's
  /// slider a fresh charge for every sentence in the app, and would empty
  /// the cache that makes a second press free.
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
      // Stopped, or replaced by another utterance, while the audio was on
      // its way. Checked again after loading, which also takes a moment.
      if (_speakingKey != id) return true;
      final player = _cloudPlayer ??= AudioPlayer();
      await player.setFilePath(path);
      await _applyToCloudPlayer();
      if (_speakingKey != id) return true;
      // Returns when the audio finishes, or when stop() pauses it.
      await player.play();
      return true;
    } catch (error) {
      if (kDebugMode) debugPrint('[speech] cannot play generated audio: $error');
      _cloudPlaybackBroken = true;
      return false;
    }
  }

  Future<void> _applyToCloudPlayer() async {
    final player = _cloudPlayer;
    if (player == null) return;
    try {
      await player.setVolume(_volume);
      // Unlike flutter_tts, 1.0 is normal speed here, which is also what
      // 8.8's slider means by 1.0.
      await player.setSpeed(_speed);
    } catch (_) {
      // Applied again before the next utterance.
    }
  }

  Future<void> _applyVoice() async {
    // Once the engine has failed to answer, every later call would cost
    // another timeout. Changing the language on 8.4 would then freeze the
    // screen for three seconds per attempt.
    if (!_available) return;
    try {
      await _tts.setLanguage(_language.ttsLocale).timeout(_engineTimeout);
      // flutter_tts rates are not comparable across platforms; 0.5 is normal
      // speed on Android, so the slider's 1.0 maps there.
      await _tts.setSpeechRate(_speed * 0.5).timeout(_engineTimeout);
      await _tts.setPitch(1.0).timeout(_engineTimeout);
      // 8.8's slider. Sent every time the voice is reconfigured, because
      // that is the only moment the engine is listening -- a volume held in
      // a field and never handed over is a setting that does nothing.
      await _tts.setVolume(_volume).timeout(_engineTimeout);
    } catch (_) {
      // No engine, no voice data, or an engine that never answered. Silent
      // is a survivable state; hung is not.
      _available = false;
    }
  }

  Future<void> _applyAudioAttributes() async {
    try {
      await _tts
          .setAudioAttributesForNavigation()
          .timeout(_engineTimeout);
    } catch (_) {
      // Android-only, and not fatal anywhere. The voice is merely quieter.
    }
  }

  /// Speaks only if the seller has asked for automatic narration.
  ///
  /// Every unprompted utterance in the app goes through here rather than
  /// [speak], so that "do not talk unless I press the speaker" cannot be
  /// undone by one screen forgetting to check.
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
