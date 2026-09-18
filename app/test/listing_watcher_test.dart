import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kaarigar/data/models/capture_item.dart';
import 'package:kaarigar/data/models/fact_sheet.dart';
import 'package:kaarigar/data/models/listing.dart';
import 'package:kaarigar/data/models/listing_status.dart';
import 'package:kaarigar/services/listing_watcher.dart';
import 'package:kaarigar/state/catalog_controller.dart';
import 'package:kaarigar/state/queue_controller.dart';

class _ScriptedCatalog extends CatalogController {
  _ScriptedCatalog(List<Listing> listings) : super(listings: listings);

  final List<List<Listing>> answers = [];
  int refreshes = 0;

  @override
  Future<void> refresh() async {
    refreshes++;
    if (answers.isEmpty) return;
    for (final listing in answers.removeAt(0)) {
      replace(listing);
    }
  }
}

void main() {
  final now = DateTime(2026, 9, 17, 12);

  Listing listing(String id, ListingStatus status) =>
      Listing(id: id, status: status, factSheet: const FactSheet());

  CaptureItem uploaded(String id, DateTime at) => CaptureItem(
    id: id,
    photoPaths: const ['p.jpg'],
    voiceNotePath: '',
    createdAt: at,
    uploadedAt: at,
  );

  late ListingWatcher watcher;

  ListingWatcher watch(
    CatalogController catalog,
    QueueController queue, {
    VoidCallback? onResume,
  }) {
    watcher = ListingWatcher(
      catalog: catalog,
      queue: queue,
      onResume: onResume,
      now: () => now,
    )..start();
    return watcher;
  }

  testWidgets('does nothing when nothing is on its way', (tester) async {
    final catalog = _ScriptedCatalog([
      listing('a', ListingStatus.published),
      listing('b', ListingStatus.needsAttention),
    ]);
    watch(catalog, QueueController());

    await tester.pump(const Duration(minutes: 2));

    expect(watcher.isPolling, isFalse);
    expect(catalog.refreshes, 0);
    watcher.dispose();
  });

  testWidgets('refreshes a processing listing until it is done', (
    tester,
  ) async {
    final catalog = _ScriptedCatalog([listing('a', ListingStatus.processing)])
      ..answers.addAll([
        [listing('a', ListingStatus.processing)],
        [listing('a', ListingStatus.needsAttention)],
      ]);
    watch(catalog, QueueController());
    expect(watcher.isPolling, isTrue);

    await tester.pump(const Duration(seconds: 3));
    expect(catalog.refreshes, 1);

    await tester.pump(const Duration(seconds: 6));
    expect(catalog.refreshes, 2);
    expect(watcher.isPolling, isFalse);

    await tester.pump(const Duration(minutes: 1));
    expect(catalog.refreshes, 2);
    watcher.dispose();
  });

  testWidgets('waits longer each time, up to the ceiling', (tester) async {
    final catalog = _ScriptedCatalog([listing('a', ListingStatus.queued)]);
    watch(catalog, QueueController());

    final at = <int>[];
    for (var second = 1; second <= 120; second++) {
      await tester.pump(const Duration(seconds: 1));
      if (catalog.refreshes > at.length) at.add(second);
    }

    expect(at.take(5), [3, 9, 21, 45, 75]);
    expect(at[5], 105);
    watcher.dispose();
  });

  testWidgets('an uploaded capture with no listing yet is waited for', (
    tester,
  ) async {
    final catalog = _ScriptedCatalog([])
      ..answers.add([listing('c1', ListingStatus.needsAttention)]);
    final queue = QueueController()
      ..add(uploaded('c1', now.subtract(const Duration(minutes: 1))));
    watch(catalog, queue);

    expect(watcher.waitingFor, {'c1'});
    await tester.pump(const Duration(seconds: 3));

    expect(catalog.refreshes, 1);
    expect(watcher.isPolling, isFalse);
    watcher.dispose();
  });

  testWidgets('an upload the server never answered is given up on', (
    tester,
  ) async {
    final queue = QueueController()
      ..add(uploaded('old', now.subtract(const Duration(hours: 2))));
    watch(_ScriptedCatalog([]), queue);

    expect(watcher.waitingFor, isEmpty);
    expect(watcher.isPolling, isFalse);
    watcher.dispose();
  });

  testWidgets('a new upload starts the quick checks again', (tester) async {
    final catalog = _ScriptedCatalog([listing('a', ListingStatus.processing)]);
    final queue = QueueController();
    watch(catalog, queue);

    await tester.pump(const Duration(seconds: 3));
    await tester.pump(const Duration(seconds: 6));
    expect(catalog.refreshes, 2);

    queue.add(uploaded('c2', now));
    await tester.pump(const Duration(seconds: 3));

    expect(catalog.refreshes, 3);
    watcher.dispose();
  });

  testWidgets('stops in the background and refreshes on return', (
    tester,
  ) async {
    final catalog = _ScriptedCatalog([listing('a', ListingStatus.processing)]);
    var resumed = 0;
    watch(catalog, QueueController(), onResume: () => resumed++);

    watcher.didChangeAppLifecycleState(AppLifecycleState.paused);
    expect(watcher.isPolling, isFalse);
    await tester.pump(const Duration(minutes: 5));
    expect(catalog.refreshes, 0);

    watcher.didChangeAppLifecycleState(AppLifecycleState.resumed);
    await tester.pump();

    expect(resumed, 1);
    expect(catalog.refreshes, 1);
    expect(watcher.isPolling, isTrue);
    watcher.dispose();
  });
}
