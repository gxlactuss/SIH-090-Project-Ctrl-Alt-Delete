import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:image/image.dart' as img;
import 'package:kirtikar/core/constants/app_constants.dart';
import 'package:kirtikar/core/theme/app_theme.dart';
import 'package:kirtikar/data/local/capture_dao.dart';
import 'package:kirtikar/data/models/app_language.dart';
import 'package:kirtikar/data/models/capture_item.dart';
import 'package:kirtikar/features/capture/capture_screen.dart';
import 'package:kirtikar/l10n/app_localizations.dart';
import 'package:kirtikar/services/camera_service.dart';
import 'package:kirtikar/services/connectivity_service.dart';
import 'package:kirtikar/services/framing_service.dart';
import 'package:kirtikar/core/utils/image_quality.dart';
import 'package:kirtikar/services/permission_service.dart';
import 'package:kirtikar/services/player_service.dart';
import 'package:kirtikar/services/recorder_service.dart';
import 'package:kirtikar/services/speech_service.dart';
import 'package:kirtikar/state/queue_controller.dart';
import 'package:provider/provider.dart';

class _FakeDao extends CaptureDao {
  final List<CaptureItem> saved = [];

  @override
  Future<void> insert(CaptureItem item) async => saved.add(item);

  @override
  Future<List<CaptureItem>> all() async => saved;

  @override
  Future<void> delete(String id) async => saved.removeWhere((i) => i.id == id);
}

class _FakeCamera extends CameraService {
  _FakeCamera(this.directory);

  final Directory directory;
  int shots = 0;

  @override
  bool get isReady => true;

  @override
  bool get hasFailed => false;

  @override
  bool get hasTorch => false;

  @override
  Future<void> start() async {}

  @override
  Future<void> stop() async {}

  @override
  Future<File?> takePicture() async {
    final seed = shots++;
    final random = Random(seed);
    final image = img.Image(width: 160, height: 120);
    for (var y = 0; y < image.height; y++) {
      for (var x = 0; x < image.width; x++) {
        final value = 100 + random.nextInt(90);
        image.setPixelRgb(x, y, value, value, value);
      }
    }
    return File('${directory.path}/shot_$seed.jpg')
      ..writeAsBytesSync(img.encodeJpg(image, quality: 92));
  }
}

class _FakeRecorder extends RecorderService {
  String? started;
  bool recording = false;
  Duration? cap;

  @override
  bool get isRecording => recording;

  @override
  Duration get elapsed => const Duration(seconds: 12);

  @override
  Future<bool> start(String path, {Duration? maxDuration}) async {
    started = path;
    cap = maxDuration;
    recording = true;
    File(path).writeAsBytesSync(Uint8List.fromList(List.filled(64, 1)));
    notifyListeners();
    return true;
  }

  @override
  Future<String?> stop() async {
    recording = false;
    notifyListeners();
    return started;
  }
}

class _FakeFraming extends FramingService {
  @override
  Future<ImageIssue?> check(File photo, int width, int height) async => null;

  @override
  Future<void> dispose() async {}
}

class _FakePlayer extends PlayerService {
  @override
  Future<void> stop() async {}
}

class _SilentTts implements FlutterTts {
  @override
  noSuchMethod(Invocation invocation) => Future<dynamic>.value(1);
}

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
    '$sdk/bin/cache/artifacts/material_fonts/MaterialIcons-Regular.otf',
  );
  if (icons.existsSync()) {
    final bytes = icons.readAsBytesSync();
    await (FontLoader(
      'MaterialIcons',
    )..addFont(Future.value(ByteData.sublistView(bytes)))).load();
  }
}

List<String> _clipped(WidgetTester tester) {
  final problems = <String>[];
  void visit(RenderObject node) {
    if (node is RenderBox && node.hasSize) {
      final parent = node.parent;
      if (parent is RenderBox && parent.hasSize) {
        final offset = node.localToGlobal(Offset.zero, ancestor: parent);
        final overshootX = offset.dx + node.size.width - parent.size.width;
        final overshootY = offset.dy + node.size.height - parent.size.height;
        if (overshootX > 0.5 || overshootY > 0.5) {
          if (parent is RenderClipRect ||
              parent is RenderClipRRect ||
              parent is RenderClipPath) {
            problems.add(
              '${node.runtimeType} is clipped by ${parent.runtimeType} '
              '(${overshootX.toStringAsFixed(1)} x '
              '${overshootY.toStringAsFixed(1)} beyond)',
            );
          }
        }
      }
    }
    node.visitChildren(visit);
  }

  tester.binding.renderViews.forEach(visit);
  return problems;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(_loadFonts);

  late Directory root;
  late _FakeDao dao;
  late _FakeCamera camera;
  late _FakeRecorder recorder;
  late QueueController queue;

  setUp(() {
    root = Directory.systemTemp.createTempSync('kirtikar_voice_guidance');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('plugins.flutter.io/path_provider'),
          (call) async => call.method == 'getApplicationDocumentsDirectory'
              ? root.path
              : null,
        );
    dao = _FakeDao();
    camera = _FakeCamera(root);
    recorder = _FakeRecorder();
    queue = QueueController(dao: dao);
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('plugins.flutter.io/path_provider'),
          null,
        );
    if (root.existsSync()) root.deleteSync(recursive: true);
  });

  Widget harness(Locale locale) {
    return MultiProvider(
      providers: [
        Provider<PermissionService>(create: (_) => const PermissionService()),
        ChangeNotifierProvider<SpeechService>(
          create: (_) => SpeechService(tts: _SilentTts()),
        ),
        ChangeNotifierProvider<ConnectivityService>(
          create: (_) => ConnectivityService(),
        ),
        ChangeNotifierProvider<QueueController>.value(value: queue),
      ],
      child: MaterialApp(
        theme: AppTheme.light,
        locale: locale,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: CaptureScreen(
          dao: dao,
          camera: camera,
          recorder: recorder,
          player: _FakePlayer(),
          framing: _FakeFraming(),
        ),
      ),
    );
  }

  Future<void> advance(WidgetTester tester) async {
    for (var i = 0; i < 25; i++) {
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 20)),
      );
      await tester.pump(const Duration(milliseconds: 50));
    }
  }

  Future<void> reachVoiceStep(
    WidgetTester tester,
    AppLocalizations l10n,
  ) async {
    await tester.pumpWidget(harness(Locale(l10n.localeName)));
    await advance(tester);

    for (var i = 0; i < AppConstants.photosPerListing; i++) {
      await tester.tap(find.text(l10n.captureTakePhoto));
      await advance(tester);
    }
    await tester.tap(find.text(l10n.photoSetConfirm));
    await advance(tester);
  }

  test('the spoken description is capped at thirty seconds', () {
    expect(AppConstants.maxVoiceNoteSeconds, 30);
    expect(
      AppConstants.minVoiceNoteSeconds,
      lessThan(AppConstants.maxVoiceNoteSeconds),
    );
  });

  testWidgets('the recorder is started with the thirty second cap', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(720, 1280);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final l10n = lookupAppLocalizations(const Locale('en'));
    await reachVoiceStep(tester, l10n);

    final gesture = await tester.startGesture(
      tester.getCenter(find.text(l10n.voiceHoldToSpeak)),
    );
    await advance(tester);
    await gesture.up();
    await advance(tester);

    expect(
      recorder.cap,
      const Duration(seconds: AppConstants.maxVoiceNoteSeconds),
      reason: 'the cap the artisan is shown must be the one enforced',
    );
  });

  testWidgets('the elapsed counter counts up to thirty', (tester) async {
    tester.view.physicalSize = const Size(720, 1280);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final l10n = lookupAppLocalizations(const Locale('en'));
    await reachVoiceStep(tester, l10n);

    expect(
      find.text(l10n.voiceElapsed(recorder.elapsed.inSeconds, 30)),
      findsOneWidget,
      reason: 'the counter must show thirty as the total, not sixty',
    );
  });

  testWidgets('a typed description is saved without any recording', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(720, 1280);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final l10n = lookupAppLocalizations(const Locale('en'));
    await reachVoiceStep(tester, l10n);

    await tester.tap(find.text(l10n.voiceTypeInstead));
    await advance(tester);

    expect(find.text(l10n.voiceGuideTitle), findsOneWidget);
    expect(find.text(l10n.voiceGuideMaterial), findsOneWidget);

    await tester.enterText(
      find.byType(TextField),
      'A clay water pot, nine inches tall, four hundred and fifty rupees.',
    );
    await advance(tester);

    final save = find.text(l10n.voiceTypeSave);
    await tester.ensureVisible(save);
    await tester.pump();
    await tester.tap(save);
    await advance(tester);

    expect(dao.saved, hasLength(1));
    expect(dao.saved.single.description, contains('clay water pot'));
    expect(
      dao.saved.single.voiceNotePath,
      isEmpty,
      reason: 'a typed description must not claim a recording',
    );
    expect(recorder.started, isNull);
  });

  testWidgets('switching back to speaking is still offered', (tester) async {
    tester.view.physicalSize = const Size(720, 1280);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final l10n = lookupAppLocalizations(const Locale('en'));
    await reachVoiceStep(tester, l10n);

    await tester.tap(find.text(l10n.voiceTypeInstead));
    await advance(tester);
    expect(find.text(l10n.voiceSpeakInstead), findsOneWidget);

    await tester.tap(find.text(l10n.voiceSpeakInstead));
    await advance(tester);
    expect(find.text(l10n.voiceHoldToSpeak), findsOneWidget);
  });

  for (final language in AppLanguage.supported) {
    {
      const scale = 2.0;
      final label = '${language.code}_2x';

      testWidgets('$label: the description prompts render intact', (
        tester,
      ) async {
        tester.view.physicalSize = const Size(720, 1280);
        tester.view.devicePixelRatio = 2.0;
        tester.platformDispatcher.textScaleFactorTestValue = scale;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

        final overflows = <String>[];
        final original = FlutterError.onError;
        FlutterError.onError = (details) {
          overflows.add(details.exceptionAsString().split('\n').first);
        };

        try {
          final l10n = lookupAppLocalizations(language.locale);
          await reachVoiceStep(tester, l10n);

          for (final prompt in [
            l10n.voiceGuideTitle,
            l10n.voiceGuideWhat,
            l10n.voiceGuideMaterial,
            l10n.voiceGuideSize,
            l10n.voiceGuideColour,
            l10n.voiceGuideTime,
            l10n.voiceGuideCraft,
            l10n.voiceGuidePrice,
          ]) {
            final finder = find.text(prompt);
            expect(
              finder,
              findsWidgets,
              reason: '$label is missing the prompt "$prompt"',
            );
            await tester.ensureVisible(finder.first);
            await tester.pump();
            expect(_clipped(tester), isEmpty, reason: '$label: $prompt');
          }

          await tester.tap(find.text(l10n.voiceTypeInstead));
          await advance(tester);
          final typed = find.text(l10n.voiceGuidePrice);
          expect(typed, findsWidgets, reason: '$label typing view');
          await tester.ensureVisible(typed.first);
          await tester.pump();
          expect(_clipped(tester), isEmpty, reason: '$label typing view');
        } finally {
          FlutterError.onError = original;
        }

        expect(overflows, isEmpty, reason: '$label: ${overflows.join('\n')}');
      }, timeout: const Timeout(Duration(minutes: 2)));
    }
  }
}
