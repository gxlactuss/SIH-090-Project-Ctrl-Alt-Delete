import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:kirtikar/core/utils/framing.dart';
import 'package:kirtikar/core/utils/image_quality.dart';

void main() {
  const photo = Size(832, 1248);

  test('nothing found is a photo with no product in it', () {
    expect(framingIssue(const [], photo), ImageIssue.noSubject);
  });

  test('something too small to see is a photo with no product in it', () {
    expect(
      framingIssue([const Rect.fromLTWH(400, 600, 60, 60)], photo),
      ImageIssue.noSubject,
    );
  });

  test('a product in the middle of the photo passes', () {
    expect(
      framingIssue([const Rect.fromLTRB(160, 540, 620, 1040)], photo),
      isNull,
    );
  });

  test('the rim of a pot at the side of a photo of a wall is out of frame', () {
    expect(
      framingIssue([const Rect.fromLTRB(0, 690, 60, 920)], photo),
      ImageIssue.outOfFrame,
    );
  });

  test('a product mostly off the side of the photo is out of frame', () {
    expect(
      framingIssue([const Rect.fromLTRB(560, 400, 832, 900)], photo),
      ImageIssue.outOfFrame,
    );
  });

  test('a close-up that fills the photo passes', () {
    expect(
      framingIssue([const Rect.fromLTRB(-4, -4, 836, 1252)], photo),
      isNull,
    );
  });

  test('a pot standing at the bottom of the photo passes', () {
    expect(
      framingIssue([const Rect.fromLTRB(200, 700, 640, 1248)], photo),
      isNull,
    );
  });

  test('the biggest thing found is the one judged', () {
    expect(
      framingIssue([
        const Rect.fromLTRB(0, 100, 40, 160),
        const Rect.fromLTRB(160, 540, 620, 1040),
      ], photo),
      isNull,
    );
  });
}
