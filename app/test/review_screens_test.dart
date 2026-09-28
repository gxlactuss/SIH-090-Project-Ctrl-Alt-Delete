import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kirtikar/core/routing/app_routes.dart';
import 'package:kirtikar/core/theme/app_theme.dart';
import 'package:kirtikar/data/models/fact_sheet.dart';
import 'package:kirtikar/data/models/listing.dart';
import 'package:kirtikar/data/models/listing_status.dart';
import 'package:kirtikar/data/models/suggestion.dart';
import 'package:kirtikar/data/remote/api_client.dart';
import 'package:kirtikar/core/routing/app_routes.dart';
import 'package:kirtikar/data/repositories/listing_repository.dart';
import 'package:kirtikar/features/review/review_screen.dart';
import 'package:kirtikar/l10n/app_localizations.dart';
import 'package:kirtikar/services/speech_service.dart';
import 'package:provider/provider.dart';

class _FakeApi implements ApiClient {
  _FakeApi(this.current);

  Listing current;
  ({bool photo, bool story})? publishedWith;

  @override
  Future<Listing> listing(String id) async => current;

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
      if (entry.key == 'isOneOfAKind') {
        sheet = sheet.copyWith(isOneOfAKind: entry.value as bool?);
      }
    }
    return current = current.copyWith(factSheet: sheet);
  }

  @override
  Future<Listing> resolveSuggestions({
    required String listingId,
    required Map<String, bool> decisions,
  }) async {
    return current = current.copyWith(
      suggestions: [
        for (final s in current.suggestions)
          decisions.containsKey(s.id)
              ? s.copyWith(accepted: decisions[s.id])
              : s,
      ],
    );
  }

  @override
  Future<Listing> publish({
    required String listingId,
    required bool photoConsent,
    required bool storyConsent,
  }) async {
    publishedWith = (photo: photoConsent, story: storyConsent);
    return current = current.copyWith(
      status: ListingStatus.published,
      previewUrl: 'https://example/p/$listingId',
    );
  }

  int republishes = 0;

  @override
  Future<Listing> republish(String listingId) async {
    republishes++;
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

  Listing ready() => const Listing(
    id: 'l1',
    status: ListingStatus.ready,
    title: 'Blue water jug',
    description: 'A hand-thrown jug, glazed blue.',
    imageUrls: ['a.jpg', 'b.jpg'],
    factSheet: FactSheet(
      material: 'Clay',
      size: '12 inches',
      quantity: 1,
      hoursToMake: 6,
      materialCostInPaise: 12000,
    ),
    suggestions: [
      Suggestion(
        id: 'summer',
        spokenPrompt: 'Shall I add: good for summer?',
        textIfAccepted: 'Good for summer.',
      ),
    ],
  );

  final routes = <RouteSettings>[];

  Widget harness(Listing listing, _FakeApi api) {
    routes.clear();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<SpeechService>(create: (_) => SpeechService()),
        Provider<ListingRepository>(create: (_) => ListingRepository(api: api)),
      ],
      child: MaterialApp(
        theme: AppTheme.light,
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: ReviewScreen(listing: listing),
        onGenerateRoute: (settings) {
          routes.add(settings);

          return MaterialPageRoute<void>(
            settings: settings,
            builder: (_) => const Scaffold(body: Text('elsewhere')),
          );
        },
      ),
    );
  }

  testWidgets('5.2 shows what was said and what was not', (tester) async {
    useCheapPhone(tester);
    final api = _FakeApi(ready());
    await tester.pumpWidget(harness(ready(), api));
    await tester.pump();

    expect(find.text(l10n.readBackTitle), findsOneWidget);
    expect(find.text('A hand-thrown jug, glazed blue.'), findsOneWidget);

    expect(find.text('Clay'), findsOneWidget);
    expect(find.text('12 inches'), findsOneWidget);

    expect(find.text(l10n.notSaid), findsNWidgets(2));
  });

  testWidgets('5.1 asks the one question when a fact is missing', (
    tester,
  ) async {
    useCheapPhone(tester);
    final listing = ready().copyWith(
      status: ListingStatus.needsAttention,
      followUpQuestion: 'How big is it?',
    );
    await tester.pumpWidget(harness(listing, _FakeApi(listing)));
    await tester.pump();

    expect(find.text(l10n.attentionTitle), findsOneWidget);
    expect(find.text('How big is it?'), findsOneWidget);
    expect(find.text(l10n.attentionHoldToAnswer), findsOneWidget);
    expect(find.byIcon(Icons.photo_camera), findsNothing);
  });

  testWidgets('5.3 and 5.4: a field opens voice, with a keypad behind it', (
    tester,
  ) async {
    useCheapPhone(tester);
    final api = _FakeApi(ready());
    await tester.pumpWidget(harness(ready(), api));
    await tester.pump();

    await tester.ensureVisible(find.text(l10n.fieldPrice));
    await tester.pumpAndSettle();
    await tester.tap(find.text(l10n.fieldPrice));
    await tester.pumpAndSettle();

    expect(find.text(l10n.correctHoldToSpeak), findsOneWidget);
    await tester.tap(find.text(l10n.correctUseKeypad));
    await tester.pumpAndSettle();

    for (final digit in ['4', '5', '0']) {
      await tester.ensureVisible(find.text(digit));
      await tester.pumpAndSettle();
      await tester.tap(find.text(digit));
      await tester.pump();
    }
    await tester.tap(find.text(l10n.correctSave));
    await tester.pumpAndSettle();

    expect(api.current.factSheet.priceInPaise, 45000);
  });

  Listing missingMaterial() => Listing(
    id: 'l1',
    status: ListingStatus.ready,
    title: 'Blue water jug',
    description: 'A hand-thrown jug, glazed blue.',
    imageUrls: const ['a.jpg', 'b.jpg'],
    factSheet: const FactSheet(size: '12 inches', quantity: 1),
    suggestions: const [
      Suggestion(
        id: 'material',
        field: 'material',
        spokenPrompt: 'The voice note did not mention what it is made of.',
        textIfAccepted: 'material',
      ),
    ],
  );

  testWidgets('5.5 a missing field asks for the value, not just yes or no', (
    tester,
  ) async {
    useCheapPhone(tester);
    final api = _FakeApi(missingMaterial());
    await tester.pumpWidget(harness(missingMaterial(), api));
    await tester.pump();

    await tester.tap(find.text(l10n.readBackApprove));
    await tester.pumpAndSettle();

    expect(find.text(l10n.suggestTitle), findsOneWidget);
    expect(find.text(l10n.suggestAskMaterial), findsOneWidget);

    await tester.tap(find.text(l10n.suggestYes));
    await tester.pumpAndSettle();

    expect(
      find.text(l10n.correctTitle(l10n.fieldMaterial.toLowerCase())),
      findsOneWidget,
    );

    await tester.tap(find.text(l10n.correctUseKeypad));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'Clay');
    await tester.pumpAndSettle();
    await tester.tap(find.text(l10n.correctSave));
    await tester.pumpAndSettle();

    expect(api.current.factSheet.material, 'Clay');
    expect(find.text(l10n.suggestDone), findsOneWidget);
  });

  testWidgets('5.5 backing out of the input leaves the question standing', (
    tester,
  ) async {
    useCheapPhone(tester);
    final api = _FakeApi(missingMaterial());
    await tester.pumpWidget(harness(missingMaterial(), api));
    await tester.pump();

    await tester.tap(find.text(l10n.readBackApprove));
    await tester.pumpAndSettle();
    await tester.tap(find.text(l10n.suggestYes));
    await tester.pumpAndSettle();

    await tester.tap(find.text(l10n.correctCancel));
    await tester.pumpAndSettle();

    expect(find.text(l10n.suggestTitle), findsOneWidget);
    expect(api.current.factSheet.material, isNull);
  });

  testWidgets('walks 5.2 to 5.11 and publishes', (tester) async {
    useCheapPhone(tester);
    final api = _FakeApi(ready());
    await tester.pumpWidget(harness(ready(), api));
    await tester.pump();

    await tester.tap(find.text(l10n.readBackApprove));
    await tester.pumpAndSettle();
    expect(find.text(l10n.suggestTitle), findsOneWidget);
    await tester.tap(find.text(l10n.suggestYes));
    await tester.pumpAndSettle();

    await tester.tap(find.text(l10n.readBackApprove));
    await tester.pumpAndSettle();

    expect(find.text(l10n.priceTitle), findsOneWidget);
    await tester.tap(find.text(l10n.priceConfirm));
    await tester.pumpAndSettle();

    expect(find.text(l10n.stockTitle), findsOneWidget);
    await tester.tap(find.text(l10n.stockConfirm));
    await tester.pumpAndSettle();

    expect(find.text(l10n.photosTitle), findsOneWidget);
    await tester.tap(find.text(l10n.photosConfirm));
    await tester.pumpAndSettle();

    expect(find.text(l10n.previewTitle), findsOneWidget);
    await tester.tap(find.text(l10n.previewConfirm));
    await tester.pumpAndSettle();

    expect(find.text(l10n.consentTitle), findsOneWidget);
    final publish = find.widgetWithText(FilledButton, l10n.consentPublish);
    expect(tester.widget<FilledButton>(publish).onPressed, isNull);

    await tester.tap(find.text(l10n.consentPhoto));
    await tester.pumpAndSettle();
    await tester.tap(find.text(l10n.consentPublish));
    await tester.pumpAndSettle();

    expect(api.publishedWith, (photo: true, story: false));
    expect(find.text(l10n.publishedTitle), findsOneWidget);
    expect(find.text(l10n.publishedShare), findsOneWidget);
    expect(find.text(l10n.publishedAnother), findsOneWidget);
  });

  testWidgets('5.6 warns below the floor but never blocks', (tester) async {
    useCheapPhone(tester);
    final api = _FakeApi(ready());
    await tester.pumpWidget(harness(ready(), api));
    await tester.pump();

    await tester.tap(find.text(l10n.readBackApprove));
    await tester.pumpAndSettle();
    await tester.tap(find.text(l10n.suggestNo));
    await tester.pumpAndSettle();
    await tester.tap(find.text(l10n.readBackApprove));
    await tester.pumpAndSettle();

    await tester.drag(find.byType(Slider), const Offset(-500, 0));
    await tester.pumpAndSettle();

    expect(find.text(l10n.priceBelowFloor), findsOneWidget);
    final confirm = find.widgetWithText(FilledButton, l10n.priceConfirm);
    expect(tester.widget<FilledButton>(confirm).onPressed, isNotNull);
  });

  testWidgets('leaving half way through an edit says what that costs', (
    tester,
  ) async {
    useCheapPhone(tester);
    final live = ready().copyWith(status: ListingStatus.published);
    await tester.pumpWidget(harness(live, _FakeApi(live)));
    await tester.pump();

    await tester.tap(find.byIcon(Icons.close));
    await tester.pumpAndSettle();

    expect(find.text(l10n.editLeaveBody), findsOneWidget);
    expect(find.text(l10n.reviewLeaveBody), findsNothing);
  });

  testWidgets('a first publish keeps the reassuring wording', (tester) async {
    useCheapPhone(tester);
    await tester.pumpWidget(harness(ready(), _FakeApi(ready())));
    await tester.pump();

    await tester.tap(find.byIcon(Icons.close));
    await tester.pumpAndSettle();

    expect(find.text(l10n.reviewLeaveBody), findsOneWidget);
  });

  testWidgets('6.3, loop 5: an edit ends on republish, and never asks for '
      'consent again', (tester) async {
    useCheapPhone(tester);
    final live = ready().copyWith(status: ListingStatus.published);
    final api = _FakeApi(live);
    await tester.pumpWidget(harness(live, api));
    await tester.pump();

    await tester.tap(find.text(l10n.readBackApprove));
    await tester.pumpAndSettle();
    await tester.tap(find.text(l10n.suggestYes));
    await tester.pumpAndSettle();
    await tester.tap(find.text(l10n.readBackApprove));
    await tester.pumpAndSettle();
    await tester.tap(find.text(l10n.priceConfirm));
    await tester.pumpAndSettle();
    await tester.tap(find.text(l10n.stockConfirm));
    await tester.pumpAndSettle();
    await tester.tap(find.text(l10n.photosConfirm));
    await tester.pumpAndSettle();

    expect(find.text(l10n.previewTitle), findsOneWidget);
    expect(find.text(l10n.previewConfirm), findsNothing);
    await tester.tap(find.text(l10n.editRepublishConfirm));
    await tester.pumpAndSettle();

    expect(find.text(l10n.consentTitle), findsNothing);
    expect(api.republishes, 1);
    expect(api.publishedWith, isNull);
    expect(find.text(l10n.editRepublished), findsOneWidget);
  });

  testWidgets('loop 6: "make another like this" carries the fact sheet with '
      'it', (tester) async {
    useCheapPhone(tester);
    final live = ready().copyWith(status: ListingStatus.published);
    final api = _FakeApi(live);
    await tester.pumpWidget(harness(live, api));
    await tester.pump();

    await tester.tap(find.text(l10n.readBackApprove));
    await tester.pumpAndSettle();
    await tester.tap(find.text(l10n.suggestYes));
    await tester.pumpAndSettle();
    await tester.tap(find.text(l10n.readBackApprove));
    await tester.pumpAndSettle();
    await tester.tap(find.text(l10n.priceConfirm));
    await tester.pumpAndSettle();
    await tester.tap(find.text(l10n.stockConfirm));
    await tester.pumpAndSettle();
    await tester.tap(find.text(l10n.photosConfirm));
    await tester.pumpAndSettle();
    await tester.tap(find.text(l10n.editRepublishConfirm));
    await tester.pumpAndSettle();

    await tester.tap(find.text(l10n.publishedAnother));
    await tester.pumpAndSettle();

    expect(routes.single.name, AppRoutes.capture);
    expect(routes.single.arguments, 'l1');
  });
}
