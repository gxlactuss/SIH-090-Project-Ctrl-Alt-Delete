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

class UploadService {
  UploadService({
    required this._api,
    required this._queue,
    required this._connectivity,
    CaptureDao? dao,
    this._analytics,
    this._notifications,
    this.onWorkLeft,
  }) : _dao = dao ?? CaptureDao();

  final Future<void> Function()? onWorkLeft;

  final ApiClient _api;
  final QueueController _queue;
  final ConnectivityService _connectivity;
  final CaptureDao _dao;

  final AnalyticsService? _analytics;
  final NotificationService? _notifications;

  bool _draining = false;
  bool _started = false;

  static const Duration retryPause = Duration(seconds: 5);

  bool get isDraining => _draining;

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
    if (_connectivity.isOnline) {
      unawaited(drain());
    } else {
      _handOver();
    }
  }

  bool _handedOver = false;

  void _handOver() {
    if (_handedOver || onWorkLeft == null) return;
    if (_queue.nextToUpload == null) return;
    _handedOver = true;
    unawaited(onWorkLeft!());
  }

  Future<void> drain() async {
    if (_draining) return;
    if (_connectivity.isOffline) {
      _handOver();
      return;
    }

    _draining = true;
    try {
      while (true) {
        final item = _queue.nextToUpload;
        if (item == null) break;
        if (_connectivity.isOffline) break;
        final sent = await _upload(item);
        if (!sent) break;
      }
    } finally {
      _draining = false;
    }
    if (_queue.nextToUpload == null) {
      _handedOver = false;
    } else {
      _handOver();
    }
  }

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
      debugPrint('upload of ${item.id} failed: $error');
      await _fail(item, UploadFailure.unknown);
      return false;
    }

    final at = DateTime.now();
    try {
      await _dao.markUploaded(item.id, at: at);
    } catch (_) {}
    _queue.markUploaded(item.id, at: at);
    _analytics?.log(
      AnalyticsEvent.uploadSucceeded,
      properties: {'captureId': item.id},
    );
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
    } catch (_) {}
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
}
