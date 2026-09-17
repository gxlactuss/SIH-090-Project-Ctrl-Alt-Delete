import 'package:flutter_test/flutter_test.dart';
import 'package:kaarigar/data/local/capture_dao.dart';
import 'package:kaarigar/data/models/capture_item.dart';
import 'package:kaarigar/data/models/listing.dart';
import 'package:kaarigar/data/models/sale.dart';
import 'package:kaarigar/data/models/seller_profile.dart';
import 'package:kaarigar/data/remote/api_client.dart';
import 'package:kaarigar/data/remote/upload_failure.dart';
import 'package:kaarigar/services/connectivity_service.dart';
import 'package:kaarigar/services/upload_service.dart';
import 'package:kaarigar/state/queue_controller.dart';

/// Section 4's promise: nothing captured is ever silently lost. Every one of
/// these tests is about what the seller is told when something goes wrong.

class _FakeApi implements ApiClient {
  final List<String> uploaded = [];

  /// Ids that should fail, and how.
  final Map<String, UploadFailure> failures = {};

  final List<double> progressReported = [];

  @override
  Future<void> uploadCapture({
    required String captureId,
    required List<String> photoPaths,
    required String voiceNotePath,
    void Function(double progress)? onProgress,
    String? templateListingId,
    String? description,
  }) async {
    final failure = failures[captureId];
    if (failure != null) throw UploadException(failure);
    onProgress?.call(0.5);
    progressReported.add(0.5);
    uploaded.add(captureId);
  }

  @override
  Future<SellerProfile> createProfile(SellerProfile draft) =>
      throw UnimplementedError();
  @override
  Future<Listing> listing(String id) => throw UnimplementedError();
  @override
  Future<List<Listing>> listings() => throw UnimplementedError();
  @override
  Future<Listing> answerQuestion({
    required String listingId,
    required String voiceReplyPath,
    String? field,
  }) =>
      throw UnimplementedError();

  @override
  Future<Listing> patchListing({
    required String listingId,
    required Map<String, Object?> changes,
  }) =>
      throw UnimplementedError();
  @override
  Future<Listing> reviseListing({
    required String listingId,
    required String voiceInstructionPath,
  }) =>
      throw UnimplementedError();
  @override
  Future<Listing> resolveSuggestions({
    required String listingId,
    required Map<String, bool> decisions,
  }) =>
      throw UnimplementedError();
  @override
  Future<Listing> publish({
    required String listingId,
    required bool photoConsent,
    required bool storyConsent,
  }) =>
      throw UnimplementedError();
  @override
  Future<Listing> setConsent({
    required String listingId,
    required bool photoConsent,
    required bool storyConsent,
  }) =>
      throw UnimplementedError();
  @override
  Future<Listing> republish(String listingId) => throw UnimplementedError();
  @override
  Future<Listing> unpublish(String listingId) => throw UnimplementedError();
  @override
  Future<Listing> relist(String listingId) => throw UnimplementedError();
  @override
  Future<List<Sale>> sales() => throw UnimplementedError();
}

class _FakeDao extends CaptureDao {
  final Map<String, CaptureItem> rows = {};

  @override
  Future<void> insert(CaptureItem item) async => rows[item.id] = item;

  @override
  Future<List<CaptureItem>> all() async => rows.values.toList();

  @override
  Future<void> markUploaded(String id, {DateTime? at}) async {
    final row = rows[id];
    if (row != null) {
      rows[id] = row.copyWith(uploadedAt: at ?? DateTime.now());
    }
  }

  @override
  Future<void> recordFailure(String id, String reason) async {
    final row = rows[id];
    if (row != null) {
      rows[id] = row.copyWith(attempts: row.attempts + 1, lastError: reason);
    }
  }

  @override
  Future<void> clearFailure(String id) async {
    final row = rows[id];
    if (row == null) return;
    rows[id] = CaptureItem(
      id: row.id,
      photoPaths: row.photoPaths,
      voiceNotePath: row.voiceNotePath,
      createdAt: row.createdAt,
      uploadedAt: row.uploadedAt,
      attempts: row.attempts,
    );
  }

  @override
  Future<void> delete(String id) async => rows.remove(id);
}

/// A network we can switch off, which is the state this app is written for.
class _FakeConnectivity extends ConnectivityService {
  bool online = true;

  @override
  bool get isOnline => online;

  @override
  Future<void> start() async {}

  void goOffline() {
    online = false;
    notifyListeners();
  }

  void goOnline() {
    online = true;
    notifyListeners();
  }
}

void main() {
  late _FakeApi api;
  late _FakeDao dao;
  late _FakeConnectivity network;
  late QueueController queue;
  late UploadService uploads;

  setUp(() {
    api = _FakeApi();
    dao = _FakeDao();
    network = _FakeConnectivity();
    queue = QueueController(dao: dao);
    uploads = UploadService(
      api: api,
      queue: queue,
      connectivity: network,
      dao: dao,
    );
  });

  tearDown(() => uploads.dispose());

  CaptureItem capture(String id, {int minutesAgo = 0}) => CaptureItem(
        id: id,
        photoPaths: ['/tmp/$id-1.jpg'],
        voiceNotePath: '/tmp/$id.m4a',
        createdAt: DateTime(2026, 1, 1).add(Duration(minutes: minutesAgo)),
      );

  Future<void> queueUp(List<CaptureItem> items) async {
    for (final item in items) {
      await dao.insert(item);
      queue.add(item);
    }
  }

  test('sends everything waiting, oldest first', () async {
    await queueUp([
      capture('second', minutesAgo: 10),
      capture('first', minutesAgo: 0),
      capture('third', minutesAgo: 20),
    ]);

    await uploads.drain();

    // Oldest first: the seller's first product goes live first, rather than
    // three being half sent.
    expect(api.uploaded, ['first', 'second', 'third']);
    expect(queue.pendingCount, 0);
    // And the database agrees, so a restart does not send them again.
    expect(dao.rows.values.every((r) => r.uploadedAt != null), isTrue);
  });

  test('an uploaded capture stays visible as being processed', () async {
    await queueUp([capture('one')]);
    await uploads.drain();

    final item = queue.byId('one')!;
    // "Where did my photo go" is the question 4.1 exists to answer, so the
    // item does not vanish the moment it is sent.
    expect(queue.stateOf(item), QueueItemState.processing);
    expect(queue.items.length, 1);
  });

  test('with no network nothing is sent and nothing is marked failed',
      () async {
    network.goOffline();
    await queueUp([capture('one')]);

    await uploads.drain();

    expect(api.uploaded, isEmpty);
    final item = queue.byId('one')!;
    expect(queue.stateOf(item), QueueItemState.waiting);
    // No error is recorded: there is nothing wrong with this capture, and
    // telling the seller it failed would be a lie.
    expect(item.lastError, isNull);
  });

  test('the signal coming back drains the queue on its own', () async {
    network.goOffline();
    await queueUp([capture('one')]);
    uploads.start();
    expect(api.uploaded, isEmpty);

    network.goOnline();
    // Let the listener's drain run.
    await Future<void>.delayed(Duration.zero);

    expect(api.uploaded, ['one']);
  });

  test('a failure is recorded with a reason and stops the run', () async {
    api.failures['first'] = UploadFailure.server;
    await queueUp([
      capture('first', minutesAgo: 0),
      capture('second', minutesAgo: 5),
    ]);

    await uploads.drain();

    final failed = queue.byId('first')!;
    expect(queue.stateOf(failed), QueueItemState.failed);
    expect(queue.failureOf(failed), UploadFailure.server);
    expect(failed.attempts, 1);

    // The second is left alone: it was about to fail for the same reason,
    // and two error rows for one broken connection is one too many.
    expect(api.uploaded, isEmpty);
    expect(queue.stateOf(queue.byId('second')!), QueueItemState.waiting);
  });

  test('a failed capture is not retried on its own', () async {
    api.failures['one'] = UploadFailure.server;
    await queueUp([capture('one')]);
    await uploads.drain();

    // It waits for a person. An upload loop that keeps failing by itself
    // flattens the battery of the seller's only phone.
    expect(queue.nextToUpload, isNull);
    await uploads.drain();
    expect(api.uploaded, isEmpty);
    expect(queue.byId('one')!.attempts, 1);
  });

  test('retry now clears the error and sends it', () async {
    api.failures['one'] = UploadFailure.server;
    await queueUp([capture('one')]);
    await uploads.drain();

    api.failures.clear();
    expect(await uploads.retry('one'), isTrue);

    expect(api.uploaded, ['one']);
    expect(queue.byId('one')!.lastError, isNull);
    // The attempt count is history, not a countdown, so it is kept.
    expect(queue.byId('one')!.attempts, 1);
  });

  test('missing photos are a permanent failure, not one to retry', () async {
    api.failures['one'] = UploadFailure.missingFiles;
    await queueUp([capture('one')]);
    await uploads.drain();

    final failure = queue.failureOf(queue.byId('one')!)!;
    expect(failure, UploadFailure.missingFiles);
    // 4.2 reads this to decide whether to offer a retry at all.
    expect(failure.isRetryable, isFalse);
  });

  test('the counts and the list follow every change to the queue', () async {
    // Worked out once per change and kept. A count that outlived the change
    // after it would leave the chip saying something is waiting once it has
    // gone, or nothing waiting while it sits there.
    await queueUp([
      capture('old', minutesAgo: 0),
      capture('new', minutesAgo: 10),
    ]);
    final before = queue.items;
    expect(queue.pendingCount, 2);
    expect(queue.items, same(before));

    queue.markFailed('old', UploadFailure.network);
    expect(queue.pendingCount, 2);
    expect(queue.failedCount, 1);
    // A failed item waits for the seller, so the other one goes next.
    expect(queue.nextToUpload!.id, 'new');

    await queue.clearFailure('old');
    expect(queue.failedCount, 0);
    expect(queue.nextToUpload!.id, 'old');

    queue.markUploaded('old');
    expect(queue.pendingCount, 1);

    await queue.remove('new');
    expect(queue.pendingCount, 0);
    expect(queue.hasPending, isFalse);
    expect(queue.items.map((i) => i.id), ['old']);
    expect(queue.items, isNot(same(before)));
  });

  test('progress is reported while the upload runs', () async {
    await queueUp([capture('one')]);
    await uploads.drain();

    expect(api.progressReported, isNotEmpty);
    // And it is cleared when the upload ends, so nothing is left showing a
    // half-full bar.
    expect(queue.uploadingId, isNull);
    expect(queue.progress, 0);
  });

  test('the reason survives being written to the database', () async {
    api.failures['one'] = UploadFailure.network;
    await queueUp([capture('one')]);
    await uploads.drain();

    // A fresh controller, as if the app had been closed and reopened.
    final reopened = QueueController(dao: dao);
    await reopened.load();

    final item = reopened.byId('one')!;
    expect(reopened.stateOf(item), QueueItemState.failed);
    expect(reopened.failureOf(item), UploadFailure.network);
  });
}
