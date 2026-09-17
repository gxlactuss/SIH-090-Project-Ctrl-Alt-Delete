/// Why an upload did not go through.
///
/// An enum and not a message, because the message has to come out of the .arb
/// files -- and because 4.2 has to decide whether to offer a retry, which is
/// a property of the reason and not of the words.
enum UploadFailure {
  /// The network went away mid-upload. Retries on its own.
  network,

  /// The server answered, and said no. Worth retrying: it is usually a
  /// restart or a timeout at the other end.
  server,

  /// The photos or the voice note are no longer on the phone. Retrying
  /// cannot help, so 4.2 offers only delete.
  missingFiles,

  /// The server refused this capture for good -- too large, or malformed.
  rejected,

  unknown;

  /// Whether trying again could plausibly work. The one thing the screen
  /// must not do is offer a retry that is certain to fail again.
  bool get isRetryable => this != missingFiles && this != rejected;

  /// Stored in sqflite and read back on the next launch, so the reason
  /// survives the app being closed.
  String get id => name;

  static UploadFailure byId(String? id) {
    if (id == null) return unknown;
    for (final failure in values) {
      if (failure.id == id) return failure;
    }
    return unknown;
  }
}

/// Thrown by an [ApiClient] so the upload service can tell the seller which
/// of the five things went wrong without parsing an exception message.
class UploadException implements Exception {
  const UploadException(this.failure, [this.detail]);

  final UploadFailure failure;

  /// For the logs, never for the screen.
  final Object? detail;

  @override
  String toString() => 'UploadException(${failure.id}, $detail)';
}
