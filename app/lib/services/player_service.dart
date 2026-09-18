import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';

class PlayerService extends ChangeNotifier {
  PlayerService({AudioPlayer? player}) : _injected = player {
    if (player != null) _listen(player);
  }

  Future<void> Function()? onBeforePlay;

  AudioPlayer? _injected;

  AudioPlayer get _player {
    final existing = _injected;
    if (existing != null) return existing;
    final player = _injected = AudioPlayer();
    _listen(player);
    return player;
  }

  void _listen(AudioPlayer player) {
    _states = player.playerStateStream.listen((state) {
      final playing =
          state.playing && state.processingState != ProcessingState.completed;
      if (state.processingState == ProcessingState.completed) {
        unawaited(player.seek(Duration.zero));
        unawaited(player.pause());
      }
      if (_playing != playing) {
        _playing = playing;
        notifyListeners();
      }
    }, onError: (_) => _fail());
    _positions = player.positionStream.listen(
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

  bool get isAvailable => _available;

  final ValueNotifier<Duration> position = ValueNotifier(Duration.zero);

  Duration get duration => _injected?.duration ?? Duration.zero;

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
