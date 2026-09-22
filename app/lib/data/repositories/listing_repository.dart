import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

import '../local/listing_dao.dart';
import '../models/listing.dart';
import '../remote/api_client.dart';

class ListingRepository {
  ListingRepository({required this._api, ListingDao? dao, this._prefs})
    : _dao = dao ?? ListingDao();

  static const _kDeleted = 'deleted_listing_ids';

  static const _deletedLimit = 500;

  final ApiClient _api;
  final ListingDao _dao;
  SharedPreferences? _prefs;

  final Map<String, Listing> _cache = {};

  final Set<String> _deleted = {};

  bool isDeleted(String id) => _deleted.contains(id);

  Future<SharedPreferences> get _store async =>
      _prefs ??= await SharedPreferences.getInstance();

  Future<void>? _hydrating;

  Future<void> hydrate() => _hydrating ??= _hydrate();

  Future<void> _hydrate() async {
    try {
      _deleted.addAll((await _store).getStringList(_kDeleted) ?? const []);
    } catch (_) {}
    try {
      for (final listing in await _dao.all()) {
        if (_deleted.contains(listing.id)) continue;
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
      final fetched = await _api.listings();
      await hydrating;
      final listings = [
        for (final listing in fetched)
          if (!_deleted.contains(listing.id)) listing,
      ];
      for (final listing in fetched) {
        if (_deleted.contains(listing.id)) unawaited(_deleteRemote(listing.id));
      }
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
    if (_deleted.contains(listing.id)) return listing;
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
    await hydrate();
    _cache.remove(listingId);
    _deleted.add(listingId);
    await _saveDeleted();
    try {
      await _dao.delete(listingId);
    } catch (_) {}
    await _deleteRemote(listingId);
  }

  Future<void> _deleteRemote(String listingId) async {
    try {
      await _api.deleteListing(listingId);
    } catch (_) {}
  }

  Future<void> _saveDeleted() async {
    final ids = _deleted.toList();
    final kept = ids.length > _deletedLimit
        ? ids.sublist(ids.length - _deletedLimit)
        : ids;
    try {
      await (await _store).setStringList(_kDeleted, kept);
    } catch (_) {}
  }

  Future<void> clearCache() async {
    _cache.clear();
    _deleted.clear();
    try {
      await (await _store).remove(_kDeleted);
    } catch (_) {}
    try {
      await _dao.clear();
    } catch (_) {}
  }
}
