enum WireCase { camel, snake }

abstract final class WireJson {
  static const WireCase jsonBodies = WireCase.snake;

  static const WireCase formFields = WireCase.snake;

  static const List<String> listWrappers = ['items', 'data', 'results'];

  static const Map<String, String> listingAliases = {'status': 'state'};

  static Object? to(WireCase wireCase, Object? json) => switch (wireCase) {
    WireCase.camel => camel(json),
    WireCase.snake => snake(json),
  };

  static String name(WireCase wireCase, String key) => switch (wireCase) {
    WireCase.camel => camelKey(key),
    WireCase.snake => snakeKey(key),
  };

  static Object? camel(Object? json) => _keys(json, camelKey);

  static Object? snake(Object? json) => _keys(json, snakeKey);

  static String camelKey(String key) {
    if (!key.contains('_')) return key;
    final parts = key.split('_').where((part) => part.isNotEmpty).toList();
    if (parts.isEmpty) return key;
    return parts.first +
        parts
            .skip(1)
            .map((part) => part[0].toUpperCase() + part.substring(1))
            .join();
  }

  static String snakeKey(String key) => key.replaceAllMapped(
    RegExp('[A-Z]'),
    (match) => '${match.start == 0 ? '' : '_'}${match[0]!.toLowerCase()}',
  );

  static Map<String, dynamic> listing(Object? json) {
    final map = Map<String, dynamic>.from(camel(json) as Map);
    for (final MapEntry(key: name, value: alias) in listingAliases.entries) {
      if (map[name] == null && map[alias] != null) map[name] = map[alias];
    }
    final status = map['status'];
    if (status is String) map['status'] = camelKey(status);
    return map;
  }

  static List<Object?>? list(Object? body) {
    if (body is List) return body;
    if (body is Map) {
      for (final key in listWrappers) {
        final inner = body[key];
        if (inner is List) return inner;
      }
    }
    return null;
  }

  static Object? _keys(Object? json, String Function(String) rename) {
    if (json is Map) {
      return {
        for (final MapEntry(:key, :value) in json.entries)
          (key is String ? rename(key) : key): _keys(value, rename),
      };
    }
    if (json is List) return [for (final item in json) _keys(item, rename)];
    return json;
  }
}
