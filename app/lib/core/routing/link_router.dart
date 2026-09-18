import 'dart:async';

import 'package:flutter/widgets.dart';

import '../../data/repositories/listing_repository.dart';
import '../../services/deep_link_service.dart';
import 'app_routes.dart';

class LinkRouter {
  LinkRouter({required this._navigatorKey, required this._listings});

  final GlobalKey<NavigatorState> _navigatorKey;
  final ListingRepository _listings;

  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  NavigatorState? get _navigator => _navigatorKey.currentState;

  bool isReady = false;

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
        final listing = await _listings.fetch(id);
        if (listing == null) return false;
        if (_navigator == null) return false;
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
