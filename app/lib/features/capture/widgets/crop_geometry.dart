import 'dart:math' as math;
import 'dart:ui';

import '../../../core/utils/photo_edit.dart';

typedef CropHandle = ({bool left, bool top, bool right, bool bottom});

class CropGeometry {
  CropGeometry({
    required this.view,
    required this.imageWidth,
    required this.imageHeight,
    required this.edit,
    this.margin = 24,
  }) {
    final turned = edit.turnedSize(imageWidth, imageHeight);
    turnedWidth = turned.$1.toDouble();
    turnedHeight = turned.$2.toDouble();
    final radians = edit.angle * math.pi / 180;
    _cos = math.cos(radians);
    _sin = math.sin(radians);
    final boundsW = turnedWidth * _cos.abs() + turnedHeight * _sin.abs();
    final boundsH = turnedWidth * _sin.abs() + turnedHeight * _cos.abs();
    scale = math.max(
      0.0001,
      math.min(
        (view.width - 2 * margin) / boundsW,
        (view.height - 2 * margin) / boundsH,
      ),
    );
  }

  static const double minBoxSide = 48;

  final Size view;
  final int imageWidth;
  final int imageHeight;
  final PhotoEdit edit;
  final double margin;

  late final double turnedWidth;
  late final double turnedHeight;

  late final double scale;

  late final double _cos;
  late final double _sin;

  Offset get viewCenter => view.center(Offset.zero);

  Rect get box {
    final (cropW, cropH) = edit.cropSize(imageWidth, imageHeight);
    final x = edit.centerX * turnedWidth;
    final y = edit.centerY * turnedHeight;
    final center =
        viewCenter + Offset(_cos * x - _sin * y, _sin * x + _cos * y) * scale;
    return Rect.fromCenter(
      center: center,
      width: cropW * scale,
      height: cropH * scale,
    );
  }

  PhotoEdit editFor(Rect rect) {
    final aspect = rect.width / rect.height;
    final (_, fullHeight) = edit
        .copyWith(aspect: aspect, zoom: 1)
        .cropSize(imageWidth, imageHeight);
    final d = (rect.center - viewCenter) / scale;
    final x = _cos * d.dx + _sin * d.dy;
    final y = -_sin * d.dx + _cos * d.dy;
    return edit.copyWith(
      aspect: aspect,
      zoom: fullHeight / (rect.height / scale),
      centerX: x / turnedWidth,
      centerY: y / turnedHeight,
    );
  }

  PhotoEdit clampedEditFor(Rect rect) =>
      editFor(rect).clampedFor(imageWidth, imageHeight);

  bool fits(Rect rect) {
    if (rect.width < minBoxSide - 1e-6 || rect.height < minBoxSide - 1e-6) {
      return false;
    }
    final raw = editFor(rect);
    final clamped = raw.clampedFor(imageWidth, imageHeight);
    const eps = 1e-6;
    return (raw.zoom - clamped.zoom).abs() < eps &&
        (raw.aspect - clamped.aspect).abs() < eps &&
        (raw.centerX - clamped.centerX).abs() < eps &&
        (raw.centerY - clamped.centerY).abs() < eps;
  }

  PhotoEdit resize(Rect start, CropHandle handle, Offset finger) {
    var left = start.left;
    var top = start.top;
    var right = start.right;
    var bottom = start.bottom;
    if (handle.left) left = math.min(finger.dx, right - minBoxSide);
    if (handle.right) right = math.max(finger.dx, left + minBoxSide);
    if (handle.top) top = math.min(finger.dy, bottom - minBoxSide);
    if (handle.bottom) bottom = math.max(finger.dy, top + minBoxSide);
    final target = Rect.fromLTRB(left, top, right, bottom);

    if (fits(target)) return clampedEditFor(target);
    var low = 0.0;
    var high = 1.0;
    for (var i = 0; i < 24; i++) {
      final mid = (low + high) / 2;
      if (fits(Rect.lerp(start, target, mid)!)) {
        low = mid;
      } else {
        high = mid;
      }
    }
    return clampedEditFor(Rect.lerp(start, target, low)!);
  }
}
