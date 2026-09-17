import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:record/record.dart';

/// Records the voice note. Wraps package:record.
///
/// The voice note is the whole product description, so this is the one
/// service in the app that must never lose what it was given. It writes
/// straight to a file in the app's own storage, and a recording that is
/// interrupted is kept rather than discarded: half a sentence the seller can
/// listen to beats a silent failure they only discover later.
///
/// Overridable, like [CameraService], because `flutter test` has no
/// microphone and the flow still has to be walkable.
class RecorderService extends ChangeNotifier {
  RecorderService({AudioRecorder? recorder}) : _injected = recorder;

  /// Created on the first recording rather than in the constructor. Building
  /// an [AudioRecorder] reaches for the platform, which a subclass written
  /// for a test -- or for the practice run -- never wants and cannot answer.
  AudioRecorder? _injected;
  AudioRecorder get _recorder => _injected ??= AudioRecorder();

  StreamSubscription<Amplitude>? _amplitudes;
  Timer? _ticker;

  bool _recording = false;
  bool get isRecording => _recording;

  String? _path;

  /// Where the finished note landed. Null until [stop] has returned one.
  String? get path => _path;

  Duration _elapsed = Duration.zero;
  Duration get elapsed => _elapsed;

  /// The live level, 0 to 1, for the waveform on 3.5. Smoothed, because the
  /// raw dBFS number jumps around enough to look broken.
  double _level = 0;
  double get level => _level;

  Object? _error;
  Object? get error => _error;

  /// True once [start]'s cap stopped the recording on its own.
  ///
  /// The screen watches this so it can run the rest of its stop -- keeping
  /// the take, moving to 3.6 -- but the microphone is already off by the
  /// time anything reads it. That is the point of enforcing the cap here
  /// rather than in a widget: a screen that has been covered, backgrounded
  /// or rebuilt is a screen that is not counting, and the file would grow
  /// for as long as the phone stayed awake.
  bool _limitReached = false;
  bool get limitReached => _limitReached;

  Duration? _limit;

  /// How often the meter and the timer update. Ten a second is smooth enough
  /// to read as live and cheap enough for a 2 GB phone.
  static const Duration _tick = Duration(milliseconds: 100);

  /// Starts recording into [path]. Returns false if the microphone refused,
  /// so the screen can say why rather than showing a timer that never moves.
  /// [maxDuration] is the 90 second cap of 3.5. Reaching it stops the
  /// recording and sets [limitReached]; it never throws the take away, which
  /// is the one thing a seller who talked for too long must not be punished
  /// with.
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

      // Mono at 32 kbps: this is speech, headed for a transcriber, over a
      // village connection. Stereo would double the upload for nothing.
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
          // Stops the hardware now and tells the screen after, so the file
          // is closed at the cap whether or not anyone is watching.
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

  /// Stops and returns the finished file, or null if nothing was written.
  ///
  /// Safe to call on a recording that has already stopped -- which the cap
  /// in [start] does on its own -- and it still checks the file, because
  /// "already stopped" is not the same as "wrote something".
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
    // The recorder can report success and still leave nothing behind on a
    // phone that killed it mid-write. An empty file would upload as silence
    // and come back as an empty listing.
    final file = File(path);
    if (!file.existsSync() || file.lengthSync() == 0) return null;
    return path;
  }

  /// Throws the recording away -- the "record again" path on 3.6.
  Future<void> cancel() async {
    await _stopMeters();
    try {
      await _recorder.cancel();
    } catch (_) {
      // Nothing to cancel is a fine outcome for a cancel.
    }
    await deleteFile(_path);
    _path = null;
    _recording = false;
    _elapsed = Duration.zero;
    _level = 0;
    _limitReached = false;
    notifyListeners();
  }

  /// Removes a note that was recorded and then rejected, so a phone with 8 GB
  /// of storage does not fill up with abandoned takes.
  Future<void> deleteFile(String? path) async {
    if (path == null) return;
    try {
      final file = File(path);
      if (file.existsSync()) await file.delete();
    } catch (_) {
      // A file we cannot delete is a wasted megabyte, not an error.
    }
  }

  void _listenToLevel() {
    _amplitudes = _recorder.onAmplitudeChanged(_tick).listen(
      (amplitude) {
        // dBFS: 0 is as loud as it gets, -45 is a quiet room. Mapped to 0..1
        // and eased towards the new value so the bars move rather than jump.
        const floor = -45.0;
        final normalised =
            ((amplitude.current - floor) / -floor).clamp(0.0, 1.0);
        _level = _level + (normalised - _level) * 0.4;
        notifyListeners();
      },
      onError: (_) {
        // No meter on this phone. The timer still runs, and the seller can
        // still hear the playback on 3.6.
      },
    );
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
    // Only if one was ever built: touching the getter here would create a
    // platform recorder purely in order to throw it away.
    _injected?.dispose();
    super.dispose();
  }
}
