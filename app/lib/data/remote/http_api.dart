import 'api_client.dart';

/// The real client. Swapping this in for [MockApi] is the only change needed
/// when the backend is ready.
class HttpApi implements ApiClient {
  // TODO: dio, base url from config, multipart upload, error mapping.
  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
