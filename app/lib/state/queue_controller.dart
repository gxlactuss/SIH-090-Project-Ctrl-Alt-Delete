import 'package:flutter/foundation.dart';

import '../data/local/capture_dao.dart';
import '../data/models/capture_item.dart';
import '../data/remote/upload_failure.dart';

enum QueueItemState { waiting, uploading, processing, failed }

class QueueController extends ChangeNotifier {
  QueueController({CaptureDao? dao}) : _dao = dao ?? CaptureDao();

  final CaptureDao _dao;

  final List<CaptureItem> _items = [];

  String? _uploadingId;
  final ValueNotifier<double> _progress = ValueNotifier(0);

  bool _loaded = false;

  bool get isLoaded => _loaded;

  List<CaptureItem>? _snapshot;
  ({int pending, int failed})? _counts;

  List<CaptureItem> get items => _snapshot ??= List.unmodifiable(_items);

  List<CaptureItem> get pending => _items.where((i) => i.isPending).toList();

  int get pendingCount => _tally.pending;

  bool get hasPending => pendingCount > 0;

  int get failedCount => _tally.failed;

  ({int pending, int failed}) get _tally {
    final cached = _counts;
    if (cached != null) return cached;
    var pending = 0;
    var failed = 0;
    for (final item in _items) {
      if (!item.isPending) continue;
      pending++;
      if (item.lastError != null) failed++;
    }
    return _counts = (pending: pending, failed: failed);
  }

  String? get uploadingId => _uploadingId;

  double get progress => _progress.value;

  ValueListenable<double> get progressListenable => _progress;

  CaptureItem? byId(String id) {
    for (final item in _items) {
      if (item.id == id) return item;
    }
    return null;
  }

  QueueItemState stateOf(CaptureItem item) {
    if (!item.isPending) return QueueItemState.processing;
    if (item.id == _uploadingId) return QueueItemState.uploading;
    if (item.lastError != null) return QueueItemState.failed;
    return QueueItemState.waiting;
  }

  UploadFailure? failureOf(CaptureItem item) =>
      item.lastError == null ? null : UploadFailure.byId(item.lastError);

  CaptureItem? get nextToUpload {
    CaptureItem? next;
    for (final item in _items) {
      if (!item.isPending || item.lastError != null) continue;
      if (next == null || item.createdAt.isBefore(next.createdAt)) next = item;
    }
    return next;
  }

  Future<void> load() async {
    try {
      final saved = await _dao.all();
      _items
        ..clear()
        ..addAll(saved);
    } catch (_) {}
    _loaded = true;
    notifyListeners();
  }

  void add(CaptureItem item) {
    _items.removeWhere((i) => i.id == item.id);
    _items.insert(0, item);
    notifyListeners();
  }

  void markUploading(String id, {double progress = 0}) {
    _uploadingId = id;
    _progress.value = progress;
    notifyListeners();
  }

  void updateProgress(double progress) {
    if (_uploadingId == null) return;
    _progress.value = progress;
  }

  void markUploaded(String id, {DateTime? at}) {
    _replace(
      id,
      (item) =>
          item.copyWith(uploadedAt: at ?? DateTime.now(), clearError: true),
    );
    if (_uploadingId == id) _clearUploading();
    notifyListeners();
  }

  void markFailed(String id, UploadFailure failure) {
    _replace(
      id,
      (item) =>
          item.copyWith(attempts: item.attempts + 1, lastError: failure.id),
    );
    if (_uploadingId == id) _clearUploading();
    notifyListeners();
  }

  Future<void> clearFailure(String id) async {
    _replace(id, (item) => item.copyWith(clearError: true));
    notifyListeners();
    try {
      await _dao.clearFailure(id);
    } catch (_) {}
  }

  Future<void> remove(String id) async {
    _items.removeWhere((i) => i.id == id);
    if (_uploadingId == id) _clearUploading();
    notifyListeners();
    try {
      await _dao.delete(id);
    } catch (_) {}
  }

  @override
  void notifyListeners() {
    _snapshot = null;
    _counts = null;
    super.notifyListeners();
  }

  void _replace(String id, CaptureItem Function(CaptureItem) update) {
    final index = _items.indexWhere((i) => i.id == id);
    if (index == -1) return;
    _items[index] = update(_items[index]);
  }

  void _clearUploading() {
    _uploadingId = null;
    _progress.value = 0;
  }

  @override
  void dispose() {
    _progress.dispose();
    super.dispose();
  }
}
