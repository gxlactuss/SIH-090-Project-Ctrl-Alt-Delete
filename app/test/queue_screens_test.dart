import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kirtikar/core/routing/app_routes.dart';
import 'package:kirtikar/core/theme/app_theme.dart';
import 'package:kirtikar/data/local/capture_dao.dart';
import 'package:kirtikar/data/models/capture_item.dart';
import 'package:kirtikar/data/remote/api_client.dart';
import 'package:kirtikar/data/remote/upload_failure.dart';
import 'package:kirtikar/features/queue/queue_item_screen.dart';
import 'package:kirtikar/features/queue/queue_screen.dart';
import 'package:kirtikar/l10n/app_localizations.dart';
import 'package:kirtikar/services/connectivity_service.dart';
import 'package:kirtikar/services/speech_service.dart';
import 'package:kirtikar/services/upload_service.dart';
import 'package:kirtikar/data/models/fact_sheet.dart';
import 'package:kirtikar/data/models/listing.dart';
import 'package:kirtikar/data/models/listing_status.dart';
import 'package:kirtikar/state/catalog_controller.dart';
import 'package:kirtikar/state/queue_controller.dart';
import 'package:provider/provider.dart';

class _SilentApi implements ApiClient {
  final List<String> uploaded = [];
  UploadFailure? failWith;

  @override
  Future<void> uploadCapture({
    required String captureId,
    required List<String> photoPaths,
    required String voiceNotePath,
    void Function(double progress)? onProgress,
    String? templateListingId,
    String? description,
  }) async {
    final failure = failWith;
    if (failure != null) throw UploadException(failure);
    uploaded.add(captureId);
  }

  @override
  noSuchMethod(Invocation invocation) => throw UnimplementedError();
}

class _FakeDao extends CaptureDao {
  final Map<String, CaptureItem> rows = {};

  @override
  Future<void> insert(CaptureItem item) async => rows[item.id] = item;
  @override
  Future<List<CaptureItem>> all() async => rows.values.toList();
  @override
  Future<void> markUploaded(String id, {DateTime? at}) async {}
  @override
  Future<void> recordFailure(String id, String reason) async {}
  @override
  Future<void> clearFailure(String id) async {}
  @override
  Future<void> delete(String id) async => rows.remove(id);
}

class _FakeConnectivity extends ConnectivityService {
  bool online = true;

  @override
  bool get isOnline => online;

  @override
  Future<void> start() async {}
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late QueueController queue;
  late _FakeDao dao;
  late _SilentApi api;
  late _FakeConnectivity network;
  late UploadService uploads;

  setUp(() {
    dao = _FakeDao();
    api = _SilentApi();
    network = _FakeConnectivity();
    queue = QueueController(dao: dao);
    uploads = UploadService(
      api: api,
      queue: queue,
      connectivity: network,
      dao: dao,
    );
  });

  tearDown(() => uploads.dispose());

  void useCheapPhone(WidgetTester tester) {
    tester.view.physicalSize = const Size(720, 1280);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  }

  CaptureItem capture(String id, {String? error, DateTime? uploadedAt}) =>
      CaptureItem(
        id: id,
        photoPaths: ['/nowhere/$id-1.jpg', '/nowhere/$id-2.jpg'],
        voiceNotePath: '/nowhere/$id.m4a',
        createdAt: DateTime(2026, 3, 14, 10, 30),
        uploadedAt: uploadedAt,
        attempts: error == null ? 0 : 2,
        lastError: error,
      );

  Widget harness(Widget home, {CatalogController? catalog}) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<SpeechService>(create: (_) => SpeechService()),
        ChangeNotifierProvider<ConnectivityService>.value(value: network),
        ChangeNotifierProvider<QueueController>.value(value: queue),
        Provider<UploadService>.value(value: uploads),
        if (catalog != null)
          ChangeNotifierProvider<CatalogController>.value(value: catalog),
      ],
      child: MaterialApp(
        theme: AppTheme.light,
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: home,
        onGenerateRoute: (settings) {
          final id = settings.arguments;
          if (id is! String) return null;
          return switch (settings.name) {
            AppRoutes.queueItem => MaterialPageRoute<void>(
              builder: (_) => QueueItemScreen(captureId: id),
            ),
            _ => null,
          };
        },
      ),
    );
  }

  final l10n = lookupAppLocalizations(const Locale('en'));

  testWidgets('4.1 shows every state, and works with no network', (
    tester,
  ) async {
    useCheapPhone(tester);
    network.online = false;
    queue
      ..add(capture('waiting'))
      ..add(capture('failed', error: UploadFailure.network.id))
      ..add(capture('sent', uploadedAt: DateTime(2026, 3, 14, 10, 35)));

    await tester.pumpWidget(harness(const QueueScreen()));
    await tester.pump();

    final list = find.byType(Scrollable).first;
    for (final state in [
      l10n.queueStateWaiting,
      l10n.queueStateFailed,
      l10n.queueStateProcessing,
    ]) {
      tester.state<ScrollableState>(list).position.jumpTo(0);
      await tester.pump();
      await tester.scrollUntilVisible(find.text(state), 200, scrollable: list);
      expect(find.text(state), findsOneWidget);
    }
    expect(tester.takeException(), isNull);
  });

  testWidgets('4.1 says so when nothing is waiting', (tester) async {
    useCheapPhone(tester);
    await tester.pumpWidget(harness(const QueueScreen()));
    await tester.pump();

    expect(find.text(l10n.queueEmptyTitle), findsOneWidget);
  });

  testWidgets('4.2 gives the reason in plain language and a retry', (
    tester,
  ) async {
    useCheapPhone(tester);
    queue.add(capture('one', error: UploadFailure.network.id));

    await tester.pumpWidget(harness(const QueueScreen()));
    await tester.pump();
    await tester.tap(find.text(l10n.queueStateFailed));
    await tester.pumpAndSettle();

    expect(find.text(l10n.failureNetwork), findsOneWidget);
    expect(find.text(l10n.queueAttempts(2)), findsOneWidget);

    await tester.tap(find.text(l10n.queueRetryNow));
    await tester.pumpAndSettle();

    expect(api.uploaded, ['one']);
  });

  testWidgets('4.2 offers no retry when retrying cannot possibly work', (
    tester,
  ) async {
    useCheapPhone(tester);
    queue.add(capture('gone', error: UploadFailure.missingFiles.id));

    await tester.pumpWidget(harness(const QueueItemScreen(captureId: 'gone')));
    await tester.pump();

    expect(find.text(l10n.failureMissingFiles), findsOneWidget);
    expect(find.text(l10n.queueRetryNow), findsNothing);
    expect(find.text(l10n.queueDelete), findsOneWidget);
  });

  testWidgets('4.2 asks before deleting, and says what is lost', (
    tester,
  ) async {
    useCheapPhone(tester);
    queue.add(capture('one', error: UploadFailure.server.id));

    await tester.pumpWidget(harness(const QueueItemScreen(captureId: 'one')));
    await tester.pump();

    await tester.tap(find.text(l10n.queueDelete));
    await tester.pumpAndSettle();

    expect(find.text(l10n.queueDeleteBody), findsOneWidget);

    await tester.tap(find.text(l10n.queueDeleteCancel));
    await tester.pumpAndSettle();
    expect(queue.byId('one'), isNotNull);

    await tester.tap(find.text(l10n.queueDelete));
    await tester.pumpAndSettle();
    await tester.tap(find.text(l10n.queueDeleteConfirm));
    await tester.pumpAndSettle();

    expect(queue.byId('one'), isNull);
  });

  testWidgets('4.2 deleting takes it off Home and the products list too', (
    tester,
  ) async {
    useCheapPhone(tester);
    queue.add(capture('one', error: UploadFailure.server.id));
    final catalog = CatalogController(
      listings: [
        Listing(
          id: 'one',
          status: ListingStatus.processing,
          title: 'Blue water jug',
          views: 0,
          previewUrl: 'https://example/p/one',
          imageUrls: const ['a.jpg'],
          factSheet: FactSheet(quantity: 1, priceInPaise: 45000),
        ),
      ],
    );

    await tester.pumpWidget(
      harness(const QueueItemScreen(captureId: 'one'), catalog: catalog),
    );
    await tester.pump();

    await tester.tap(find.text(l10n.queueDelete));
    await tester.pumpAndSettle();
    await tester.tap(find.text(l10n.queueDeleteConfirm));
    await tester.pumpAndSettle();

    expect(queue.byId('one'), isNull);
    expect(catalog.byId('one'), isNull);
    expect(catalog.listings, isEmpty);
    expect(catalog.recent, isEmpty);
    expect(catalog.nextToFinish, isNull);
    expect(catalog.countOf(ListingFilter.inProgress), 0);
  });

  testWidgets('4.2 for something already with us is leaveable, never a trap', (
    tester,
  ) async {
    useCheapPhone(tester);
    queue.add(capture('sent', uploadedAt: DateTime(2026, 3, 14, 10, 35)));

    await tester.pumpWidget(harness(const QueueItemScreen(captureId: 'sent')));
    await tester.pump();

    expect(find.text(l10n.processingGoHome), findsOneWidget);
    expect(find.text(l10n.queueRetryNow), findsNothing);
    final list = find.byType(Scrollable).first;
    await tester.scrollUntilVisible(
      find.text(l10n.processingLeave),
      200,
      scrollable: list,
    );
    expect(find.text(l10n.processingLeave), findsOneWidget);
  });
}
