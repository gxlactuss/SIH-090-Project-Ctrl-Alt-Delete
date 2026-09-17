import 'dart:async';

import '../local/listing_dao.dart';
import '../models/listing.dart';
import '../remote/api_client.dart';

/// Decides what comes from the cache and what comes from the network, and
/// hands the screens a single source of truth.
///
/// Two layers of cache, and they answer different questions. The map is what
/// a screen reads while it is drawing, and it has to be synchronous or every
/// widget in section 6 grows a FutureBuilder. The database behind it is what
/// makes the map non-empty on a morning with no signal: without it the
/// Listings tab is empty every time the app is opened cold and offline,
/// which for this seller is most times.
///
/// Writes go to both, and the database write is never awaited by the caller.
/// A cache that cannot be written is a slower app, not a broken one, and no
/// screen should wait on a disk to show a listing it already has in hand.
class ListingRepository {
  ListingRepository({required this._api, ListingDao? dao})
      : _dao = dao ?? ListingDao();

  final ApiClient _api;
  final ListingDao _dao;

  final Map<String, Listing> _cache = {};

  Future<void>? _hydrating;

  /// Fills the in-memory map from the database. Called once, early, by
  /// whoever is going to show a list -- and safe to call from several places
  /// at once, because the future is held rather than the result.
  ///
  /// Nothing that is already in memory is overwritten: a listing the app has
  /// fetched in this session is newer than the row on disk by definition.
  Future<void> hydrate() => _hydrating ??= _hydrate();

  Future<void> _hydrate() async {
    try {
      for (final listing in await _dao.all()) {
        _cache.putIfAbsent(listing.id, () => listing);
      }
    } catch (_) {
      // A cache we cannot read is an app that has to go to the network,
      // which is exactly what it did before there was one.
    }
  }

  bool _lastRefreshFailed = false;

  /// Whether the last [refreshAll] fell back to the cache. The screens need
  /// this to tell "nothing to show" apart from "we could not look".
  bool get lastRefreshFailed => _lastRefreshFailed;

  Listing? cached(String id) => _cache[id];

  List<Listing> get all => List.unmodifiable(_cache.values);

  /// Reads the listing, preferring the network and falling back to whatever
  /// was last seen. Every screen in section 5 renders from cache with no
  /// network, which is the rule the whole app is written to.
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
    } catch (_) {
      // As above.
    }
  }

  Future<List<Listing>> refreshAll() async {
    // The cached rows alongside the network rather than before it. A refresh
    // that fails still leaves the screen showing what the phone knows, and
    // one that succeeds no longer waits on a disk read and a decode of every
    // row before it has even asked.
    final hydrating = hydrate();
    try {
      final listings = await _api.listings();
      // Both are finished before this answers, exactly as when the cache
      // went first -- and the rows on disk, being older, never land on top
      // of what just arrived, because hydrating only fills gaps.
      await hydrating;
      for (final listing in listings) {
        _cache[listing.id] = listing;
      }
      _lastRefreshFailed = false;
      // One transaction rather than one write per listing: forty separate
      // writes is a visible stutter on the phone this is built for.
      unawaited(_persistAll(listings));
      return listings;
    } catch (_) {
      await hydrating;
      _lastRefreshFailed = true;
      return all;
    }
  }

  /// 5.1 and 5.3: a voice answer, either to the one question or to one field.
  Future<Listing> answer({
    required String listingId,
    required String voiceReplyPath,
    String? field,
  }) async {
    return _remember(
      await _api.answerQuestion(
        listingId: listingId,
        voiceReplyPath: voiceReplyPath,
        field: field,
      ),
    );
  }

  /// 5.4, 5.6, 5.7 and 5.8: values the seller typed, picked or dragged.
  Future<Listing> patch({
    required String listingId,
    required Map<String, Object?> changes,
  }) async {
    return _remember(
      await _api.patchListing(listingId: listingId, changes: changes),
    );
  }

  /// "Say the changes" on the polished result.
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

  /// 5.5. The map holds only what was answered; a suggestion nobody answered
  /// stays unanswered rather than becoming a no.
  Future<Listing> resolveSuggestions({
    required String listingId,
    required Map<String, bool> decisions,
  }) async {
    return _remember(
      await _api.resolveSuggestions(
        listingId: listingId,
        decisions: decisions,
      ),
    );
  }

  /// 6.4 and loop 7. Stock is a fact sheet field like any other, but it is
  /// the one the marketplace acts on by itself, so it has its own way in.
  Future<Listing> setStock({
    required String listingId,
    required int quantity,
  }) =>
      patch(listingId: listingId, changes: {'quantity': quantity});

  /// 8.9 -- the consent centre, where a seller takes back a permission they
  /// gave on 5.10.
  Future<Listing> setConsent({
    required String listingId,
    required bool photoConsent,
    required bool storyConsent,
  }) async =>
      _remember(
        await _api.setConsent(
          listingId: listingId,
          photoConsent: photoConsent,
          storyConsent: storyConsent,
        ),
      );

  /// 6.3, loop 5. The end of an edit to something already on sale. Kept
  /// apart from [publish] because the two are different calls to the
  /// marketplace, and because the split between loops 1--4 and 5--7 is
  /// exactly this line.
  Future<Listing> republish(String listingId) async =>
      _remember(await _api.republish(listingId));

  /// 6.5.
  Future<Listing> unpublish(String listingId) async =>
      _remember(await _api.unpublish(listingId));

  /// 6.2, and the relist button loop 7 leaves behind.
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
    // Deliberately not awaited -- see the class comment.
    unawaited(_persist(listing));
    return listing;
  }

  Future<void> _persist(Listing listing) async {
    try {
      await _dao.upsert(listing);
    } catch (_) {
      // Same bargain as [hydrate]: the cache is an optimisation, and losing
      // a write to it costs a network call later and nothing else.
    }
  }

  /// Drops the cached copies. 8.10, where the seller is clearing space.
  ///
  /// Safe by construction: everything in here is a copy of something the
  /// server has, which is the opposite of the captures table next to it.
  Future<void> clearCache() async {
    _cache.clear();
    try {
      await _dao.clear();
    } catch (_) {
      // Nothing to tell the seller: the space either came back or it did not,
      // and 8.10 reports the size it can actually measure afterwards.
    }
  }
}
