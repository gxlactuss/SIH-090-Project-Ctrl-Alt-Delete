abstract final class DevFlags {
  static const bool freshStart = bool.fromEnvironment('fresh');

  static const bool failUploads = bool.fromEnvironment('failUploads');

  static const bool forceUpdate = bool.fromEnvironment('forceUpdate');
}
