import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:kaarigar/core/utils/image_quality.dart';
import 'package:kaarigar/features/onboarding/practice_screen.dart';

void main() {
  test('the good example passes the photo check', () {
    final quality = checkImageQualityBytes(
      File(PracticeScreen.goodPhoto).readAsBytesSync(),
    );
    expect(quality.isAcceptable, isTrue, reason: '${quality.issue}');
  });

  test('the bad example is turned away as blurry', () {
    final quality = checkImageQualityBytes(
      File(PracticeScreen.badPhoto).readAsBytesSync(),
    );
    expect(quality.isAcceptable, isFalse);
    expect(quality.issue, ImageIssue.blurry);
  });
}
