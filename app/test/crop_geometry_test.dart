import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:kaarigar/core/constants/app_constants.dart';
import 'package:kaarigar/core/utils/photo_edit.dart';
import 'package:kaarigar/features/capture/widgets/crop_geometry.dart';

void main() {
  const view = Size(360, 400);
  const leftEdge = (left: true, top: false, right: false, bottom: false);
  const bottomEdge = (left: false, top: false, right: false, bottom: true);
  const topLeft = (left: true, top: true, right: false, bottom: false);

  CropGeometry geometryFor(PhotoEdit edit, {int w = 900, int h = 1200}) =>
      CropGeometry(view: view, imageWidth: w, imageHeight: h, edit: edit);

  void expectRect(Rect actual, Rect expected, {double tolerance = 1e-3}) {
    expect(actual.left, closeTo(expected.left, tolerance));
    expect(actual.top, closeTo(expected.top, tolerance));
    expect(actual.right, closeTo(expected.right, tolerance));
    expect(actual.bottom, closeTo(expected.bottom, tolerance));
  }

  test('the untouched box is the whole short side, square and centred', () {
    final g = geometryFor(PhotoEdit.identity);
    final box = g.box;
    expect(box.center.dx, closeTo(g.viewCenter.dx, 1e-9));
    expect(box.center.dy, closeTo(g.viewCenter.dy, 1e-9));
    expect(box.width, closeTo(g.scale * 900, 1e-9));
    expect(box.height, closeTo(box.width, 1e-9));
  });

  test('a box turns into an edit and back without moving', () {
    for (final angle in [0.0, 7.5, -12.0]) {
      for (final turns in [0, 1]) {
        final g = geometryFor(PhotoEdit(angle: angle, quarterTurns: turns));
        final rect = Rect.fromCenter(
          center: g.viewCenter + const Offset(6, -9),
          width: 90,
          height: 60,
        );
        final again = geometryFor(g.editFor(rect));
        expectRect(again.box, rect, tolerance: 1e-6);
      }
    }
  });

  test('dragging the left edge crops only the width', () {
    final g = geometryFor(PhotoEdit.identity);
    final box = g.box;
    final edit = g.resize(box, leftEdge, box.centerLeft + const Offset(50, 0));
    expectRect(
      geometryFor(edit).box,
      Rect.fromLTRB(box.left + 50, box.top, box.right, box.bottom),
    );
    expect(edit.aspect, lessThan(1));
  });

  test('dragging the bottom edge crops only the height', () {
    final g = geometryFor(PhotoEdit.identity);
    final box = g.box;
    final edit = g.resize(
      box,
      bottomEdge,
      box.bottomCenter + const Offset(0, -40),
    );
    expectRect(
      geometryFor(edit).box,
      Rect.fromLTRB(box.left, box.top, box.right, box.bottom - 40),
    );
    expect(edit.aspect, greaterThan(1));
  });

  test('an edge dragged past the photo stops at its edge', () {
    final g = geometryFor(const PhotoEdit(zoom: 2));
    final box = g.box;
    final edit = g.resize(
      box,
      bottomEdge,
      box.bottomCenter + const Offset(0, 5000),
    );
    final after = geometryFor(edit).box;
    final photoBottom = g.viewCenter.dy + 600 * g.scale;
    expect(after.top, closeTo(box.top, 1e-3));
    expect(after.left, closeTo(box.left, 1e-3));
    expect(after.bottom, lessThanOrEqualTo(photoBottom + 1e-3));
    expect(edit.clampedFor(900, 1200), edit);
  });

  test('a corner moves two sides and holds the other two', () {
    final g = geometryFor(PhotoEdit.identity);
    final box = g.box;
    final edit = g.resize(box, topLeft, box.topLeft + const Offset(70, 30));
    expectRect(
      geometryFor(edit).box,
      Rect.fromLTRB(box.left + 70, box.top + 30, box.right, box.bottom),
    );
  });

  test('a box cannot be dragged thinner than the limits allow', () {
    final g = geometryFor(PhotoEdit.identity);
    final box = g.box;
    final edit = g.resize(box, leftEdge, box.centerRight);
    final after = geometryFor(edit).box;
    expect(after.right, closeTo(box.right, 1e-3));
    expect(after.width, greaterThanOrEqualTo(CropGeometry.minBoxSide - 1e-3));
    expect(
      edit.aspect,
      greaterThanOrEqualTo(1 / AppConstants.maxCropAspect - 1e-9),
    );
  });

  test('moving the box off the photo holds it at the edge', () {
    final g = geometryFor(const PhotoEdit(zoom: 2));
    final edit = g
        .editFor(g.box.shift(const Offset(-900, 0)))
        .clampedFor(900, 1200);
    final photoLeft = g.viewCenter.dx - 450 * g.scale;
    expect(geometryFor(edit).box.left, closeTo(photoLeft, 1e-6));
  });

  test('a turn makes a wide crop tall, over the same part of the photo', () {
    const wide = PhotoEdit(aspect: 2, zoom: 1.5, centerX: 0.1);
    final turned = wide.turned();
    expect(turned.aspect, 0.5);
    final before = wide.cropSize(900, 1200);
    final after = turned.cropSize(900, 1200);
    expect(after.$1, closeTo(before.$2, 1e-9));
    expect(after.$2, closeTo(before.$1, 1e-9));
  });
}
