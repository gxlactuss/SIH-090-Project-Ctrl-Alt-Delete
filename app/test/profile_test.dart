import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kirtikar/core/theme/app_theme.dart';
import 'package:kirtikar/data/models/app_language.dart';
import 'package:kirtikar/data/models/craft_type.dart';
import 'package:kirtikar/data/models/fact_sheet.dart';
import 'package:kirtikar/data/models/listing.dart';
import 'package:kirtikar/data/models/listing_status.dart';
import 'package:kirtikar/data/models/seller_profile.dart';
import 'package:kirtikar/data/remote/api_client.dart';
import 'package:kirtikar/data/repositories/listing_repository.dart';
import 'package:kirtikar/data/repositories/seller_repository.dart';
import 'package:kirtikar/features/onboarding/ondc_screen.dart';
import 'package:kirtikar/features/profile/account_screen.dart';
import 'package:kirtikar/features/profile/ondc_account_screen.dart';
import 'package:kirtikar/features/profile/privacy_screen.dart';
import 'package:kirtikar/features/profile/profile_screen.dart';
import 'package:kirtikar/features/profile/storage_screen.dart';
import 'package:kirtikar/l10n/app_localizations.dart';
import 'package:kirtikar/services/permission_service.dart';
import 'package:kirtikar/services/speech_service.dart';
import 'package:kirtikar/services/storage_service.dart';
import 'package:kirtikar/state/app_state.dart';
import 'package:kirtikar/state/catalog_controller.dart';
import 'package:kirtikar/state/queue_controller.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _FakeApi implements ApiClient {
  _FakeApi(this.current);

  Listing current;
  ({bool photo, bool story})? lastConsent;

  @override
  Future<List<Listing>> listings() async => [current];

  @override
  Future<Listing> setConsent({
    required String listingId,
    required bool photoConsent,
    required bool storyConsent,
  }) async {
    lastConsent = (photo: photoConsent, story: storyConsent);
    return current = current.copyWith(
      photoConsent: photoConsent,
      storyConsent: storyConsent,
      status: photoConsent ? current.status : ListingStatus.unpublished,
    );
  }

  bool deleted = false;
  bool refuseDelete = false;

  @override
  Future<void> deleteAccount() async {
    if (refuseDelete) throw Exception('offline');
    deleted = true;
  }

  @override
  noSuchMethod(Invocation invocation) => throw UnimplementedError();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late SellerRepository sellers;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    sellers = SellerRepository();
  });

  void useCheapPhone(WidgetTester tester) {
    tester.view.physicalSize = const Size(720, 1280);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  }

  final l10n = lookupAppLocalizations(const Locale('en'));

  const profile = SellerProfile(
    id: 'seller-1',
    name: 'Radha',
    languageCode: 'en',
    phone: '8828333400',
    craft: CraftType.pottery,
    village: 'Kotri',
    ondcSellerId: 'demo-seller-01',
  );

  Listing published({bool photo = true, bool story = true}) => Listing(
    id: 'l1',
    status: ListingStatus.published,
    title: 'Blue water jug',
    factSheet: const FactSheet(quantity: 2, priceInPaise: 45000),
    photoConsent: photo,
    storyConsent: story,
  );

  ({Widget widget, AppState state}) harness(
    Widget home, {
    SellerProfile? seller = profile,
    _FakeApi? api,
    List<Listing> catalogue = const [],
    QueueController? queue,
    StorageService? storage,
  }) {
    final speech = SpeechService();
    final state = AppState(sellers: sellers, speech: speech);
    if (seller != null) state.completeSetup(seller);
    final client = api ?? _FakeApi(published());

    return (
      widget: MultiProvider(
        providers: [
          Provider<SellerRepository>.value(value: sellers),
          Provider<PermissionService>(create: (_) => const PermissionService()),
          ChangeNotifierProvider<SpeechService>.value(value: speech),
          ChangeNotifierProvider<AppState>.value(value: state),
          ChangeNotifierProvider<QueueController>.value(
            value: queue ?? QueueController(),
          ),
          Provider<ApiClient>.value(value: client),
          Provider<ListingRepository>(
            create: (_) => ListingRepository(api: client),
          ),
          ChangeNotifierProvider<CatalogController>(
            create: (_) => CatalogController(listings: catalogue),
          ),
          if (storage != null) Provider<StorageService>.value(value: storage),
        ],
        child: MaterialApp(
          theme: AppTheme.light,
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(body: home),
        ),
      ),
      state: state,
    );
  }

  group('8.1 the overview', () {
    testWidgets('shows what each setting is currently set to', (tester) async {
      useCheapPhone(tester);
      final (widget: widget, state: _) = harness(const ProfileScreen());
      await tester.pumpWidget(widget);
      await tester.pumpAndSettle();

      expect(find.text('Radha'), findsWidgets);
      expect(find.text('Kotri'), findsOneWidget);

      await tester.drag(find.byType(ListView), const Offset(0, -320));
      await tester.pumpAndSettle();

      expect(find.text(AppLanguage.fallback.endonym), findsOneWidget);
      expect(find.text('8828333400'), findsOneWidget);
      expect(find.text(l10n.ondcAccountLinked), findsOneWidget);
    });

    testWidgets('a detail nobody gave says so rather than sitting blank', (
      tester,
    ) async {
      useCheapPhone(tester);
      final (widget: widget, state: _) = harness(
        const ProfileScreen(),
        seller: const SellerProfile(
          id: 'seller-2',
          name: 'Radha',
          languageCode: 'en',
        ),
      );
      await tester.pumpWidget(widget);
      await tester.pumpAndSettle();

      expect(find.text(l10n.profileNotSet), findsWidgets);

      await tester.drag(find.byType(ListView), const Offset(0, -320));
      await tester.pumpAndSettle();
      expect(find.text(l10n.ondcAccountNone), findsOneWidget);
    });
  });

  group('8.6 the selling account', () {
    testWidgets('unlinking asks first, and says what comes down', (
      tester,
    ) async {
      useCheapPhone(tester);
      final (widget: widget, :state) = harness(const OndcAccountScreen());
      await tester.pumpWidget(widget);
      await tester.pumpAndSettle();

      await tester.tap(find.text(l10n.ondcAccountUnlink));
      await tester.pumpAndSettle();

      expect(find.text(l10n.ondcUnlinkBody), findsOneWidget);
      await tester.tap(find.text(l10n.ondcUnlinkCancel));
      await tester.pumpAndSettle();
      expect(state.profile?.hasOndcAccount, isTrue);

      await tester.tap(find.text(l10n.ondcAccountUnlink));
      await tester.pumpAndSettle();
      await tester.tap(find.text(l10n.ondcUnlinkConfirm));
      await tester.pumpAndSettle();

      expect(state.profile?.hasOndcAccount, isFalse);
      expect(state.profile?.ondcSellerId, isNull);
      expect(find.text(l10n.ondcAccountLink), findsOneWidget);
    });
  });

  group('1.8 linking a selling account', () {
    testWidgets('asks for an email and seller id, and links well-formed ones', (
      tester,
    ) async {
      useCheapPhone(tester);
      final (widget: widget, :state) = harness(
        const OndcScreen(),
        seller: const SellerProfile(
          id: 'seller-3',
          name: 'Radha',
          languageCode: 'en',
        ),
      );
      await tester.pumpWidget(widget);
      await tester.pumpAndSettle();

      expect(find.byType(TextField), findsNWidgets(2));
      expect(find.text(l10n.ondcEmailLabel), findsOneWidget);
      expect(find.text(l10n.ondcSellerIdLabel), findsOneWidget);
      final email = find.byType(TextField).at(0);
      final sellerId = find.byType(TextField).at(1);

      Future<void> link() async {
        await tester.pump();
        await tester.ensureVisible(find.text(l10n.ondcLink));
        await tester.tap(find.text(l10n.ondcLink));
        await tester.pumpAndSettle();
      }

      await tester.enterText(email, 'radha');
      await tester.enterText(sellerId, 'seller.example.com');
      await link();
      expect(find.text(l10n.ondcEmailMalformed), findsOneWidget);
      expect(state.profile?.hasOndcAccount, isFalse);

      await tester.enterText(email, 'radha@gmail.com');
      await tester.enterText(sellerId, 'my seller id');
      await link();
      expect(find.text(l10n.ondcMalformed), findsOneWidget);
      expect(state.profile?.hasOndcAccount, isFalse);

      await tester.enterText(sellerId, ' seller.example.com ');
      await link();

      expect(find.text(l10n.ondcMalformed), findsNothing);
      expect(state.profile?.ondcSellerId, 'seller.example.com');
      expect(state.profile?.ondcEmail, 'radha@gmail.com');
    });
  });

  group('8.9 the consent centre', () {
    testWidgets('withdrawing the photos says it takes the listing down', (
      tester,
    ) async {
      useCheapPhone(tester);
      final api = _FakeApi(published());
      final (widget: widget, state: _) = harness(
        const PrivacyScreen(),
        api: api,
        catalogue: [published()],
      );
      await tester.pumpWidget(widget);
      await tester.pumpAndSettle();

      expect(find.text(l10n.privacyPhoto), findsOneWidget);
      expect(find.text(l10n.privacyStory), findsOneWidget);

      await tester.tap(find.text(l10n.privacyWithdrawConfirm).first);
      await tester.pumpAndSettle();

      expect(find.text(l10n.privacyWithdrawPhotoBody), findsOneWidget);
      await tester.tap(find.text(l10n.privacyWithdrawCancel));
      await tester.pumpAndSettle();
      expect(api.lastConsent, isNull);

      await tester.tap(find.text(l10n.privacyWithdrawConfirm).first);
      await tester.pumpAndSettle();
      await tester.tap(find.text(l10n.privacyWithdrawConfirm).last);
      await tester.pumpAndSettle();

      expect(api.lastConsent, (photo: false, story: true));
      expect(api.current.status, ListingStatus.unpublished);
    });

    testWidgets('a consent that was never given cannot be withdrawn', (
      tester,
    ) async {
      useCheapPhone(tester);
      final listing = published(story: false);
      final (widget: widget, state: _) = harness(
        const PrivacyScreen(),
        api: _FakeApi(listing),
        catalogue: [listing],
      );
      await tester.pumpWidget(widget);
      await tester.pumpAndSettle();

      expect(find.text(l10n.privacyWithdrawConfirm), findsOneWidget);
    });

    testWidgets('nothing published says so', (tester) async {
      useCheapPhone(tester);
      final (widget: widget, state: _) = harness(const PrivacyScreen());
      await tester.pumpWidget(widget);
      await tester.pump();

      expect(find.text(l10n.privacyNothing), findsOneWidget);
    });
  });

  group('8.10 storage', () {
    test('clearing never touches a capture that is still waiting', () async {
      final root = Directory.systemTemp.createTempSync('kirtikar_storage');
      addTearDown(() => root.deleteSync(recursive: true));

      final storage = StorageService(documentsDirectory: () async => root);
      final captures = await storage.capturesDirectory();

      for (final id in ['sent', 'waiting']) {
        final dir = Directory('${captures.path}/$id')
          ..createSync(recursive: true);
        File('${dir.path}/photo_1.jpg').writeAsBytesSync(List.filled(2048, 7));
      }

      expect(await storage.capturedBytes(), 4096);

      final freed = await storage.clearUploaded(keepIds: {'waiting'});

      expect(freed, 2048);
      expect(Directory('${captures.path}/waiting').existsSync(), isTrue);
      expect(Directory('${captures.path}/sent').existsSync(), isFalse);
      expect(await storage.capturedBytes(), 2048);
    });

    testWidgets('says how much is used and how much is waiting', (
      tester,
    ) async {
      useCheapPhone(tester);
      final root = Directory.systemTemp.createTempSync('kirtikar_storage_ui');
      addTearDown(() => root.deleteSync(recursive: true));
      final storage = StorageService(documentsDirectory: () async => root);

      final (widget: widget, state: _) = harness(
        StorageScreen(storage: storage),
      );
      await tester.pumpWidget(widget);
      await tester.pump();

      expect(find.text(l10n.storagePhotos), findsOneWidget);
      expect(find.text(l10n.storageWaiting(0)), findsOneWidget);
      expect(find.text(l10n.storageClearWhy), findsOneWidget);
    });
  });

  group('8.11 signing out', () {
    testWidgets('says what is lost, out loud, before doing it', (tester) async {
      useCheapPhone(tester);
      final (widget: widget, :state) = harness(const AccountScreen());
      await tester.pumpWidget(widget);
      await tester.pumpAndSettle();

      await tester.tap(find.text(l10n.accountSignOut));
      await tester.pumpAndSettle();

      expect(find.text(l10n.accountSignOutBody), findsOneWidget);
      await tester.tap(find.text(l10n.accountSignOutCancel));
      await tester.pumpAndSettle();

      expect(state.profile, isNotNull);
      expect(await sellers.hasCompletedSetup(), isTrue);
    });

    testWidgets('takes the previous seller\'s products with it', (
      tester,
    ) async {
      useCheapPhone(tester);
      final (widget: widget, state: _) = harness(
        const AccountScreen(),
        catalogue: [published()],
      );
      await tester.pumpWidget(widget);
      await tester.pumpAndSettle();

      final context = tester.element(find.byType(AccountScreen));
      final catalog = context.read<CatalogController>();
      final listings = context.read<ListingRepository>();
      expect(catalog.listings, isNotEmpty);

      await tester.tap(find.text(l10n.accountSignOut));
      await tester.pumpAndSettle();
      await tester.tap(find.text(l10n.accountSignOutConfirm));
      for (var i = 0; i < 5; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }

      expect(catalog.listings, isEmpty);
      expect(listings.all, isEmpty);
    });

    testWidgets('deleting needs a held press, not a tap', (tester) async {
      useCheapPhone(tester);
      final (widget: widget, :state) = harness(const AccountScreen());
      await tester.pumpWidget(widget);
      await tester.pumpAndSettle();

      await tester.tap(find.text(l10n.accountDelete));
      await tester.pumpAndSettle();
      expect(find.text(l10n.accountDeleteBody), findsNothing);
      expect(state.profile, isNotNull);

      await tester.longPress(find.text(l10n.accountDelete));
      await tester.pumpAndSettle();
      expect(find.text(l10n.accountDeleteBody), findsOneWidget);
    });

    testWidgets('deleting asks the server first, then clears the phone', (
      tester,
    ) async {
      useCheapPhone(tester);
      final api = _FakeApi(published());
      final (widget: widget, state: _) = harness(
        const AccountScreen(),
        api: api,
        catalogue: [published()],
      );
      await tester.pumpWidget(widget);
      await tester.pumpAndSettle();
      final catalog = tester
          .element(find.byType(AccountScreen))
          .read<CatalogController>();

      await tester.longPress(find.text(l10n.accountDelete));
      await tester.pumpAndSettle();
      await tester.tap(find.text(l10n.accountDeleteConfirm));
      for (var i = 0; i < 5; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }

      expect(api.deleted, isTrue);
      expect(catalog.listings, isEmpty);
    });

    testWidgets('a delete the server refused leaves everything in place', (
      tester,
    ) async {
      useCheapPhone(tester);
      final api = _FakeApi(published())..refuseDelete = true;
      final (widget: widget, :state) = harness(const AccountScreen(), api: api);
      await tester.pumpWidget(widget);
      await tester.pumpAndSettle();

      await tester.longPress(find.text(l10n.accountDelete));
      await tester.pumpAndSettle();
      await tester.tap(find.text(l10n.accountDeleteConfirm));
      await tester.pumpAndSettle();

      expect(state.profile, isNotNull);
      expect(await sellers.hasCompletedSetup(), isTrue);
      expect(find.text(l10n.listingActionFailed), findsOneWidget);
    });
  });

  group('the profile itself', () {
    test('an edit is written to the phone, and survives a restart', () async {
      final speech = SpeechService();
      final state = AppState(sellers: sellers, speech: speech);
      await state.completeSetup(profile);

      await state.updateProfile(
        name: 'Radha Devi',
        village: 'Kotri',
        craftStory: 'Three generations on the same wheel.',
      );

      final saved = await sellers.profile();
      expect(saved?.name, 'Radha Devi');
      expect(saved?.village, 'Kotri');
      expect(saved?.craftStory, 'Three generations on the same wheel.');
    });

    test('signing out clears the profile but keeps the language', () async {
      final speech = SpeechService();
      final state = AppState(sellers: sellers, speech: speech);
      await state.completeSetup(profile);
      await sellers.saveLanguage(state.language);

      await state.signOut();

      expect(state.profile, isNull);
      expect(await sellers.profile(), isNull);
      expect(await sellers.hasCompletedSetup(), isFalse);
      expect(await sellers.languageCode(), isNotNull);
    });
  });
}
