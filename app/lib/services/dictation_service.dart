import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../data/models/app_language.dart';
import '../data/remote/voice/voice_api.dart';

/// Turns speech into text for the few fields that need one -- the name and
/// the village on 1.7, the craft story on 8.3, and later the voice
/// corrections in the review flow.
///
/// Used only for short answers. The long voice note on 3.5 is recorded as
/// audio and transcribed on the server; the two must not be confused.
///
/// Two recognisers sit behind it. With a key and a signal, the take is
/// recorded and sent to the cloud, which hears all eleven languages and the
/// English words sellers mix into them -- but only once they stop, not live.
/// Otherwise the phone's own recogniser listens, with words appearing as they
/// are spoken, exactly as before there was a cloud one.
class DictationService extends ChangeNotifier {
  DictationService({
    SpeechToText? speech,
    this._voice,
    AudioRecorder? recorder,
    this._isOnline,
  })  : _speech = speech ?? SpeechToText(),
        _injectedRecorder = recorder;

  final SpeechToText _speech;

  /// Null without a key, which is every test and every build not given one.
  final VoiceApi? _voice;

  /// Asked before every take. A take recorded with no signal would be
  /// thrown away when it could not be sent, where the phone's recogniser
  /// could have heard it.
  final bool Function()? _isOnline;

  /// Built on first use: constructing one reaches for the platform.
  AudioRecorder? _injectedRecorder;
  AudioRecorder get _recorder => _injectedRecorder ??= AudioRecorder();

  bool get _cloudUsable =>
      (_voice?.isAvailable ?? false) && (_isOnline?.call() ?? true);

  bool _initialised = false;
  bool _available = false;

  /// False on a phone with no recogniser, and on the desktop the app is
  /// developed on. Every caller must have a typed path for this case.
  bool get isAvailable => _available;

  /// True once [init] has run, whatever the answer was. Until then
  /// [isAvailable] is only a default, not a verdict, so a caller must not
  /// hide the microphone on the strength of it.
  bool get isChecked => _initialised;

  /// Why the recogniser is unavailable, when the engine bothered to say.
  /// Shown to the seller rather than silently swallowing the microphone.
  String? _error;
  String? get error => _error;

  bool _isListening = false;

  /// Stays true through a cloud take's transcription, so the field that
  /// asked for the words is still the one holding the microphone when they
  /// arrive.
  bool get isListening => _isListening;

  bool _transcribing = false;

  /// The recording is finished and the words are on their way. Only ever
  /// true for a cloud take.
  bool get isTranscribing => _transcribing;

  /// What has been heard so far, including partial results, so the field can
  /// fill in live while the seller is still talking.
  String _transcript = '';
  String get transcript => _transcript;

  /// What the recogniser on this phone actually offers. Android reports
  /// underscored ids ("en_IN"), not the hyphenated tags the speech
  /// *synthesiser* wants ("en-IN"), and handing it the wrong shape makes it
  /// quietly ignore the request and listen in the phone's system language --
  /// which is why dictating a Marathi name produced English words.
  List<LocaleName> _locales = const [];

  /// The cloud take being recorded, if there is one.
  _Take? _take;
  Timer? _takeCap;

  /// Asks the platform whether it can hear us.
  ///
  /// [force] re-asks after the microphone permission has been granted:
  /// speech_to_text caches a refusal for the life of the process, so a seller
  /// who deferred the permission on 1.4 and changed their mind on 1.7 would
  /// otherwise be stuck with a dead button.
  Future<bool> init({bool force = false}) async {
    if (_initialised && !force) return _available;
    _initialised = true;
    _error = null;
    try {
      _available = await _speech.initialize(
        debugLogging: kDebugMode,
        onStatus: (status) {
          // A cloud take owns the flag while it runs; the phone recogniser
          // is not listening then and has nothing to say about it.
          if (_take != null) return;
          final listening = status == 'listening';
          if (listening != _isListening) {
            _isListening = listening;
            notifyListeners();
          }
        },
        onError: (error) {
          _error = error.errorMsg;
          if (kDebugMode) {
            debugPrint('[dictation] error ${error.errorMsg} '
                '(permanent: ${error.permanent})');
          }
          if (_take == null) _setListening(false);
        },
      );
    } catch (_) {
      _available = false;
    }
    if (_available) {
      try {
        _locales = await _speech.locales();
      } catch (_) {
        _locales = const [];
      }
    }

    // A phone with no recogniser of its own can still record, and the cloud
    // can still hear it -- once the microphone is allowed.
    if (!_available && _cloudUsable) {
      try {
        _available = await _recorder.hasPermission(request: false);
      } catch (_) {
        _available = false;
      }
    }

    notifyListeners();
    return _available;
  }

  /// Picks the closest locale the recogniser actually has.
  ///
  /// Falls back through: exact match, then any region of the same language
  /// (an Indian phone offering only "hi_IN" still serves a Hindi speaker),
  /// then null -- which lets the engine use the phone's own language rather
  /// than refusing to listen at all.
  String? resolveLocaleId(AppLanguage language) {
    if (_locales.isEmpty) return null;

    String normalise(String id) => id.replaceAll('-', '_').toLowerCase();
    final wanted = normalise(language.ttsLocale);
    final languageOnly = language.code.toLowerCase();

    for (final locale in _locales) {
      if (normalise(locale.localeId) == wanted) return locale.localeId;
    }
    for (final locale in _locales) {
      if (normalise(locale.localeId).split('_').first == languageOnly) {
        return locale.localeId;
      }
    }
    return null;
  }

  /// Starts listening. [onResult] fires on every partial result and again
  /// with the final one, so the caller can write straight into a controller.
  /// A cloud take has no partial results: it fires once, after [stop].
  Future<void> start({
    required AppLanguage language,
    required ValueChanged<String> onResult,
  }) async {
    if (!_available) return;
    if (_isListening) return;

    if (_cloudUsable) return _startTake(language, onResult);

    _transcript = '';
    _setListening(true);
    try {
      final localeId = resolveLocaleId(language);
      if (kDebugMode) {
        debugPrint('[dictation] listening in '
            '${localeId ?? 'the phone default'} '
            '(${_locales.length} locales available)');
      }

      await _speech.listen(
        listenOptions: SpeechListenOptions(
          localeId: localeId,
          partialResults: true,
          // A transient recogniser error should not end the session; the
          // status handler closes it when it genuinely stops.
          cancelOnError: false,
          // Long enough that a slow speaker is not cut off mid-name, with a
          // generous pause because this user often thinks between words.
          listenFor: const Duration(seconds: 30),
          pauseFor: const Duration(seconds: 5),
        ),
        onResult: (result) {
          // Partial results arrive repeatedly and can briefly come back
          // empty; keeping the last non-empty text stops the field from
          // flickering back to blank mid-sentence.
          if (result.recognizedWords.isEmpty) return;
          _transcript = result.recognizedWords;
          if (kDebugMode) {
            debugPrint('[dictation] heard "$_transcript" '
                '(final: ${result.finalResult})');
          }
          onResult(_transcript);
          notifyListeners();
        },
      );
    } catch (_) {
      _setListening(false);
    }
  }

  Future<void> stop() async {
    if (!_isListening) return;

    final take = _take;
    if (take != null) return _finishTake(take);

    try {
      await _speech.stop();
    } catch (_) {
      // Nothing to stop; fall through to clearing the flag.
    }
    _setListening(false);
  }

  Future<void> _startTake(
    AppLanguage language,
    ValueChanged<String> onResult,
  ) async {
    _transcript = '';
    _error = null;
    try {
      if (!await _recorder.hasPermission()) {
        _error = 'permission';
        notifyListeners();
        return;
      }

      final folder = await getTemporaryDirectory();
      final path = p.join(
        folder.path,
        'dictation-${DateTime.now().millisecondsSinceEpoch}.m4a',
      );
      await _recorder.start(
        // 16 kHz mono is what the recogniser is tuned for; more is only a
        // bigger upload.
        const RecordConfig(
          encoder: AudioEncoder.aacLc,
          numChannels: 1,
          sampleRate: 16000,
          bitRate: 32000,
        ),
        path: path,
      );

      _take = _Take(path: path, language: language, onResult: onResult);
      _setListening(true);

      // The cloud takes one clip of up to thirty seconds. Stopping just
      // short sends what was said, where one second more would be refused
      // whole.
      _takeCap = Timer(
        _voice!.maxClipLength - const Duration(seconds: 1),
        () => unawaited(stop()),
      );
    } catch (error) {
      _error = '$error';
      _take = null;
      _setListening(false);
    }
  }

  Future<void> _finishTake(_Take take) async {
    if (_transcribing) return;
    _takeCap?.cancel();
    _takeCap = null;
    _transcribing = true;
    notifyListeners();

    try {
      await _recorder.stop();
      final transcript = await _voice!.transcribe(take.path, take.language);
      if (kDebugMode) debugPrint('[dictation] cloud heard "${transcript.text}"');
      if (transcript.text.isNotEmpty) {
        _transcript = transcript.text;
        take.onResult(_transcript);
      }
    } on VoiceException catch (error) {
      _error = error.message ?? error.failure.name;
      if (kDebugMode) debugPrint('[dictation] cloud: $error');
    } catch (error) {
      _error = '$error';
    } finally {
      // The seller's voice, and no longer needed by anyone.
      unawaited(_delete(take.path));
      _take = null;
      _transcribing = false;
      _setListening(false);
    }
  }

  Future<void> _delete(String path) async {
    try {
      final file = File(path);
      if (await file.exists()) await file.delete();
    } catch (_) {
      // A temporary file the system will clear anyway.
    }
  }

  void _setListening(bool value) {
    if (_isListening == value) return;
    _isListening = value;
    notifyListeners();
  }

  @override
  void dispose() {
    _takeCap?.cancel();
    _speech.cancel();
    // Only if one was ever built: touching the getter here would create a
    // platform recorder purely in order to throw it away.
    _injectedRecorder?.dispose();
    super.dispose();
  }
}

class _Take {
  const _Take({
    required this.path,
    required this.language,
    required this.onResult,
  });

  final String path;
  final AppLanguage language;
  final ValueChanged<String> onResult;
}
