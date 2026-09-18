import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kirtikar/widgets/app_logo.dart';

const _res = 'android/app/src/main/res';

const _densities = {
  'mdpi': 1.0,
  'hdpi': 1.5,
  'xhdpi': 2.0,
  'xxhdpi': 3.0,
  'xxxhdpi': 4.0,
};

void main() {
  testWidgets('launcher icons', (tester) async {
    Future<void> render(String path, double canvas, double logo) async {
      final key = GlobalKey();
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: Center(
            child: RepaintBoundary(
              key: key,
              child: SizedBox.square(
                dimension: canvas,
                child: Center(child: AppLogo(size: logo)),
              ),
            ),
          ),
        ),
      );
      await tester.runAsync(() async {
        final boundary =
            key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
        final image = await boundary.toImage();
        final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
        File(path)
          ..createSync(recursive: true)
          ..writeAsBytesSync(bytes!.buffer.asUint8List());
      });
    }

    tester.view.physicalSize = const Size(1000, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    for (final MapEntry(key: bucket, value: scale) in _densities.entries) {
      await render(
        '$_res/mipmap-$bucket/ic_launcher.png',
        48 * scale,
        44 * scale,
      );
      await render(
        '$_res/mipmap-$bucket/ic_launcher_foreground.png',
        108 * scale,
        72 * scale,
      );
    }
  });
}
