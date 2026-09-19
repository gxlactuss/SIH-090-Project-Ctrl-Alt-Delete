import 'dart:async';
import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AnalyticsEvent {
  captureStarted,

  captureSaved,

  uploadSucceeded,

  uploadFailed,

  retakePrompted,

  questionAsked,

  fieldCorrected,

  suggestionAnswered,

  listingCancelled,

  listingPublished,

  listingRepublished,

  duplicateStarted,

  listingSoldOut,

  saleReceived,
}

@immutable
class AnalyticsRecord {
  const AnalyticsRecord({
    required this.event,
    required this.at,
    this.properties = const {},
  });

  final AnalyticsEvent event;
  final DateTime at;
  final Map<String, Object?> properties;

  Map<String, Object?> toJson() => {
    'event': event.name,
    'at': at.toIso8601String(),
    if (properties.isNotEmpty) 'properties': properties,
  };

  @override
  String toString() => '${event.name} ${properties.isEmpty ? '' : properties}';
}

abstract interface class AnalyticsSink {
  Future<void> send(AnalyticsRecord record);
}

class DebugAnalyticsSink implements AnalyticsSink {
  final Queue<AnalyticsRecord> records = ListQueue();

  static const int _keep = 500;

  @override
  Future<void> send(AnalyticsRecord record) async {
    records.add(record);
    if (records.length > _keep) records.removeFirst();
    if (kDebugMode) debugPrint('[analytics] $record');
  }
}

class AnalyticsService {
  AnalyticsService({
    AnalyticsSink? sink,
    Future<SharedPreferences> Function()? store,
    DateTime Function()? now,
  }) : _sink = sink ?? DebugAnalyticsSink(),
       _storeOf = store ?? SharedPreferences.getInstance,
       _now = now ?? DateTime.now;

  final AnalyticsSink _sink;
  final Future<SharedPreferences> Function() _storeOf;
  final DateTime Function() _now;

  static const String _kStartedPrefix = 'analytics.started.';
  static const String _kLastTimeToPublish = 'analytics.lastTimeToPublish';

  Future<SharedPreferences>? _cached;
  Future<SharedPreferences> get _store => _cached ??= _storeOf();

  void log(AnalyticsEvent event, {Map<String, Object?> properties = const {}}) {
    unawaited(_report(event, properties));
  }

  Future<void> _report(
    AnalyticsEvent event,
    Map<String, Object?> properties,
  ) async {
    try {
      await _sink.send(
        AnalyticsRecord(event: event, at: _now(), properties: properties),
      );
    } catch (_) {}
  }

  Future<void> captureStarted(String captureId) async {
    try {
      final store = await _store;
      final key = '$_kStartedPrefix$captureId';
      if (store.containsKey(key)) return;
      await store.setString(key, _now().toIso8601String());
      log(AnalyticsEvent.captureStarted, properties: {'captureId': captureId});
    } catch (_) {}
  }

  Future<Duration?> listingPublished(String listingId) async {
    final elapsed = await _closeClock(listingId);
    log(
      AnalyticsEvent.listingPublished,
      properties: {
        'listingId': listingId,
        if (elapsed != null) 'secondsToPublish': elapsed.inSeconds,
      },
    );
    return elapsed;
  }

  Future<Duration?> _closeClock(String id) async {
    try {
      final store = await _store;
      final key = '$_kStartedPrefix$id';
      final started = store.getString(key);
      if (started == null) return null;

      final at = DateTime.tryParse(started);
      if (at == null) return null;

      final elapsed = _now().difference(at);
      await store.remove(key);
      await store.setInt(_kLastTimeToPublish, elapsed.inSeconds);
      return elapsed;
    } catch (_) {
      return null;
    }
  }

  Future<Duration?> lastTimeToPublish() async {
    try {
      final seconds = (await _store).getInt(_kLastTimeToPublish);
      return seconds == null ? null : Duration(seconds: seconds);
    } catch (_) {
      return null;
    }
  }

  static const Duration _clockLifetime = Duration(days: 14);

  Future<void> sweep() async {
    try {
      final store = await _store;
      final cutoff = _now().subtract(_clockLifetime);

      final stale = <String>[];
      for (final key in store.getKeys()) {
        if (!key.startsWith(_kStartedPrefix)) continue;
        final at = DateTime.tryParse(store.getString(key) ?? '');
        if (at == null || at.isBefore(cutoff)) stale.add(key);
      }

      await Future.wait(stale.map(store.remove));
    } catch (_) {}
  }

  Future<void> captureDiscarded(String captureId) async {
    try {
      await (await _store).remove('$_kStartedPrefix$captureId');
    } catch (_) {}
  }
}
