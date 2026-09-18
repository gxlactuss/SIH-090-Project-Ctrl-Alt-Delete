import 'backend_session.dart';

class MediaAuth {
  MediaAuth({required String baseUrl, required this.token})
    : _origin = Uri.parse(baseUrl);

  factory MediaAuth.forSession(String baseUrl, BackendSession session) =>
      MediaAuth(baseUrl: baseUrl, token: () => session.currentToken);

  final Uri _origin;

  final String? Function() token;

  Map<String, String>? headersFor(String url) {
    final target = Uri.tryParse(url);
    if (target == null ||
        target.scheme != _origin.scheme ||
        target.host != _origin.host ||
        target.port != _origin.port) {
      return null;
    }
    final current = token();
    return current == null ? null : {'authorization': 'Bearer $current'};
  }
}
