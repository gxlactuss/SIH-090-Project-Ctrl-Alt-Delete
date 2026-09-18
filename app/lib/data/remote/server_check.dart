import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'backend_session.dart';

class ServerCheckResult {
  const ServerCheckResult({required this.reachable, required this.lines});

  final bool reachable;

  final List<String> lines;
}

class ServerCheck {
  ServerCheck({
    required String baseUrl,
    this.session,
    http.Client? client,
    this.timeout = const Duration(seconds: 8),
  }) : _base = Uri.parse(baseUrl.endsWith('/') ? baseUrl : '$baseUrl/'),
       _client = client ?? http.Client();

  final Uri _base;
  final http.Client _client;
  final BackendSession? session;
  final Duration timeout;

  Uri get healthUrl => _base.resolve('/health');

  Future<ServerCheckResult> run() async {
    final lines = <String>[];
    final clock = Stopwatch()..start();
    bool reachable;
    try {
      final response = await _client.get(healthUrl).timeout(timeout);
      reachable = response.statusCode == 200;
      lines.add(
        'health: ${response.statusCode} in ${clock.elapsedMilliseconds} ms'
        '${_describe(response)}',
      );
    } on TimeoutException {
      reachable = false;
      lines.add('health: no answer in ${timeout.inSeconds} s');
    } catch (error) {
      reachable = false;
      lines.add(
        'health: ${error.runtimeType} -- wrong address, or the '
        'server is not listening on the network',
      );
    }

    final signIn = session;
    if (!reachable || signIn == null) {
      return ServerCheckResult(reachable: reachable, lines: lines);
    }
    try {
      final token = await signIn.token();
      lines.add(
        token == null ? 'sign-in: nobody signed in to Firebase' : 'sign-in: ok',
      );
    } catch (error) {
      lines.add('sign-in: failed ($error)');
    }
    return ServerCheckResult(reachable: reachable, lines: lines);
  }

  static String _describe(http.Response response) {
    final Object? body;
    try {
      body = jsonDecode(utf8.decode(response.bodyBytes));
    } on FormatException {
      return '';
    }
    if (body is Map) {
      final name = body['service'];
      final version = body['version'];
      if (name != null || version != null) {
        return ' -- ${name ?? '?'} ${version ?? ''}'.trimRight();
      }
    }
    return '';
  }
}
