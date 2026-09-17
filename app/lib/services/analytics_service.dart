import 'dart:async';
import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The events the app reports. A closed set on purpose: an analytics call
/// that takes a free string grows into forty spellings of the same event and
/// a metrics page nobody can read.
///
/// Every name here is a thing that happened to the seller, not a screen that
/// was drawn. "The seller published something" is a fact worth keeping for a
/// year; "the preview screen was built" is noise.
enum AnalyticsEvent {
  /// The first photograph of a listing was kept. This is where the clock
  /// that matters starts.
  captureStarted,

  /// 3.7 -- the capture is on the phone and will send itself.
  captureSaved,

  /// The upload finished and the server has it.
  uploadSucceeded,

  /// Every failure the seller was shown, with the reason.
  uploadFailed,

  /// Loop 1: the on-device quality check sent them back to the camera.
  retakePrompted,

  /// Loop 2: a required fact was missing and had to be asked for.
  questionAsked,

  /// Loop 3: they disagreed with something we wrote.
  fieldCorrected,

  /// Loop 4, one card at a time, so the accept rate per suggestion is
  /// knowable rather than guessed at.
  suggestionAnswered,

  /// 5.11. Carries the seconds since [captureStarted] when we know them.
  listingPublished,

  /// Loop 5.
  listingRepublished,

  /// Loop 6.
  duplicateStarted,

  /// Loop 7, whether it came from a sale or from 6.4.
  listingSoldOut,

  /// Something sold. The reason the app exists.
  saleReceived,
}

/// A single thing that happened, with the little that is worth keeping about
/// it. Immutable, because an event is a fact and facts do not get edited.
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

/// Where events go once they leave the app.
///
/// Split out so the app never depends on a particular vendor, and so the
/// tests can assert on what was reported without a network or a plugin.
abstract interface class AnalyticsSink {
  Future<void> send(AnalyticsRecord record);
}

/// The sink until there is a backend to send to. Keeps the last few hundred
/// events in memory and prints them in debug, which is enough to demo the
/// metrics and enough to develop against.
class DebugAnalyticsSink implements AnalyticsSink {
  /// Oldest first. A queue rather than a list: the release build uses this
  /// sink too, and once it is full every event drops the oldest -- which a
  /// list does by moving the other 499 along one place.
  final Queue<AnalyticsRecord> records = ListQueue();

  static const int _keep = 500;

  @override
  Future<void> send(AnalyticsRecord record) async {
    records.add(record);
    if (records.length > _keep) records.removeFirst();
    if (kDebugMode) debugPrint('[analytics] $record');
  }
}

/// Reports what the seller did, and computes the one number the spec says
/// matters: the time from the first photograph to the listing being live.
///
/// That number is not something a single screen can measure. The first photo
/// happens in section 3, the publish happens in section 5, and in between the
/// phone may have been offline for a day and the app closed twice. So the
/// start time is written to disk keyed by the capture id -- which is also the
/// listing id -- and the duration is worked out when the publish lands.
///
/// Nothing here is allowed to fail loudly. Analytics that can throw is
/// analytics that can crash a seller's phone in a field, and no number is
/// worth that.
class AnalyticsService {
  AnalyticsService({
    AnalyticsSink? sink,
    Future<SharedPreferences> Function()? store,
    DateTime Function()? now,
  })  : _sink = sink ?? DebugAnalyticsSink(),
        _storeOf = store ?? SharedPreferences.getInstance,
        _now = now ?? DateTime.now;

  final AnalyticsSink _sink;
  final Future<SharedPreferences> Function() _storeOf;
  final DateTime Function() _now;

  static const String _kStartedPrefix = 'analytics.started.';
  static const String _kLastTimeToPublish = 'analytics.lastTimeToPublish';

  Future<SharedPreferences>? _cached;
  Future<SharedPreferences> get _store => _cached ??= _storeOf();

  /// Fire and forget. Callers are screens and controllers, and none of them
  /// should be waiting on a metric before they draw.
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
    } catch (_) {
      // Swallowed deliberately. See the class comment: a metric is never
      // worth an exception on the seller's phone.
    }
  }

  /// Called when the first photograph of a capture is kept. Starts the clock.
  ///
  /// Idempotent: retaking photo one does not restart it, because the seller's
  /// experience of "how long did this take" began at the first shutter press
  /// and not at the one they settled on.
  Future<void> captureStarted(String captureId) async {
    try {
      final store = await _store;
      final key = '$_kStartedPrefix$captureId';
      if (store.containsKey(key)) return;
      await store.setString(key, _now().toIso8601String());
      log(AnalyticsEvent.captureStarted, properties: {'captureId': captureId});
    } catch (_) {
      // A phone that will not give us preferences still gets to sell things.
    }
  }

  /// Called when a listing goes live. Closes the clock [captureStarted]
  /// opened and reports the duration with the event.
  ///
  /// The capture id and the listing id are the same id by design -- the
  /// device generates it before the first photograph exists -- so the two
  /// halves of the measurement join without the server having to help.
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
      // Removed once used: a listing publishes once, and leaving the key
      // behind would slowly fill a cheap phone's preferences with dead ids.
      await store.remove(key);
      await store.setInt(_kLastTimeToPublish, elapsed.inSeconds);
      return elapsed;
    } catch (_) {
      return null;
    }
  }

  /// The headline number, for the metrics page: how long the last listing
  /// took from first photograph to being on sale. Null before the first one.
  Future<Duration?> lastTimeToPublish() async {
    try {
      final seconds = (await _store).getInt(_kLastTimeToPublish);
      return seconds == null ? null : Duration(seconds: seconds);
    } catch (_) {
      return null;
    }
  }

  /// How long a start time is worth keeping. A capture that has not become a
  /// listing in a fortnight never will: the photographs are still on the
  /// phone and still in the queue, but the *measurement* is meaningless, and
  /// on this phone that stopwatch is only ever a number in a report.
  static const Duration _clockLifetime = Duration(days: 14);

  /// Drops start times nothing will ever close.
  ///
  /// [captureDiscarded] handles the tidy case, but the untidy one is the
  /// common one on a 2 GB phone: the OS kills the app mid-capture and the
  /// key stays in preferences for the life of the install. Called once at
  /// startup, where it costs one read of a handful of keys.
  Future<void> sweep() async {
    try {
      final store = await _store;
      final cutoff = _now().subtract(_clockLifetime);

      // A plain loop rather than a collection-if: the nesting this needs --
      // "is it a clock, does it parse, is it old" -- is exactly the shape
      // where a dangling else silently attaches to the wrong condition.
      final stale = <String>[];
      for (final key in store.getKeys()) {
        if (!key.startsWith(_kStartedPrefix)) continue;
        final at = DateTime.tryParse(store.getString(key) ?? '');
        // A value we cannot parse is a clock nothing can ever close.
        if (at == null || at.isBefore(cutoff)) stale.add(key);
      }

      // Together rather than one after another: each is its own trip to the
      // platform, and none of them waits on another.
      await Future.wait(stale.map(store.remove));
    } catch (_) {
      // A sweep that could not run costs a few bytes, and nothing else.
    }
  }

  /// Drops the clock for a capture the seller abandoned or deleted, so it
  /// cannot later be joined to an unrelated listing.
  Future<void> captureDiscarded(String captureId) async {
    try {
      await (await _store).remove('$_kStartedPrefix$captureId');
    } catch (_) {
      // Nothing to do: a stale key is harmless, it just never matches.
    }
  }
}
