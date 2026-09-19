import 'dart:async';

import '../local/listing_dao.dart';
import '../models/listing.dart';
import '../remote/api_client.dart';

class ListingRepository {
  ListingRepository({required this._api, ListingDao? dao})
    : _dao = dao ?? ListingDao();

  final ApiClient _api;
  final ListingDao _dao;

  final Map<String, Listing> _cache = {};

  Future<void>? _hydrating;

  Future<void> hydrate() => _hydrating ??= _hydrate();

  Future<void> _hydrate() async {
    try {
      for (final listing in await _dao.all()) {
        _cache.putIfAbsent(listing.id, () => listing);
      }
    } catch (_) {}
  }

  Object? _lastRefreshError;

  bool get lastRefreshFailed => _lastRefreshError != null;

  Object? get lastRefreshError => _lastRefreshError;

  Listing? cached(String id) => _cache[id];

  List<Listing> get all => List.unmodifiable(_cache.values);

  Future<Listing?> fetch(String id, {bool refresh = true}) async {
    if (!refresh && _cache.containsKey(id)) return _cache[id];
    try {
      return _remember(await _api.listing(id));
    } catch (_) {
      return _cache[id];
    }
  }

  Future<void> _persistAll(List<Listing> listings) async {
    try {
      await _dao.upsertAll(listings);
    } catch (_) {}
  }

  Future<List<Listing>> refreshAll() async {
    final hydrating = hydrate();
    try {
      final listings = await _api.listings();
      await hydrating;
      for (final listing in listings) {
        _cache[listing.id] = listing;
      }
      _lastRefreshError = null;
      unawaited(_persistAll(listings));
      return listings;
    } catch (error) {
      await hydrating;
      _lastRefreshError = error;
      return all;
    }
  }

  Future<Listing> answer({
    required String listingId,
    required String voiceReplyPath,
    String? field,
    String? transcript,
  }) async {
    return _remember(
      await _api.answerQuestion(
        listingId: listingId,
        voiceReplyPath: voiceReplyPath,
        field: field,
        transcript: transcript,
      ),
    );
  }

  Future<Listing> retakePhotos({
    required String listingId,
    required List<String> photoPaths,
    void Function(double progress)? onProgress,
  }) async {
    return _remember(
      await _api.retakePhotos(
        listingId: listingId,
        photoPaths: photoPaths,
        onProgress: onProgress,
      ),
    );
  }

  Future<Listing> patch({
    required String listingId,
    required Map<String, Object?> changes,
  }) async {
    return _remember(
      await _api.patchListing(listingId: listingId, changes: changes),
    );
  }

  Future<Listing> revise({
    required String listingId,
    required String voiceInstructionPath,
  }) async {
    return _remember(
      await _api.reviseListing(
        listingId: listingId,
        voiceInstructionPath: voiceInstructionPath,
      ),
    );
  }

  Future<Listing> resolveSuggestions({
    required String listingId,
    required Map<String, bool> decisions,
  }) async {
    return _remember(
      await _api.resolveSuggestions(listingId: listingId, decisions: decisions),
    );
  }

  Future<Listing> setStock({
    required String listingId,
    required int quantity,
  }) => patch(listingId: listingId, changes: {'quantity': quantity});

  Future<Listing> setConsent({
    required String listingId,
    required bool photoConsent,
    required bool storyConsent,
  }) async => _remember(
    await _api.setConsent(
      listingId: listingId,
      photoConsent: photoConsent,
      storyConsent: storyConsent,
    ),
  );

  Future<Listing> republish(String listingId) async =>
      _remember(await _api.republish(listingId));

  Future<Listing> unpublish(String listingId) async =>
      _remember(await _api.unpublish(listingId));

  Future<Listing> relist(String listingId) async =>
      _remember(await _api.relist(listingId));

  Future<Listing> publish({
    required String listingId,
    required bool photoConsent,
    required bool storyConsent,
  }) async {
    return _remember(
      await _api.publish(
        listingId: listingId,
        photoConsent: photoConsent,
        storyConsent: storyConsent,
      ),
    );
  }

  Listing _remember(Listing listing) {
    _cache[listing.id] = listing;
    unawaited(_persist(listing));
    return listing;
  }

  Future<void> _persist(Listing listing) async {
    try {
      await _dao.upsert(listing);
    } catch (_) {}
  }

  Future<void> discard(String listingId) async {
    _cache.remove(listingId);
    try {
      await _dao.delete(listingId);
    } catch (_) {}
    try {
      await _api.deleteListing(listingId);
    } catch (_) {
    }
  }

  Future<void> clearCache() async {
    _cache.clear();
    try {
      await _dao.clear();
    } catch (_) {}
  }
}
