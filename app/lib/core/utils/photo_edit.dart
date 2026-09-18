import 'dart:math' as math;
import 'dart:typed_data';

import 'package:image/image.dart' as img;

import '../constants/app_constants.dart';

class PhotoEdit {
  const PhotoEdit({
    this.quarterTurns = 0,
    this.angle = 0,
    this.zoom = 1,
    this.centerX = 0,
    this.centerY = 0,
    this.aspect = 1,
  });

  final int quarterTurns;

  final double angle;

  final double zoom;

  final double aspect;

  final double centerX;
  final double centerY;

  static const identity = PhotoEdit();

  bool get isIdentity =>
      quarterTurns == 0 &&
      angle == 0 &&
      zoom == 1 &&
      centerX == 0 &&
      centerY == 0 &&
      aspect == 1;

  PhotoEdit copyWith({
    int? quarterTurns,
    double? angle,
    double? zoom,
    double? centerX,
    double? centerY,
    double? aspect,
  }) => PhotoEdit(
    quarterTurns: quarterTurns ?? this.quarterTurns,
    angle: angle ?? this.angle,
    zoom: zoom ?? this.zoom,
    centerX: centerX ?? this.centerX,
    centerY: centerY ?? this.centerY,
    aspect: aspect ?? this.aspect,
  );

  PhotoEdit clampedFor(int width, int height) {
    final turned = turnedSize(width, height);
    final sized = PhotoEdit(
      quarterTurns: quarterTurns % 4,
      angle: angle
          .clamp(
            -AppConstants.maxStraightenDegrees,
            AppConstants.maxStraightenDegrees,
          )
          .toDouble(),
      zoom: zoom.clamp(1.0, AppConstants.maxPhotoZoom).toDouble(),
      aspect: aspect
          .clamp(1 / AppConstants.maxCropAspect, AppConstants.maxCropAspect)
          .toDouble(),
    );
    final (cropW, cropH) = sized.cropSize(width, height);
    final radians = sized.angle * math.pi / 180;
    final c = math.cos(radians).abs();
    final s = math.sin(radians).abs();
    final halfX = (cropW * c + cropH * s) / 2;
    final halfY = (cropW * s + cropH * c) / 2;
    final limitX = math.max(0.0, 0.5 - halfX / turned.$1);
    final limitY = math.max(0.0, 0.5 - halfY / turned.$2);
    return sized.copyWith(
      centerX: centerX.clamp(-limitX, limitX).toDouble(),
      centerY: centerY.clamp(-limitY, limitY).toDouble(),
    );
  }

  PhotoEdit turned() => PhotoEdit(
    quarterTurns: (quarterTurns + 1) % 4,
    angle: angle,
    zoom: zoom,
    centerX: -centerY,
    centerY: centerX,
    aspect: 1 / aspect,
  );

  (int, int) turnedSize(int width, int height) =>
      quarterTurns.isOdd ? (height, width) : (width, height);

  (double, double) cropSize(int width, int height) {
    final turned = turnedSize(width, height);
    final radians = angle * math.pi / 180;
    final c = math.cos(radians).abs();
    final s = math.sin(radians).abs();
    final fullHeight = math.min(
      turned.$1 / (aspect * c + s),
      turned.$2 / (aspect * s + c),
    );
    final cropH = fullHeight / zoom;
    return (cropH * aspect, cropH);
  }

  @override
  bool operator ==(Object other) =>
      other is PhotoEdit &&
      other.quarterTurns == quarterTurns &&
      other.angle == angle &&
      other.zoom == zoom &&
      other.centerX == centerX &&
      other.centerY == centerY &&
      other.aspect == aspect;

  @override
  int get hashCode =>
      Object.hash(quarterTurns, angle, zoom, centerX, centerY, aspect);
}

(double, double) sourcePointFor(
  PhotoEdit edit,
  int width,
  int height,
  double dx,
  double dy,
  double outputScale,
) {
  final turned = edit.turnedSize(width, height);
  final radians = edit.angle * math.pi / 180;
  final c = math.cos(radians);
  final s = math.sin(radians);

  final lx = (c * dx + s * dy) / outputScale;
  final ly = (-s * dx + c * dy) / outputScale;

  final tx = lx + edit.centerX * turned.$1;
  final ty = ly + edit.centerY * turned.$2;

  var ox = tx;
  var oy = ty;
  for (var i = 0; i < edit.quarterTurns % 4; i++) {
    final nx = oy;
    final ny = -ox;
    ox = nx;
    oy = ny;
  }
  return (ox + width / 2, oy + height / 2);
}

img.Image? decodeUpright(Uint8List bytes) {
  final decoded = img.decodeImage(bytes);
  return decoded == null ? null : img.bakeOrientation(decoded);
}

PhotoPreview? decodePreview(Uint8List bytes) {
  final upright = decodeUpright(bytes);
  if (upright == null) return null;
  final longest = math.max(upright.width, upright.height);
  final small = longest <= AppConstants.photoEditPreviewSide
      ? upright
      : img.copyResize(
          upright,
          width: upright.width >= upright.height
              ? AppConstants.photoEditPreviewSide
              : null,
          height: upright.height > upright.width
              ? AppConstants.photoEditPreviewSide
              : null,
          interpolation: img.Interpolation.average,
        );
  final rgba = small.convert(numChannels: 4, format: img.Format.uint8);
  return PhotoPreview(
    width: rgba.width,
    height: rgba.height,
    sourceWidth: upright.width,
    sourceHeight: upright.height,
    rgba: rgba.getBytes(order: img.ChannelOrder.rgba),
  );
}

class PhotoPreview {
  const PhotoPreview({
    required this.width,
    required this.height,
    required this.sourceWidth,
    required this.sourceHeight,
    required this.rgba,
  });

  final int width;
  final int height;
  final int sourceWidth;
  final int sourceHeight;
  final Uint8List rgba;
}

class PhotoEditJob {
  const PhotoEditJob(this.bytes, this.edit);

  final Uint8List bytes;
  final PhotoEdit edit;
}

Uint8List? renderPhotoEdit(PhotoEditJob job) {
  final source = decodeUpright(job.bytes);
  if (source == null) return null;

  final edit = job.edit.clampedFor(source.width, source.height);
  final (cropW, cropH) = edit.cropSize(source.width, source.height);
  final scale = math.min(
    1.0,
    AppConstants.editedPhotoMaxSide / math.max(cropW, cropH),
  );
  final outputW = math.max(1, (cropW * scale).floor());
  final outputH = math.max(1, (cropH * scale).floor());

  final output = img.Image(width: outputW, height: outputH);
  final halfW = outputW / 2;
  final halfH = outputH / 2;
  final maxX = source.width - 1.0;
  final maxY = source.height - 1.0;

  for (var y = 0; y < outputH; y++) {
    for (var x = 0; x < outputW; x++) {
      final point = sourcePointFor(
        edit,
        source.width,
        source.height,
        x + 0.5 - halfW,
        y + 0.5 - halfH,
        scale,
      );
      final pixel = source.getPixelLinear(
        (point.$1 - 0.5).clamp(0.0, maxX),
        (point.$2 - 0.5).clamp(0.0, maxY),
      );
      output.setPixelRgb(x, y, pixel.r, pixel.g, pixel.b);
    }
  }

  return img.encodeJpg(output, quality: AppConstants.editedPhotoJpegQuality);
}
