import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

class ConnectivityService extends ChangeNotifier {
  ConnectivityService({Connectivity? connectivity})
    : _connectivity = connectivity ?? Connectivity();

  final Connectivity _connectivity;
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  bool _online = true;
  bool get isOnline => _online;

  bool get isOffline => !isOnline;

  Future<void> start() async {
    if (_subscription != null) return;
    try {
      _apply(await _connectivity.checkConnectivity());
      _subscription = _connectivity.onConnectivityChanged.listen(
        _apply,
        onError: (_) => _set(true),
      );
    } catch (_) {
      _set(true);
    }
  }

  void _apply(List<ConnectivityResult> results) {
    _set(results.any((r) => r != ConnectivityResult.none));
  }

  void _set(bool online) {
    if (_online == online) return;
    _online = online;
    notifyListeners();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
