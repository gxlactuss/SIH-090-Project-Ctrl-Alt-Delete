import 'package:flutter/foundation.dart';

import '../core/dev/demo_listings.dart';
import '../data/models/listing.dart';
import '../data/models/listing_status.dart';
import '../data/repositories/listing_repository.dart';

enum ListingFilter { inProgress, listed }

class CatalogController extends ChangeNotifier {
  CatalogController({this._repository, List<Listing>? listings})
    : _listings = [...?listings];

  factory CatalogController.demo({ListingRepository? repository}) =>
      CatalogController(
        repository: repository,
        listings: DemoListings.listings,
      );

  final ListingRepository? _repository;

  final List<Listing> _listings;

  List<Listing>? _snapshot;
  List<Listing>? _recent;
  final Map<ListingFilter, List<Listing>> _filtered = {};

  List<Listing> get listings => _snapshot ??= List.unmodifiable(_listings);

  List<Listing> withFilter(ListingFilter filter) =>
      _filtered[filter] ??= List.unmodifiable(
        listings.where(
          (l) => l.status.wasPublished == (filter == ListingFilter.listed),
        ),
      );

  int countOf(ListingFilter filter) => withFilter(filter).length;

  List<Listing> get recent => _recent ??= List.unmodifiable(listings.take(3));

  bool get isEmpty => _listings.isEmpty;

  Listing? get nextToFinish {
    for (final status in const [
      ListingStatus.needsAttention,
      ListingStatus.ready,
    ]) {
      for (final listing in listings) {
        if (listing.status == status) return listing;
      }
    }
    return null;
  }

  Future<void> refresh() =>
      _inFlight ??= _refresh().whenComplete(() => _inFlight = null);

  Future<void>? _inFlight;

  Future<void> _refresh() async {
    final repository = _repository;
    if (repository == null) return;

    _failedToRefresh = false;
    final listings = await repository.refreshAll();
    if (listings.isEmpty) {
      _failedToRefresh = repository.lastRefreshFailed;
      notifyListeners();
      return;
    }

    _listings
      ..clear()
      ..addAll(listings);
    notifyListeners();
  }

  bool _failedToRefresh = false;

  bool get failedToRefresh => _failedToRefresh;

  void replace(Listing listing) {
    final index = _listings.indexWhere((l) => l.id == listing.id);
    if (index == -1) {
      _listings.insert(0, listing);
    } else {
      _listings[index] = listing;
    }
    notifyListeners();
  }

  void clear() {
    if (_listings.isEmpty) return;
    _listings.clear();
    _failedToRefresh = false;
    notifyListeners();
  }

  @override
  void notifyListeners() {
    _snapshot = null;
    _recent = null;
    _filtered.clear();
    super.notifyListeners();
  }

  Listing? byId(String id) {
    for (final listing in _listings) {
      if (listing.id == id) return listing;
    }
    return null;
  }
}
