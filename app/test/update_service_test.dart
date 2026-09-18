import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:kirtikar/data/remote/api_client.dart';
import 'package:kirtikar/services/update_service.dart';

class _VersionApi implements ApiClient {
  _VersionApi(this.answer);

  final Future<int?> Function() answer;

  @override
  Future<int?> minimumSupportedBuild() => answer();

  @override
  noSuchMethod(Invocation invocation) => throw UnimplementedError();
}

void main() {
  UpdateService service(
    Future<int?> Function() minimum, {
    int? installed = 10,
  }) => UpdateService(
    api: _VersionApi(minimum),
    currentBuild: () async => installed,
    timeout: const Duration(milliseconds: 50),
  );

  test('gates a build older than the server supports', () async {
    final updates = service(() async => 11);
    await updates.check();
    expect(updates.mustUpdate, isTrue);
  });

  test('lets through the oldest supported build and anything newer', () async {
    final same = service(() async => 10);
    await same.check();
    expect(same.mustUpdate, isFalse);

    final newer = service(() async => 3);
    await newer.check();
    expect(newer.mustUpdate, isFalse);
  });

  test('a server with no opinion does not gate', () async {
    final updates = service(() async => null);
    await updates.check();
    expect(updates.mustUpdate, isFalse);
  });

  test('an error, a timeout or an unreadable build never gates', () async {
    final failing = service(() async => throw Exception('500'));
    await failing.check();
    expect(failing.mustUpdate, isFalse);

    final slow = service(() => Completer<int?>().future);
    await slow.check();
    expect(slow.mustUpdate, isFalse);

    final unknownBuild = service(() async => 99, installed: null);
    await unknownBuild.check();
    expect(unknownBuild.mustUpdate, isFalse);
  });

  test('a failed check keeps the last clear answer', () async {
    var fail = false;
    final updates = service(() async {
      if (fail) throw Exception('offline');
      return 11;
    });

    await updates.check();
    expect(updates.mustUpdate, isTrue);

    fail = true;
    await updates.check();
    expect(updates.mustUpdate, isTrue);
  });

  test('a build with nothing to ask never gates', () async {
    final updates = UpdateService();
    await updates.check();
    expect(updates.mustUpdate, isFalse);
  });
}
