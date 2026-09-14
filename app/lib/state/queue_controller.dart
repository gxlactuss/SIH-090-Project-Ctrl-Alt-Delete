import 'package:flutter/foundation.dart';

import '../data/local/capture_dao.dart';
import '../data/models/capture_item.dart';
import '../data/remote/upload_failure.dart';

/// What one item in the queue is doing right now.
///
/// Four of these are on the disk -- waiting, uploaded, failed, and how many
/// attempts -- and one, [uploading], only exists while the app is open. That
/// is why this is derived rather than stored: a phone killed mid-upload comes
/// back to "waiting", which is the truth, instead of to a progress bar that
/// will never move again.
enum QueueItemState { waiting, uploading, processing, failed }

/// Exposes the pending-upload count that the "3 items waiting" chip shows,
/// and the per-item state that 4.1 lists.
///
/// The database is the truth and this is the copy the widgets watch. Every
/// write goes to [CaptureDao] first -- section 3 saves a capture before it
/// tells the seller it was saved -- and this is updated after, so the chip
/// can never claim something is queued that is not on the disk.
class QueueController extends ChangeNotifier {
  QueueController({CaptureDao? dao}) : _dao = dao ?? CaptureDao();

  final CaptureDao _dao;

  final List<CaptureItem> _items = [];

  /// The one item going up right now, and how far it has got. In memory
  /// only, and cleared the moment the app is closed.
  String? _uploadingId;
  final ValueNotifier<double> _progress = ValueNotifier(0);

  bool _loaded = false;

  /// False until the database has been read once. The chip shows nothing
  /// rather than a wrong zero.
  bool get isLoaded => _loaded;

  // Built once per change rather than once per read: the chip, the banner
  // and 4.1 all select these, and a selector runs again on every
  // notification -- each upload starting and finishing among them. Copies,
  // replaced rather than updated, so a `select` can see that they changed.
  List<CaptureItem>? _snapshot;
  ({int pending, int failed})? _counts;

  /// Newest first, which is the order both the chip and 4.1 want.
  List<CaptureItem> get items => _snapshot ??= List.unmodifiable(_items);

  List<CaptureItem> get pending => _items.where((i) => i.isPending).toList();

  int get pendingCount => _tally.pending;

  bool get hasPending => pendingCount > 0;

  /// Failed items still count as pending -- they are still on the phone and
  /// still not sold -- but they need a person, so they are counted apart.
  int get failedCount => _tally.failed;

  /// Both counts, in one pass.
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

  /// 0 to 1 for the item currently going up.
  double get progress => _progress.value;

  /// The same number, for whatever draws it.
  ///
  /// Kept off [notifyListeners] on purpose. An upload reports progress many
  /// times a second, and every tick used to rebuild Home, the offline banner
  /// and everything else watching the queue -- none of which show it -- and
  /// wake the uploader to ask whether it should start draining.
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

  /// The next thing to send: oldest first, and never one that has already
  /// failed -- those wait for the seller to press retry, so a permanently
  /// broken capture cannot spin the radio flat.
  CaptureItem? get nextToUpload {
    // One pass for the oldest, rather than a sorted copy of the whole queue
    // made again for every item the drain sends.
    CaptureItem? next;
    for (final item in _items) {
      if (!item.isPending || item.lastError != null) continue;
      if (next == null || item.createdAt.isBefore(next.createdAt)) next = item;
    }
    return next;
  }

  /// Reads what survived the last time the app was closed. A capture made on
  /// a bus with no signal is still here a day later, which is the whole point
  /// of writing it to sqflite rather than holding it in memory.
  Future<void> load() async {
    try {
      final saved = await _dao.all();
      _items
        ..clear()
        ..addAll(saved);
    } catch (_) {
      // No database (a desktop with no sqflite, or a corrupt file): an empty
      // queue is wrong but survivable, and the retry on 4.2 is the way back.
    }
    _loaded = true;
    notifyListeners();
  }

  /// Called after the capture is on the disk, never before.
  void add(CaptureItem item) {
    _items.removeWhere((i) => i.id == item.id);
    _items.insert(0, item);
    notifyListeners();
  }

  // --- Driven by the upload service ------------------------------------

  void markUploading(String id, {double progress = 0}) {
    _uploadingId = id;
    _progress.value = progress;
    notifyListeners();
  }

  void updateProgress(double progress) {
    if (_uploadingId == null) return;
    _progress.value = progress;
  }

  /// The server has it. The item stays in the list, now showing as being
  /// processed, because "where did my photo go" is the question this screen
  /// exists to answer.
  void markUploaded(String id, {DateTime? at}) {
    _replace(
      id,
      (item) => item.copyWith(uploadedAt: at ?? DateTime.now(), clearError: true),
    );
    if (_uploadingId == id) _clearUploading();
    notifyListeners();
  }

  void markFailed(String id, UploadFailure failure) {
    _replace(
      id,
      (item) => item.copyWith(attempts: item.attempts + 1, lastError: failure.id),
    );
    if (_uploadingId == id) _clearUploading();
    notifyListeners();
  }

  /// 4.2's "try now": clears the error so the drain picks it up again.
  Future<void> clearFailure(String id) async {
    _replace(id, (item) => item.copyWith(clearError: true));
    notifyListeners();
    try {
      await _dao.clearFailure(id);
    } catch (_) {
      // The row keeping its old error until the next load is survivable;
      // the drain is driven by this list.
    }
  }

  /// Drops it from the queue and from the database.
  Future<void> remove(String id) async {
    _items.removeWhere((i) => i.id == id);
    if (_uploadingId == id) _clearUploading();
    notifyListeners();
    try {
      await _dao.delete(id);
    } catch (_) {
      // The row outliving the widget list is reconciled on the next load,
      // and is better than throwing at the seller.
    }
  }

  /// Where the copies above go stale. Dropped on every notification rather
  /// than at each place the list changes, so a change that is announced can
  /// never leave an old copy behind.
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
