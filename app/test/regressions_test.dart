import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kaarigar/data/local/capture_dao.dart';
import 'package:kaarigar/data/local/listing_dao.dart';
import 'package:kaarigar/data/models/capture_item.dart';
import 'package:kaarigar/data/models/fact_sheet.dart';
import 'package:kaarigar/data/models/listing.dart';
import 'package:kaarigar/data/models/listing_status.dart';
import 'package:kaarigar/data/models/sale.dart';
import 'package:kaarigar/data/models/seller_profile.dart';
import 'package:kaarigar/data/remote/api_client.dart';
import 'package:kaarigar/data/remote/upload_failure.dart';
import 'package:kaarigar/data/repositories/listing_repository.dart';
import 'package:kaarigar/features/review/review_screen.dart';
import 'package:kaarigar/features/review/widgets/review_scaffold.dart';
import 'package:kaarigar/l10n/app_localizations.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:kaarigar/services/recorder_service.dart';
import 'package:record/record.dart';
import 'package:kaarigar/services/speech_service.dart';
import 'package:kaarigar/state/catalog_controller.dart';
import 'package:kaarigar/state/queue_controller.dart';
import 'package:kaarigar/state/review_controller.dart';
import 'package:provider/provider.dart';

class _FakeApi implements ApiClient {
  _FakeApi([this.current]);

  Listing? current;
  int republishes = 0;

  @override
  Future<Listing> listing(String id) async => current!;

  @override
  Future<Listing> patchListing({
    required String listingId,
    required Map<String, Object?> changes,
  }) async => current!;

  @override
  Future<Listing> publish({
    required String listingId,
    required bool photoConsent,
    required bool storyConsent,
  }) async => current = current!.copyWith(status: ListingStatus.published);

  @override
  Future<Listing> republish(String listingId) async {
    republishes++;
    return current = current!.copyWith(status: ListingStatus.published);
  }

  @override
  noSuchMethod(Invocation invocation) => throw UnimplementedError();

  @override
  Future<SellerProfile> createProfile(SellerProfile draft) =>
      throw UnimplementedError();
  @override
  Future<List<Sale>> sales() => throw UnimplementedError();
}

class _FakeCaptureDao extends CaptureDao {
  @override
  Future<void> insert(CaptureItem item) async {}
  @override
  Future<List<CaptureItem>> all() async => [];
  @override
  Future<void> markUploaded(String id, {DateTime? at}) async {}
  @override
  Future<void> recordFailure(String id, String reason) async {}
  @override
  Future<void> clearFailure(String id) async {}
  @override
  Future<void> delete(String id) async {}
}

class _FakeListingDao implements ListingDao {
  final Map<String, Listing> rows = {};

  @override
  Future<void> upsert(Listing listing) async => rows[listing.id] = listing;
  @override
  Future<void> upsertAll(Iterable<Listing> listings) async {
    for (final listing in listings) {
      rows[listing.id] = listing;
    }
  }

  @override
  Future<List<Listing>> all() async => rows.values.toList();
  @override
  Future<Listing?> byId(String id) async => rows[id];
  @override
  Future<void> delete(String id) async => rows.remove(id);
  @override
  Future<void> clear() async => rows.clear();
  @override
  Future<int> count() async => rows.length;

  @override
  noSuchMethod(Invocation invocation) => throw UnimplementedError();
}

void main() {
  Listing seed({
    ListingStatus status = ListingStatus.ready,
    String id = 'l1',
  }) => Listing(
    id: id,
    status: status,
    title: 'Blue water jug',
    imageUrls: const ['a.jpg'],
    factSheet: const FactSheet(material: 'Clay', quantity: 1),
  );

  group('a duplicate keeps its template through the queue', () {
    CaptureItem duplicate() => CaptureItem(
      id: 'c1',
      photoPaths: const ['1.jpg', '2.jpg', '3.jpg'],
      voiceNotePath: '',
      createdAt: DateTime(2026, 3, 1),
      templateListingId: 'l0',
    );

    test('through a failure and a retry', () async {
      final queue = QueueController(dao: _FakeCaptureDao())..add(duplicate());

      queue.markFailed('c1', UploadFailure.network);
      expect(queue.byId('c1')!.templateListingId, 'l0');
      expect(queue.byId('c1')!.attempts, 1);

      await queue.clearFailure('c1');
      expect(queue.byId('c1')!.templateListingId, 'l0');
      expect(queue.byId('c1')!.lastError, isNull);

      expect(queue.nextToUpload!.templateListingId, 'l0');
    });

    test('through a successful upload', () {
      final queue = QueueController(dao: _FakeCaptureDao())..add(duplicate());

      queue.markUploaded('c1', at: DateTime(2026, 3, 2));

      final item = queue.byId('c1')!;
      expect(item.templateListingId, 'l0');
      expect(item.isPending, isFalse);
      expect(item.lastError, isNull);
    });

    test('a failure then a success leaves no stale error', () {
      final queue = QueueController(dao: _FakeCaptureDao())..add(duplicate());

      queue.markFailed('c1', UploadFailure.network);
      queue.markUploaded('c1');

      expect(queue.byId('c1')!.lastError, isNull);
      expect(queue.byId('c1')!.templateListingId, 'l0');
    });
  });

  group('upload progress stays off the queue notifier', () {
    test('a tick moves the bar without notifying the queue', () {
      final queue = QueueController(dao: _FakeCaptureDao())
        ..add(
          CaptureItem(
            id: 'c1',
            photoPaths: const ['1.jpg', '2.jpg', '3.jpg'],
            voiceNotePath: 'v.m4a',
            createdAt: DateTime(2026, 3, 1),
          ),
        )
        ..markUploading('c1');

      var notified = 0;
      queue.addListener(() => notified++);
      final ticks = <double>[];
      queue.progressListenable.addListener(
        () => ticks.add(queue.progressListenable.value),
      );

      queue
        ..updateProgress(0.25)
        ..updateProgress(0.5);

      expect(notified, 0);
      expect(ticks, [0.25, 0.5]);
      expect(queue.progress, 0.5);

      queue.markUploaded('c1');
      expect(notified, 1);
      expect(queue.progress, 0);
    });
  });

  group('the review flow tells the list what it did', () {
    Widget harness({
      required Listing listing,
      required _FakeApi api,
      required CatalogController catalog,
    }) {
      return MultiProvider(
        providers: [
          ChangeNotifierProvider<SpeechService>(create: (_) => SpeechService()),
          Provider<ListingRepository>(
            create: (_) => ListingRepository(api: api, dao: _FakeListingDao()),
          ),
          ChangeNotifierProvider<CatalogController>.value(value: catalog),
        ],
        child: MaterialApp(
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: ReviewScreen(listing: listing),
        ),
      );
    }

    testWidgets('publishing updates the listing behind the flow', (
      tester,
    ) async {
      final listing = seed();
      final api = _FakeApi(listing);
      final catalog = CatalogController(listings: [listing]);

      await tester.pumpWidget(
        harness(listing: listing, api: api, catalog: catalog),
      );
      await tester.pump();

      final review = tester
          .element(find.byType(ReviewScaffold))
          .read<ReviewController>();
      await review.publish(photoConsent: true, storyConsent: false);
      await tester.pump();

      expect(catalog.byId('l1')!.status, ListingStatus.published);
    });

    testWidgets('a listing the list had never seen is added, not lost', (
      tester,
    ) async {
      final listing = seed();
      final api = _FakeApi(listing);
      final catalog = CatalogController();

      await tester.pumpWidget(
        harness(listing: listing, api: api, catalog: catalog),
      );
      await tester.pump();

      final review = tester
          .element(find.byType(ReviewScaffold))
          .read<ReviewController>();
      await review.publish(photoConsent: true, storyConsent: true);
      await tester.pump();

      expect(catalog.listings, hasLength(1));
      expect(catalog.byId('l1')!.status, ListingStatus.published);
    });
  });

  group('publishing and republishing stay apart', () {
    test('walking the first-publish order never republishes', () async {
      final listing = seed();
      final api = _FakeApi(listing);
      final review = ReviewController(
        listings: ListingRepository(api: api, dao: _FakeListingDao()),
        listing: listing,
      );

      expect(review.isEdit, isFalse);
      review.goTo(ReviewStage.consent);
      review.next();
      await Future<void>.delayed(Duration.zero);

      expect(review.stage, ReviewStage.publishing);
      expect(api.republishes, 0);
    });
  });

  group('the voice note cap belongs to the recorder', () {
    test('sixty seconds stops the microphone, screen or no screen', () async {
      final plugin = _FakeAudioRecorder();
      final recorder = RecorderService(recorder: plugin);
      final file = File(
        '${Directory.systemTemp.createTempSync('kaarigar').path}/note.m4a',
      );
      file.writeAsBytesSync(List.filled(64, 1));
      addTearDown(() => file.parent.deleteSync(recursive: true));

      expect(
        await recorder.start(
          file.path,
          maxDuration: const Duration(seconds: 1),
        ),
        isTrue,
      );
      expect(recorder.isRecording, isTrue);

      await Future<void>.delayed(const Duration(milliseconds: 1400));

      expect(recorder.isRecording, isFalse);
      expect(recorder.limitReached, isTrue);
      expect(plugin.stopped, isTrue);
      expect(recorder.path, file.path);

      recorder.dispose();
    });

    test('a take inside the cap is left alone', () async {
      final plugin = _FakeAudioRecorder();
      final recorder = RecorderService(recorder: plugin);

      await recorder.start(
        '/tmp/kaarigar-unused.m4a',
        maxDuration: const Duration(seconds: 30),
      );
      await Future<void>.delayed(const Duration(milliseconds: 300));

      expect(recorder.isRecording, isTrue);
      expect(recorder.limitReached, isFalse);

      await recorder.cancel();
      recorder.dispose();
    });
  });

  group('two voices never talk over each other', () {
    test('the app speaking silences the note', () async {
      var playerStopped = 0;
      final speech = SpeechService(tts: _RecordingTts())
        ..onBeforeSpeak = () async => playerStopped++;
      await speech.init();

      await speech.speak('Take three photographs');

      expect(playerStopped, 1);
    });
  });
}

class _FakeAudioRecorder implements AudioRecorder {
  bool stopped = false;
  String? path;

  @override
  Future<bool> hasPermission({bool request = true}) async => true;

  @override
  Future<void> start(RecordConfig config, {required String path}) async {
    this.path = path;
  }

  @override
  Future<String?> stop() async {
    stopped = true;
    return path;
  }

  @override
  Future<void> cancel() async => stopped = true;

  @override
  Stream<Amplitude> onAmplitudeChanged(Duration interval) =>
      const Stream<Amplitude>.empty();

  @override
  Future<void> dispose() async {}

  @override
  noSuchMethod(Invocation invocation) => throw UnimplementedError();
}

class _RecordingTts implements FlutterTts {
  final List<double> volumes = [];

  @override
  Future<dynamic> setVolume(
    double volume, [
    Map<String, String>? options,
  ]) async {
    volumes.add(volume);
    return 1;
  }

  @override
  noSuchMethod(Invocation invocation) => Future<dynamic>.value(1);
}
