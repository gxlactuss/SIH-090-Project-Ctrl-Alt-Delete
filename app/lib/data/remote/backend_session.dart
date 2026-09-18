import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'api_routes.dart';
import 'http_api.dart';
import 'upload_failure.dart';

class BackendSession {
  BackendSession({
    required String baseUrl,
    http.Client? client,
    Future<String?> Function()? firebaseIdToken,
    DateTime Function()? now,
    this.timeout = const Duration(seconds: 20),
  }) : _base = Uri.parse(baseUrl.endsWith('/') ? baseUrl : '$baseUrl/'),
       _client = client ?? http.Client(),
       _firebaseIdToken = firebaseIdToken ?? _currentFirebaseIdToken,
       _now = now ?? DateTime.now;

  static const String _kToken = 'backend_access_token';

  static const Duration _expiryMargin = Duration(minutes: 1);

  final Uri _base;
  final http.Client _client;
  final Future<String?> Function() _firebaseIdToken;
  final DateTime Function() _now;
  final Duration timeout;

  String? _token;
  bool _loaded = false;
  Future<String?>? _exchanging;

  Future<String?> token() async {
    if (!_loaded) {
      _token = (await SharedPreferences.getInstance()).getString(_kToken);
      _loaded = true;
    }
    final current = _token;
    if (current != null && !_isExpired(current)) return current;
    return _exchanging ??= _exchange().whenComplete(() => _exchanging = null);
  }

  String? get currentToken {
    final current = _token;
    return current != null && !_isExpired(current) ? current : null;
  }

  Future<void> invalidate() async {
    _token = null;
    _loaded = true;
    await (await SharedPreferences.getInstance()).remove(_kToken);
  }

  Future<void> clear() => invalidate();

  Future<String?> _exchange() async {
    final String? idToken;
    try {
      idToken = await _firebaseIdToken();
    } on FirebaseAuthException catch (error) {
      throw UploadException(UploadFailure.network, error);
    }
    if (idToken == null || idToken.isEmpty) return null;

    final http.Response response;
    try {
      const route = ApiRoutes.authExchange;
      final request = http.Request(route.method, _base.resolve(route.path()))
        ..headers['accept'] = 'application/json'
        ..headers['content-type'] = 'application/json; charset=utf-8'
        ..body = jsonEncode({'id_token': idToken});
      response = await _client
          .send(request)
          .then(http.Response.fromStream)
          .timeout(timeout);
    } on TimeoutException catch (error) {
      throw UploadException(UploadFailure.network, error);
    } on SocketException catch (error) {
      throw UploadException(UploadFailure.network, error);
    } on http.ClientException catch (error) {
      throw UploadException(UploadFailure.network, error);
    }

    final code = response.statusCode;
    if (code < 200 || code >= 300) {
      throw UploadException(
        HttpApi.failureFor(code),
        'sign-in HTTP $code',
        code,
      );
    }

    final String token;
    try {
      final body = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
      token = body['access_token'] as String;
    } catch (error) {
      throw UploadException(UploadFailure.server, error);
    }

    _token = token;
    await (await SharedPreferences.getInstance()).setString(_kToken, token);
    return token;
  }

  bool _isExpired(String token) {
    final expiry = expiryOf(token);
    if (expiry == null) return false;
    return !_now().isBefore(expiry.subtract(_expiryMargin));
  }

  static DateTime? expiryOf(String token) {
    final parts = token.split('.');
    if (parts.length != 3) return null;
    try {
      final payload = jsonDecode(
        utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))),
      );
      final exp = (payload as Map)['exp'];
      if (exp is! num) return null;
      return DateTime.fromMillisecondsSinceEpoch(
        exp.toInt() * 1000,
        isUtc: true,
      );
    } catch (_) {
      return null;
    }
  }

  static Future<String?> _currentFirebaseIdToken() async {
    if (Firebase.apps.isEmpty) return null;
    return FirebaseAuth.instance.currentUser?.getIdToken();
  }
}
