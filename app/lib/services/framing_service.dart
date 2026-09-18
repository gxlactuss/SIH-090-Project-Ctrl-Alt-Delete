import 'dart:io';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:google_mlkit_object_detection/google_mlkit_object_detection.dart';

import '../core/utils/framing.dart';
import '../core/utils/image_quality.dart';

class FramingService {
  ObjectDetector? _detector;

  Future<ImageIssue?> check(File photo, int width, int height) async {
    final detector = _detector ??= ObjectDetector(
      options: ObjectDetectorOptions(
        mode: DetectionMode.single,
        classifyObjects: false,
        multipleObjects: true,
      ),
    );

    final objects = await detector.processImage(
      InputImage.fromFilePath(photo.path),
    );
    final boxes = [for (final object in objects) object.boundingBox];
    final issue = framingIssue(
      boxes,
      Size(width.toDouble(), height.toDouble()),
    );

    if (kDebugMode) debugPrint('framing ${width}x$height $boxes -> $issue');
    return issue;
  }

  Future<void> dispose() async {
    final detector = _detector;
    _detector = null;
    try {
      await detector?.close();
    } catch (_) {}
  }
}
