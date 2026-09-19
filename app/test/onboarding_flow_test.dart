import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kirtikar/app.dart';
import 'package:kirtikar/core/constants/app_constants.dart';
import 'package:kirtikar/core/dev/dev_accounts.dart';
import 'package:kirtikar/data/models/app_language.dart';
import 'package:kirtikar/data/repositories/seller_repository.dart';
import 'package:kirtikar/l10n/app_localizations.dart';
import 'package:kirtikar/services/speech_service.dart';
import 'package:kirtikar/state/providers.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  Widget harness() {
    final speech = SpeechService();

    return MultiProvider(
      providers: appProviders(sellers: sellers, speech: speech),
      child: const KirtikarApp(),
    );
  }

  Future<void> advance(
    WidgetTester tester, [
    Duration total = const Duration(seconds: 2),
  ]) async {
    const step = Duration(milliseconds: 100);
    for (var i = 0; i < total.inMilliseconds ~/ step.inMilliseconds; i++) {
      await tester.pump(step);
    }
  }

  Future<void> typeOnPad(WidgetTester tester, String value) async {
    for (final digit in value.split('')) {
      final key = find.widgetWithText(InkWell, digit).first;
      await tester.ensureVisible(key);
      await tester.pump();
      await tester.tap(key);
      await tester.pump();
    }
  }

  testWidgets('a first run walks setup to Home and saves the profile', (
    tester,
  ) async {
    useCheapPhone(tester);
    await tester.pumpWidget(harness());

    await tester.pump();
    await advance(tester, const Duration(seconds: 4));

    expect(find.text('हिंदी'), findsOneWidget);
    expect(find.text('मराठी'), findsOneWidget);
    await tester.ensureVisible(find.text('English'));
    await advance(tester);
    await tester.tap(find.text('English'));
    await advance(tester);

    final l10n = lookupAppLocalizations(const Locale('en'));

    expect(find.text(l10n.welcomeCard1Title), findsOneWidget);
    await tester.tap(find.text(l10n.actionNext));
    await advance(tester);
    expect(find.text(l10n.welcomeCard2Title), findsOneWidget);
    await tester.tap(find.text(l10n.actionNext));
    await advance(tester);
    expect(find.text(l10n.welcomeCard3Title), findsOneWidget);
    await tester.tap(find.text(l10n.welcomeStart));
    await advance(tester);

    expect(find.text(l10n.termsAgreeTitle), findsOneWidget);
    await tester.tap(find.text(l10n.termsAgreeContinue));
    await advance(tester);
    expect(find.text(l10n.termsAgreeTitle), findsOneWidget);
    await tester.tap(find.byKey(const Key('terms-agree-check')));
    await tester.pump();
    await tester.tap(find.text(l10n.termsAgreeContinue));
    await advance(tester);
    expect(await sellers.acceptedTermsVersion(), AppConstants.termsVersion);
    expect(await sellers.termsAcceptedAt(), isNotNull);

    for (final title in [l10n.permissionCameraTitle, l10n.permissionMicTitle]) {
      expect(find.text(title), findsOneWidget);
      await tester.tap(find.text(l10n.permissionNotNow));
      await advance(tester);
    }

    expect(find.text(l10n.phoneTitle), findsOneWidget);
    expect(find.byType(TextField), findsNothing);
    await typeOnPad(tester, DevAccounts.phone);
    await tester.tap(find.text(l10n.phoneSendCode));
    await advance(tester);

    expect(find.text(l10n.otpTitle), findsOneWidget);
    await advance(tester, const Duration(seconds: 5));

    expect(find.text(l10n.profileTitle), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
    await tester.enterText(find.byType(TextField).at(0), 'Radha');
    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pump();
    await tester.ensureVisible(find.text(l10n.craftWeaving));
    await advance(tester);
    await tester.tap(find.text(l10n.craftWeaving));
    await advance(tester);

    await tester.tap(find.text(l10n.practiceFinish));
    await advance(tester);
    expect(find.text(l10n.ondcTitle), findsNothing);
    expect(find.text(l10n.practiceTitle), findsNothing);
    expect(find.text(l10n.homeAddProduct), findsOneWidget);

    expect(await sellers.hasCompletedSetup(), isTrue);
    final saved = await sellers.profile();
    expect(saved?.name, 'Radha');
    expect(saved?.ondcSellerId, isNull);
    expect(saved?.languageCode, 'en');

    await tester.tap(find.text(l10n.homeAddProduct));
    await advance(tester);
    expect(find.text(l10n.practiceTitle), findsOneWidget);
    expect(await sellers.hasSeenPractice(), isFalse);
  });

  testWidgets('a number that is not the demo number is refused', (
    tester,
  ) async {
    useCheapPhone(tester);
    await sellers.saveLanguage(AppLanguage.byCode('en'));
    await tester.pumpWidget(harness());
    await tester.pump();
    await advance(tester, const Duration(seconds: 4));

    final l10n = lookupAppLocalizations(const Locale('en'));

    await tester.tap(find.text(l10n.actionSkip));
    await advance(tester);
    await tester.tap(find.byKey(const Key('terms-agree-check')));
    await tester.pump();
    await tester.tap(find.text(l10n.termsAgreeContinue));
    await advance(tester);
    for (var i = 0; i < 2; i++) {
      await tester.tap(find.text(l10n.permissionNotNow));
      await advance(tester);
    }

    await typeOnPad(tester, '9876543210');
    await tester.tap(find.text(l10n.phoneSendCode));
    await advance(tester);

    expect(find.text(l10n.phoneUnknown(DevAccounts.phone)), findsOneWidget);
    expect(find.text(l10n.otpTitle), findsNothing);
  });

  testWidgets('a completed setup skips onboarding entirely', (tester) async {
    useCheapPhone(tester);
    await sellers.saveLanguage(AppLanguage.byCode('en'));
    await sellers.markSetupComplete();

    await tester.pumpWidget(harness());
    await tester.pump();
    await advance(tester, const Duration(seconds: 4));

    final l10n = lookupAppLocalizations(const Locale('en'));
    expect(find.text(l10n.languageTitle), findsNothing);
    expect(find.text(l10n.homeAddProduct), findsOneWidget);
    for (final tab in [l10n.navHome, l10n.navListings, l10n.navProfile]) {
      expect(find.text(tab), findsOneWidget);
    }
  });
}
