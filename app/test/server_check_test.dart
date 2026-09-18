import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:kaarigar/data/remote/backend_session.dart';
import 'package:kaarigar/data/remote/server_check.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('health is asked at the root, outside the api path', () {
    final check = ServerCheck(baseUrl: 'http://10.0.2.2:8000/api/v1');
    expect(check.healthUrl.toString(), 'http://10.0.2.2:8000/health');
  });

  test(
    'a healthy server reports its name and version, then signs in',
    () async {
      final seen = <Uri>[];
      final client = MockClient((request) async {
        seen.add(request.url);
        if (request.url.path == '/health') {
          return http.Response(
            jsonEncode({
              'status': 'ok',
              'service': 'kaarigar',
              'version': '0.1',
            }),
            200,
          );
        }
        return http.Response(jsonEncode({'access_token': 'server-token'}), 200);
      });
      final check = ServerCheck(
        baseUrl: 'http://10.0.2.2:8000/api/v1',
        client: client,
        session: BackendSession(
          baseUrl: 'http://10.0.2.2:8000/api/v1',
          client: client,
          firebaseIdToken: () async => 'firebase-token',
        ),
      );

      final result = await check.run();

      expect(result.reachable, isTrue);
      expect(result.lines.first, contains('health: 200'));
      expect(result.lines.first, contains('kaarigar 0.1'));
      expect(result.lines.last, 'sign-in: ok');
      expect(seen.last.path, '/api/v1/auth/firebase');
    },
  );

  test('an unreachable server says so and does not try to sign in', () async {
    var calls = 0;
    final check = ServerCheck(
      baseUrl: 'http://192.168.1.20:8000/api/v1',
      client: MockClient((_) async {
        calls++;
        throw http.ClientException('Connection refused');
      }),
      session: BackendSession(
        baseUrl: 'http://192.168.1.20:8000/api/v1',
        firebaseIdToken: () async => fail('should not sign in'),
      ),
    );

    final result = await check.run();

    expect(result.reachable, isFalse);
    expect(result.lines.single, startsWith('health: ClientException'));
    expect(calls, 1);
  });
}
