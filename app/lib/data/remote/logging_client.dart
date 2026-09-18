import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class LoggingClient extends http.BaseClient {
  LoggingClient(this._inner, {void Function(String line)? log})
    : _log = log ?? debugPrint;

  final http.Client _inner;
  final void Function(String line) _log;

  static const int _bodyLimit = 400;

  static final RegExp _tokenish = RegExp(
    r'[A-Za-z0-9_-]{10,}\.[A-Za-z0-9_-]{10,}\.[A-Za-z0-9_-]{10,}',
  );

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final clock = Stopwatch()..start();
    final line = '[http] ${request.method} ${request.url}';
    final http.StreamedResponse response;
    try {
      response = await _inner.send(request);
    } catch (error) {
      _log('$line -> ${error.runtimeType} (${clock.elapsedMilliseconds} ms)');
      rethrow;
    }
    final took = '${response.statusCode} (${clock.elapsedMilliseconds} ms)';
    if (response.statusCode < 400) {
      _log('$line -> $took');
      return response;
    }

    final bytes = await response.stream.toBytes();
    _log('$line -> $took ${mask(utf8.decode(bytes, allowMalformed: true))}');
    return http.StreamedResponse(
      http.ByteStream.fromBytes(bytes),
      response.statusCode,
      contentLength: bytes.length,
      request: response.request,
      headers: response.headers,
      isRedirect: response.isRedirect,
      persistentConnection: response.persistentConnection,
      reasonPhrase: response.reasonPhrase,
    );
  }

  static String mask(String body) {
    final hidden = body.replaceAll(_tokenish, '<token>');
    return hidden.length <= _bodyLimit
        ? hidden
        : '${hidden.substring(0, _bodyLimit)}…';
  }

  @override
  void close() => _inner.close();
}
