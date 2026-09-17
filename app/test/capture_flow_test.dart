import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:kaarigar/core/utils/image_quality.dart';
import 'package:kaarigar/data/local/capture_dao.dart';
import 'package:kaarigar/data/models/capture_item.dart';
import 'package:kaarigar/services/recorder_service.dart';
import 'package:kaarigar/state/capture_controller.dart';
import 'package:kaarigar/state/queue_controller.dart';

class _FakeDao extends CaptureDao {
  final List<CaptureItem> saved = [];

  bool failWrites = false;

  @override
  Future<void> insert(CaptureItem item) async {
    if (failWrites) throw const FileSystemException('no space left');
    saved
      ..removeWhere((i) => i.id == item.id)
      ..add(item);
  }

  @override
  Future<List<CaptureItem>> all() async => saved;

  @override
  Future<void> delete(String id) async =>
      saved.removeWhere((i) => i.id == id);
}

class _FakeRecorder extends RecorderService {
  String? started;
  bool recording = false;

  @override
  bool get isRecording => recording;

  @override
  Future<bool> start(String path, {Duration? maxDuration}) async {
    started = path;
    recording = true;
    File(path).writeAsBytesSync(Uint8List.fromList(List.filled(64, 7)));
    notifyListeners();
    return true;
  }

  @override
  Future<String?> stop() async {
    recording = false;
    notifyListeners();
    return started;
  }

  @override
  Future<void> cancel() async {
    recording = false;
    await deleteFile(started);
    started = null;
  }

  @override
  Future<void> deleteFile(String? path) async {
    if (path == null) return;
    final file = File(path);
    if (file.existsSync()) file.deleteSync();
  }
}

void main() {
  late Directory root;
  late _FakeDao dao;
  late _FakeRecorder recorder;
  late QueueController queue;

  setUp(() {
    root = Directory.systemTemp.createTempSync('kaarigar_capture_test');
    dao = _FakeDao();
    recorder = _FakeRecorder();
    queue = QueueController(dao: dao);
  });

  tearDown(() {
    if (root.existsSync()) root.deleteSync(recursive: true);
  });

  const good = ImageQuality(sharpness: 900, brightness: 130, isAcceptable: true);
  const dark = ImageQuality(
    sharpness: 20,
    brightness: 12,
    isAcceptable: false,
    issue: ImageIssue.tooDark,
  );

  CaptureController controllerWith(ImageQuality verdict) => CaptureController(
        dao: dao,
        queue: queue,
        recorder: recorder,
        qualityChecker: (_) async => verdict,
        storageDirectory: () async => root,
      );

  File shotFrom(String name) {
    final cache = Directory('${root.path}/cache')..createSync(recursive: true);
    final file = File('${cache.path}/$name.jpg');
    file.writeAsBytesSync(Uint8List.fromList(List.filled(128, 3)));
    return file;
  }

  Future<void> takeThreePhotos(CaptureController capture) async {
    for (var i = 0; i < 3; i++) {
      await capture.reviewShot(shotFrom('shot$i'));
    }
  }

  test('a photo that passes the check is kept without asking', () async {
    final capture = controllerWith(good);

    await capture.reviewShot(shotFrom('first'));

    expect(capture.stage, CaptureStage.camera);
    expect(capture.photos.length, 1);
    expect(capture.slot, 1);
  });

  test('leaving while the check runs keeps nothing', () async {
    final verdict = Completer<ImageQuality>();
    final capture = CaptureController(
      dao: dao,
      queue: queue,
      recorder: recorder,
      qualityChecker: (_) => verdict.future,
      storageDirectory: () async => root,
    );

    final checking = capture.reviewShot(shotFrom('late'));
    await capture.discard();
    verdict.complete(good);
    await checking;

    expect(capture.photos, isEmpty);
    expect(Directory('${root.path}/captures').existsSync(), isFalse);
  });

  test('three photos and a voice note become a queued capture', () async {
    final capture = controllerWith(good);

    expect(capture.stage, CaptureStage.camera);
    await takeThreePhotos(capture);

    expect(capture.stage, CaptureStage.photoSet);
    expect(capture.photos.length, 3);
    for (final photo in capture.photos) {
      expect(photo.path, contains(capture.id));
      expect(photo.existsSync(), isTrue);
    }

    capture.confirmPhotos();
    expect(capture.stage, CaptureStage.voiceRecord);

    expect(await capture.startRecording(), isTrue);
    await capture.stopRecording();
    expect(capture.stage, CaptureStage.voiceRecord);
    expect(capture.voiceNotePath, isNotNull);

    expect(await capture.save(), isTrue);
    expect(capture.stage, CaptureStage.saved);

    expect(dao.saved.single.id, capture.id);
    expect(dao.saved.single.photoPaths.length, 3);
    expect(queue.pendingCount, 1);
  });

  test('a dark photo goes to the warning, and retaking deletes it', () async {
    final capture = controllerWith(dark);
    final shot = shotFrom('dark');

    await capture.reviewShot(shot);
    expect(capture.stage, CaptureStage.qualityWarning);
    expect(capture.quality?.issue, ImageIssue.tooDark);

    await capture.retakeShot();

    expect(capture.stage, CaptureStage.camera);
    expect(capture.slot, 0);
    expect(capture.photos, isEmpty);
    expect(shot.existsSync(), isFalse);
  });

  test('a warned photo can still be kept, because the seller can see it',
      () async {
    final capture = controllerWith(dark);
    await capture.reviewShot(shotFrom('dim'));
    await capture.keepShot();

    expect(capture.photos.length, 1);
    expect(capture.stage, CaptureStage.camera);
  });

  test('one photo of the three can be retaken from the set review', () async {
    final capture = controllerWith(good);
    await takeThreePhotos(capture);
    final replaced = capture.photos[1].path;

    capture.retakePhotoAt(1);
    expect(capture.stage, CaptureStage.camera);
    expect(capture.slot, 1);

    await capture.reviewShot(shotFrom('replacement'));
    await capture.keepShot();

    expect(capture.photos.length, 3);
    expect(capture.photos[1].path, replaced);
    expect(capture.stage, CaptureStage.photoSet);
  });

  test('the first photo can be changed, because buyers see it first', () async {
    final capture = controllerWith(good);
    await takeThreePhotos(capture);
    final third = capture.photos[2].path;

    capture.movePhoto(2, 0);

    expect(capture.photos.first.path, third);
    expect(capture.photos.length, 3);
  });

  test('recording again throws the first take away', () async {
    final capture = controllerWith(good);
    await takeThreePhotos(capture);
    capture.confirmPhotos();

    await capture.startRecording();
    await capture.stopRecording();
    final firstTake = capture.voiceNotePath!;
    expect(File(firstTake).existsSync(), isTrue);

    await capture.recordAgain();

    expect(capture.stage, CaptureStage.voiceRecord);
    expect(capture.voiceNotePath, isNull);
    expect(File(firstTake).existsSync(), isFalse);
  });

  test('a typed description stands in for the voice note', () async {
    final capture = controllerWith(good);
    await takeThreePhotos(capture);
    capture.confirmPhotos();

    expect(await capture.saveTyped('   '), isFalse);
    expect(dao.saved, isEmpty);

    expect(await capture.saveTyped(' A blue clay jug, 600 rupees. '), isTrue);
    expect(capture.stage, CaptureStage.saved);
    expect(dao.saved.single.voiceNotePath, isEmpty);
    expect(dao.saved.single.description, 'A blue clay jug, 600 rupees.');
    expect(queue.pendingCount, 1);
  });

  test('nothing is queued until the voice note exists', () async {
    final capture = controllerWith(good);
    await takeThreePhotos(capture);

    expect(await capture.save(), isFalse);
    expect(dao.saved, isEmpty);
    expect(queue.pendingCount, 0);
  });

  test('a failed write says so instead of claiming it was saved', () async {
    final capture = controllerWith(good);
    await takeThreePhotos(capture);
    capture.confirmPhotos();
    await capture.startRecording();
    await capture.stopRecording();

    dao.failWrites = true;
    expect(await capture.save(), isFalse);

    expect(capture.saveError, isNotNull);
    expect(capture.stage, isNot(CaptureStage.saved));
    expect(queue.pendingCount, 0);

    dao.failWrites = false;
    expect(await capture.save(), isTrue);
    expect(queue.pendingCount, 1);
  });

  test('leaving before saving leaves nothing behind', () async {
    final capture = controllerWith(good);
    await takeThreePhotos(capture);
    final folder = capture.photos.first.parent;
    expect(folder.existsSync(), isTrue);

    await capture.discard();

    expect(folder.existsSync(), isFalse);
    expect(dao.saved, isEmpty);
  });

  test('a photo kept past a warning stays flagged, wherever it is moved',
      () async {
    var verdict = dark;
    final capture = CaptureController(
      dao: dao,
      queue: queue,
      recorder: recorder,
      qualityChecker: (_) async => verdict,
      storageDirectory: () async => root,
    );

    await capture.reviewShot(shotFrom('dim'));
    await capture.keepShot();
    verdict = good;
    for (var i = 1; i < 3; i++) {
      await capture.reviewShot(shotFrom('shot$i'));
      await capture.keepShot();
    }

    expect(capture.stage, CaptureStage.photoSet);
    expect(capture.issueAt(0), ImageIssue.tooDark);
    expect(capture.issueAt(1), isNull);

    capture.movePhoto(2, 0);
    expect(capture.issueAt(0), isNull);
    expect(capture.issueAt(1), ImageIssue.tooDark);

    capture.retakePhotoAt(1);
    await capture.reviewShot(shotFrom('retaken'));
    await capture.keepShot();
    expect(capture.issueAt(1), isNull);
  });

  group('framing', () {
    const sized = ImageQuality(
      sharpness: 900,
      brightness: 130,
      isAcceptable: true,
      width: 832,
      height: 1248,
    );

    CaptureController framedWith(
      ImageQuality verdict,
      Future<ImageIssue?> Function(File, int, int) framing,
    ) =>
        CaptureController(
          dao: dao,
          queue: queue,
          recorder: recorder,
          qualityChecker: (_) async => verdict,
          framingChecker: framing,
          storageDirectory: () async => root,
        );

    test('a photo with the product off the edge goes to the warning',
        () async {
      (int, int)? askedWith;
      final capture = framedWith(sized, (_, width, height) async {
        askedWith = (width, height);
        return ImageIssue.outOfFrame;
      });

      await capture.reviewShot(shotFrom('wall'));

      expect(askedWith, (832, 1248));
      expect(capture.stage, CaptureStage.qualityWarning);
      expect(capture.quality?.issue, ImageIssue.outOfFrame);
    });

    test('a photo that already failed is not sent to the detector', () async {
      var asked = false;
      final capture = framedWith(dark, (_, _, _) async {
        asked = true;
        return null;
      });

      await capture.reviewShot(shotFrom('dark'));

      expect(asked, isFalse);
      expect(capture.quality?.issue, ImageIssue.tooDark);
    });

    test('a detector that throws does not trap the seller', () async {
      final capture = framedWith(
        sized,
        (_, _, _) async => throw StateError('no detector'),
      );

      await capture.reviewShot(shotFrom('undetectable'));

      expect(capture.stage, CaptureStage.camera);
      expect(capture.photos.length, 1);
    });
  });

  test('a check that throws does not trap the seller', () async {
    final capture = CaptureController(
      dao: dao,
      queue: queue,
      recorder: recorder,
      qualityChecker: (_) async => throw StateError('no isolate'),
      storageDirectory: () async => root,
    );

    await capture.reviewShot(shotFrom('unmeasurable'));

    expect(capture.stage, CaptureStage.camera);
    expect(capture.photos.length, 1);
    expect(capture.isChecking, isFalse);
  });
}
