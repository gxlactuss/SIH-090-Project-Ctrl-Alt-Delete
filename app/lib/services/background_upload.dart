import 'dart:async';
import 'dart:isolate';
import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:workmanager/workmanager.dart';

import '../data/local/capture_dao.dart';
import '../data/remote/api_client.dart';
import '../data/remote/default_api.dart';
import '../data/repositories/sales_repository.dart';
import '../data/repositories/seller_repository.dart';
import '../firebase_options.dart';
import '../state/queue_controller.dart';
import 'connectivity_service.dart';
import 'notification_service.dart';
import 'upload_service.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, _) async {
    try {
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
      }
      await BackgroundUpload.run();
    } catch (error) {
      debugPrint('background upload failed: $error');
    }
    return true;
  });
}

abstract final class BackgroundUpload {
  static const String periodicTask = 'kaarigar.upload.periodic';

  static const String soonTask = 'kaarigar.upload.soon';

  static const String appIsolateName = 'kaarigar.app_isolate';

  static final Constraints _constraints = Constraints(
    networkType: NetworkType.connected,
    requiresBatteryNotLow: true,
  );

  static ReceivePort? _appPort;

  static Future<void> schedule() async {
    markAppIsolate();
    try {
      await Workmanager().initialize(callbackDispatcher);
      await Workmanager().registerPeriodicTask(
        periodicTask,
        periodicTask,
        frequency: const Duration(minutes: 15),
        constraints: _constraints,
        existingWorkPolicy: ExistingPeriodicWorkPolicy.update,
      );
    } catch (error) {
      debugPrint('background upload not scheduled: $error');
    }
  }

  static Future<void> nudge() async {
    try {
      await Workmanager().registerOneOffTask(
        soonTask,
        soonTask,
        constraints: _constraints,
        existingWorkPolicy: ExistingWorkPolicy.keep,
      );
    } catch (error) {
      debugPrint('background upload not nudged: $error');
    }
  }

  static void markAppIsolate() {
    _appPort?.close();
    final port = ReceivePort();
    IsolateNameServer.removePortNameMapping(appIsolateName);
    IsolateNameServer.registerPortWithName(port.sendPort, appIsolateName);
    _appPort = port;
  }

  static bool _appIsOpen() =>
      IsolateNameServer.lookupPortByName(appIsolateName) != null;

  static Future<bool> run({
    ApiClient? api,
    CaptureDao? dao,
    ConnectivityService? connectivity,
    NotificationService? notifications,
    bool Function()? appIsOpen,
  }) async {
    if ((appIsOpen ?? _appIsOpen)()) return false;

    final captures = dao ?? CaptureDao();
    final queue = QueueController(dao: captures);
    final network = connectivity ?? ConnectivityService();
    final client = api ?? buildApiClient();
    final notifier =
        notifications ?? NotificationService(sellers: SellerRepository());
    final uploads = UploadService(
      api: client,
      queue: queue,
      connectivity: network,
      dao: captures,
      notifications: notifier,
    );

    try {
      await network.start();
      await queue.load();
      await uploads.drain();
      await _remindToPack(client, notifier);
      return true;
    } finally {
      uploads.dispose();
      queue.dispose();
      if (connectivity == null) network.dispose();
    }
  }

  static Future<void> _remindToPack(
    ApiClient api,
    NotificationService notifier,
  ) async {
    try {
      await notifier.remindToPack(await SalesRepository(api: api).fetch());
    } catch (error) {
      debugPrint('pack-by reminders skipped: $error');
    }
  }
}
