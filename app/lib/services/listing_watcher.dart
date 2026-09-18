import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../data/models/listing_status.dart';
import '../state/catalog_controller.dart';
import '../state/queue_controller.dart';

class ListingWatcher with WidgetsBindingObserver {
  ListingWatcher({
    required this.catalog,
    required this.queue,
    this.onResume,
    this.firstInterval = const Duration(seconds: 3),
    this.maxInterval = const Duration(seconds: 30),
    this.uploadWindow = const Duration(minutes: 30),
    DateTime Function()? now,
  }) : _now = now ?? DateTime.now;

  final CatalogController catalog;
  final QueueController queue;

  final VoidCallback? onResume;

  final Duration firstInterval;
  final Duration maxInterval;

  final Duration uploadWindow;

  final DateTime Function() _now;

  Timer? _timer;
  Duration _interval = Duration.zero;
  Set<String> _waitingFor = const {};
  bool _foreground = true;
  bool _started = false;

  static const _unfinished = {ListingStatus.queued, ListingStatus.processing};

  Set<String> get waitingFor {
    final ids = <String>{
      for (final listing in catalog.listings)
        if (_unfinished.contains(listing.status)) listing.id,
    };
    final since = _now().subtract(uploadWindow);
    for (final item in queue.items) {
      final uploaded = item.uploadedAt;
      if (uploaded == null || uploaded.isBefore(since)) continue;
      if (catalog.byId(item.id) == null) ids.add(item.id);
    }
    return ids;
  }

  bool get isPolling => _timer != null;

  void start() {
    if (_started) return;
    _started = true;
    WidgetsBinding.instance.addObserver(this);
    catalog.addListener(_update);
    queue.addListener(_update);
    _update();
  }

  void dispose() {
    if (!_started) return;
    WidgetsBinding.instance.removeObserver(this);
    catalog.removeListener(_update);
    queue.removeListener(_update);
    _stop();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final foreground = state == AppLifecycleState.resumed;
    if (foreground == _foreground) return;
    _foreground = foreground;
    if (!foreground) {
      _stop();
      return;
    }
    onResume?.call();
    _interval = Duration.zero;
    unawaited(_poll());
  }

  void _update() {
    final waiting = waitingFor;
    if (waiting.isEmpty || !_foreground) {
      _waitingFor = waiting;
      _stop();
      return;
    }
    if (!waiting.every(_waitingFor.contains)) {
      _interval = Duration.zero;
      _stop();
    }
    _waitingFor = waiting;
    _timer ??= Timer(_next(), _poll);
  }

  Duration _next() {
    _interval = _interval == Duration.zero
        ? firstInterval
        : Duration(
            microseconds: math.min(
              _interval.inMicroseconds * 2,
              maxInterval.inMicroseconds,
            ),
          );
    return _interval;
  }

  Future<void> _poll() async {
    _timer = null;
    if (!_foreground) return;
    try {
      await catalog.refresh();
    } catch (_) {}
    _update();
  }

  void _stop() {
    _timer?.cancel();
    _timer = null;
  }
}
