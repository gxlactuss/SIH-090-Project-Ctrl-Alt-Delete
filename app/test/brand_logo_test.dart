import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kirtikar/widgets/app_logo.dart';

const _markAsset = 'assets/images/brand/logo_mark.png';
const _lockupAsset = 'assets/images/brand/logo_full.png';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('the brand artwork exists and pubspec ships it', () {
    final pubspec = File('pubspec.yaml').readAsStringSync();
    expect(
      pubspec,
      contains('- assets/images/brand/'),
      reason: 'the brand folder must be declared or the logo will not load',
    );

    for (final asset in [_markAsset, _lockupAsset]) {
      final file = File(asset);
      expect(file.existsSync(), isTrue, reason: '$asset is missing');
      expect(
        file.lengthSync(),
        greaterThan(1024),
        reason: '$asset looks empty or truncated',
      );
    }
  });

  test('both files decode as real transparent images', () async {
    for (final asset in [_markAsset, _lockupAsset]) {
      final bytes = await rootBundle.load(asset);
      final codec = await ui.instantiateImageCodec(
        bytes.buffer.asUint8List(),
      );
      final frame = await codec.getNextFrame();

      expect(frame.image.width, greaterThan(64), reason: asset);
      expect(frame.image.height, greaterThan(64), reason: asset);

      final data = await frame.image.toByteData();
      final corner = data!.getUint32(0);
      expect(
        corner & 0xFF,
        0,
        reason: '$asset should have a transparent top-left corner',
      );
    }
  });

  testWidgets('the mark is drawn at the size asked for', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Center(child: AppLogo(size: 96))),
    );

    final image = tester.widget<Image>(find.byType(Image));
    expect((image.image as AssetImage).assetName, _markAsset);
    expect(tester.getSize(find.byType(Image)), const Size(96, 96));
  });

  testWidgets('the lockup draws the wordmark version', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Center(child: AppLogoLockup(width: 180))),
    );

    final image = tester.widget<Image>(find.byType(Image));
    expect((image.image as AssetImage).assetName, _lockupAsset);
    expect(tester.getSize(find.byType(Image)).width, 180);
  });

  testWidgets('the logo loads from the bundle without an error box', (
    tester,
  ) async {
    final errors = <String>[];
    final original = FlutterError.onError;
    FlutterError.onError = (details) =>
        errors.add(details.exceptionAsString());

    try {
      await tester.pumpWidget(
        const MaterialApp(home: Center(child: AppLogo(size: 132))),
      );
      final element = tester.element(find.byType(AppLogo));
      await tester.runAsync(
        () => precacheImage(const AssetImage(_markAsset), element),
      );
      await tester.pumpAndSettle();
    } finally {
      FlutterError.onError = original;
    }

    expect(errors, isEmpty, reason: errors.join('\n'));
  });
}
