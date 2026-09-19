abstract final class ApiRoutes {
  static const authExchange = ApiRoute('POST', 'auth/firebase');

  static const updateSeller = ApiRoute('PUT', 'seller');

  static const createListing = ApiRoute('POST', 'listings');
  static const uploadMedia = ApiRoute('POST', 'listings/{id}/media');

  static const listings = ApiRoute('GET', 'listings');
  static const listing = ApiRoute('GET', 'listings/{id}');
  static const setConsent = ApiRoute('POST', 'listings/{id}/consent');
  static const publish = ApiRoute('POST', 'listings/{id}/publish');
  static const approveSuggestion = ApiRoute(
    'POST',
    'listings/{id}/suggestions/{sub}/approval',
  );

  static const deleteAccount = ApiRoute('DELETE', 'seller');
  static const deleteListing = ApiRoute('DELETE', 'listings/{id}');
  static const patchListing = ApiRoute('PATCH', 'listings/{id}');
  static const answerQuestion = ApiRoute('POST', 'listings/{id}/answer');
  static const reviseListing = ApiRoute('POST', 'listings/{id}/revise');
  static const republish = ApiRoute('POST', 'listings/{id}/republish');
  static const unpublish = ApiRoute('POST', 'listings/{id}/unpublish');
  static const relist = ApiRoute('POST', 'listings/{id}/relist');
  static const sales = ApiRoute('GET', 'sales');
  static const minimumSupportedBuild = ApiRoute('GET', 'app/version');
}

class ApiRoute {
  const ApiRoute(this.method, this.template);

  final String method;

  final String template;

  String path([String? id, String? sub]) {
    var path = template;
    for (final (name, value) in [('{id}', id), ('{sub}', sub)]) {
      if (!path.contains(name)) continue;
      if (value == null) throw ArgumentError('$template needs $name');
      path = path.replaceAll(name, Uri.encodeComponent(value));
    }
    return path;
  }
}
