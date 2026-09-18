import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kirtikar/widgets/hold_to_speak_button.dart';

void main() {
  late List<String> calls;
  late Completer<void> starting;

  Widget harness() => MaterialApp(
    home: Scaffold(
      body: ListView(
        children: [
          const SizedBox(height: 200),
          HoldToSpeakButton(
            label: 'Hold to speak',
            recording: false,
            onStart: () async {
              calls.add('start');
              await starting.future;
              calls.add('started');
            },
            onStop: () async => calls.add('stop'),
          ),
          const SizedBox(height: 2000),
        ],
      ),
    ),
  );

  void reset() {
    calls = [];
    starting = Completer<void>();
  }

  testWidgets('a quick press stops once the recorder has started', (
    tester,
  ) async {
    reset();
    await tester.pumpWidget(harness());

    final gesture = await tester.startGesture(
      tester.getCenter(find.text('Hold to speak')),
    );
    await gesture.up();
    await tester.pump();

    expect(calls, ['start']);

    starting.complete();
    await tester.pump();
    expect(calls, ['start', 'started', 'stop']);
  });

  testWidgets('a finger that drifts keeps recording until it lifts', (
    tester,
  ) async {
    reset();
    starting.complete();
    await tester.pumpWidget(harness());

    final gesture = await tester.startGesture(
      tester.getCenter(find.text('Hold to speak')),
    );
    await tester.pump();

    await gesture.moveBy(const Offset(0, -60));
    await tester.pump();
    await gesture.moveBy(const Offset(8, -40));
    await tester.pump();
    expect(calls, ['start', 'started']);

    await gesture.up();
    await tester.pump();
    expect(calls, ['start', 'started', 'stop']);
  });
}
