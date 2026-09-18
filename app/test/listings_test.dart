import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kirtikar/core/theme/app_theme.dart';
import 'package:kirtikar/data/models/fact_sheet.dart';
import 'package:kirtikar/data/models/listing.dart';
import 'package:kirtikar/data/models/listing_status.dart';
import 'package:kirtikar/data/remote/api_client.dart';
import 'package:kirtikar/data/remote/mock_api.dart';
import 'package:kirtikar/data/repositories/listing_repository.dart';
import 'package:kirtikar/features/listings/listing_detail_screen.dart';
import 'package:kirtikar/features/listings/listings_screen.dart';
import 'package:kirtikar/l10n/app_localizations.dart';
import 'package:kirtikar/services/speech_service.dart';
import 'package:kirtikar/state/catalog_controller.dart';
import 'package:kirtikar/widgets/listing_tile.dart';
import 'package:provider/provider.dart';

class _FakeApi implements ApiClient {
  _FakeApi(this.current, [List<Listing>? all]) : all = all ?? [current];

  Listing current;

  final List<Listing> all;
  int unpublishCalls = 0;
  int relistCalls = 0;

  @override
  Future<Listing> listing(String id) async => current;

  @override
  Future<List<Listing>> listings() async => [
    for (final l in all) l.id == current.id ? current : l,
  ];

  @override
  Future<Listing> patchListing({
    required String listingId,
    required Map<String, Object?> changes,
  }) async {
    var sheet = current.factSheet;
    for (final entry in changes.entries) {
      final field = ListingField.values
          .where((f) => f.name == entry.key)
          .firstOrNull;
      if (field != null) sheet = sheet.withField(field, entry.value);
    }

    var status = current.status;
    if (current.status.wasPublished) {
      final stock = sheet.quantity ?? 0;
      if (stock <= 0) {
        status = ListingStatus.soldOut;
      } else if (current.status == ListingStatus.soldOut) {
        status = ListingStatus.published;
      }
    }
    return current = current.copyWith(factSheet: sheet, status: status);
  }

  @override
  Future<Listing> unpublish(String id) async {
    unpublishCalls++;
    return current = current.copyWith(status: ListingStatus.unpublished);
  }

  @override
  Future<Listing> relist(String id) async {
    relistCalls++;
    return current = current.copyWith(status: ListingStatus.published);
  }

  @override
  noSuchMethod(Invocation invocation) => throw UnimplementedError();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  void useCheapPhone(WidgetTester tester) {
    tester.view.physicalSize = const Size(720, 1280);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  }

  final l10n = lookupAppLocalizations(const Locale('en'));

  Listing listing({
    String id = 'l1',
    ListingStatus status = ListingStatus.published,
    int stock = 3,
    int views = 12,
  }) => Listing(
    id: id,
    status: status,
    title: 'Blue water jug',
    views: views,
    previewUrl: 'https://example/p/$id',
    imageUrls: const ['a.jpg'],
    factSheet: FactSheet(quantity: stock, priceInPaise: 45000),
  );

  Widget harness(Widget home, List<Listing> catalogue, _FakeApi api) {
    final repository = ListingRepository(api: api);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<SpeechService>(create: (_) => SpeechService()),
        Provider<ListingRepository>.value(value: repository),
        ChangeNotifierProvider<CatalogController>(
          create: (_) => CatalogController(listings: catalogue),
        ),
      ],
      child: MaterialApp(
        theme: AppTheme.light,
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(body: home),
      ),
    );
  }

  group('6.1 the list', () {
    testWidgets('in progress and listed split the listings between them', (
      tester,
    ) async {
      useCheapPhone(tester);
      final catalogue = [
        listing(id: 'live'),
        listing(id: 'needs', status: ListingStatus.needsAttention),
        listing(id: 'sold', status: ListingStatus.soldOut, stock: 0),
      ];
      final api = _FakeApi(catalogue.first, catalogue);

      await tester.pumpWidget(
        harness(
          const ListingsList(filter: ListingFilter.listed),
          catalogue,
          api,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(ListingTile), findsNWidgets(2));
      expect(find.text(l10n.statusPublished), findsOneWidget);
      expect(find.text(l10n.statusSoldOut), findsOneWidget);
      expect(find.text(l10n.statusNeedsAttention), findsNothing);

      await tester.pumpWidget(
        harness(
          const ListingsList(filter: ListingFilter.inProgress),
          catalogue,
          api,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(ListingTile), findsOneWidget);
      expect(find.text(l10n.statusNeedsAttention), findsOneWidget);
    });

    testWidgets('a section with nothing in it says so differently from an '
        'empty shop', (tester) async {
      useCheapPhone(tester);
      final catalogue = [listing(id: 'live')];
      await tester.pumpWidget(
        harness(
          const ListingsList(filter: ListingFilter.inProgress),
          catalogue,
          _FakeApi(catalogue.first, catalogue),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text(l10n.listingsEmptyFilter), findsOneWidget);
      expect(find.text(l10n.listingsEmptyTitle), findsNothing);
    });
  });

  group('6.1 the counts follow every change', () {
    test('a listing moves between filters, and the copies are replaced', () {
      final catalog = CatalogController(
        listings: [
          listing(id: 'a', status: ListingStatus.published),
          listing(id: 'b', status: ListingStatus.needsAttention),
        ],
      );

      final live = catalog.withFilter(ListingFilter.listed);
      expect(live.map((l) => l.id), ['a']);
      expect(catalog.countOf(ListingFilter.inProgress), 1);
      expect(catalog.recent.last.status, ListingStatus.needsAttention);
      expect(catalog.withFilter(ListingFilter.listed), same(live));

      catalog.replace(listing(id: 'b', status: ListingStatus.published));

      expect(catalog.countOf(ListingFilter.inProgress), 0);
      expect(catalog.countOf(ListingFilter.listed), 2);
      expect(catalog.recent.last.status, ListingStatus.published);
      expect(catalog.withFilter(ListingFilter.listed), isNot(same(live)));

      catalog.clear();
      expect(catalog.listings, isEmpty);
      expect(catalog.recent, isEmpty);
      expect(catalog.countOf(ListingFilter.listed), 0);
      expect(catalog.countOf(ListingFilter.inProgress), 0);
    });
  });

  group('6.4 quick stock, and loop 7', () {
    testWidgets('opens from the list without opening the listing', (
      tester,
    ) async {
      useCheapPhone(tester);
      final api = _FakeApi(listing());
      await tester.pumpWidget(
        harness(const ListingsList(filter: ListingFilter.listed), [
          listing(),
        ], api),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text(l10n.listingsQuickStock).first);
      await tester.pumpAndSettle();

      expect(find.text(l10n.quickStockTitle), findsOneWidget);
      await tester.tap(find.byIcon(Icons.remove));
      await tester.pump();
      await tester.tap(find.text(l10n.quickStockSave));
      await tester.pumpAndSettle();

      expect(api.current.stock, 2);
      expect(api.current.status, ListingStatus.published);
    });

    testWidgets('counting down to nothing warns before it is saved', (
      tester,
    ) async {
      useCheapPhone(tester);
      final api = _FakeApi(listing(stock: 1));
      await tester.pumpWidget(
        harness(const ListingsList(filter: ListingFilter.listed), [
          listing(stock: 1),
        ], api),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text(l10n.listingsQuickStock).first);
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.remove));
      await tester.pumpAndSettle();

      expect(find.text(l10n.listingSoldOutBody), findsOneWidget);
      expect(api.current.stock, 1);
    });

    testWidgets('marking it all sold takes it off sale at once, with Undo', (
      tester,
    ) async {
      useCheapPhone(tester);
      final api = _FakeApi(listing());
      await tester.pumpWidget(
        harness(const ListingsList(filter: ListingFilter.listed), [
          listing(),
        ], api),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text(l10n.listingsQuickStock).first);
      await tester.pumpAndSettle();
      await tester.tap(find.text(l10n.quickStockMarkSoldOut));
      await tester.pumpAndSettle();

      expect(api.current.stock, 0);
      expect(api.current.status, ListingStatus.soldOut);
      expect(find.text(l10n.listingSoldOutBody), findsOneWidget);

      await tester.tap(find.text(l10n.actionUndo));
      await tester.pumpAndSettle();

      expect(api.current.stock, 3);
      expect(api.current.status, ListingStatus.published);
    });
  });

  group('6.2 the detail screen', () {
    testWidgets('shows views and stock, and offers the live actions', (
      tester,
    ) async {
      useCheapPhone(tester);
      final item = listing();
      await tester.pumpWidget(
        harness(ListingDetailScreen(listing: item), [item], _FakeApi(item)),
      );
      await tester.pump();

      await tester.drag(find.byType(ListView), const Offset(0, -300));
      await tester.pumpAndSettle();

      expect(find.text(l10n.listingsViews(12)), findsOneWidget);
      expect(find.text(l10n.listingsStock(3)), findsOneWidget);
      expect(find.text(l10n.listingEdit), findsOneWidget);
      expect(find.text(l10n.listingDuplicate), findsOneWidget);
      expect(find.text(l10n.listingUnpublish), findsOneWidget);
    });

    testWidgets('6.5 asks before taking it off sale, and says what it means', (
      tester,
    ) async {
      useCheapPhone(tester);
      final item = listing();
      final api = _FakeApi(item);
      await tester.pumpWidget(
        harness(ListingDetailScreen(listing: item), [item], api),
      );
      await tester.pump();

      await tester.tap(find.text(l10n.listingUnpublish));
      await tester.pumpAndSettle();

      expect(find.text(l10n.unpublishBody), findsOneWidget);
      await tester.tap(find.text(l10n.unpublishCancel));
      await tester.pumpAndSettle();
      expect(api.unpublishCalls, 0);

      await tester.tap(find.text(l10n.listingUnpublish));
      await tester.pumpAndSettle();
      await tester.tap(find.text(l10n.unpublishConfirm));
      await tester.pumpAndSettle();

      expect(api.unpublishCalls, 1);
      expect(find.text(l10n.listingRelist), findsOneWidget);
    });

    testWidgets('a sold out listing explains itself and cannot be relisted '
        'empty', (tester) async {
      useCheapPhone(tester);
      final item = listing(status: ListingStatus.soldOut, stock: 0);
      await tester.pumpWidget(
        harness(ListingDetailScreen(listing: item), [item], _FakeApi(item)),
      );
      await tester.pump();

      await tester.scrollUntilVisible(
        find.text(l10n.listingSoldOutBody),
        200,
        scrollable: find
            .descendant(
              of: find.byType(ListView),
              matching: find.byType(Scrollable),
            )
            .first,
      );
      await tester.pumpAndSettle();
      expect(find.text(l10n.listingSoldOutBody), findsOneWidget);

      final relist = find.widgetWithText(FilledButton, l10n.listingRelist);
      expect(tester.widget<FilledButton>(relist).onPressed, isNull);
      expect(find.text(l10n.listingsQuickStock), findsOneWidget);
    });
  });

  group('dev: the polished result', () {
    test('comes back ready, with a photo, a title and a description, and '
        'takes typed and spoken changes', () async {
      final api = MockApi();
      final polished = api.simulatePolished();

      expect(polished.status, ListingStatus.ready);
      expect(polished.imageUrls, isNotEmpty);
      expect(polished.title, isNotEmpty);
      expect(polished.description, isNotEmpty);
      expect(polished.needsAttention, isFalse);

      final typed = await api.patchListing(
        listingId: polished.id,
        changes: {'title': 'Blue jug', 'description': 'A blue jug.'},
      );
      expect(typed.title, 'Blue jug');
      expect(typed.description, 'A blue jug.');

      final said = await api.reviseListing(
        listingId: polished.id,
        voiceInstructionPath: '/tmp/revise.m4a',
      );
      expect(said.description, isNot('A blue jug.'));
      expect(said.title, 'Blue jug');
    });

    test('there are no invented orders', () async {
      expect(await MockApi().sales(), isEmpty);
    });
  });

  group('6.6 duplicate, loop 6', () {
    test(
      'a duplicate reuses the fact sheet and takes only new photos',
      () async {
        final api = MockApi(uploadDuration: Duration.zero);
        final dir = Directory.systemTemp.createTempSync('kirtikar_dup');
        addTearDown(() => dir.deleteSync(recursive: true));
        final photos = [
          for (final name in ['new1.jpg', 'new2.jpg'])
            (File('${dir.path}/$name')..writeAsBytesSync([1, 2, 3])).path,
        ];

        await api.uploadCapture(
          captureId: 'first',
          photoPaths: const [],
          voiceNotePath: '',
        );
        await api.answerQuestion(
          listingId: 'first',
          voiceReplyPath: '/tmp/a.m4a',
        );
        final original = await api.listing('first');

        await api.uploadCapture(
          captureId: 'second',
          photoPaths: photos,
          voiceNotePath: '',
          templateListingId: 'first',
        );
        final copy = await api.listing('second');

        expect(copy.id, 'second');
        expect(copy.factSheet.material, original.factSheet.material);
        expect(copy.factSheet.size, original.factSheet.size);
        expect(copy.description, original.description);
        expect(copy.imageUrls, photos);
        expect(copy.templateListingId, 'first');

        expect(copy.status, ListingStatus.ready);
        expect(copy.followUpQuestion, isNull);
      },
    );
  });
}
