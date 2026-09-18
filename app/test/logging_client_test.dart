import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:kaarigar/data/remote/logging_client.dart';

void main() {
  const jwt = 'eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJzMSJ9abc.c2lnbmF0dXJlLXZhbHVl';

  test(
    'a good call is one line and its body passes through untouched',
    () async {
      final lines = <String>[];
      final client = LoggingClient(
        MockClient((_) async => http.Response('{"ok":true}', 200)),
        log: lines.add,
      );

      final response = await client.get(
        Uri.parse('https://api.example.test/api/v1/listings'),
        headers: {'authorization': 'Bearer $jwt'},
      );

      expect(response.body, '{"ok":true}');
      expect(lines, hasLength(1));
      expect(lines.single, startsWith('[http] GET https://api.example.test'));
      expect(lines.single, contains('-> 200'));
      expect(lines.single, isNot(contains(jwt)));
    },
  );

  test(
    'a refusal prints its body with tokens masked, and still reads',
    () async {
      final lines = <String>[];
      final body = '{"detail":[{"loc":["body","id_token"],"input":"$jwt"}]}';
      final client = LoggingClient(
        MockClient((_) async => http.Response(body, 422)),
        log: lines.add,
      );

      final response = await client.post(
        Uri.parse('https://api.example.test/api/v1/auth/firebase'),
      );

      expect(response.statusCode, 422);
      expect(response.body, body);
      expect(lines.single, contains('-> 422'));
      expect(lines.single, contains('id_token'));
      expect(lines.single, contains('<token>'));
      expect(lines.single, isNot(contains(jwt)));
    },
  );

  test('a call that never reached the server is logged and rethrown', () async {
    final lines = <String>[];
    final client = LoggingClient(
      MockClient((_) async => throw http.ClientException('refused')),
      log: lines.add,
    );

    await expectLater(
      client.get(Uri.parse('http://10.0.2.2:8000/api/v1/sales')),
      throwsA(isA<http.ClientException>()),
    );
    expect(lines.single, contains('ClientException'));
  });

  test('long bodies are cut short', () {
    expect(LoggingClient.mask('x' * 1000).length, lessThan(420));
  });
}
