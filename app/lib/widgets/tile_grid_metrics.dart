import 'dart:math' as math;

import 'package:flutter/widgets.dart';

class TileGridMetrics {
  const TileGridMetrics._({
    required this.columns,
    required this.tileWidth,
    required this.labelHeight,
  });

  final int columns;
  final double tileWidth;

  final double labelHeight;

  factory TileGridMetrics.of(
    BuildContext context, {
    required List<String> labels,
    required double width,
    required double spacing,
    required double labelInset,
    required TextStyle style,
    int maxColumns = 3,
  }) {
    final resolved = DefaultTextStyle.of(context).style.merge(style);
    final scaler = MediaQuery.textScalerOf(context);
    final direction = Directionality.of(context);
    final locale = Localizations.maybeLocaleOf(context);

    TextPainter painter(String text) => TextPainter(
      text: TextSpan(text: text, style: resolved),
      textDirection: direction,
      textScaler: scaler,
      locale: locale,
    );

    var widestWord = 0.0;
    for (final label in labels) {
      for (final word in label.split(RegExp(r'\s+'))) {
        if (word.isEmpty) continue;
        final measured = painter(word)..layout();
        widestWord = math.max(widestWord, measured.width);
        measured.dispose();
      }
    }

    double tileWidthFor(int columns) =>
        (width - spacing * (columns - 1)) / columns;

    var columns = maxColumns;
    while (columns > 1 && tileWidthFor(columns) - labelInset < widestWord) {
      columns--;
    }
    final tileWidth = tileWidthFor(columns);

    var tallest = 0.0;
    for (final label in labels) {
      final measured = painter(label)
        ..layout(maxWidth: math.max(1, tileWidth - labelInset));
      tallest = math.max(tallest, measured.height);
      measured.dispose();
    }

    return TileGridMetrics._(
      columns: columns,
      tileWidth: tileWidth,
      labelHeight: tallest,
    );
  }
}
