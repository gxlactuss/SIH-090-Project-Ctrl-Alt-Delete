import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:kaarigar/core/theme/app_theme.dart';

void main() {
  final hardcoded = RegExp(r'fontSize:\s*([0-9]+(?:\.[0-9]+)?)\s*[,)]');

  test('no text in the app is smaller than the floor', () {
    final offenders = <String>[];

    for (final entity in Directory('lib').listSync(recursive: true)) {
      if (entity is! File || !entity.path.endsWith('.dart')) continue;
      if (entity.path.contains('app_localizations')) continue;

      final lines = entity.readAsLinesSync();
      for (var i = 0; i < lines.length; i++) {
        for (final match in hardcoded.allMatches(lines[i])) {
          final size = double.parse(match.group(1)!);
          if (size < AppTheme.minTextSize) {
            offenders.add('${entity.path}:${i + 1} -> ${match.group(1)}');
          }
        }
      }
    }

    expect(
      offenders,
      isEmpty,
      reason:
          'Text below ${AppTheme.minTextSize}sp. Use '
          'AppTheme.minTextSize for secondary text, AppTheme.bodyTextSize '
          'for body copy, or the theme:\n${offenders.join('\n')}',
    );
  });

  test('the floor is not quietly lowered', () {
    expect(AppTheme.bodyTextSize, 18);
    expect(AppTheme.minTextSize, greaterThanOrEqualTo(16));
  });
}
