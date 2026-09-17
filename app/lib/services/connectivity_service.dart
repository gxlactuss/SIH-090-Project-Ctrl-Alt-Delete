import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

/// Tells the app whether there is a network, so the offline banner and the
/// queue chip are honest.
///
/// Optimistic on purpose: until the platform has answered we say online.
/// Claiming "no network" on a phone that has one would send the seller
/// looking for a signal they already have, and the upload itself is the real
/// test of connectivity anyway.
///
/// This reports whether an interface exists, not whether the server can be
/// reached -- a village tower that answers but carries nothing still reads as
/// online here. That is why every failure has a visible retry rather than a
/// promise that the next attempt will work.
class ConnectivityService extends ChangeNotifier {
  ConnectivityService({Connectivity? connectivity})
      : _connectivity = connectivity ?? Connectivity();

  final Connectivity _connectivity;
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  bool _online = true;
  bool get isOnline => _online;

  /// Defined in terms of [isOnline] rather than the field, so that a subclass
  /// -- a test's fake network, say -- only has to override one of them for
  /// both to agree.
  bool get isOffline => !isOnline;

  /// Reads the current state once and then follows it. Safe to call twice.
  Future<void> start() async {
    if (_subscription != null) return;
    try {
      _apply(await _connectivity.checkConnectivity());
      _subscription = _connectivity.onConnectivityChanged.listen(
        _apply,
        // A plugin that dies takes the banner with it, not the app.
        onError: (_) => _set(true),
      );
    } catch (_) {
      // No plugin (tests, or a phone that refuses the query): stay optimistic.
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
