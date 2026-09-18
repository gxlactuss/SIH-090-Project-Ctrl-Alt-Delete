import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:kirtikar/data/local/capture_dao.dart';
import 'package:kirtikar/data/models/capture_item.dart';
import 'package:kirtikar/data/remote/mock_api.dart';
import 'package:kirtikar/data/remote/upload_failure.dart';
import 'package:kirtikar/data/repositories/seller_repository.dart';
import 'package:kirtikar/services/background_upload.dart';
import 'package:kirtikar/services/connectivity_service.dart';
import 'package:kirtikar/services/notification_service.dart';
import 'package:kirtikar/services/upload_service.dart';
import 'package:kirtikar/state/queue_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
}

class _FakeConnectivity extends ConnectivityService {
  bool online = true;

  @override
  bool get isOnline => online;

  @override
  Future<void> start() async {}
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory files;
  late _FakeDao dao;
  late _FakeConnectivity network;
  late DebugNotificationPresenter tray;
  late NotificationService notifications;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    files = Directory.systemTemp.createTempSync('kirtikar_bg');
    dao = _FakeDao();
    network = _FakeConnectivity();
    tray = DebugNotificationPresenter();
    notifications = NotificationService(
      sellers: SellerRepository(),
      presenter: tray,
    );
  });

  tearDown(() => files.deleteSync(recursive: true));

  Future<CaptureItem> saved(String id, {int minutesAgo = 0}) async {
    final photo = File('${files.path}/$id.jpg')..writeAsBytesSync([1]);
    final voice = File('${files.path}/$id.m4a')..writeAsBytesSync([1]);
    final item = CaptureItem(
      id: id,
      photoPaths: [photo.path],
      voiceNotePath: voice.path,
      createdAt: DateTime(2026, 1, 1).subtract(Duration(minutes: minutesAgo)),
    );
    await dao.insert(item);
    return item;
  }

  Future<bool> runWorker({bool appIsOpen = false, MockApi? api}) =>
      BackgroundUpload.run(
        api: api ?? MockApi(uploadDuration: Duration.zero),
        dao: dao,
        connectivity: network,
        notifications: notifications,
        appIsOpen: () => appIsOpen,
      );

  test('sends what the app left waiting, and the disk records it', () async {
    await saved('older', minutesAgo: 30);
    await saved('newer');

    expect(await runWorker(), isTrue);
    await pumpEventQueue();

    expect(dao.rows.values.every((r) => r.uploadedAt != null), isTrue);
    expect(
      tray.shown.map((m) => m.kind),
      everyElement(NotificationKind.uploadFinished),
    );
    expect(tray.shown, hasLength(2));
  });

  test('leaves the queue alone while the app is open', () async {
    await saved('one');

    expect(await runWorker(appIsOpen: true), isFalse);

    expect(dao.rows['one']!.uploadedAt, isNull);
    expect(tray.shown, isEmpty);
  });

  test('a failure is recorded for the seller and not retried', () async {
    await saved('one');
    final failing = MockApi(failUploads: true, uploadDuration: Duration.zero);

    await runWorker(api: failing);
    expect(dao.rows['one']!.lastError, UploadFailure.server.id);
    expect(dao.rows['one']!.attempts, 1);

    await runWorker(api: failing);
    expect(dao.rows['one']!.attempts, 1);
  });

  test('photos the system cleared are a permanent failure', () async {
    final item = await saved('one');
    File(item.photoPaths.single).deleteSync();

    await runWorker();

    expect(dao.rows['one']!.lastError, UploadFailure.missingFiles.id);
  });

  test('with no network nothing is sent or marked failed', () async {
    await saved('one');
    network.online = false;

    await runWorker();

    expect(dao.rows['one']!.uploadedAt, isNull);
    expect(dao.rows['one']!.lastError, isNull);
  });

  group('handing over to the background', () {
    late int handOvers;
    late QueueController queue;
    late UploadService uploads;

    setUp(() {
      handOvers = 0;
      queue = QueueController(dao: dao);
      uploads = UploadService(
        api: MockApi(uploadDuration: Duration.zero),
        queue: queue,
        connectivity: network,
        dao: dao,
        onWorkLeft: () async => handOvers++,
      );
    });

    tearDown(() => uploads.dispose());

    test('a capture made offline is handed over, once', () async {
      network.online = false;
      uploads.start();

      queue.add(await saved('one'));
      queue.add(await saved('two'));
      await uploads.drain();

      expect(handOvers, 1);
    });

    test('nothing is handed over when the queue empties', () async {
      uploads.start();
      queue.add(await saved('one'));
      await pumpEventQueue();

      expect(dao.rows['one']!.uploadedAt, isNotNull);
      expect(handOvers, 0);
    });

    test('a failed capture is not handed over', () async {
      final failing = UploadService(
        api: MockApi(failUploads: true, uploadDuration: Duration.zero),
        queue: queue,
        connectivity: network,
        dao: dao,
        onWorkLeft: () async => handOvers++,
      );
      addTearDown(failing.dispose);

      queue.add(await saved('one'));
      await failing.drain();

      expect(handOvers, 0);
    });
  });
}
