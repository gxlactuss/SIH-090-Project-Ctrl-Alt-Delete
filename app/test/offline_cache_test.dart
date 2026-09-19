import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:kirtikar/data/local/listing_dao.dart';
import 'package:kirtikar/data/models/fact_sheet.dart';
import 'package:kirtikar/data/models/listing.dart';
import 'package:kirtikar/data/models/listing_status.dart';
import 'package:kirtikar/data/models/sale.dart';
import 'package:kirtikar/data/models/seller_profile.dart';
import 'package:kirtikar/data/models/suggestion.dart';
import 'package:kirtikar/data/remote/api_client.dart';
import 'package:kirtikar/data/repositories/listing_repository.dart';
import 'package:kirtikar/state/catalog_controller.dart';

class _FakeApi implements ApiClient {
  _FakeApi(this.remote);

  List<Listing> remote;
  bool offline = false;
  int calls = 0;

  @override
  Future<List<Listing>> listings() async {
    calls++;
    if (offline) throw Exception('no network');
    return remote;
  }

  @override
  Future<Listing> listing(String id) async {
    calls++;
    if (offline) throw Exception('no network');
    return remote.firstWhere((l) => l.id == id);
  }

  @override
  noSuchMethod(Invocation invocation) => throw UnimplementedError();

  @override
  Future<SellerProfile> createProfile(SellerProfile draft) =>
      throw UnimplementedError();
  @override
  Future<List<Sale>> sales() => throw UnimplementedError();
}

class _FakeDao implements ListingDao {
  final Map<String, Listing> rows = {};

  bool broken = false;
  int writes = 0;

  @override
  Future<void> upsert(Listing listing) async {
    if (broken) throw Exception('read-only storage');
    writes++;
    rows[listing.id] = listing;
  }

  @override
  Future<void> upsertAll(Iterable<Listing> listings) async {
    if (broken) throw Exception('read-only storage');
    writes++;
    for (final listing in listings) {
      rows[listing.id] = listing;
    }
  }

  @override
  Future<List<Listing>> all() async {
    if (broken) throw Exception('unreadable');
    return rows.values.toList();
  }

  @override
  Future<Listing?> byId(String id) async => rows[id];

  @override
  Future<void> delete(String id) async => rows.remove(id);

  @override
  Future<void> clear() async => rows.clear();

  @override
  Future<int> count() async => rows.length;

  @override
  noSuchMethod(Invocation invocation) => throw UnimplementedError();
}

class _SlowDao extends _FakeDao {
  final Completer<void> gate = Completer<void>();

  @override
  Future<List<Listing>> all() async {
    await gate.future;
    return super.all();
  }
}

void main() {
  Listing seed(String id, {ListingStatus status = ListingStatus.published}) =>
      Listing(
        id: id,
        status: status,
        title: 'Blue water jug',
        description: 'A hand-thrown jug, glazed blue.',
        imageUrls: const ['a.jpg', 'b.jpg'],
        factSheet: const FactSheet(
          material: 'Clay',
          size: '12 inches',
          quantity: 2,
          priceInPaise: 60000,
          hoursToMake: 6.5,
          materialCostInPaise: 12000,
        ),
      );

  group('a deleted listing stays deleted', () {
    test('the last one deleted leaves Home and the products list empty', () async {
      final api = _FakeApi([seed('l1')]);
      final dao = _FakeDao();
      final repository = ListingRepository(api: api, dao: dao);
      final catalog = CatalogController(repository: repository);

      await catalog.refresh();
      expect(catalog.listings.map((l) => l.id), ['l1']);

      api.remote = [];
      await repository.discard('l1');
      catalog.forget('l1');

      await catalog.refresh();

      expect(catalog.listings, isEmpty);
      expect(catalog.recent, isEmpty);
      expect(catalog.nextToFinish, isNull);
      expect(catalog.countOf(ListingFilter.inProgress), 0);
      expect(catalog.countOf(ListingFilter.listed), 0);
      expect(catalog.failedToRefresh, isFalse);
    });

    test('an empty answer is not read as a failed refresh', () async {
      final api = _FakeApi([]);
      final repository = ListingRepository(api: api, dao: _FakeDao());
      final catalog = CatalogController(repository: repository);

      await catalog.refresh();

      expect(catalog.failedToRefresh, isFalse);
      expect(catalog.refreshError, isNull);
    });

    test('a refresh that fails keeps what is already on screen', () async {
      final api = _FakeApi([seed('l1')]);
      final repository = ListingRepository(api: api, dao: _FakeDao());
      final catalog = CatalogController(repository: repository);

      await catalog.refresh();
      api.offline = true;
      await catalog.refresh();

      expect(catalog.listings.map((l) => l.id), ['l1']);
      expect(catalog.failedToRefresh, isTrue);
    });

  });

  group('the row format', () {
    test('carries every field of a listing there and back', () {
      const original = Listing(
        id: 'l1',
        status: ListingStatus.soldOut,
        title: 'Blue water jug',
        description: 'A hand-thrown jug, glazed blue.',
        imageUrls: ['a.jpg', 'b.jpg', 'c.jpg'],
        followUpQuestion: 'How big is it?',
        suggestedPriceInPaise: 60000,
        priceFloorInPaise: 48000,
        previewUrl: 'https://kirtikar.example/p/l1',
        photoConsent: true,
        storyConsent: true,
        views: 12,
        templateListingId: 'l0',
        factSheet: FactSheet(
          material: 'Clay',
          size: '12 inches',
          colour: 'Blue',
          technique: 'Wheel thrown',
          quantity: 3,
          priceInPaise: 60000,
          hoursToMake: 6.5,
          materialCostInPaise: 12000,
          isOneOfAKind: true,
        ),
        suggestions: [
          Suggestion(
            id: 'summer',
            spokenPrompt: 'Shall I add: good for summer?',
            textIfAccepted: 'Good for summer.',
            accepted: true,
          ),
          Suggestion(
            id: 'gift',
            spokenPrompt: 'Shall I add: makes a good gift?',
            textIfAccepted: 'Makes a good gift.',
          ),
        ],
      );

      final restored = ListingDao.fromRow(ListingDao.toRow(original))!;

      expect(restored.id, original.id);
      expect(restored.status, original.status);
      expect(restored.title, original.title);
      expect(restored.description, original.description);
      expect(restored.imageUrls, original.imageUrls);
      expect(restored.followUpQuestion, original.followUpQuestion);
      expect(restored.suggestedPriceInPaise, original.suggestedPriceInPaise);
      expect(restored.priceFloorInPaise, original.priceFloorInPaise);
      expect(restored.previewUrl, original.previewUrl);
      expect(restored.photoConsent, isTrue);
      expect(restored.storyConsent, isTrue);
      expect(restored.views, 12);
      expect(restored.templateListingId, 'l0');

      expect(restored.factSheet.material, 'Clay');
      expect(restored.factSheet.size, '12 inches');
      expect(restored.factSheet.colour, 'Blue');
      expect(restored.factSheet.technique, 'Wheel thrown');
      expect(restored.factSheet.quantity, 3);
      expect(restored.factSheet.priceInPaise, 60000);
      expect(restored.factSheet.hoursToMake, 6.5);
      expect(restored.factSheet.materialCostInPaise, 12000);
      expect(restored.factSheet.isOneOfAKind, isTrue);

      expect(restored.suggestions, hasLength(2));
      expect(restored.suggestions.first.accepted, isTrue);
      expect(restored.suggestions.last.accepted, isNull);
    });

    test('a whole number of hours survives the trip as a double', () {
      const listing = Listing(
        id: 'l1',
        status: ListingStatus.ready,
        factSheet: FactSheet(hoursToMake: 6),
      );

      final restored = ListingDao.fromRow(ListingDao.toRow(listing))!;
      expect(restored.factSheet.hoursToMake, 6.0);
    });

    test('"not said" survives as "not said", never as a guess', () {
      const bare = Listing(
        id: 'l1',
        status: ListingStatus.needsAttention,
        factSheet: FactSheet(material: 'Clay'),
      );

      final restored = ListingDao.fromRow(ListingDao.toRow(bare))!;

      expect(restored.factSheet.material, 'Clay');
      expect(restored.factSheet.colour, isNull);
      expect(restored.factSheet.size, isNull);
      expect(restored.factSheet.quantity, isNull);
      expect(restored.title, isNull);
      expect(restored.imageUrls, isEmpty);
      expect(restored.suggestions, isEmpty);
    });

    test('a row this build cannot read is skipped, not thrown', () {
      final future = ListingDao.toRow(seed('l1'))..['status'] = 'invented';
      expect(ListingDao.fromRow(future), isNull);

      expect(ListingDao.fromRow({'id': 'l1'}), isNull);
      expect(
        ListingDao.fromRow({'id': 'l1', 'status': 'ready', 'data': 'not json'}),
        isNull,
      );
    });
  });

  group('the repository', () {
    ({ListingRepository repository, _FakeApi api, _FakeDao dao}) build({
      List<Listing> remote = const [],
    }) {
      final api = _FakeApi([...remote]);
      final dao = _FakeDao();
      return (
        repository: ListingRepository(api: api, dao: dao),
        api: api,
        dao: dao,
      );
    }

    test('what the server sends is written to disk', () async {
      final (:repository, :api, :dao) = build(remote: [seed('l1'), seed('l2')]);

      await repository.refreshAll();
      await Future<void>.delayed(Duration.zero);

      expect(dao.rows.keys, containsAll(['l1', 'l2']));
    });

    test(
      'a cold start with no signal still shows what the phone knows',
      () async {
        final (repository: first, :api, :dao) = build(
          remote: [seed('l1'), seed('l2')],
        );
        await first.refreshAll();
        await Future<void>.delayed(Duration.zero);

        final offlineApi = _FakeApi([])..offline = true;
        final second = ListingRepository(api: offlineApi, dao: dao);

        final listings = await second.refreshAll();

        expect(listings.map((l) => l.id), containsAll(['l1', 'l2']));
        expect(second.lastRefreshFailed, isTrue);
      },
    );

    test('one listing opens offline from the cache', () async {
      final (:repository, :api, :dao) = build(remote: [seed('l1')]);
      await repository.refreshAll();
      await Future<void>.delayed(Duration.zero);

      final offlineApi = _FakeApi([])..offline = true;
      final second = ListingRepository(api: offlineApi, dao: dao);
      await second.hydrate();

      final listing = await second.fetch('l1');
      expect(listing?.title, 'Blue water jug');
    });

    test('what this session fetched wins over what is on disk', () async {
      final (:repository, :api, :dao) = build(remote: [seed('l1')]);
      await repository.refreshAll();
      await Future<void>.delayed(Duration.zero);

      api.remote = [seed('l1', status: ListingStatus.soldOut)];
      await repository.refreshAll();
      await Future<void>.delayed(Duration.zero);

      await repository.hydrate();
      expect(repository.cached('l1')?.status, ListingStatus.soldOut);
    });

    test(
      'storage that will not be written is a slower app, not a broken one',
      () async {
        final (:repository, :api, :dao) = build(remote: [seed('l1')]);
        dao.broken = true;

        final listings = await repository.refreshAll();
        await Future<void>.delayed(Duration.zero);

        expect(listings, hasLength(1));
        expect(repository.cached('l1'), isNotNull);
      },
    );

    test('8.10 clearing the cache empties both halves of it', () async {
      final (:repository, :api, :dao) = build(remote: [seed('l1')]);
      await repository.refreshAll();
      await Future<void>.delayed(Duration.zero);

      await repository.clearCache();

      expect(repository.cached('l1'), isNull);
      expect(dao.rows, isEmpty);
      expect(api.remote, hasLength(1));
    });

    test('a refresh asks the network without waiting on the disk', () async {
      final api = _FakeApi([seed('l1')]);
      final dao = _SlowDao()..rows['l0'] = seed('l0');
      final repository = ListingRepository(api: api, dao: dao);

      final refreshing = repository.refreshAll();
      await Future<void>.delayed(Duration.zero);

      expect(api.calls, 1);

      dao.gate.complete();
      final listings = await refreshing;

      expect(listings.map((l) => l.id), ['l1']);
      expect(repository.cached('l0'), isNotNull);
    });

    test('a refresh asked for twice at once asks the server once', () async {
      final (:repository, :api, dao: _) = build(remote: [seed('l1')]);
      final catalog = CatalogController(repository: repository);

      await Future.wait([catalog.refresh(), catalog.refresh()]);
      expect(api.calls, 1);
      expect(catalog.listings, hasLength(1));

      await catalog.refresh();
      expect(api.calls, 2);
    });

    test('hydrating twice reads the disk once', () async {
      final (:repository, api: _, :dao) = build();
      dao.rows['l1'] = seed('l1');

      await repository.hydrate();
      await repository.hydrate();

      expect(repository.cached('l1'), isNotNull);
    });
  });
}
