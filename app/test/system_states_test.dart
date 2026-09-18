import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kirtikar/core/theme/app_theme.dart';
import 'package:kirtikar/data/models/listing.dart';
import 'package:kirtikar/data/remote/api_client.dart';
import 'package:kirtikar/data/repositories/listing_repository.dart';
import 'package:kirtikar/features/listings/listings_screen.dart';
import 'package:kirtikar/features/system/force_update_screen.dart';
import 'package:kirtikar/features/system/permission_recovery_screen.dart';
import 'package:kirtikar/l10n/app_localizations.dart';
import 'package:kirtikar/services/permission_service.dart';
import 'package:kirtikar/services/speech_service.dart';
import 'package:kirtikar/state/catalog_controller.dart';
import 'package:kirtikar/widgets/status_view.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class _DeadApi implements ApiClient {
  int calls = 0;

  @override
  Future<List<Listing>> listings() async {
    calls++;
    throw Exception('server down');
  }

  @override
  noSuchMethod(Invocation invocation) => throw UnimplementedError();
}

class _BlockingPermissions implements PermissionService {
  final Map<AppPermission, PermissionOutcome> outcomes = {
    AppPermission.camera: PermissionOutcome.blocked,
    AppPermission.microphone: PermissionOutcome.granted,
    AppPermission.notifications: PermissionOutcome.granted,
  };
  int settingsOpened = 0;

  @override
  Future<PermissionOutcome> check(AppPermission permission) async =>
      outcomes[permission]!;

  @override
  Future<PermissionOutcome> request(AppPermission permission) async =>
      outcomes[permission]!;

  @override
  Future<bool> openSettings() async {
    settingsOpened++;
    return true;
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

  Widget harness(Widget home, {List<SingleChildWidget> extra = const []}) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<SpeechService>(create: (_) => SpeechService()),
        ...extra,
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

  group('the shared panel', () {
    testWidgets('10.1 says the work is safe, and is not an error', (
      tester,
    ) async {
      useCheapPhone(tester);
      await tester.pumpWidget(
        harness(const StatusView(kind: StatusKind.noNetwork)),
      );
      await tester.pumpAndSettle();

      expect(find.text(l10n.noNetworkTitle), findsOneWidget);
      expect(find.text(l10n.noNetworkBody), findsOneWidget);
      expect(find.text(l10n.actionTryAgain), findsNothing);
    });

    testWidgets('10.3 says nothing was lost, and always offers a retry', (
      tester,
    ) async {
      useCheapPhone(tester);
      var retried = 0;
      await tester.pumpWidget(
        harness(
          StatusView(kind: StatusKind.serverError, onAction: () => retried++),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text(l10n.serverErrorBody), findsOneWidget);
      await tester.tap(find.text(l10n.actionTryAgain));
      await tester.pump();
      expect(retried, 1);
    });

    testWidgets('every state reads itself aloud', (tester) async {
      useCheapPhone(tester);
      for (final kind in StatusKind.values) {
        await tester.pumpWidget(harness(StatusView(kind: kind)));
        await tester.pumpAndSettle();
        expect(
          find.byIcon(Icons.volume_up),
          findsOneWidget,
          reason: 'no speaker on ${kind.name}',
        );
      }
    });
  });

  group('10.3 on a real screen', () {
    testWidgets('a dead server is not shown as an empty shop', (tester) async {
      useCheapPhone(tester);
      final api = _DeadApi();
      final catalog = CatalogController(
        repository: ListingRepository(api: api),
      );
      await catalog.refresh();

      await tester.pumpWidget(
        harness(
          const ListingsList(filter: ListingFilter.listed),
          extra: [
            ChangeNotifierProvider<CatalogController>.value(value: catalog),
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text(l10n.serverErrorTitle), findsOneWidget);
      expect(find.text(l10n.listingsEmptyTitle), findsNothing);

      await tester.tap(find.text(l10n.actionTryAgain));
      await tester.pumpAndSettle();
      expect(api.calls, greaterThan(1));
    });
  });

  group('10.5 permission recovery', () {
    testWidgets('says which is blocked, why it matters, and opens settings', (
      tester,
    ) async {
      useCheapPhone(tester);
      final permissions = _BlockingPermissions();

      await tester.pumpWidget(
        harness(
          const PermissionRecoveryScreen(),
          extra: [Provider<PermissionService>.value(value: permissions)],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text(l10n.permissionCameraTitle), findsOneWidget);
      expect(find.text(l10n.permissionCameraWhy), findsOneWidget);
      expect(find.text(l10n.permissionBlocked), findsOneWidget);

      await tester.drag(find.byType(ListView), const Offset(0, -320));
      await tester.pumpAndSettle();
      expect(find.text(l10n.permissionGranted), findsWidgets);

      await tester.tap(find.text(l10n.permissionAsk));
      await tester.pumpAndSettle();
      expect(permissions.settingsOpened, 1);
    });

    testWidgets('says so when everything is allowed', (tester) async {
      useCheapPhone(tester);
      final permissions = _BlockingPermissions()
        ..outcomes[AppPermission.camera] = PermissionOutcome.granted;

      await tester.pumpWidget(
        harness(
          const PermissionRecoveryScreen(),
          extra: [Provider<PermissionService>.value(value: permissions)],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text(l10n.permissionAllGood), findsOneWidget);
      expect(find.text(l10n.permissionAsk), findsNothing);
    });
  });

  group('10.6 the update gate', () {
    testWidgets('has no way out, and promises the phone keeps its work', (
      tester,
    ) async {
      useCheapPhone(tester);
      await tester.pumpWidget(harness(const ForceUpdateScreen()));
      await tester.pumpAndSettle();

      expect(find.text(l10n.updateTitle), findsOneWidget);
      expect(find.text(l10n.updateBody), findsOneWidget);
      expect(find.text(l10n.updateAction), findsOneWidget);

      final scopes = tester
          .widgetList(find.byWidgetPredicate((w) => w is PopScope))
          .cast<PopScope>();
      expect(scopes, isNotEmpty);
      expect(scopes.every((s) => s.canPop), isFalse);
    });

    testWidgets(
      'with no store listing it says so rather than opening nothing',
      (tester) async {
        useCheapPhone(tester);
        await tester.pumpWidget(harness(const ForceUpdateScreen()));
        await tester.pumpAndSettle();

        await tester.tap(find.text(l10n.updateAction));
        await tester.pumpAndSettle();

        expect(find.text(l10n.updateFailed), findsOneWidget);

        await tester.pump(const Duration(seconds: 4));
      },
    );
  });
}
