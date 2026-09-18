enum UploadFailure {
  network,

  server,

  missingFiles,

  rejected,

  unknown;

  bool get isRetryable => this != missingFiles && this != rejected;

  String get id => name;

  static UploadFailure byId(String? id) {
    if (id == null) return unknown;
    for (final failure in values) {
      if (failure.id == id) return failure;
    }
    return unknown;
  }
}

class UploadException implements Exception {
  const UploadException(this.failure, [this.detail, this.statusCode]);

  final UploadFailure failure;

  final int? statusCode;

  final Object? detail;

  @override
  String toString() => 'UploadException(${failure.id}, $detail)';
}
