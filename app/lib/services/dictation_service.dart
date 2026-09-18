import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../data/models/app_language.dart';
import '../data/remote/voice/voice_api.dart';

class DictationService extends ChangeNotifier {
  DictationService({
    SpeechToText? speech,
    this._voice,
    AudioRecorder? recorder,
    this._isOnline,
  }) : _speech = speech ?? SpeechToText(),
       _injectedRecorder = recorder;

  final SpeechToText _speech;

  final VoiceApi? _voice;

  final bool Function()? _isOnline;

  AudioRecorder? _injectedRecorder;
  AudioRecorder get _recorder => _injectedRecorder ??= AudioRecorder();

  bool get _cloudUsable =>
      (_voice?.isAvailable ?? false) && (_isOnline?.call() ?? true);

  bool _initialised = false;
  bool _available = false;

  bool get isAvailable => _available;

  bool get isChecked => _initialised;

  String? _error;
  String? get error => _error;

  bool _isListening = false;

  bool get isListening => _isListening;

  bool _transcribing = false;

  bool get isTranscribing => _transcribing;

  String _transcript = '';
  String get transcript => _transcript;

  List<LocaleName> _locales = const [];

  _Take? _take;
  Timer? _takeCap;

  Future<bool> init({bool force = false}) async {
    if (_initialised && !force) return _available;
    _initialised = true;
    _error = null;
    try {
      _available = await _speech.initialize(
        debugLogging: kDebugMode,
        onStatus: (status) {
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
            debugPrint(
              '[dictation] error ${error.errorMsg} '
              '(permanent: ${error.permanent})',
            );
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
        debugPrint(
          '[dictation] listening in '
          '${localeId ?? 'the phone default'} '
          '(${_locales.length} locales available)',
        );
      }

      await _speech.listen(
        listenOptions: SpeechListenOptions(
          localeId: localeId,
          partialResults: true,
          cancelOnError: false,
          listenFor: const Duration(seconds: 30),
          pauseFor: const Duration(seconds: 5),
        ),
        onResult: (result) {
          if (result.recognizedWords.isEmpty) return;
          _transcript = result.recognizedWords;
          if (kDebugMode) {
            debugPrint(
              '[dictation] heard "$_transcript" '
              '(final: ${result.finalResult})',
            );
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
    } catch (_) {}
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
      if (kDebugMode) {
        debugPrint('[dictation] cloud heard "${transcript.text}"');
      }
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
    } catch (_) {}
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
