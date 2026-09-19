import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../core/config/app_config.dart';
import '../../core/dev/dev_flags.dart';
import 'api_client.dart';
import 'backend_session.dart';
import 'http_api.dart';
import 'hybrid_api.dart';
import 'logging_client.dart';
import 'mock_api.dart';

ApiClient buildApiClient({
  BackendSession? session,
  String? Function()? craftStory,
}) {
  if (!AppConfig.hasBackend) {
    return MockApi(failUploads: DevFlags.failUploads, craftStory: craftStory);
  }
  final signIn = session ?? buildBackendSession()!;
  final server = HttpApi(
    baseUrl: AppConfig.apiBaseUrl,
    client: _serverClient(),
    authToken: signIn.token,
    onUnauthorised: signIn.invalidate,
  );
  final onServer = HybridApi.parse(AppConfig.apiRealCalls);
  if (onServer == null) return server;
  return HybridApi(
    server: server,
    mock: MockApi(failUploads: DevFlags.failUploads, craftStory: craftStory),
    onServer: onServer,
  );
}

BackendSession? buildBackendSession() => AppConfig.hasBackend
    ? BackendSession(baseUrl: AppConfig.apiBaseUrl, client: _serverClient())
    : null;

http.Client? _serverClient() =>
    kDebugMode && DevFlags.logHttp ? LoggingClient(http.Client()) : null;
