abstract final class DevFlags {
  static const bool _release = bool.fromEnvironment('dart.vm.product');

  static const bool freshStart = !_release && bool.fromEnvironment('fresh');

  static const bool failUploads =
      !_release && bool.fromEnvironment('failUploads');

  static const bool forceUpdate =
      !_release && bool.fromEnvironment('forceUpdate');

  static const bool logHttp =
      !_release && bool.fromEnvironment('logHttp', defaultValue: true);
}
