import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:kaarigar/core/constants/app_constants.dart';
import 'package:kaarigar/core/utils/image_quality.dart';
import 'package:kaarigar/core/utils/photo_edit.dart';
import 'package:kaarigar/data/local/capture_dao.dart';
import 'package:kaarigar/data/models/capture_item.dart';
import 'package:kaarigar/services/recorder_service.dart';
import 'package:kaarigar/state/capture_controller.dart';
import 'package:kaarigar/state/queue_controller.dart';

class _FakeDao extends CaptureDao {
  final List<CaptureItem> saved = [];

  @override
  Future<void> insert(CaptureItem item) async => saved.add(item);

  @override
  Future<List<CaptureItem>> all() async => saved;
}

Uint8List _testPhoto() {
  final image = img.Image(width: 40, height: 20);
  for (var y = 0; y < 20; y++) {
    for (var x = 0; x < 40; x++) {
      if (x < 4 && y < 4) {
        image.setPixelRgb(x, y, 0, 255, 0);
      } else if (x < 20) {
        image.setPixelRgb(x, y, 255, 0, 0);
      } else {
        image.setPixelRgb(x, y, 0, 0, 255);
      }
    }
  }
  return img.encodePng(image);
}

img.Image _render(PhotoEdit edit) =>
    img.decodeJpg(renderPhotoEdit(PhotoEditJob(_testPhoto(), edit))!)!;

void main() {
  group('the geometry', () {
    test('no edit cuts the largest centred square', () {
      final out = _render(PhotoEdit.identity);
      expect(out.width, 20);
      expect(out.height, 20);
      expect(out.getPixel(3, 10).r, greaterThan(200));
      expect(out.getPixel(16, 10).b, greaterThan(200));
    });

    test('the square cannot be dragged off the photo', () {
      final edit = const PhotoEdit(centerX: -5, centerY: 5).clampedFor(40, 20);
      expect(edit.centerX, closeToValue(-0.25));
      expect(edit.centerY, 0);
    });

    test('dragged fully left, the square holds the green corner', () {
      final out = _render(const PhotoEdit(centerX: -1));
      expect(out.getPixel(1, 1).g, greaterThan(200));
      expect(out.getPixel(1, 1).r, lessThan(80));
    });

    test('a quarter turn clockwise puts the top-left corner top-right', () {
      final edit = const PhotoEdit(quarterTurns: 1, centerY: -1);
      final out = _render(edit);
      expect(out.width, 20);
      expect(out.getPixel(18, 1).g, greaterThan(200));
      expect(out.getPixel(1, 1).r, greaterThan(200));
    });

    test('turning keeps the square on the same part of the product', () {
      const edit = PhotoEdit(centerX: 0.2, centerY: -0.1);
      final back = edit.turned().turned().turned().turned();
      expect(back.centerX, closeToValue(edit.centerX));
      expect(back.centerY, closeToValue(edit.centerY));
      expect(back.quarterTurns, 0);
    });

    test('levelling never lets a corner of the crop outside the photo', () {
      for (final angle in [-15.0, -7.5, 3.0, 15.0]) {
        for (final aspect in [1.0, 2.5, 0.4]) {
          final edit = PhotoEdit(
            angle: angle,
            centerX: 1,
            centerY: 1,
            zoom: 1.3,
            aspect: aspect,
          ).clampedFor(4000, 3000);
          final (cropW, cropH) = edit.cropSize(4000, 3000);
          for (final corner in [(-1, -1), (1, -1), (-1, 1), (1, 1)]) {
            final point = sourcePointFor(
              edit,
              4000,
              3000,
              corner.$1 * cropW / 2,
              corner.$2 * cropH / 2,
              1,
            );
            expect(point.$1, inInclusiveRange(-1e-6, 4000 + 1e-6));
            expect(point.$2, inInclusiveRange(-1e-6, 3000 + 1e-6));
          }
        }
      }
    });

    test('a wide crop is saved wide, and a tall one tall', () {
      final wide = _render(const PhotoEdit(aspect: 2));
      expect(wide.width, 40);
      expect(wide.height, 20);
      expect(wide.getPixel(1, 1).g, greaterThan(200));

      final tall = _render(const PhotoEdit(aspect: 0.5));
      expect(tall.width, 10);
      expect(tall.height, 20);
    });

    test('the straightening and the zoom are held to their limits', () {
      final edit = const PhotoEdit(angle: 40, zoom: 99).clampedFor(100, 100);
      expect(edit.angle, AppConstants.maxStraightenDegrees);
      expect(edit.zoom, AppConstants.maxPhotoZoom);
    });

    test('the saved photo is never bigger than the cap', () {
      final big = img.Image(width: 3000, height: 2400);
      final bytes = renderPhotoEdit(
        PhotoEditJob(img.encodeJpg(big), PhotoEdit.identity),
      )!;
      expect(img.decodeJpg(bytes)!.width, AppConstants.editedPhotoMaxSide);
    });
  });

  group('the capture flow', () {
    late Directory root;
    late _FakeDao dao;
    late List<PhotoEdit> rendered;

    setUp(() {
      root = Directory.systemTemp.createTempSync('kaarigar_edit_test');
      dao = _FakeDao();
      rendered = [];
    });

    tearDown(() {
      if (root.existsSync()) root.deleteSync(recursive: true);
    });

    CaptureController controller() => CaptureController(
      dao: dao,
      queue: QueueController(dao: dao),
      recorder: RecorderService(),
      qualityChecker: (_) async => const ImageQuality(
        sharpness: 900,
        brightness: 130,
        isAcceptable: true,
      ),
      storageDirectory: () async => root,
      photoRenderer: (bytes, edit) async {
        rendered.add(edit);
        return Uint8List.fromList([1, 2, 3]);
      },
    );

    File shotFrom(String name) {
      final cache = Directory('${root.path}/cache')
        ..createSync(recursive: true);
      return File('${cache.path}/$name.jpg')
        ..writeAsBytesSync(List.filled(64, 9));
    }

    const crop = PhotoEdit(zoom: 2, centerX: 0.1);

    test('a photo edited on 3.4 is kept edited, original behind it', () async {
      final capture = controller();
      for (var i = 0; i < 3; i++) {
        await capture.reviewShot(shotFrom('a$i'));
      }

      capture.editPhotoAt(0);
      expect(capture.stage, CaptureStage.photoEdit);
      expect(await capture.applyEdit(crop), isTrue);
      expect(capture.stage, CaptureStage.photoSet);
      expect(capture.photos.first.path, contains('_edit_'));

      capture.editPhotoAt(0);
      expect(capture.currentEdit, crop);
      expect(capture.editSource!.path, endsWith('photo_1.jpg'));
    });

    test(
      'editing from 3.4 replaces the photo and deletes the old copy',
      () async {
        final capture = controller();
        for (var i = 0; i < 3; i++) {
          await capture.reviewShot(shotFrom('s$i'));
          await capture.keepShot();
        }

        capture.editPhotoAt(1);
        await capture.applyEdit(crop);
        final first = capture.photos[1];
        expect(capture.stage, CaptureStage.photoSet);

        capture.editPhotoAt(1);
        await capture.applyEdit(crop.copyWith(zoom: 3));
        expect(first.existsSync(), isFalse);
        expect(capture.photos[1].path, isNot(first.path));

        capture.editPhotoAt(1);
        await capture.applyEdit(PhotoEdit.identity);
        expect(capture.photos[1].path, endsWith('photo_2.jpg'));
        expect(rendered.length, 2);
      },
    );

    test('backing out of the editor changes nothing', () async {
      final capture = controller();
      for (var i = 0; i < 3; i++) {
        await capture.reviewShot(shotFrom('c$i'));
      }
      final before = capture.photos.first.path;

      capture.editPhotoAt(0);
      capture.cancelEdit();
      expect(capture.stage, CaptureStage.photoSet);
      expect(capture.photos.first.path, before);
      expect(rendered, isEmpty);
    });

    test(
      'a photo that will not render says so and stays on the editor',
      () async {
        final capture = CaptureController(
          dao: dao,
          queue: QueueController(dao: dao),
          recorder: RecorderService(),
          qualityChecker: (_) async => const ImageQuality(
            sharpness: 900,
            brightness: 130,
            isAcceptable: true,
          ),
          storageDirectory: () async => root,
          photoRenderer: (_, _) async => null,
        );
        await capture.reviewShot(shotFrom('d'));
        capture.editPhotoAt(0);

        expect(await capture.applyEdit(crop), isFalse);
        expect(capture.stage, CaptureStage.photoEdit);
        expect(capture.editError, isNotNull);
      },
    );
  });
}

Matcher closeToValue(double value) => closeTo(value, 1e-9);
