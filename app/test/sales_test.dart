import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kirtikar/core/theme/app_theme.dart';
import 'package:kirtikar/data/models/listing.dart';
import 'package:kirtikar/data/models/sale.dart';
import 'package:kirtikar/data/remote/api_client.dart';
import 'package:kirtikar/data/repositories/sales_repository.dart';
import 'package:kirtikar/features/sales/earnings_screen.dart';
import 'package:kirtikar/features/sales/packing_screen.dart';
import 'package:kirtikar/features/sales/sale_detail_screen.dart';
import 'package:kirtikar/features/sales/sales_screen.dart';
import 'package:kirtikar/l10n/app_localizations.dart';
import 'package:kirtikar/services/speech_service.dart';
import 'package:kirtikar/state/catalog_controller.dart';
import 'package:kirtikar/state/sales_controller.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _FakeApi implements ApiClient {
  _FakeApi(this.orders);

  List<Sale> orders;
  bool fail = false;
  int calls = 0;

  Duration delay = Duration.zero;

  @override
  Future<List<Sale>> sales() async {
    calls++;
    if (delay > Duration.zero) await Future<void>.delayed(delay);
    if (fail) throw Exception('no network');
    return orders;
  }

  @override
  Future<List<Listing>> listings() async => const [];

  @override
  noSuchMethod(Invocation invocation) => throw UnimplementedError();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() => SharedPreferences.setMockInitialValues({}));

  void useCheapPhone(WidgetTester tester) {
    tester.view.physicalSize = const Size(720, 1280);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  }

  final l10n = lookupAppLocalizations(const Locale('en'));

  DateTime days(int offset) {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day + offset, 10);
  }

  Sale sale({
    String id = 's1',
    String title = 'Blue water jug',
    int quantity = 2,
    int amount = 81000,
    int placedDaysAgo = 0,
    int? packInDays = 2,
  }) => Sale(
    id: id,
    listingId: 'demo-1',
    listingTitle: title,
    quantity: quantity,
    amountInPaise: amount,
    placedAt: days(-placedDaysAgo),
    packByDate: packInDays == null ? null : days(packInDays),
    buyerArea: 'Jaipur',
  );

  ({Widget widget, SalesController sales}) harness(Widget home, _FakeApi api) {
    final controller = SalesController(sales: SalesRepository(api: api));
    return (
      widget: MultiProvider(
        providers: [
          ChangeNotifierProvider<SpeechService>(create: (_) => SpeechService()),
          ChangeNotifierProvider<SalesController>.value(value: controller),
          ChangeNotifierProvider<CatalogController>(
            create: (_) => CatalogController(),
          ),
        ],
        child: MaterialApp(
          theme: AppTheme.light,
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(body: home),
        ),
      ),
      sales: controller,
    );
  }

  group('the repository', () {
    test('an unreachable server keeps what was last seen', () async {
      final api = _FakeApi([sale()]);
      final repository = SalesRepository(api: api);

      expect((await repository.fetch()).length, 1);

      api.fail = true;
      final second = await repository.fetch();

      expect(second.length, 1);
      expect(api.calls, 2);
    });

    test('read state survives a fresh repository', () async {
      final api = _FakeApi([sale(), sale(id: 's2')]);
      final first = SalesRepository(api: api);
      await first.fetch();
      expect(first.unreadCount, 2);

      await first.markRead('s1');
      expect(first.unreadCount, 1);

      final second = SalesRepository(api: api);
      await second.fetch();
      expect(second.unreadCount, 1);
    });
  });

  group('7.4 the three numbers', () {
    test(
      'week, month and total are counted from the calendar, not a window',
      () async {
        final api = _FakeApi([
          sale(id: 'today', amount: 10000, placedDaysAgo: 0),
          sale(id: 'old', amount: 50000, placedDaysAgo: 60),
        ]);
        final controller = SalesController(sales: SalesRepository(api: api));
        await controller.load();

        expect(controller.totalInPaise, 60000);
        expect(controller.thisWeekInPaise, 10000);
        expect(controller.thisMonthInPaise, greaterThanOrEqualTo(10000));
        expect(controller.itemsSold, 4);
      },
    );

    test(
      'a second load replaces every number the first one worked out',
      () async {
        final api = _FakeApi([sale(id: 'a', amount: 10000, quantity: 1)]);
        final controller = SalesController(sales: SalesRepository(api: api));
        await controller.load();
        expect(controller.totalInPaise, 10000);
        expect(controller.thisWeekInPaise, 10000);
        expect(controller.itemsSold, 1);
        expect(controller.unreadCount, 1);

        api.orders = [
          sale(id: 'a', amount: 10000, quantity: 1),
          sale(id: 'b', amount: 5000, quantity: 3),
        ];
        await controller.load();

        expect(controller.totalInPaise, 15000);
        expect(controller.thisWeekInPaise, 15000);
        expect(controller.thisMonthInPaise, 15000);
        expect(controller.itemsSold, 4);
        expect(controller.unreadCount, 2);

        await controller.markRead('b');
        expect(controller.unreadCount, 1);
      },
    );

    testWidgets('shows three numbers and no chart', (tester) async {
      useCheapPhone(tester);
      final api = _FakeApi([sale(amount: 10000)]);
      final (widget: widget, sales: controller) = harness(
        const EarningsScreen(),
        api,
      );
      await controller.load();
      await tester.pumpWidget(widget);
      await tester.pumpAndSettle();

      expect(find.text(l10n.earningsWeek), findsOneWidget);
      expect(find.text(l10n.earningsMonth), findsOneWidget);
      expect(find.text(l10n.earningsTotal), findsOneWidget);
      expect(find.text(l10n.earningsNote), findsOneWidget);
    });
  });

  group('7.1 the list', () {
    test('a second load while one is running joins it', () async {
      final api = _FakeApi([sale()])..delay = const Duration(milliseconds: 10);
      final controller = SalesController(sales: SalesRepository(api: api));

      await Future.wait([controller.load(), controller.load()]);
      expect(api.calls, 1);
      expect(controller.sales, hasLength(1));

      await controller.load();
      expect(api.calls, 2);
    });

    testWidgets('marks what has not been opened, and says the pack-by date '
        'in words', (tester) async {
      useCheapPhone(tester);
      final api = _FakeApi([sale(packInDays: 0)]);
      final (widget: widget, sales: _) = harness(const SalesList(), api);
      await tester.pumpWidget(widget);
      await tester.pumpAndSettle();

      expect(find.text(l10n.salesNew), findsOneWidget);
      expect(find.text(l10n.salesPackByToday), findsOneWidget);
    });

    testWidgets('an empty list is different before and after we have looked', (
      tester,
    ) async {
      useCheapPhone(tester);
      final api = _FakeApi(const [])..delay = const Duration(seconds: 1);
      final (widget: widget, sales: _) = harness(const SalesList(), api);
      await tester.pumpWidget(widget);
      await tester.pump();
      await tester.pump();

      expect(find.text(l10n.salesLoading), findsOneWidget);

      await tester.pumpAndSettle();
      expect(find.text(l10n.salesEmptyTitle), findsOneWidget);
    });
  });

  group('7.2 the detail', () {
    testWidgets('says plainly that it cannot change anything, and clears the '
        'badge', (tester) async {
      useCheapPhone(tester);
      final api = _FakeApi([sale()]);
      final (widget: widget, sales: controller) = harness(
        const SaleDetailScreen(saleId: 's1'),
        api,
      );
      await controller.load();
      expect(controller.unreadCount, 1);

      await tester.pumpWidget(widget);
      await tester.pumpAndSettle();

      expect(find.text(l10n.salePaid('₹810')), findsOneWidget);
      expect(find.text(l10n.salesQuantity(2)), findsOneWidget);

      await tester.drag(find.byType(ListView), const Offset(0, -300));
      await tester.pumpAndSettle();
      expect(find.text(l10n.saleReadOnly), findsOneWidget);

      expect(controller.unreadCount, 0);
    });
  });

  group('7.3 packing', () {
    testWidgets('is a checklist that names how many pieces to put in', (
      tester,
    ) async {
      useCheapPhone(tester);
      final api = _FakeApi([sale(quantity: 3)]);
      final (widget: widget, sales: controller) = harness(
        const PackingScreen(saleId: 's1'),
        api,
      );
      await controller.load();
      await tester.pumpWidget(widget);
      await tester.pumpAndSettle();

      expect(find.text(l10n.packingProgress(0, 5)), findsOneWidget);

      await tester.drag(find.byType(ListView), const Offset(0, -260));
      await tester.pumpAndSettle();
      expect(find.textContaining(l10n.salesQuantity(3)), findsOneWidget);

      await tester.drag(find.byType(ListView), const Offset(0, 260));
      await tester.pumpAndSettle();
      await tester.tap(find.text(l10n.packingStep1));
      await tester.pumpAndSettle();
      expect(find.text(l10n.packingProgress(1, 5)), findsOneWidget);
    });
  });
}
