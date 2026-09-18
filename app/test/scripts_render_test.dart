import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kirtikar/app.dart';
import 'package:kirtikar/core/dev/demo_listings.dart';
import 'package:kirtikar/core/routing/app_routes.dart';
import 'package:kirtikar/core/theme/app_theme.dart';
import 'package:kirtikar/data/models/app_language.dart';
import 'package:kirtikar/data/models/capture_item.dart';
import 'package:kirtikar/data/models/fact_sheet.dart';
import 'package:kirtikar/data/models/listing.dart';
import 'package:kirtikar/data/models/listing_status.dart';
import 'package:kirtikar/data/models/sale.dart';
import 'package:kirtikar/data/models/suggestion.dart';
import 'package:kirtikar/data/remote/api_client.dart';
import 'package:kirtikar/data/remote/upload_failure.dart';
import 'package:kirtikar/data/repositories/seller_repository.dart';
import 'package:kirtikar/features/help/help_content.dart';
import 'package:kirtikar/l10n/app_localizations.dart';
import 'package:kirtikar/services/speech_service.dart';
import 'package:kirtikar/state/app_state.dart';
import 'package:kirtikar/state/catalog_controller.dart';
import 'package:kirtikar/state/providers.dart';
import 'package:kirtikar/state/queue_controller.dart';
import 'package:kirtikar/state/review_controller.dart';
import 'package:kirtikar/state/sales_controller.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _Api implements ApiClient {
  bool empty = false;

  @override
  Future<List<Listing>> listings() async =>
      empty ? const [] : [...DemoListings.listings, ready];

  @override
  Future<Listing> listing(String id) async =>
      (await listings()).firstWhere((l) => l.id == id);

  @override
  Future<List<Sale>> sales() async => empty ? const [] : [sale];

  @override
  noSuchMethod(Invocation invocation) => throw UnimplementedError();
}

const ready = Listing(
  id: 'ready-1',
  status: ListingStatus.ready,
  title: 'Blue pottery water jug',
  description: 'A hand-thrown jug, glazed blue, holds two litres of water.',
  imageUrls: ['assets/images/crafts/pottery.jpg'],
  previewUrl: 'https://kirtikar.example/p/ready-1',
  factSheet: FactSheet(
    material: 'Clay',
    colour: 'Blue',
    quantity: 2,
    hoursToMake: 6,
    materialCostInPaise: 12000,
    priceInPaise: 45000,
  ),
  suggestions: [
    Suggestion(
      id: 'summer',
      spokenPrompt: 'Shall I add: keeps water cool in summer?',
      textIfAccepted: 'Keeps water cool in summer.',
    ),
  ],
);

final sale = Sale(
  id: 'sale-1',
  listingId: 'demo-1',
  listingTitle: 'Blue pottery water jug',
  quantity: 2,
  amountInPaise: 90000,
  placedAt: DateTime(2026, 9, 12),
  packByDate: DateTime(2026, 9, 16),
  buyerArea: 'Jaipur',
);

final stuck = CaptureItem(
  id: 'capture-1',
  photoPaths: const ['/nowhere/capture-1-1.jpg', '/nowhere/capture-1-2.jpg'],
  voiceNotePath: '/nowhere/capture-1.m4a',
  createdAt: DateTime(2026, 9, 12, 10, 30),
  attempts: 2,
  lastError: UploadFailure.network.id,
);

const _bundled = {
  'NotoSansDevanagari': 'assets/fonts/NotoSansDevanagari-VF.ttf',
  'NotoSansBengali': 'assets/fonts/NotoSansBengali-VF.ttf',
  'NotoSansGujarati': 'assets/fonts/NotoSansGujarati-VF.ttf',
  'NotoSansKannada': 'assets/fonts/NotoSansKannada-VF.ttf',
  'NotoSansMalayalam': 'assets/fonts/NotoSansMalayalam-VF.ttf',
  'NotoSansOriya': 'assets/fonts/NotoSansOriya-VF.ttf',
  'NotoSansGurmukhi': 'assets/fonts/NotoSansGurmukhi-VF.ttf',
  'NotoSansTamil': 'assets/fonts/NotoSansTamil-VF.ttf',
  'NotoSansTelugu': 'assets/fonts/NotoSansTelugu-VF.ttf',
};

Future<void> _loadFonts() async {
  for (final entry in _bundled.entries) {
    await (FontLoader(entry.key)..addFont(rootBundle.load(entry.value))).load();
  }

  final sdk = Platform.resolvedExecutable.split('/bin/cache/').first;
  final icons = File(
    '$sdk/bin/cache/artifacts/material_fonts/'
    'MaterialIcons-Regular.otf',
  );
  if (icons.existsSync()) {
    final bytes = icons.readAsBytesSync();
    await (FontLoader(
      'MaterialIcons',
    )..addFont(Future.value(ByteData.sublistView(bytes)))).load();
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final shots = Platform.environment['KIRTIKAR_SHOTS'];

  setUpAll(_loadFonts);

  test('every language is drawn with a bundled face for its script', () {
    for (final language in AppLanguage.supported) {
      expect(
        _bundled,
        contains(language.fontFamily),
        reason: '${language.code} names a font pubspec.yaml does not ship',
      );
    }
    final pubspec = File('pubspec.yaml').readAsStringSync();
    for (final entry in _bundled.entries) {
      expect(pubspec, contains('family: ${entry.key}'));
      expect(pubspec, contains('asset: ${entry.value}'));
      expect(File(entry.value).existsSync(), isTrue, reason: entry.value);
    }
  });

  for (final language in AppLanguage.supported) {
    for (final scale in const [1.0, 2.0]) {
      final name = '${language.code}_${scale == 1.0 ? '1x' : '2x'}';
      testWidgets('$name: no screen overflows, truncates, splits or clips', (
        tester,
      ) async {
        SharedPreferences.setMockInitialValues({});
        tester.view.physicalSize = const Size(720, 1280);
        tester.view.devicePixelRatio = 2.0;
        tester.platformDispatcher.textScaleFactorTestValue = scale;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

        final problems = <String>{};
        var where = 'startup';
        final original = FlutterError.onError;
        FlutterError.onError = (details) {
          final first = details.exceptionAsString().split('\n').first;
          problems.add('$where  OVERFLOW  $first');
        };

        try {
          await _walk(
            tester,
            language,
            name,
            shots,
            at: (label) => where = label,
            inspect: () => _inspect(tester, where, problems),
          );
        } finally {
          FlutterError.onError = original;
        }

        if (shots != null) {
          File('$shots/findings_$name.txt')
              .writeAsStringSync((problems.toList()..sort()).join('\n'));
        }
        expect(problems, isEmpty, reason: problems.join('\n'));
      }, timeout: const Timeout(Duration(minutes: 3)));
    }
  }
}

Future<void> _advance(WidgetTester tester, Duration total) async {
  const step = Duration(milliseconds: 100);
  for (var i = 0; i < total.inMilliseconds ~/ step.inMilliseconds; i++) {
    await tester.pump(step);
  }
}

Future<void> _walk(
  WidgetTester tester,
  AppLanguage language,
  String name,
  String? shots, {
  required void Function(String label) at,
  required void Function() inspect,
}) async {
  final navigatorKey = GlobalKey<NavigatorState>();
  final api = _Api();
  await tester.pumpWidget(
    MultiProvider(
      providers: appProviders(
        sellers: SellerRepository(),
        speech: SpeechService(),
        api: api,
        navigatorKey: navigatorKey,
      ),
      child: const KirtikarApp(),
    ),
  );
  await _advance(tester, const Duration(seconds: 5));

  final context = tester.element(find.byType(MaterialApp));
  Future<void> settle(List<Future<void>> work) async {
    var settled = false;
    Future.wait(work).whenComplete(() => settled = true);
    for (var i = 0; i < 100 && !settled; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
    await _advance(tester, const Duration(seconds: 1));
  }

  await settle([
    context.read<AppState>().setLanguage(language),
    context.read<CatalogController>().refresh(),
    context.read<SalesController>().load(),
  ]);

  final l10n = lookupAppLocalizations(language.locale);

  Future<void> capture(String label) async {
    at(label);
    await _pages(
      tester,
      shots == null ? null : '$shots/${name}_$label',
      inspect,
    );
  }

  Future<void> open(String label, String route, [Object? arguments]) async {
    at(label);
    final navigator = navigatorKey.currentState!;
    navigator.popUntil((route) => route.isFirst);
    await _advance(tester, const Duration(milliseconds: 600));
    at(label);
    navigator.pushNamed(route, arguments: arguments);
    await _advance(tester, const Duration(milliseconds: 1500));
    await capture(label);
  }

  Future<void> press(Finder finder, String label) async {
    if (finder.evaluate().isEmpty) return;
    at(label);
    await tester.ensureVisible(finder.first);
    await tester.pump();
    await tester.tap(finder.first, warnIfMissed: false);
    await _advance(tester, const Duration(milliseconds: 1200));
    await capture(label);
  }

  const plain = {
    'language': AppRoutes.language,
    'welcome': AppRoutes.welcome,
    'terms_agree': AppRoutes.termsAgree,
    'permissions': AppRoutes.permissions,
    'phone': AppRoutes.phone,
    'otp': AppRoutes.otp,
    'profile_setup': AppRoutes.profile,
    'ondc_link': AppRoutes.ondc,
    'practice': AppRoutes.practice,
    'queue': AppRoutes.queue,
    'earnings': AppRoutes.earnings,
    'edit_profile': AppRoutes.editProfile,
    'craft_story': AppRoutes.craftStory,
    'change_language': AppRoutes.changeLanguage,
    'change_phone': AppRoutes.changePhone,
    'ondc_account': AppRoutes.ondcAccount,
    'notifications': AppRoutes.notifications,
    'voice_settings': AppRoutes.voiceSettings,
    'privacy': AppRoutes.privacy,
    'storage': AppRoutes.storage,
    'account': AppRoutes.account,
    'help': AppRoutes.help,
    'faq': AppRoutes.faq,
    'about': AppRoutes.about,
    'support': AppRoutes.support,
    'terms': AppRoutes.terms,
    'permission_recovery': AppRoutes.permissionRecovery,
    'force_update': AppRoutes.forceUpdate,
  };
  for (final entry in plain.entries) {
    await open(entry.key, entry.value);
  }

  for (final topic in HelpTopic.values) {
    await open('help_${topic.name}', AppRoutes.helpTopic, topic.name);
  }

  await open('welcome', AppRoutes.welcome);
  await press(find.text(l10n.actionNext), 'welcome_card2');
  await press(find.text(l10n.actionNext), 'welcome_card3');

  await open('account', AppRoutes.account);
  await press(find.text(l10n.accountSignOut), 'dialog_sign_out');
  await open('account', AppRoutes.account);
  await press(find.text(l10n.accountDelete), 'dialog_delete_account');
  await open('privacy', AppRoutes.privacy);
  await press(find.text(l10n.privacyWithdrawConfirm), 'dialog_withdraw');
  await open('ondc_link', AppRoutes.ondc);
  await press(find.text(l10n.ondcNoAccount), 'dialog_ondc_skip');

  for (final stage in ReviewStage.values) {
    await open('review_${stage.name}', AppRoutes.review, (ready, stage));
  }
  await open('review_readBack', AppRoutes.review, (
    ready,
    ReviewStage.readBack,
  ));
  await press(find.text(l10n.notSaid), 'sheet_correction');
  await open('review_readBack', AppRoutes.review, (
    ready,
    ReviewStage.readBack,
  ));
  await press(find.byIcon(Icons.close), 'dialog_leave_review');

  for (final listing in DemoListings.listings) {
    await open('listing_${listing.id}', AppRoutes.listing, listing);
  }
  final live = DemoListings.listings.first;
  await open('listing_${live.id}', AppRoutes.listing, live);
  await press(find.text(l10n.listingUnpublish), 'dialog_unpublish');
  await open('listing_${live.id}', AppRoutes.listing, live);
  await press(find.text(l10n.listingDuplicate), 'dialog_duplicate');
  await open('listing_${live.id}', AppRoutes.listing, live);
  await press(find.text(l10n.listingsQuickStock), 'sheet_quick_stock');

  await open('sale', AppRoutes.sale, sale.id);
  await open('packing', AppRoutes.packing, sale.id);

  context.read<QueueController>().add(stuck);
  await _advance(tester, const Duration(milliseconds: 500));
  await open('queue_with_item', AppRoutes.queue);
  await open('queue_item', AppRoutes.queueItem, stuck.id);
  await press(find.text(l10n.queueDelete), 'dialog_queue_delete');

  await open('capture', AppRoutes.capture);
  await press(find.byIcon(Icons.close), 'dialog_leave_capture');

  Future<void> shell(String suffix) async {
    await open('home$suffix', AppRoutes.home);
    Future<void> tapText(String text) async {
      final target = find.text(text);
      if (target.evaluate().isEmpty) return;
      await tester.tap(target.first, warnIfMissed: false);
      await _advance(tester, const Duration(milliseconds: 800));
    }

    await tapText(l10n.navListings);
    for (final (label, text) in [
      ('products_in_progress', l10n.productsInProgress),
      ('products_listed', l10n.productsListed),
      ('products_sold', l10n.productsSold),
    ]) {
      await tapText(text);
      await capture('$label$suffix');
    }
    await tapText(l10n.navProfile);
    await capture('profile_tab$suffix');
  }

  await shell('');

  api.empty = true;
  await settle([
    context.read<CatalogController>().refresh(),
    context.read<SalesController>().load(),
  ]);
  await shell('_empty');

  navigatorKey.currentState!.popUntil((route) => route.isFirst);
  await tester.pumpWidget(const SizedBox.shrink());
  await _advance(tester, const Duration(seconds: 5));
}

Future<void> _pages(
  WidgetTester tester,
  String? path,
  void Function() inspect,
) async {
  inspect();
  await _shoot(tester, path == null ? null : '${path}_p0.png');

  final scrollables = tester
      .stateList<ScrollableState>(find.byType(Scrollable))
      .where(
        (s) =>
            s.position.axis == Axis.vertical &&
            s.position.hasContentDimensions &&
            s.position.maxScrollExtent > 0,
      )
      .toList();
  if (scrollables.isEmpty) return;
  scrollables.sort(
    (a, b) =>
        b.position.viewportDimension.compareTo(a.position.viewportDimension),
  );
  final position = scrollables.first.position;

  for (var page = 1; page <= 6; page++) {
    if (position.pixels >= position.maxScrollExtent) break;
    position.jumpTo(
      (position.pixels + position.viewportDimension * 0.8).clamp(
        0,
        position.maxScrollExtent,
      ),
    );
    await tester.pump(const Duration(milliseconds: 100));
    inspect();
    await _shoot(tester, path == null ? null : '${path}_p$page.png');
  }
}

void _inspect(WidgetTester tester, String where, Set<String> problems) {
  final screen = Offset.zero & tester.view.physicalSize;
  for (final element in find.byType(RichText).evaluate()) {
    final paragraph = element.renderObject;
    if (paragraph is! RenderParagraph || !paragraph.hasSize) continue;
    final bounds = MatrixUtils.transformRect(
      paragraph.getTransformTo(null),
      Offset.zero & paragraph.size,
    );
    if (!bounds.overlaps(screen)) continue;

    final text = paragraph.text.toPlainText(includeSemanticsLabels: false);
    if (text.trim().isEmpty) continue;
    if (_isIcon(paragraph.text)) continue;

    if (paragraph.didExceedMaxLines) {
      problems.add('$where  TRUNCATED  "$text"');
    }
    final split = _splitWord(paragraph, text);
    if (split != null) problems.add('$where  WORD SPLIT  "$split"  in "$text"');

    final clip = _clippedBy(paragraph, bounds);
    if (clip != null) problems.add('$where  CLIPPED  by $clip  "$text"');
    if (_cutByOwnBox(paragraph)) {
      problems.add('$where  CLIPPED  by its own box  "$text"');
    }

    final fontSize = paragraph.text.style?.fontSize;
    if (fontSize != null) {
      final drawn = paragraph.textScaler.scale(fontSize);
      if (drawn < AppTheme.minTextSize - 0.05) {
        problems.add(
          '$where  TOO SMALL  ${drawn.toStringAsFixed(1)}sp  "$text"',
        );
      }
    }
  }
}

bool _isIcon(InlineSpan span) =>
    span is TextSpan && (span.style?.fontFamily ?? '') == 'MaterialIcons';

bool _cutByOwnBox(RenderParagraph paragraph) {
  var hasPlaceholder = false;
  paragraph.text.visitChildren((span) {
    if (span is PlaceholderSpan) hasPlaceholder = true;
    return !hasPlaceholder;
  });
  if (hasPlaceholder) return false;

  final painter = TextPainter(
    text: paragraph.text,
    textDirection: paragraph.textDirection,
    textAlign: paragraph.textAlign,
    textScaler: paragraph.textScaler,
    maxLines: paragraph.maxLines,
    ellipsis: paragraph.overflow == TextOverflow.ellipsis ? '…' : null,
    locale: paragraph.locale,
    strutStyle: paragraph.strutStyle,
    textWidthBasis: paragraph.textWidthBasis,
    textHeightBehavior: paragraph.textHeightBehavior,
  );
  try {
    final wraps =
        paragraph.softWrap || paragraph.overflow == TextOverflow.ellipsis;
    painter.layout(
      maxWidth: wraps ? paragraph.constraints.maxWidth : double.infinity,
    );
    return painter.height > paragraph.size.height + 0.5 ||
        (!wraps && painter.width > paragraph.size.width + 0.5);
  } finally {
    painter.dispose();
  }
}

String? _clippedBy(RenderParagraph paragraph, Rect bounds) {
  RenderObject? node = paragraph.parent;
  RenderObject last = paragraph;
  while (node != null && node is! RenderAbstractViewport) {
    last = node;
    final clips = switch (node) {
      RenderClipRect() ||
      RenderClipRRect() ||
      RenderClipOval() ||
      RenderClipPath() => true,
      RenderPhysicalModel(:final clipBehavior) ||
      RenderPhysicalShape(:final clipBehavior) => clipBehavior != Clip.none,
      _ => false,
    };
    if (clips && node is RenderBox && node.hasSize) {
      final box = MatrixUtils.transformRect(
        node.getTransformTo(null),
        Offset.zero & node.size,
      );
      if (bounds.left < box.left - 1 ||
          bounds.top < box.top - 1 ||
          bounds.right > box.right + 1 ||
          bounds.bottom > box.bottom + 1) {
        return '${node.runtimeType}';
      }
    }
    node = node.parent;
  }
  if (node == null && last is RenderView) {
    final screen = last.paintBounds;
    if (bounds.left < screen.left - 1 ||
        bounds.top < screen.top - 1 ||
        bounds.right > screen.right + 1 ||
        bounds.bottom > screen.bottom + 1) {
      return 'the edge of the screen';
    }
  }
  return null;
}

String? _splitWord(RenderParagraph paragraph, String text) {
  var hasPlaceholder = false;
  paragraph.text.visitChildren((span) {
    if (span is PlaceholderSpan) hasPlaceholder = true;
    return !hasPlaceholder;
  });
  if (hasPlaceholder) return null;

  final painter = TextPainter(
    text: paragraph.text,
    textDirection: paragraph.textDirection,
    textAlign: paragraph.textAlign,
    textScaler: paragraph.textScaler,
    maxLines: paragraph.maxLines,
    ellipsis: paragraph.overflow == TextOverflow.ellipsis ? '…' : null,
    locale: paragraph.locale,
    strutStyle: paragraph.strutStyle,
    textWidthBasis: paragraph.textWidthBasis,
    textHeightBehavior: paragraph.textHeightBehavior,
  );
  try {
    painter.layout(
      maxWidth:
          paragraph.softWrap || paragraph.overflow == TextOverflow.ellipsis
          ? paragraph.constraints.maxWidth
          : double.infinity,
    );
    final lines = painter.computeLineMetrics();
    for (var i = 1; i < lines.length; i++) {
      final line = lines[i];
      final start = painter
          .getPositionForOffset(Offset(line.left + 0.5, line.baseline - 1))
          .offset;
      if (start <= 0 || start >= text.length) continue;
      if (_inWord(text[start - 1]) && _inWord(text[start])) {
        final from = (start - 8).clamp(0, text.length);
        final to = (start + 8).clamp(0, text.length);
        return '${text.substring(from, start)}|${text.substring(start, to)}';
      }
    }
    return null;
  } finally {
    painter.dispose();
  }
}

bool _inWord(String character) =>
    character.trim().isNotEmpty && !'-/–—,.:;!?()[]{}|·…​'.contains(character);

Future<void> _shoot(WidgetTester tester, String? path) async {
  if (path == null) return;
  RenderObject target = tester.renderObject(find.byType(MaterialApp));
  while (!target.isRepaintBoundary) {
    target = target.parent!;
  }
  final layer = target.debugLayer! as OffsetLayer;
  final bounds = target.paintBounds;
  await tester.runAsync(() async {
    final image = await layer.toImage(bounds);
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    image.dispose();
    File(path).writeAsBytesSync(bytes!.buffer.asUint8List());
  });
}
