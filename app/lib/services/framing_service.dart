import 'dart:io';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:google_mlkit_object_detection/google_mlkit_object_detection.dart';

import '../core/utils/framing.dart';
import '../core/utils/image_quality.dart';

/// Finds the product in a photo with the on-device object detector, so a
/// photo of the wall beside the product is caught before it is uploaded.
///
/// ML Kit's bundled model: no network and no Play services, which is the
/// phone this is built for. It finds the most prominent things in a photo and
/// draws a box round each. It does not know a bowl from a bucket, and nothing
/// here pretends it does -- that is the server's job.
///
/// Created and closed with the capture screen, like the camera: the model is
/// memory that nothing outside this flow needs. Overridable so a widget test
/// can stand in for it, since there is no detector under `flutter test`.
class FramingService {
  ObjectDetector? _detector;

  /// [width] and [height] are the upright photo's, which is the space the
  /// detector's boxes come back in.
  Future<ImageIssue?> check(File photo, int width, int height) async {
    final detector = _detector ??= ObjectDetector(
      options: ObjectDetectorOptions(
        mode: DetectionMode.single,
        classifyObjects: false,
        multipleObjects: true,
      ),
    );

    final objects =
        await detector.processImage(InputImage.fromFilePath(photo.path));
    final boxes = [for (final object in objects) object.boundingBox];
    final issue =
        framingIssue(boxes, Size(width.toDouble(), height.toDouble()));

    // What the detector saw, for tuning the thresholds on a real phone.
    if (kDebugMode) debugPrint('framing ${width}x$height $boxes -> $issue');
    return issue;
  }

  Future<void> dispose() async {
    final detector = _detector;
    _detector = null;
    try {
      await detector?.close();
    } catch (_) {
      // A detector that is already gone is not worth an error.
    }
  }
}
