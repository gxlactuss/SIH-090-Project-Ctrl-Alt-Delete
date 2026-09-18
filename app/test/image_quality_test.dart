import 'dart:math';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:kaarigar/core/constants/app_constants.dart';
import 'package:kaarigar/core/utils/image_quality.dart';

void main() {
  Uint8List textured({int brightness = 128, int spread = 60, int seed = 7}) {
    final random = Random(seed);
    final image = img.Image(width: 320, height: 240);
    for (var y = 0; y < image.height; y++) {
      for (var x = 0; x < image.width; x++) {
        final value = (brightness + random.nextInt(spread * 2) - spread).clamp(
          0,
          255,
        );
        image.setPixelRgb(x, y, value, value, value);
      }
    }
    return img.encodeJpg(image, quality: 92);
  }

  Uint8List flat(int value) {
    final image = img.Image(width: 320, height: 240);
    img.fill(image, color: img.ColorRgb8(value, value, value));
    return img.encodeJpg(image, quality: 92);
  }

  Uint8List blurredBowl() {
    final image = img.Image(width: 320, height: 240);
    img.fill(image, color: img.ColorRgb8(200, 200, 200));
    img.fillCircle(
      image,
      x: 160,
      y: 120,
      radius: 70,
      color: img.ColorRgb8(60, 60, 60),
    );
    return img.encodeJpg(img.gaussianBlur(image, radius: 16), quality: 92);
  }

  Uint8List blurredBowlOnSharpFloor() {
    final random = Random(5);
    final image = img.Image(width: 320, height: 240);
    img.fill(image, color: img.ColorRgb8(200, 200, 200));
    img.fillCircle(
      image,
      x: 160,
      y: 120,
      radius: 70,
      color: img.ColorRgb8(60, 60, 60),
    );
    img.gaussianBlur(image, radius: 16);
    for (var y = 216; y < 240; y++) {
      for (var x = 0; x < 320; x++) {
        final value = 20 + random.nextInt(160);
        image.setPixelRgb(x, y, value, value, value);
      }
    }
    return img.encodeJpg(image, quality: 92);
  }

  Uint8List onTable({
    required int left,
    required int top,
    required int width,
    required int height,
  }) {
    final random = Random(3);
    final image = img.Image(width: 320, height: 240);
    img.fill(image, color: img.ColorRgb8(200, 200, 200));
    for (var y = top; y < top + height; y++) {
      for (var x = left; x < left + width; x++) {
        final value = 20 + random.nextInt(160);
        image.setPixelRgb(x, y, value, value, value);
      }
    }
    return img.encodeJpg(image, quality: 92);
  }

  test('a well lit, detailed photo passes', () {
    final result = checkImageQualityBytes(textured());
    expect(result.isAcceptable, isTrue);
    expect(result.issue, isNull);
    expect((result.width, result.height), (320, 240));
  });

  test('the size reported is the photo as shown, not as stored', () {
    final image = img.decodeJpg(textured())!;
    image.exif.imageIfd.orientation = 6;
    final result = checkImageQualityBytes(img.encodeJpg(image, quality: 92));
    expect((result.width, result.height), (240, 320));
  });

  test('a photo taken in the dark is rejected as too dark', () {
    final result = checkImageQualityBytes(textured(brightness: 14, spread: 10));
    expect(result.isAcceptable, isFalse);
    expect(result.issue, ImageIssue.tooDark);
  });

  test('a photo shot into the sun is rejected as too bright', () {
    final result = checkImageQualityBytes(textured(brightness: 248, spread: 6));
    expect(result.isAcceptable, isFalse);
    expect(result.issue, ImageIssue.tooBright);
  });

  test('a photo of one flat tone is rejected as having nothing in it', () {
    final result = checkImageQualityBytes(flat(140));
    expect(result.isAcceptable, isFalse);
    expect(result.issue, ImageIssue.noSubject);
  });

  test('a badly blurred photo of a real object is rejected as blurry', () {
    final result = checkImageQualityBytes(blurredBowl());
    expect(result.isAcceptable, isFalse);
    expect(result.issue, ImageIssue.blurry);
  });

  test('a shaken photo with a sharp strip of floor is still blurry', () {
    final result = checkImageQualityBytes(blurredBowlOnSharpFloor());
    expect(
      result.sharpness,
      greaterThan(AppConstants.minSharpness),
      reason: 'the whole-photo number alone would let this through',
    );
    expect(result.isAcceptable, isFalse);
    expect(result.issue, ImageIssue.blurry);
  });

  test(
    'something tiny in an empty frame is rejected as having nothing in it',
    () {
      final result = checkImageQualityBytes(
        onTable(left: 45, top: 33, width: 30, height: 24),
      );
      expect(result.isAcceptable, isFalse);
      expect(result.issue, ImageIssue.noSubject);
    },
  );

  test('a product on a plain background is not taken for an empty frame', () {
    final result = checkImageQualityBytes(
      onTable(left: 80, top: 60, width: 160, height: 120),
    );
    expect(result.isAcceptable, isTrue);
    expect(result.issue, isNull);
  });

  test('a file that is not an image at all is rejected, not thrown', () {
    final result = checkImageQualityBytes(
      Uint8List.fromList([1, 2, 3, 4, 5, 6, 7, 8]),
    );
    expect(result.isAcceptable, isFalse);
    expect(result.issue, ImageIssue.unreadable);
  });

  test('darkness is reported before blur, because it is the fixable one', () {
    final result = checkImageQualityBytes(flat(8));
    expect(result.issue, ImageIssue.tooDark);
  });
}
