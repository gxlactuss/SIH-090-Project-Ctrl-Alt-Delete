import 'dart:math' as math;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class WholeWordText extends StatelessWidget {
  const WholeWordText(
    this.data, {
    super.key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  final String data;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context) {
    return WholeWords(
      child: Text(
        data,
        style: style,
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: overflow,
      ),
    );
  }
}

class WholeWords extends SingleChildRenderObjectWidget {
  const WholeWords({super.key, required Widget super.child});

  @override
  RenderObject createRenderObject(BuildContext context) => _RenderWholeWords();
}

class _RenderWholeWords extends RenderProxyBox {
  TextScaler? _requested;

  TextScaler? _applied;

  static final RegExp _space = RegExp(r'\s+');

  static final Map<Object, double> _widths = {};

  RenderParagraph? get _paragraph {
    RenderObject? node = child;
    while (node != null) {
      if (node is RenderParagraph) return node;
      node = node is RenderObjectWithChildMixin ? node.child : null;
    }
    return null;
  }

  @override
  void performLayout() {
    final paragraph = _paragraph;
    if (paragraph != null && constraints.hasBoundedWidth) {
      final current = paragraph.textScaler;
      if (_applied == null || current != _applied) _requested = current;
      final wanted = _fit(paragraph, _requested!, constraints.maxWidth);
      if (wanted != current) {
        invokeLayoutCallback<BoxConstraints>(
          (_) => paragraph.textScaler = wanted,
        );
      }
      _applied = wanted;
    }
    super.performLayout();
  }

  TextScaler _fit(
    RenderParagraph paragraph,
    TextScaler requested,
    double maxWidth,
  ) {
    final style = paragraph.text.style;
    final fontSize = style?.fontSize;
    if (style == null || fontSize == null || maxWidth <= 0) return requested;

    final text = paragraph.text.toPlainText(
      includeSemanticsLabels: false,
      includePlaceholders: false,
    );
    var widest = 0.0;
    for (final word in text.split(_space)) {
      if (word.isEmpty) continue;
      widest = math.max(widest, _width(word, style, requested, paragraph));
    }
    if (widest <= maxWidth) return requested;

    final size = requested.scale(fontSize) * maxWidth / widest * 0.98;
    return TextScaler.linear(size / fontSize);
  }

  static double _width(
    String word,
    TextStyle style,
    TextScaler scaler,
    RenderParagraph paragraph,
  ) {
    final key = (
      word,
      style,
      scaler.scale(style.fontSize!),
      paragraph.textDirection,
      paragraph.locale,
    );
    final known = _widths[key];
    if (known != null) return known;

    final painter = TextPainter(
      text: TextSpan(text: word, style: style),
      textDirection: paragraph.textDirection,
      locale: paragraph.locale,
      textScaler: scaler,
      maxLines: 1,
    )..layout();
    final width = painter.width;
    painter.dispose();

    if (_widths.length > 4000) _widths.clear();
    return _widths[key] = width;
  }
}
