import 'dart:async';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:kaarigar/data/remote/api_problem.dart';
import 'package:kaarigar/data/remote/http_api.dart';
import 'package:kaarigar/data/remote/upload_failure.dart';
import 'package:kaarigar/l10n/app_localizations_en.dart';
import 'package:kaarigar/widgets/api_problem_text.dart';
import 'package:kaarigar/widgets/status_view.dart';

void main() {
  Future<ApiProblem> problemFor(int status) async {
    final api = HttpApi(
      baseUrl: 'https://api.example.test/api/v1',
      client: MockClient((_) async => http.Response('{}', status)),
    );
    try {
      await api.listings();
    } catch (error) {
      return ApiProblem.of(error);
    }
    fail('HTTP $status should have thrown');
  }

  test('each status the server can send maps to one problem', () async {
    expect(await problemFor(401), ApiProblem.server);
    expect(await problemFor(403), ApiProblem.notAllowed);
    expect(await problemFor(404), ApiProblem.notFound);
    expect(await problemFor(409), ApiProblem.conflict);
    expect(await problemFor(422), ApiProblem.invalid);
    expect(await problemFor(500), ApiProblem.server);
    expect(await problemFor(503), ApiProblem.server);
  });

  test('no signal and timeouts are offline, however they arrive', () async {
    final api = HttpApi(
      baseUrl: 'https://api.example.test/api/v1',
      client: MockClient((_) async => throw const SocketException('down')),
    );
    Object? caught;
    try {
      await api.sales();
    } catch (error) {
      caught = error;
    }
    expect(ApiProblem.of(caught), ApiProblem.offline);
    expect(ApiProblem.of(TimeoutException('slow')), ApiProblem.offline);
    expect(ApiProblem.of(http.ClientException('reset')), ApiProblem.offline);
  });

  test('errors that did not come from the server are unknown', () {
    expect(ApiProblem.of(StateError('bug')), ApiProblem.unknown);
    expect(
      ApiProblem.of(const UploadException(UploadFailure.missingFiles)),
      ApiProblem.unknown,
    );
  });

  test('offline is 10.1, everything else 10.3, each with its own words', () {
    final l10n = AppLocalizationsEn();
    expect(ApiProblem.offline.statusKind, StatusKind.noNetwork);
    expect(ApiProblem.server.statusKind, StatusKind.serverError);
    expect(ApiProblem.notFound.statusKind, StatusKind.serverError);

    final messages = {for (final p in ApiProblem.values) p.message(l10n)};
    expect(messages, hasLength(ApiProblem.values.length));
    expect(ApiProblem.offline.isRetryable, isTrue);
    expect(ApiProblem.invalid.isRetryable, isFalse);
  });
}
