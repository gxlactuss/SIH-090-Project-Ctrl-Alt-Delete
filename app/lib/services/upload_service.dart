import 'dart:async';

import 'package:flutter/foundation.dart';

import '../data/local/capture_dao.dart';
import '../data/models/capture_item.dart';
import '../data/remote/api_client.dart';
import '../data/remote/upload_failure.dart';
import '../state/queue_controller.dart';
import 'analytics_service.dart';
import 'connectivity_service.dart';
import 'notification_service.dart';

/// Drains the capture queue whenever a network appears.
///
/// One item at a time, oldest first. A phone on a village connection cannot
/// send three captures at once faster than it can send them one after
/// another, and doing them in order means the seller's first product is live
/// first rather than all three being half sent.
///
/// Retries are safe because every capture carries a device-generated id, so
/// the same upload arriving twice is the same listing, not two.
///
/// Nothing here is silent. Every failure lands on the item as a reason 4.2
/// can say out loud, and every item that has failed stops being retried
/// automatically -- an upload loop that keeps failing on its own drains the
/// battery of a phone that is already the seller's only one.
class UploadService {
  UploadService({
    required this._api,
    required this._queue,
    required this._connectivity,
    CaptureDao? dao,
    this._analytics,
    this._notifications,
  }) : _dao = dao ?? CaptureDao();

  final ApiClient _api;
  final QueueController _queue;
  final ConnectivityService _connectivity;
  final CaptureDao _dao;

  /// Both optional: the uploader has to work in a test harness that cares
  /// about nothing but whether the bytes went.
  final AnalyticsService? _analytics;
  final NotificationService? _notifications;

  bool _draining = false;
  bool _started = false;

  /// How long to wait before the next item after one fails on the network.
  /// Not a backoff ladder: the drain stops on failure and waits to be woken
  /// by connectivity or by the seller, which is cheaper than a timer that
  /// wakes the radio every thirty seconds in a village with no signal.
  static const Duration retryPause = Duration(seconds: 5);

  /// True while an upload is in flight.
  bool get isDraining => _draining;

  /// Starts watching. The queue and the network both wake the drain: a new
  /// capture on a good connection goes immediately, and a capture made
  /// offline goes the moment the signal comes back.
  void start() {
    if (_started) return;
    _started = true;
    _connectivity.addListener(_onConnectivityChanged);
    _queue.addListener(_onQueueChanged);
    unawaited(drain());
  }

  void _onConnectivityChanged() {
    if (_connectivity.isOnline) unawaited(drain());
  }

  void _onQueueChanged() {
    if (_connectivity.isOnline) unawaited(drain());
  }

  /// Sends everything that is waiting, one at a time. Safe to call from
  /// anywhere and as often as anything likes: a second call while one is
  /// running is ignored rather than queued.
  Future<void> drain() async {
    if (_draining) return;
    if (_connectivity.isOffline) return;

    _draining = true;
    try {
      while (true) {
        final item = _queue.nextToUpload;
        if (item == null) break;
        if (_connectivity.isOffline) break;
        final sent = await _upload(item);
        // A failure stops the run. The next item is probably about to fail
        // for the same reason, and three failures in a row is three error
        // messages for one broken connection.
        if (!sent) break;
      }
    } finally {
      _draining = false;
    }
  }

  /// 4.2's "try now": clears the recorded failure and sends this one item,
  /// whatever the rest of the queue is doing.
  Future<bool> retry(String id) async {
    await _queue.clearFailure(id);
    final item = _queue.byId(id);
    if (item == null || !item.isPending) return false;
    if (_connectivity.isOffline) return false;
    if (_draining) return false;

    _draining = true;
    try {
      return await _upload(item);
    } finally {
      _draining = false;
      unawaited(drain());
    }
  }

  Future<bool> _upload(CaptureItem item) async {
    _queue.markUploading(item.id);

    try {
      await _api.uploadCapture(
        captureId: item.id,
        photoPaths: item.photoPaths,
        voiceNotePath: item.voiceNotePath,
        onProgress: _queue.updateProgress,
        templateListingId: item.templateListingId,
        description: item.description,
      );
    } on UploadException catch (error) {
      await _fail(item, error.failure);
      return false;
    } catch (error) {
      // Anything the client did not classify. The seller still gets a
      // sentence and a retry rather than a spinner that stopped.
      debugPrint('upload of ${item.id} failed: $error');
      await _fail(item, UploadFailure.unknown);
      return false;
    }

    // The database first, then the screen: if the app dies in this gap the
    // next launch reads "uploaded" and does not send it twice.
    final at = DateTime.now();
    try {
      await _dao.markUploaded(item.id, at: at);
    } catch (_) {
      // A write we could not make means the next launch sends it again --
      // which the device-generated id makes harmless.
    }
    _queue.markUploaded(item.id, at: at);
    _analytics?.log(
      AnalyticsEvent.uploadSucceeded,
      properties: {'captureId': item.id},
    );
    // "Upload finished" is one of the three things 8.7 has a switch for, and
    // it is the one that matters most while the app is closed: a capture
    // made in a village goes out hours later, somewhere else entirely, and
    // the seller has no other way of learning that it did.
    unawaited(
      _notifications?.handle(
            PushMessage(
              kind: NotificationKind.uploadFinished,
              listingId: item.id,
            ),
          ) ??
          Future<bool>.value(false),
    );
    return true;
  }

  Future<void> _fail(CaptureItem item, UploadFailure failure) async {
    try {
      await _dao.recordFailure(item.id, failure.id);
    } catch (_) {
      // Same as above: the reason not surviving a restart is a worse
      // message, not a lost capture.
    }
    _queue.markFailed(item.id, failure);
    _analytics?.log(
      AnalyticsEvent.uploadFailed,
      properties: {'captureId': item.id, 'reason': failure.id},
    );
  }

  void dispose() {
    _connectivity.removeListener(_onConnectivityChanged);
    _queue.removeListener(_onQueueChanged);
    _started = false;
  }

  // TODO(background): register a workmanager periodic task with a top-level
  // callbackDispatcher that runs this same drain with the app closed. It
  // needs the real backend and an Android-side test to be worth anything --
  // in the foreground the queue already survives the app being killed,
  // because it lives in sqflite and not in this object.
}
