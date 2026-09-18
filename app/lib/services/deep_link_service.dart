import 'package:flutter/foundation.dart';

import '../core/routing/app_routes.dart';

@immutable
class LinkTarget {
  const LinkTarget({required this.route, this.listingId, this.saleId});

  const LinkTarget.listing(String id)
    : route = AppRoutes.listing,
      listingId = id,
      saleId = null;

  const LinkTarget.review(String id)
    : route = AppRoutes.review,
      listingId = id,
      saleId = null;

  const LinkTarget.sale(String id)
    : route = AppRoutes.sale,
      listingId = null,
      saleId = id;

  const LinkTarget.queue()
    : route = AppRoutes.queue,
      listingId = null,
      saleId = null;

  final String route;
  final String? listingId;
  final String? saleId;

  @override
  bool operator ==(Object other) =>
      other is LinkTarget &&
      other.route == route &&
      other.listingId == listingId &&
      other.saleId == saleId;

  @override
  int get hashCode => Object.hash(route, listingId, saleId);

  @override
  String toString() => 'LinkTarget($route, ${listingId ?? saleId ?? ''})';
}

abstract final class DeepLinks {
  static const String scheme = 'kirtikar';

  static const String shareHost = 'kirtikar.example';

  static LinkTarget? parse(Uri uri) {
    final segments = [
      for (final segment in uri.pathSegments)
        if (segment.isNotEmpty) segment,
    ];

    if (uri.scheme == scheme) {
      final kind = uri.host.isNotEmpty ? uri.host : segments.firstOrNull;
      final id = uri.host.isNotEmpty
          ? segments.firstOrNull
          : segments.elementAtOrNull(1);
      return switch (kind) {
        'listing' when id != null => LinkTarget.listing(id),
        'review' when id != null => LinkTarget.review(id),
        'sale' when id != null => LinkTarget.sale(id),
        'queue' => const LinkTarget.queue(),
        _ => null,
      };
    }

    if ((uri.scheme == 'https' || uri.scheme == 'http') &&
        uri.host == shareHost) {
      if (segments.length >= 2 && segments.first == 'p') {
        return LinkTarget.listing(segments[1]);
      }
      return null;
    }

    return null;
  }

  static String shareUrl(String listingId) => 'https://$shareHost/p/$listingId';
}
