import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kaarigar/core/routing/app_routes.dart';
import 'package:kaarigar/core/routing/link_router.dart';
import 'package:kaarigar/data/models/fact_sheet.dart';
import 'package:kaarigar/data/models/listing.dart';
import 'package:kaarigar/data/models/listing_status.dart';
import 'package:kaarigar/data/models/sale.dart';
import 'package:kaarigar/data/models/seller_profile.dart';
import 'package:kaarigar/data/remote/api_client.dart';
import 'package:kaarigar/data/repositories/listing_repository.dart';
import 'package:kaarigar/data/repositories/seller_repository.dart';
import 'package:kaarigar/services/analytics_service.dart';
import 'package:kaarigar/services/crash_reporter.dart';
import 'package:kaarigar/services/deep_link_service.dart';
import 'package:kaarigar/services/notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _FakeApi implements ApiClient {
  _FakeApi(this.store);

  final Map<String, Listing> store;
  int fetches = 0;
  bool offline = false;

  @override
  Future<Listing> listing(String id) async {
    fetches++;
    if (offline) throw Exception('no network');
    final found = store[id];
    if (found == null) throw Exception('no such listing');
    return found;
  }

  @override
  noSuchMethod(Invocation invocation) => throw UnimplementedError();

  @override
  Future<SellerProfile> createProfile(SellerProfile draft) =>
      throw UnimplementedError();
  @override
  Future<List<Sale>> sales() => throw UnimplementedError();
}

class _FakeSellers implements SellerRepository {
  bool sold = true;
  bool attention = true;
  bool upload = true;

  @override
  Future<bool> notifySold() async => sold;
  @override
  Future<bool> notifyNeedsAttention() async => attention;
  @override
  Future<bool> notifyUploadFinished() async => upload;

  @override
  noSuchMethod(Invocation invocation) => throw UnimplementedError();
}

class _RecordingSink implements AnalyticsSink {
  final List<AnalyticsRecord> records = [];

  @override
  Future<void> send(AnalyticsRecord record) async => records.add(record);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() => SharedPreferences.setMockInitialValues({}));

  group('analytics', () {
    test('measures first photograph to published, across a restart', () async {
      var clock = DateTime(2026, 3, 1, 9);
      final sink = _RecordingSink();
      AnalyticsService build() =>
          AnalyticsService(sink: sink, now: () => clock);

      await build().captureStarted('c1');

      clock = clock.add(const Duration(hours: 4, minutes: 12));
      final elapsed = await build().listingPublished('c1');

      expect(elapsed, const Duration(hours: 4, minutes: 12));

      final published = sink.records.firstWhere(
        (r) => r.event == AnalyticsEvent.listingPublished,
      );
      expect(published.properties['secondsToPublish'], 4 * 3600 + 12 * 60);
      expect(await build().lastTimeToPublish(), elapsed);
    });

    test('retaking the first photo does not restart the clock', () async {
      var clock = DateTime(2026, 3, 1, 9);
      final analytics = AnalyticsService(now: () => clock);

      await analytics.captureStarted('c1');
      clock = clock.add(const Duration(minutes: 5));
      await analytics.captureStarted('c1');

      clock = clock.add(const Duration(minutes: 5));
      expect(
        await analytics.listingPublished('c1'),
        const Duration(minutes: 10),
      );
    });

    test('a capture that was abandoned is not measured later', () async {
      final analytics = AnalyticsService();

      await analytics.captureStarted('c1');
      await analytics.captureDiscarded('c1');

      expect(await analytics.listingPublished('c1'), isNull);
    });

    test(
      'a listing published without a measured start still reports',
      () async {
        final sink = _RecordingSink();
        final analytics = AnalyticsService(sink: sink);

        expect(await analytics.listingPublished('never-captured'), isNull);

        final record = sink.records.single;
        expect(record.event, AnalyticsEvent.listingPublished);
        expect(record.properties.containsKey('secondsToPublish'), isFalse);
      },
    );

    test('stopwatches nothing will ever close are swept away', () async {
      final now = DateTime(2026, 3, 21, 9);
      SharedPreferences.setMockInitialValues({
        'analytics.started.old': now
            .subtract(const Duration(days: 20))
            .toIso8601String(),
        'analytics.started.recent': now
            .subtract(const Duration(days: 2))
            .toIso8601String(),
        'analytics.started.corrupt': 'not a date',
        'analytics.lastTimeToPublish': 42,
      });

      await AnalyticsService(now: () => now).sweep();

      final store = await SharedPreferences.getInstance();
      expect(store.containsKey('analytics.started.old'), isFalse);
      expect(store.containsKey('analytics.started.corrupt'), isFalse);
      expect(store.containsKey('analytics.started.recent'), isTrue);
      expect(store.getInt('analytics.lastTimeToPublish'), 42);
    });

    test('the debug sink keeps the latest 500, oldest first', () async {
      final print = debugPrint;
      debugPrint = (String? message, {int? wrapWidth}) {};
      addTearDown(() => debugPrint = print);

      final sink = DebugAnalyticsSink();
      for (var i = 0; i < 501; i++) {
        await sink.send(
          AnalyticsRecord(
            event: AnalyticsEvent.captureSaved,
            at: DateTime(2026, 3, 1).add(Duration(seconds: i)),
          ),
        );
      }

      expect(sink.records, hasLength(500));
      expect(sink.records.first.at, DateTime(2026, 3, 1, 0, 0, 1));
      expect(sink.records.last.at, DateTime(2026, 3, 1, 0, 8, 20));
    });

    test('a sink that throws never reaches the caller', () async {
      final analytics = AnalyticsService(sink: _ThrowingSink());

      analytics.log(AnalyticsEvent.captureSaved);
      await analytics.captureStarted('c1');
      expect(await analytics.listingPublished('c1'), isNotNull);
    });
  });

  group('notifications', () {
    test('each switch silences exactly its own kind', () async {
      final sellers = _FakeSellers()..sold = false;
      final presenter = DebugNotificationPresenter();
      final service = NotificationService(
        sellers: sellers,
        presenter: presenter,
      );

      expect(
        await service.handle(
          const PushMessage(kind: NotificationKind.sold, saleId: 's1'),
        ),
        isFalse,
      );
      expect(
        await service.handle(
          const PushMessage(
            kind: NotificationKind.needsAttention,
            listingId: 'l1',
          ),
        ),
        isTrue,
      );

      expect(presenter.shown.single.kind, NotificationKind.needsAttention);
    });

    test('preferences we cannot read mean silence, not noise', () async {
      final service = NotificationService(sellers: _BrokenSellers());

      expect(
        await service.handle(
          const PushMessage(kind: NotificationKind.sold, saleId: 's1'),
        ),
        isFalse,
      );
    });

    test('each kind opens the screen it is about', () {
      expect(
        const PushMessage(kind: NotificationKind.sold, saleId: 's1').target,
        const LinkTarget.sale('s1'),
      );
      expect(
        const PushMessage(
          kind: NotificationKind.needsAttention,
          listingId: 'l1',
        ).target,
        const LinkTarget.review('l1'),
      );
      expect(
        const PushMessage(kind: NotificationKind.uploadFinished).target,
        const LinkTarget.queue(),
      );
    });

    test('a payload of an unknown kind is dropped', () async {
      final service = NotificationService(sellers: _FakeSellers());
      expect(await service.handlePayload({'kind': 'invented'}), isFalse);
    });
  });

  group('deep links', () {
    test('the link 5.11 shares is the link the app can open', () {
      final url = DeepLinks.shareUrl('l1');
      expect(DeepLinks.parse(Uri.parse(url)), const LinkTarget.listing('l1'));
    });

    test('the app scheme carries notification targets', () {
      expect(
        DeepLinks.parse(Uri.parse('kaarigar://listing/l1')),
        const LinkTarget.listing('l1'),
      );
      expect(
        DeepLinks.parse(Uri.parse('kaarigar://review/l1')),
        const LinkTarget.review('l1'),
      );
      expect(
        DeepLinks.parse(Uri.parse('kaarigar://queue')),
        const LinkTarget.queue(),
      );
    });

    test('a link that is not ours opens nothing', () {
      for (final link in [
        'https://example.com/p/l1',
        'https://kaarigar.example/',
        'https://kaarigar.example/p',
        'kaarigar://listing',
        'kaarigar://nonsense/l1',
        'not a url at all',
      ]) {
        expect(
          DeepLinks.parse(Uri.parse(link)),
          isNull,
          reason: 'the wrong listing is worse than none: $link',
        );
      }
    });
  });

  group('link router', () {
    Listing live(String id) => Listing(
      id: id,
      status: ListingStatus.published,
      factSheet: const FactSheet(material: 'Clay', quantity: 1),
      title: 'Blue water jug',
      imageUrls: const ['a.jpg'],
    );

    ({LinkRouter router, _FakeApi api, GlobalKey<NavigatorState> key}) build() {
      final api = _FakeApi({'l1': live('l1')});
      final key = GlobalKey<NavigatorState>();
      return (
        router: LinkRouter(
          navigatorKey: key,
          listings: ListingRepository(api: api),
        ),
        api: api,
        key: key,
      );
    }

    Widget app(GlobalKey<NavigatorState> key) => MaterialApp(
      navigatorKey: key,
      home: const Scaffold(body: Text('home')),
      onGenerateRoute: (settings) => MaterialPageRoute<void>(
        settings: settings,
        builder: (_) => Scaffold(body: Text('at ${settings.name}')),
      ),
    );

    testWidgets('a shared link opens the listing it names', (tester) async {
      final (:router, :api, :key) = build();
      await tester.pumpWidget(app(key));
      router.isReady = true;

      expect(await router.openUri(Uri.parse(DeepLinks.shareUrl('l1'))), isTrue);
      await tester.pumpAndSettle();

      expect(find.text('at ${AppRoutes.listing}'), findsOneWidget);
    });

    testWidgets('a link arriving during onboarding is dropped', (tester) async {
      final (:router, :api, :key) = build();
      await tester.pumpWidget(app(key));
      router.isReady = false;

      expect(
        await router.openUri(Uri.parse(DeepLinks.shareUrl('l1'))),
        isFalse,
      );
      await tester.pumpAndSettle();

      expect(find.text('home'), findsOneWidget);
    });

    testWidgets('a listing the phone has never seen opens nothing', (
      tester,
    ) async {
      final (:router, :api, :key) = build();
      await tester.pumpWidget(app(key));
      router.isReady = true;

      expect(
        await router.openUri(Uri.parse(DeepLinks.shareUrl('missing'))),
        isFalse,
      );
      await tester.pumpAndSettle();

      expect(find.text('home'), findsOneWidget);
    });

    testWidgets('a link opened with no network still uses the cache', (
      tester,
    ) async {
      final (:router, :api, :key) = build();
      await tester.pumpWidget(app(key));
      router.isReady = true;

      expect(await router.openUri(Uri.parse(DeepLinks.shareUrl('l1'))), isTrue);
      await tester.pumpAndSettle();

      api.offline = true;
      expect(await router.openUri(Uri.parse(DeepLinks.shareUrl('l1'))), isTrue);
      await tester.pumpAndSettle();

      expect(find.text('at ${AppRoutes.listing}'), findsOneWidget);
    });

    testWidgets('a tapped notification lands on the same screen a link does', (
      tester,
    ) async {
      final (:router, :api, :key) = build();
      await tester.pumpWidget(app(key));
      router.isReady = true;

      final service = NotificationService(sellers: _FakeSellers())
        ..onOpen = router.open;
      service.open(
        const PushMessage(
          kind: NotificationKind.uploadFinished,
          listingId: 'l1',
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('at ${AppRoutes.listing}'), findsOneWidget);
    });
  });

  group('crash reporter', () {
    test('records what the app caught itself', () async {
      final sink = DebugCrashSink();
      final reporter = CrashReporter(sink: sink);

      reporter.record(
        StateError('camera would not open'),
        StackTrace.current,
        context: 'opening the camera on 3.1',
      );
      await Future<void>.delayed(Duration.zero);

      expect(sink.reports.single.context, 'opening the camera on 3.1');
      expect(sink.reports.single.fatal, isFalse);
    });

    test('catches what the widget tree throws, without hiding it', () async {
      final sink = DebugCrashSink();
      final reporter = CrashReporter(sink: sink);
      final original = FlutterError.onError;
      var passedOn = 0;
      FlutterError.onError = (_) => passedOn++;

      reporter.install();
      addTearDown(() {
        reporter.dispose();
        FlutterError.onError = original;
      });

      FlutterError.reportError(
        FlutterErrorDetails(exception: Exception('boom')),
      );
      await Future<void>.delayed(Duration.zero);

      expect(sink.reports, hasLength(1));
      expect(passedOn, 1);
    });

    test('a sink that throws does not crash the app', () async {
      CrashReporter(sink: _ThrowingCrashSink())
          .record(Exception('boom'), StackTrace.current);
      await Future<void>.delayed(Duration.zero);
    });
  });
}

class _ThrowingSink implements AnalyticsSink {
  @override
  Future<void> send(AnalyticsRecord record) async => throw Exception('no');
}

class _ThrowingCrashSink implements CrashSink {
  @override
  Future<void> report(CrashReport report) async => throw Exception('no');
}

class _BrokenSellers implements SellerRepository {
  @override
  Future<bool> notifySold() async => throw Exception('unreadable');
  @override
  Future<bool> notifyNeedsAttention() async => throw Exception('unreadable');
  @override
  Future<bool> notifyUploadFinished() async => throw Exception('unreadable');

  @override
  noSuchMethod(Invocation invocation) => throw UnimplementedError();
}
