import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:record/record.dart';

class RecorderService extends ChangeNotifier {
  RecorderService({AudioRecorder? recorder}) : _injected = recorder;

  AudioRecorder? _injected;
  AudioRecorder get _recorder => _injected ??= AudioRecorder();

  StreamSubscription<Amplitude>? _amplitudes;
  Timer? _ticker;

  bool _recording = false;
  bool get isRecording => _recording;

  String? _path;

  String? get path => _path;

  Duration _elapsed = Duration.zero;
  Duration get elapsed => _elapsed;

  double _level = 0;
  double get level => _level;

  Object? _error;
  Object? get error => _error;

  bool _limitReached = false;
  bool get limitReached => _limitReached;

  Duration? _limit;

  static const Duration _tick = Duration(milliseconds: 100);

  Future<bool> start(String path, {Duration? maxDuration}) async {
    if (_recording) return true;
    _error = null;
    _elapsed = Duration.zero;
    _level = 0;
    _limit = maxDuration;
    _limitReached = false;

    try {
      if (!await _recorder.hasPermission()) {
        _error = 'permission';
        notifyListeners();
        return false;
      }

      await _recorder.start(
        const RecordConfig(
          encoder: AudioEncoder.aacLc,
          numChannels: 1,
          sampleRate: 22050,
          bitRate: 32000,
        ),
        path: path,
      );

      _path = path;
      _recording = true;
      _listenToLevel();
      _ticker = Timer.periodic(_tick, (_) {
        _elapsed += _tick;
        final limit = _limit;
        if (limit != null && _elapsed >= limit && !_limitReached) {
          _limitReached = true;
          unawaited(stop());
          return;
        }
        notifyListeners();
      });
      notifyListeners();
      return true;
    } catch (error) {
      _error = error;
      _recording = false;
      notifyListeners();
      return false;
    }
  }

  Future<String?> stop() async {
    if (_recording) {
      await _stopMeters();

      try {
        final result = await _recorder.stop();
        _path = result ?? _path;
      } catch (error) {
        _error = error;
      }

      _recording = false;
      _level = 0;
      notifyListeners();
    }

    final path = _path;
    if (path == null) return null;
    final file = File(path);
    if (!file.existsSync() || file.lengthSync() == 0) return null;
    return path;
  }

  Future<void> cancel() async {
    await _stopMeters();
    try {
      await _recorder.cancel();
    } catch (_) {}
    await deleteFile(_path);
    _path = null;
    _recording = false;
    _elapsed = Duration.zero;
    _level = 0;
    _limitReached = false;
    notifyListeners();
  }

  Future<void> deleteFile(String? path) async {
    if (path == null) return;
    try {
      final file = File(path);
      if (file.existsSync()) await file.delete();
    } catch (_) {}
  }

  void _listenToLevel() {
    _amplitudes = _recorder.onAmplitudeChanged(_tick).listen((amplitude) {
      const floor = -45.0;
      final normalised = ((amplitude.current - floor) / -floor).clamp(0.0, 1.0);
      _level = _level + (normalised - _level) * 0.4;
      notifyListeners();
    }, onError: (_) {});
  }

  Future<void> _stopMeters() async {
    _ticker?.cancel();
    _ticker = null;
    await _amplitudes?.cancel();
    _amplitudes = null;
  }

  @override
  void dispose() {
    _stopMeters();
    _injected?.dispose();
    super.dispose();
  }
}
