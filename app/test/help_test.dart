import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kaarigar/core/theme/app_theme.dart';
import 'package:kaarigar/features/help/about_screen.dart';
import 'package:kaarigar/features/help/faq_screen.dart';
import 'package:kaarigar/features/help/help_content.dart';
import 'package:kaarigar/features/help/help_screen.dart';
import 'package:kaarigar/features/help/help_topic_screen.dart';
import 'package:kaarigar/features/help/support_screen.dart';
import 'package:kaarigar/features/help/terms_screen.dart';
import 'package:kaarigar/l10n/app_localizations.dart';
import 'package:kaarigar/services/speech_service.dart';
import 'package:provider/provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  void useCheapPhone(WidgetTester tester) {
    tester.view.physicalSize = const Size(720, 1280);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  }

  final l10n = lookupAppLocalizations(const Locale('en'));

  Widget harness(Widget home) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<SpeechService>(create: (_) => SpeechService()),
      ],
      child: MaterialApp(
        theme: AppTheme.light,
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: home,
      ),
    );
  }

  group('9.1 the help centre', () {
    testWidgets('offers the four topics and the practice run', (tester) async {
      useCheapPhone(tester);
      await tester.pumpWidget(harness(const HelpScreen()));
      await tester.pumpAndSettle();

      for (final topic in HelpTopic.values) {
        expect(find.text(topic.title(l10n)), findsOneWidget);
      }

      await tester.drag(find.byType(ListView), const Offset(0, -320));
      await tester.pumpAndSettle();
      expect(find.text(l10n.helpPractice), findsOneWidget);
    });

    testWidgets('every topic can be heard without opening it', (tester) async {
      useCheapPhone(tester);
      await tester.pumpWidget(harness(const HelpScreen()));
      await tester.pumpAndSettle();

      expect(
        find.byIcon(Icons.volume_up),
        findsAtLeast(HelpTopic.values.length),
      );
    });
  });

  group('the topics themselves', () {
    test('each has a title, a reason, and steps in every language', () {
      for (final locale in AppLocalizations.supportedLocales.map(
        (l) => l.languageCode,
      )) {
        final strings = lookupAppLocalizations(Locale(locale));
        for (final topic in HelpTopic.values) {
          expect(topic.title(strings), isNotEmpty, reason: '$topic in $locale');
          expect(topic.body(strings), isNotEmpty, reason: '$topic in $locale');
          expect(topic.steps(strings).length, greaterThanOrEqualTo(4));
          for (final step in topic.steps(strings)) {
            expect(step, isNotEmpty);
          }
        }
      }
    });

    testWidgets('a topic shows its steps, and no promise of a video', (
      tester,
    ) async {
      useCheapPhone(tester);
      await tester.pumpWidget(
        harness(const HelpTopicScreen(topic: HelpTopic.photos)),
      );
      await tester.pumpAndSettle();

      expect(find.text(l10n.helpTopicPhotosStep1), findsOneWidget);

      for (var i = 0; i < 4; i++) {
        await tester.drag(find.byType(ListView), const Offset(0, -300));
        await tester.pumpAndSettle();
      }
      expect(find.text(l10n.helpVideoComing), findsNothing);
    });
  });

  group('9.3 the FAQ', () {
    testWidgets('opens one answer at a time', (tester) async {
      useCheapPhone(tester);
      await tester.pumpWidget(harness(const FaqScreen()));
      await tester.pumpAndSettle();

      expect(find.text(l10n.faqQ1), findsOneWidget);
      expect(find.text(l10n.faqA1), findsNothing);

      await tester.tap(find.text(l10n.faqQ1));
      await tester.pumpAndSettle();
      expect(find.text(l10n.faqA1), findsOneWidget);

      await tester.tap(find.text(l10n.faqQ2));
      await tester.pumpAndSettle();
      expect(find.text(l10n.faqA2), findsOneWidget);
      expect(find.text(l10n.faqA1), findsNothing);
    });

    test('every question has an answer in every language', () {
      for (final locale in AppLocalizations.supportedLocales.map(
        (l) => l.languageCode,
      )) {
        final strings = lookupAppLocalizations(Locale(locale));
        final entries = faqs(strings);
        expect(entries.length, 7);
        for (final entry in entries) {
          expect(entry.question, isNotEmpty);
          expect(entry.answer, isNotEmpty);
        }
      }
    });
  });

  group('9.4 about', () {
    testWidgets('leads with the mission and names the hackathon', (
      tester,
    ) async {
      useCheapPhone(tester);
      await tester.pumpWidget(harness(const AboutScreen(version: '1.0.0 (1)')));
      await tester.pumpAndSettle();

      expect(find.text(l10n.aboutMission), findsOneWidget);

      for (var i = 0; i < 5; i++) {
        await tester.drag(find.byType(ListView), const Offset(0, -300));
        await tester.pumpAndSettle();
      }
      expect(find.text(l10n.aboutSihTitle), findsOneWidget);
    });

    testWidgets('ends with the terms, the licences and the version, and no '
        'update check that can only say yes', (tester) async {
      useCheapPhone(tester);
      await tester.pumpWidget(harness(const AboutScreen(version: '1.0.0 (1)')));
      await tester.pumpAndSettle();

      final list = find.byType(Scrollable).first;
      await tester.scrollUntilVisible(
        find.text(l10n.versionNumber('1.0.0 (1)')),
        300,
        scrollable: list,
      );
      expect(find.text(l10n.versionLicences), findsOneWidget);
      expect(find.text(l10n.helpTermsEntry), findsOneWidget);
      expect(find.text(l10n.versionCheck), findsNothing);
    });
  });

  group('9.5 support', () {
    testWidgets('offers a call and WhatsApp, and never an email form', (
      tester,
    ) async {
      useCheapPhone(tester);
      await tester.pumpWidget(harness(const SupportScreen()));
      await tester.pumpAndSettle();

      expect(find.text(l10n.supportCall), findsOneWidget);
      expect(find.text(l10n.supportWhatsApp), findsOneWidget);
      expect(find.byType(TextField), findsNothing);
      expect(find.text(Support.phone), findsOneWidget);
    });
  });

  group('9.6 terms', () {
    testWidgets('puts the plain summary first', (tester) async {
      useCheapPhone(tester);
      await tester.pumpWidget(harness(const TermsScreen()));
      await tester.pumpAndSettle();

      expect(find.text(l10n.termsSummaryTitle), findsOneWidget);
      expect(find.text(l10n.termsSummary1), findsOneWidget);
    });
  });
}
