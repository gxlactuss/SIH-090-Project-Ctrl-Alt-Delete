import 'dart:async';

import 'package:flutter/widgets.dart';

import '../../data/repositories/listing_repository.dart';
import '../../services/deep_link_service.dart';
import 'app_routes.dart';

/// Takes the app to where a link or a notification points.
///
/// It is separate from [DeepLinks] because parsing and navigating fail for
/// different reasons and at different times. A link can be understood
/// perfectly and still not be openable: the seller may be halfway through
/// recording a voice note, or may not have finished onboarding, or the
/// listing may not be on the phone yet.
///
/// The rules it follows:
///
///  * Onboarding is never interrupted. A link that arrives before the seller
///    has an account is dropped, not queued -- a half-registered seller
///    landing on a listing screen is a bug report, and the link is one tap
///    away in WhatsApp anyway.
///  * A listing has to be fetched before its screen can be pushed, and the
///    repository falls back to the cache, so a link opened underground on a
///    train still shows the listing if the phone has seen it before.
///  * A listing we cannot find opens nothing. Guessing is worse than
///    doing nothing.
class LinkRouter {
  LinkRouter({
    required this._navigatorKey,
    required this._listings,
  });

  final GlobalKey<NavigatorState> _navigatorKey;
  final ListingRepository _listings;

  /// Handed to the [MaterialApp], so the router can navigate without a
  /// BuildContext -- which it has to, because a push and a link both arrive
  /// from outside the widget tree entirely.
  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  NavigatorState? get _navigator => _navigatorKey.currentState;

  /// True once the seller is past onboarding and the shell is on screen.
  /// Set by the app; false until then, which is what keeps a notification
  /// from throwing a stranger into the middle of section 6.
  bool isReady = false;

  /// Opens a raw link -- from the share page, a WhatsApp message, or a
  /// scanned QR code. Returns whether it went anywhere, which is what the
  /// tests assert on.
  Future<bool> openUri(Uri uri) async {
    final target = DeepLinks.parse(uri);
    if (target == null) return false;
    return open(target);
  }

  Future<bool> open(LinkTarget target) async {
    final navigator = _navigator;
    if (navigator == null || !isReady) return false;

    switch (target.route) {
      case AppRoutes.listing || AppRoutes.review:
        final id = target.listingId;
        if (id == null) return false;
        // Cache first and network second, both through the repository: a
        // listing the app has already seen opens instantly and a listing it
        // has not waits for the one call.
        final listing = await _listings.fetch(id);
        if (listing == null) return false;
        if (_navigator == null) return false;
        // Not awaited. `pushNamed` completes when the route is *popped*, so
        // awaiting it would leave this future hanging for as long as the
        // seller stays on the screen we just opened.
        unawaited(_navigator!.pushNamed(target.route, arguments: listing));
        return true;

      case AppRoutes.sale:
        final id = target.saleId;
        if (id == null) return false;
        unawaited(navigator.pushNamed(AppRoutes.sale, arguments: id));
        return true;

      case AppRoutes.queue:
        unawaited(navigator.pushNamed(AppRoutes.queue));
        return true;

      default:
        return false;
    }
  }
}
