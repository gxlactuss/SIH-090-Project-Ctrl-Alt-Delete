import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:kaarigar/core/theme/app_theme.dart';
import 'package:kaarigar/data/local/capture_dao.dart';
import 'package:kaarigar/data/models/capture_item.dart';
import 'package:kaarigar/features/capture/capture_screen.dart';
import 'package:kaarigar/core/utils/photo_edit.dart';
import 'package:kaarigar/features/capture/widgets/crop_geometry.dart';
import 'package:kaarigar/l10n/app_localizations.dart';
import 'package:kaarigar/services/camera_service.dart';
import 'package:kaarigar/core/utils/image_quality.dart';
import 'package:kaarigar/services/connectivity_service.dart';
import 'package:kaarigar/services/framing_service.dart';
import 'package:kaarigar/services/permission_service.dart';
import 'package:kaarigar/services/player_service.dart';
import 'package:kaarigar/services/recorder_service.dart';
import 'package:kaarigar/services/speech_service.dart';
import 'package:kaarigar/state/queue_controller.dart';
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
  int picks = 0;

  bool galleryCancels = false;

  final Set<int> blankShots = {};

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
    final shot = shots++;
    return _photo('shot', shot, blank: blankShots.contains(shot));
  }

  @override
  Future<File?> pickFromGallery() async {
    picks++;
    if (galleryCancels) return null;
    return _photo('gallery', picks);
  }

  File _photo(String name, int seed, {bool blank = false}) {
    final random = Random(seed);
    final image = img.Image(width: 160, height: 120);
    for (var y = 0; y < image.height; y++) {
      for (var x = 0; x < image.width; x++) {
        final value = blank ? 150 : 100 + random.nextInt(90);
        image.setPixelRgb(x, y, value, value, value);
      }
    }
    return File('${directory.path}/${name}_$seed.jpg')
      ..writeAsBytesSync(img.encodeJpg(image, quality: 92));
  }
}

class _FakeRecorder extends RecorderService {
  String? started;
  bool recording = false;

  @override
  bool get isRecording => recording;

  @override
  Duration get elapsed => const Duration(seconds: 20);

  @override
  Future<bool> start(String path, {Duration? maxDuration}) async {
    started = path;
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
  ImageIssue? next;

  @override
  Future<ImageIssue?> check(File photo, int width, int height) async => next;

  @override
  Future<void> dispose() async {}
}

class _FakePlayer extends PlayerService {
  @override
  Future<void> stop() async {}
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory root;
  late _FakeDao dao;
  late _FakeCamera camera;
  late _FakeFraming framing;
  late QueueController queue;

  setUp(() {
    root = Directory.systemTemp.createTempSync('kaarigar_capture_screen');

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('plugins.flutter.io/path_provider'),
      (call) async =>
          call.method == 'getApplicationDocumentsDirectory' ? root.path : null,
    );
    dao = _FakeDao();
    camera = _FakeCamera(root);
    framing = _FakeFraming();
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

  void useCheapPhone(WidgetTester tester) {
    tester.view.physicalSize = const Size(720, 1280);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  }

  Widget harness() {
    return MultiProvider(
      providers: [
        Provider<PermissionService>(create: (_) => const PermissionService()),
        ChangeNotifierProvider<SpeechService>(create: (_) => SpeechService()),
        ChangeNotifierProvider<ConnectivityService>(
          create: (_) => ConnectivityService(),
        ),
        ChangeNotifierProvider<QueueController>.value(value: queue),
      ],
      child: MaterialApp(
        theme: AppTheme.light,
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: CaptureScreen(
          dao: dao,
          camera: camera,
          recorder: _FakeRecorder(),
          player: _FakePlayer(),
          framing: framing,
        ),
      ),
    );
  }

  final l10n = lookupAppLocalizations(const Locale('en'));

  Future<void> advance(WidgetTester tester) async {
    for (var i = 0; i < 25; i++) {
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 20)),
      );
      await tester.pump(const Duration(milliseconds: 50));
    }
  }

  testWidgets('walks 3.1 to 3.7 and queues the capture', (tester) async {
    useCheapPhone(tester);
    await tester.pumpWidget(harness());
    await advance(tester);

    for (var i = 0; i < 3; i++) {
      expect(find.text(l10n.captureTakePhoto), findsOneWidget);
      expect(
        find.text(l10n.capturePhotoStep(i + 1, 3)),
        findsNothing,
        reason: 'the step count lives in the overlay, not in the body text',
      );

      await tester.tap(find.text(l10n.captureTakePhoto));
      await advance(tester);
    }

    expect(find.text(l10n.photoSetTitle), findsOneWidget);
    expect(find.text(l10n.photoSetMain), findsOneWidget);
    await tester.tap(find.text(l10n.photoSetConfirm));
    await advance(tester);

    expect(find.text(l10n.voiceHoldToSpeak), findsOneWidget);
    final gesture =
        await tester.startGesture(tester.getCenter(find.text(l10n.voiceHoldToSpeak)));
    await advance(tester);
    await gesture.up();
    await advance(tester);

    expect(find.text(l10n.playbackPlay), findsOneWidget);
    expect(find.text(l10n.playbackAgain), findsOneWidget);
    final accept = find.text(l10n.playbackAccept);
    await tester.ensureVisible(accept);
    await tester.pump();
    await tester.tap(accept);
    await advance(tester);

    expect(find.text(l10n.savedTitle), findsOneWidget);
    expect(dao.saved.length, 1);
    expect(dao.saved.single.photoPaths.length, 3);
    expect(queue.pendingCount, 1);
  });

  testWidgets('a photo from the gallery is checked and kept like a shot',
      (tester) async {
    useCheapPhone(tester);
    await tester.pumpWidget(harness());
    await advance(tester);

    camera.galleryCancels = true;
    await tester.tap(find.text(l10n.captureFromGallery));
    await advance(tester);
    expect(camera.picks, 1);
    expect(find.text(l10n.capturePhotoWhole), findsOneWidget);

    camera.galleryCancels = false;
    await tester.tap(find.text(l10n.captureFromGallery));
    await advance(tester);

    expect(camera.shots, 0);
    expect(find.text(l10n.capturePhotoDetail), findsOneWidget);
  });

  testWidgets('a photo kept past a warning is flagged on the set review',
      (tester) async {
    useCheapPhone(tester);
    camera.blankShots.add(0);
    await tester.pumpWidget(harness());
    await advance(tester);

    await tester.tap(find.text(l10n.captureTakePhoto));
    await advance(tester);
    expect(find.text(l10n.qualityNoSubject), findsOneWidget);
    await tester.tap(find.text(l10n.qualityKeepAnyway));
    await advance(tester);

    for (var i = 1; i < 3; i++) {
      await tester.tap(find.text(l10n.captureTakePhoto));
      await advance(tester);
    }

    expect(find.text(l10n.photoSetTitle), findsOneWidget);
    expect(find.byIcon(Icons.warning_rounded), findsOneWidget);
    expect(find.text(l10n.photoIssueNoSubject), findsOneWidget);
  });

  testWidgets('a photo with the product off the edge says so, and is flagged',
      (tester) async {
    useCheapPhone(tester);
    await tester.pumpWidget(harness());
    await advance(tester);

    framing.next = ImageIssue.outOfFrame;
    await tester.tap(find.text(l10n.captureTakePhoto));
    await advance(tester);
    expect(find.text(l10n.qualityOutOfFrame), findsOneWidget);
    await tester.tap(find.text(l10n.qualityKeepAnyway));
    await advance(tester);

    framing.next = null;
    for (var i = 1; i < 3; i++) {
      await tester.tap(find.text(l10n.captureTakePhoto));
      await advance(tester);
    }

    expect(find.byIcon(Icons.warning_rounded), findsOneWidget);
    expect(find.text(l10n.photoIssueOutOfFrame), findsOneWidget);
  });

  testWidgets('leaving before saving asks first, and says what it costs',
      (tester) async {
    useCheapPhone(tester);
    await tester.pumpWidget(harness());
    await advance(tester);

    await tester.tap(find.byIcon(Icons.close));
    await advance(tester);

    expect(find.text(l10n.captureLeaveTitle), findsOneWidget);
    expect(find.text(l10n.captureLeaveBody), findsOneWidget);

    await tester.tap(find.text(l10n.captureLeaveCancel));
    await advance(tester);
    expect(find.text(l10n.captureTakePhoto), findsOneWidget);
  });

  testWidgets('dragging a corner of the crop box saves a smaller square',
      (tester) async {
    useCheapPhone(tester);
    await tester.pumpWidget(harness());
    await advance(tester);

    for (var i = 0; i < 3; i++) {
      await tester.tap(find.text(l10n.captureTakePhoto));
      await advance(tester);
    }
    expect(find.text(l10n.photoSetTitle), findsOneWidget);

    final open = find.text(l10n.photoEditOpen).first;
    await tester.ensureVisible(open);
    await tester.pump();
    await tester.tap(open);
    await advance(tester);

    expect(find.text(l10n.photoEditTitle), findsOneWidget);
    final canvas = find.byKey(const Key('photo-edit-canvas'));
    expect(canvas, findsOneWidget);

    final rect = tester.getRect(canvas);
    final box = CropGeometry(
      view: rect.size,
      imageWidth: 160,
      imageHeight: 120,
      edit: PhotoEdit.identity,
    ).box;
    final gesture = await tester.startGesture(rect.topLeft + box.topLeft);
    for (var i = 0; i < 10; i++) {
      await gesture.moveBy(Offset(box.width * 0.05, box.width * 0.05));
      await tester.pump(const Duration(milliseconds: 16));
    }
    await gesture.up();
    await tester.pump();

    await tester.tap(find.text(l10n.photoEditDone));
    await advance(tester);

    expect(find.text(l10n.photoSetTitle), findsOneWidget);
    final edited = root
        .listSync(recursive: true)
        .whereType<File>()
        .where((f) => f.path.contains('_edit_'))
        .toList();
    expect(edited, hasLength(1));
    final image = img.decodeJpg(edited.single.readAsBytesSync())!;
    expect(image.width, image.height);
    expect(image.width, inInclusiveRange(50, 70));
  });
}
