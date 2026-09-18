import 'dart:math';
import 'dart:typed_data';

import 'package:image/image.dart' as img;

import '../constants/app_constants.dart';

enum ImageIssue {
  tooDark,
  tooBright,
  blurry,

  noSubject,

  outOfFrame,

  unreadable,
}

class ImageQuality {
  const ImageQuality({
    required this.sharpness,
    required this.brightness,
    required this.isAcceptable,
    this.issue,
    this.width = 0,
    this.height = 0,
  });

  final double sharpness;

  final double brightness;

  final bool isAcceptable;

  final ImageIssue? issue;

  final int width;
  final int height;
}

ImageQuality checkImageQualityBytes(Uint8List bytes) {
  final decoded = img.decodeImage(bytes);
  if (decoded == null) {
    return const ImageQuality(
      sharpness: 0,
      brightness: 0,
      isAcceptable: false,
      issue: ImageIssue.unreadable,
    );
  }

  final sideways = switch (decoded.exif.imageIfd.orientation) {
    5 || 6 || 7 || 8 => true,
    _ => false,
  };
  final uprightWidth = sideways ? decoded.height : decoded.width;
  final uprightHeight = sideways ? decoded.width : decoded.height;

  final small = img.grayscale(
    img.copyResize(
      decoded,
      width: AppConstants.qualityCheckWidth,
      interpolation: img.Interpolation.average,
    ),
  );

  final width = small.width;
  final height = small.height;

  final luma = Float64List(width * height);
  var sum = 0.0;
  var squares = 0.0;
  for (var y = 0; y < height; y++) {
    for (var x = 0; x < width; x++) {
      final value = small.getPixel(x, y).luminance.toDouble();
      luma[y * width + x] = value;
      sum += value;
      squares += value * value;
    }
  }
  final brightness = sum / luma.length;

  final contrast = sqrt(
    max(0.0, squares / luma.length - brightness * brightness),
  );

  const grid = AppConstants.qualityGrid;
  final cellSum = Float64List(grid * grid);
  final cellSquares = Float64List(grid * grid);
  final cellCount = Int32List(grid * grid);
  final cellLuma = Float64List(grid * grid);
  final cellLumaSquares = Float64List(grid * grid);
  var laplaceSum = 0.0;
  var laplaceSquares = 0.0;
  var count = 0;
  for (var y = 1; y < height - 1; y++) {
    final row = y * grid ~/ height * grid;
    for (var x = 1; x < width - 1; x++) {
      final i = y * width + x;
      final value =
          luma[i - 1] +
          luma[i + 1] +
          luma[i - width] +
          luma[i + width] -
          4 * luma[i];
      laplaceSum += value;
      laplaceSquares += value * value;
      count++;

      final cell = row + x * grid ~/ width;
      cellSum[cell] += value;
      cellSquares[cell] += value * value;
      cellCount[cell]++;
      cellLuma[cell] += luma[i];
      cellLumaSquares[cell] += luma[i] * luma[i];
    }
  }

  final sharpness = _variance(laplaceSum, laplaceSquares, count);

  var detailCells = 0;
  var shadedCells = 0;
  var softCells = 0;
  for (var c = 0; c < cellCount.length; c++) {
    final sharp =
        _variance(cellSum[c], cellSquares[c], cellCount[c]) >=
        AppConstants.minSharpness;
    if (sharp) detailCells++;

    final shade = sqrt(
      max(0.0, _variance(cellLuma[c], cellLumaSquares[c], cellCount[c])),
    );
    if (shade >= AppConstants.minCellShade) {
      shadedCells++;
      if (!sharp) softCells++;
    }
  }
  final softShare = shadedCells == 0 ? 0.0 : softCells / shadedCells;

  final ImageIssue? issue;
  if (brightness < AppConstants.minBrightness) {
    issue = ImageIssue.tooDark;
  } else if (brightness > AppConstants.maxBrightness) {
    issue = ImageIssue.tooBright;
  } else if (detailCells > 0 && detailCells < AppConstants.minDetailCells) {
    issue = ImageIssue.noSubject;
  } else if (sharpness < AppConstants.minSharpness ||
      softShare >= AppConstants.maxSoftShare) {
    issue = contrast < AppConstants.minContrast
        ? ImageIssue.noSubject
        : ImageIssue.blurry;
  } else {
    issue = null;
  }

  return ImageQuality(
    sharpness: sharpness,
    brightness: brightness,
    isAcceptable: issue == null,
    issue: issue,
    width: uprightWidth,
    height: uprightHeight,
  );
}

double _variance(double sum, double squares, int count) {
  if (count == 0) return 0;
  final mean = sum / count;
  return squares / count - mean * mean;
}
