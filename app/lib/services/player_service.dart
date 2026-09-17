import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';

/// Plays recorded audio back: the voice note on 3.6, and later the read-back
/// on 5.2.
///
/// Separate from [SpeechService] on purpose. That one synthesises the app's
/// own words; this one plays back the seller's. Both stop before the other
/// starts, because two voices at once is worse than no voice at all.
class PlayerService extends ChangeNotifier {
  PlayerService({AudioPlayer? player}) : _injected = player {
    if (player != null) _listen(player);
  }

  /// Silences whatever else is making noise. Wired to [SpeechService.stop]
  /// where the two are built together, so the rule the class comment states
  /// is enforced in one place rather than remembered at every call site --
  /// the app reading a screen aloud over the seller's own voice note is the
  /// exact failure this is here to prevent.
  Future<void> Function()? onBeforePlay;

  /// Built on the first playback, not in the constructor: constructing an
  /// [AudioPlayer] reaches for the platform, and a subclass written for a
  /// test has no platform to answer it.
  AudioPlayer? _injected;

  AudioPlayer get _player {
    final existing = _injected;
    if (existing != null) return existing;
    final player = _injected = AudioPlayer();
    _listen(player);
    return player;
  }

  void _listen(AudioPlayer player) {
    _states = player.playerStateStream.listen(
      (state) {
        final playing = state.playing && state.processingState != ProcessingState.completed;
        if (state.processingState == ProcessingState.completed) {
          // Rewind, so pressing play again starts at the beginning rather
          // than doing nothing.
          unawaited(player.seek(Duration.zero));
          unawaited(player.pause());
        }
        if (_playing != playing) {
          _playing = playing;
          notifyListeners();
        }
      },
      onError: (_) => _fail(),
    );
    _positions = player.positionStream.listen(
      // Deliberately not notifyListeners(): this fires several times a
      // second, and waking every widget watching the service to redraw a
      // play button that has not changed is exactly the kind of work the
      // phone this is built for cannot spare. Anything that genuinely wants
      // the playhead listens to [position] on its own.
      (value) => position.value = value,
      onError: (_) => _fail(),
    );
  }

  StreamSubscription<PlayerState>? _states;
  StreamSubscription<Duration>? _positions;

  String? _path;
  String? get path => _path;

  bool _playing = false;
  bool get isPlaying => _playing;

  bool _available = true;

  /// False on a phone that cannot play the file. The screen keeps the rest of
  /// its actions rather than trapping the seller on a dead play button.
  bool get isAvailable => _available;

  /// The playhead, as its own listenable so that following it costs a
  /// rebuild of whatever is drawing it and nothing else.
  final ValueNotifier<Duration> position = ValueNotifier(Duration.zero);

  Duration get duration => _injected?.duration ?? Duration.zero;

  /// Plays [path] from the start, or stops if it is already playing.
  Future<void> toggle(String path) async {
    if (_playing && _path == path) {
      await stop();
      return;
    }
    await play(path);
  }

  Future<void> play(String path) async {
    await onBeforePlay?.call();
    try {
      if (_path != path) {
        _path = path;
        await _player.setFilePath(path);
      }
      await _player.seek(Duration.zero);
      await _player.play();
    } catch (_) {
      _fail();
    }
  }

  Future<void> stop() async {
    // Nothing has played, so there is nothing to stop -- and asking for the
    // player here would build one just to pause it.
    if (_injected == null) return;
    try {
      await _player.pause();
      await _player.seek(Duration.zero);
    } catch (_) {
      _fail();
    }
    position.value = Duration.zero;
    if (_playing) {
      _playing = false;
      notifyListeners();
    }
  }

  void _fail() {
    _available = false;
    _playing = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _states?.cancel();
    _positions?.cancel();
    position.dispose();
    _injected?.dispose();
    super.dispose();
  }
}
