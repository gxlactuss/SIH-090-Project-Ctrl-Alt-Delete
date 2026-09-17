import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kaarigar/data/models/capture_item.dart';
import 'package:kaarigar/data/models/listing.dart';
import 'package:kaarigar/data/models/sale.dart';
import 'package:kaarigar/data/remote/api_client.dart';
import 'package:kaarigar/features/shell/app_shell.dart';
import 'package:kaarigar/l10n/app_localizations.dart';
import 'package:kaarigar/services/speech_service.dart';
import 'package:kaarigar/state/providers.dart';
import 'package:kaarigar/state/queue_controller.dart';
import 'package:kaarigar/core/theme/app_theme.dart';
import 'package:kaarigar/data/repositories/seller_repository.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _NoServer implements ApiClient {
  int listingCalls = 0;
  int saleCalls = 0;

  @override
  Future<List<Listing>> listings() async {
    listingCalls++;
    return const [];
  }

  @override
  Future<List<Sale>> sales() async {
    saleCalls++;
    return const [];
  }

  @override
  noSuchMethod(Invocation invocation) => throw UnimplementedError();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late QueueController queue;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    queue = QueueController();
  });

  void useCheapPhone(WidgetTester tester) {
    tester.view.physicalSize = const Size(720, 1280);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  }

  late _NoServer server;

  Widget harness() {
    server = _NoServer();
    return MultiProvider(
      providers: [
        ...appProviders(
          sellers: SellerRepository(),
          speech: SpeechService(),
          api: server,
        ),
        ChangeNotifierProvider<QueueController>.value(value: queue),
      ],
      child: MaterialApp(
        theme: AppTheme.light,
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const AppShell(),
      ),
    );
  }

  final l10n = lookupAppLocalizations(const Locale('en'));

  testWidgets('a tab asks again for what it is about to show', (tester) async {
    useCheapPhone(tester);
    await tester.pumpWidget(harness());
    await tester.pumpAndSettle();

    final afterHome = server.listingCalls;
    expect(afterHome, 1);
    expect(server.saleCalls, 1);

    final salesAfterHome = server.saleCalls;
    await tester.tap(find.text(l10n.navListings));
    await tester.pumpAndSettle();
    expect(server.listingCalls, greaterThan(afterHome));
    expect(server.saleCalls, greaterThan(salesAfterHome));

    final beforeProfile = server.listingCalls + server.saleCalls;
    await tester.tap(find.text(l10n.navProfile));
    await tester.pumpAndSettle();
    expect(server.listingCalls + server.saleCalls, beforeProfile);
  });

  testWidgets('opens on Home and moves between all three tabs', (tester) async {
    useCheapPhone(tester);
    await tester.pumpWidget(harness());
    await tester.pump();

    expect(find.text(l10n.homeAddProduct), findsOneWidget);

    await tester.tap(find.text(l10n.navListings));
    await tester.pumpAndSettle();
    expect(find.text(l10n.listingsTitle), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('section-sold')));
    await tester.pumpAndSettle();
    expect(find.text(l10n.salesEmptyTitle), findsOneWidget);

    await tester.tap(find.text(l10n.navProfile));
    await tester.pumpAndSettle();
    expect(find.text(l10n.profileEditEntry), findsOneWidget);

    await tester.tap(find.text(l10n.navHome));
    await tester.pump();
    expect(find.text(l10n.homeAddProduct), findsOneWidget);
  });

  testWidgets('Home survives the OS font scale at 200%', (tester) async {
    useCheapPhone(tester);
    tester.platformDispatcher.textScaleFactorTestValue = 2.0;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

    await tester.pumpWidget(harness());
    await tester.pump();

    expect(tester.takeException(), isNull);
    expect(find.text(l10n.homeAddProduct), findsOneWidget);
  });

  testWidgets('the offline banner appears whenever the queue is not empty', (
    tester,
  ) async {
    useCheapPhone(tester);
    await tester.pumpWidget(harness());
    await tester.pump();

    expect(find.text(l10n.offlineNothingLost), findsNothing);

    queue.add(
      CaptureItem(
        id: 'c1',
        photoPaths: const ['a.jpg'],
        voiceNotePath: 'a.m4a',
        createdAt: DateTime.now(),
      ),
    );
    await tester.pump();

    expect(find.text(l10n.offlineNothingLost), findsOneWidget);
    await tester.tap(find.text(l10n.navProfile));
    await tester.pump();
    expect(find.text(l10n.offlineNothingLost), findsOneWidget);
  });
}
