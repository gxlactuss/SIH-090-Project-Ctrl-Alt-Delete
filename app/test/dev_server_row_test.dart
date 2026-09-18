import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kirtikar/data/remote/server_check.dart';
import 'package:kirtikar/widgets/dev_server_row.dart';

class _FakeCheck implements ServerCheck {
  @override
  Future<ServerCheckResult> run() async => const ServerCheckResult(
    reachable: true,
    lines: ['health: 200 in 12 ms', 'sign-in: ok'],
  );

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  testWidgets('hidden in a build with no server', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: DevServerRow())),
    );
    expect(find.byType(InkWell), findsNothing);
  });

  testWidgets('a tap runs the check and lists what it found', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: DevServerRow(check: _FakeCheck())),
      ),
    );
    expect(find.text('Tap to check server'), findsOneWidget);

    await tester.tap(find.byType(InkWell));
    await tester.pumpAndSettle();

    expect(find.text('health: 200 in 12 ms'), findsOneWidget);
    expect(find.text('sign-in: ok'), findsOneWidget);
    expect(find.byIcon(Icons.cloud_done_outlined), findsOneWidget);
  });
}
