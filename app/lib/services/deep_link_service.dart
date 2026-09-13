import 'package:flutter/foundation.dart';

import '../core/routing/app_routes.dart';

/// Where a link or a notification wants the app to go.
///
/// Deliberately not a route name plus a loose `Object?`: the two ways into
/// the app from outside -- a shared link and a pushed notification -- have to
/// agree on their destinations, and a shared type is what stops them drifting
/// apart.
@immutable
class LinkTarget {
  const LinkTarget({required this.route, this.listingId, this.saleId});

  /// A listing, from the share page or from a "it sold" notification.
  const LinkTarget.listing(String id)
      : route = AppRoutes.listing,
        listingId = id,
        saleId = null;

  /// 5.1: something needs answering before it can go up.
  const LinkTarget.review(String id)
      : route = AppRoutes.review,
        listingId = id,
        saleId = null;

  /// 7.2.
  const LinkTarget.sale(String id)
      : route = AppRoutes.sale,
        listingId = null,
        saleId = id;

  /// 4.1, where an upload that has just finished or just failed is shown.
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

/// Turns a link into somewhere to go.
///
/// Two shapes are accepted, and both have to be, because they come from
/// different places. The custom scheme `kaarigar://listing/<id>` is what the
/// app's own notifications carry. The https link
/// `https://kaarigar.example/p/<id>` is what 5.11 puts on the QR code and
/// into the WhatsApp message -- so it is the one a buyer's phone will open,
/// and the one that has to survive being pasted, forwarded and re-shortened.
///
/// Parsing is pure and separate from navigating on purpose: a link arriving
/// at a bad moment -- during onboarding, before the seller has signed in --
/// is a routing decision, not a parsing one, and the two failing together
/// would be very hard to tell apart.
abstract final class DeepLinks {
  /// The app's own scheme, used by notification payloads.
  static const String scheme = 'kaarigar';

  /// The host the share page is served from. The path `/p/<id>` is what
  /// [PublishStage] builds its QR code and WhatsApp message from.
  static const String shareHost = 'kaarigar.example';

  /// Null when the link is not ours or names nothing we can open. A link we
  /// do not understand must open nothing rather than guess at a listing: the
  /// wrong listing is worse than none.
  static LinkTarget? parse(Uri uri) {
    final segments = [
      for (final segment in uri.pathSegments)
        if (segment.isNotEmpty) segment,
    ];

    if (uri.scheme == scheme) {
      // kaarigar://listing/<id> -- the host carries the kind, because a
      // custom scheme has no meaningful authority of its own.
      final kind = uri.host.isNotEmpty ? uri.host : segments.firstOrNull;
      final id = uri.host.isNotEmpty ? segments.firstOrNull : segments.elementAtOrNull(1);
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
      // The share page: /p/<id>.
      if (segments.length >= 2 && segments.first == 'p') {
        return LinkTarget.listing(segments[1]);
      }
      return null;
    }

    return null;
  }

  /// The link 5.11 shares, built in one place so the thing we hand out and
  /// the thing we parse can never disagree.
  static String shareUrl(String listingId) =>
      'https://$shareHost/p/$listingId';
}
