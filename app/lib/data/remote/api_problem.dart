import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'upload_failure.dart';

enum ApiProblem {
  offline,

  server,

  notAllowed,

  notFound,

  conflict,

  invalid,

  unknown;

  static ApiProblem of(Object? error) => switch (error) {
    UploadException(statusCode: final int code) => forStatus(code),
    UploadException(failure: UploadFailure.network) => offline,
    UploadException(failure: UploadFailure.server) => server,
    UploadException(failure: UploadFailure.rejected) => invalid,
    UploadException() => unknown,
    TimeoutException() ||
    SocketException() ||
    http.ClientException() => offline,
    _ => unknown,
  };

  static ApiProblem forStatus(int code) => switch (code) {
    403 => notAllowed,
    404 || 410 => notFound,
    409 => conflict,
    400 || 422 => invalid,
    401 || 408 || 429 || >= 500 => server,
    _ => unknown,
  };

  bool get isRetryable => this == offline || this == server || this == unknown;
}
