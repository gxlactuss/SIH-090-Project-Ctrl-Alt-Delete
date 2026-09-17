import 'dart:io';

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kaarigar/widgets/whole_word_text.dart';

void main() {
  test('no plain Text widgets in the app', () {
    final plain = RegExp(r'(?<![\w.])Text\(');
    final offenders = <String>[];

    for (final entity in Directory('lib').listSync(recursive: true)) {
      if (entity is! File || !entity.path.endsWith('.dart')) continue;
      if (entity.path.contains('app_localizations')) continue;
      if (entity.path.endsWith('whole_word_text.dart')) continue;

      final lines = entity.readAsLinesSync();
      for (var i = 0; i < lines.length; i++) {
        if (lines[i].trimLeft().startsWith('//')) continue;
        if (plain.hasMatch(lines[i])) {
          offenders.add('${entity.path}:${i + 1}');
        }
      }
    }

    expect(
      offenders,
      isEmpty,
      reason: 'Use WholeWordText rather than Text:\n${offenders.join('\n')}',
    );
  });

  Widget boxed(double width, String text) => Directionality(
    textDirection: TextDirection.ltr,
    child: Center(
      child: SizedBox(
        width: width,
        child: WholeWordText(text, style: const TextStyle(fontSize: 20)),
      ),
    ),
  );

  RenderParagraph paragraph(WidgetTester tester) =>
      tester.renderObject<RenderParagraph>(find.byType(RichText));

  int lines(WidgetTester tester) {
    final laidOut = paragraph(tester);
    final length = laidOut.text.toPlainText().length;
    return laidOut
        .getBoxesForSelection(
          TextSelection(baseOffset: 0, extentOffset: length),
        )
        .map((box) => box.top)
        .toSet()
        .length;
  }

  testWidgets('leaves text alone when every word fits', (tester) async {
    await tester.pumpWidget(boxed(300, 'abc def'));

    expect(paragraph(tester).textScaler.scale(20), 20);
    expect(lines(tester), 1);
  });

  testWidgets('wraps between words at full size', (tester) async {
    await tester.pumpWidget(boxed(100, 'abcd efgh'));

    expect(paragraph(tester).textScaler.scale(20), 20);
    expect(lines(tester), 2);
  });

  testWidgets('shrinks a word wider than its box rather than breaking it', (
    tester,
  ) async {
    await tester.pumpWidget(boxed(100, 'abcdefghij'));

    expect(paragraph(tester).textScaler.scale(20), lessThanOrEqualTo(10));
    expect(lines(tester), 1);
  });

  testWidgets('grows back when the box does', (tester) async {
    await tester.pumpWidget(boxed(100, 'abcdefghij'));
    await tester.pumpWidget(boxed(400, 'abcdefghij'));

    expect(paragraph(tester).textScaler.scale(20), 20);
  });
}
