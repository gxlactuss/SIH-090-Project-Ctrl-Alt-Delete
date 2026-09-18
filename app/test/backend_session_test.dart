import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:kaarigar/data/remote/backend_session.dart';
import 'package:kaarigar/data/remote/http_api.dart';
import 'package:kaarigar/data/remote/upload_failure.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  final now = DateTime.utc(2026, 9, 17, 12);

  String jwt(DateTime expiry) {
    String part(Object json) =>
        base64Url.encode(utf8.encode(jsonEncode(json))).replaceAll('=', '');
    return '${part({'alg': 'HS256'})}.'
        '${part({'sub': 's1', 'exp': expiry.millisecondsSinceEpoch ~/ 1000})}'
        '.sig';
  }

  late List<http.Request> seen;
  late List<String> issued;

  BackendSession session({
    String? idToken = 'firebase-token',
    int status = 200,
    DateTime Function()? clock,
    Object? failure,
  }) => BackendSession(
    baseUrl: 'https://api.example.test/api/v1',
    firebaseIdToken: () async => idToken,
    now: clock ?? () => now,
    client: MockClient((request) async {
      seen.add(request);
      if (failure != null) throw failure;
      final token = jwt(now.add(const Duration(hours: 1)));
      issued.add(token);
      return http.Response(
        jsonEncode({'access_token': token, 'token_type': 'bearer'}),
        status,
      );
    }),
  );

  Matcher failsWith(UploadFailure failure) => throwsA(
    isA<UploadException>().having((e) => e.failure, 'failure', failure),
  );

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    seen = [];
    issued = [];
  });

  test('exchanges the Firebase token once and reuses the answer', () async {
    final signIn = session();

    final first = await signIn.token();
    final second = await signIn.token();

    expect(seen, hasLength(1));
    expect(seen.single.method, 'POST');
    expect(
      seen.single.url.toString(),
      'https://api.example.test/api/v1/auth/firebase',
    );
    expect(jsonDecode(seen.single.body), {'id_token': 'firebase-token'});
    expect(first, issued.single);
    expect(second, first);
  });

  test('calls made together share one exchange', () async {
    final signIn = session();

    final tokens = await Future.wait([signIn.token(), signIn.token()]);

    expect(seen, hasLength(1));
    expect(tokens.toSet(), hasLength(1));
  });

  test('a token on disk is used without signing in again', () async {
    await session().token();

    final restarted = session();
    final token = await restarted.token();

    expect(seen, hasLength(1));
    expect(token, issued.single);
  });

  test('a token about to run out is renewed first', () async {
    var clock = now;
    final signIn = session(clock: () => clock);
    await signIn.token();

    clock = now.add(const Duration(minutes: 59, seconds: 30));
    await signIn.token();

    expect(seen, hasLength(2));
  });

  test('invalidating forgets the token, on disk too', () async {
    final signIn = session();
    await signIn.token();

    await signIn.invalidate();
    await signIn.token();

    expect(seen, hasLength(2));
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString('backend_access_token'), issued.last);
  });

  test('clearing leaves nothing behind for the next seller', () async {
    final signIn = session();
    await signIn.token();

    await signIn.clear();

    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString('backend_access_token'), isNull);
  });

  test('nobody signed in to Firebase means no token, and no call', () async {
    final signIn = session(idToken: null);

    expect(await signIn.token(), isNull);
    expect(seen, isEmpty);
  });

  test('no network is a network failure', () async {
    final signIn = session(failure: const SocketException('offline'));

    await expectLater(signIn.token(), failsWith(UploadFailure.network));
  });

  test('a refused exchange carries the status reason', () async {
    await expectLater(
      session(status: 503).token(),
      failsWith(UploadFailure.server),
    );
    await expectLater(
      session(status: 422).token(),
      failsWith(UploadFailure.rejected),
    );
  });

  test('reads the expiry a server token carries', () {
    final expiry = now.add(const Duration(hours: 1));

    expect(BackendSession.expiryOf(jwt(expiry)), expiry);
    expect(BackendSession.expiryOf('not-a-jwt'), isNull);
  });

  group('with HttpApi', () {
    test('a 401 renews the token and tries once more', () async {
      final signIn = session();
      var calls = 0;
      final authorisations = <String?>[];
      final api = HttpApi(
        baseUrl: 'https://api.example.test/api/v1',
        authToken: signIn.token,
        onUnauthorised: signIn.invalidate,
        client: MockClient((request) async {
          calls++;
          authorisations.add(request.headers['authorization']);
          return calls == 1
              ? http.Response('expired', 401)
              : http.Response('[]', 200);
        }),
      );

      expect(await api.listings(), isEmpty);
      expect(calls, 2);
      expect(issued, hasLength(2));
      expect(authorisations, ['Bearer ${issued[0]}', 'Bearer ${issued[1]}']);
    });

    test('a second 401 is reported, not retried forever', () async {
      var calls = 0;
      final api = HttpApi(
        baseUrl: 'https://api.example.test/api/v1',
        authToken: () async => 'token',
        onUnauthorised: () async {},
        client: MockClient((_) async {
          calls++;
          return http.Response('no', 401);
        }),
      );

      await expectLater(api.listings(), failsWith(UploadFailure.server));
      expect(calls, 2);
    });

    test('without a way to renew, a 401 fails at once', () async {
      var calls = 0;
      final api = HttpApi(
        baseUrl: 'https://api.example.test/api/v1',
        client: MockClient((_) async {
          calls++;
          return http.Response('no', 401);
        }),
      );

      await expectLater(api.listings(), failsWith(UploadFailure.server));
      expect(calls, 1);
    });
  });
}
