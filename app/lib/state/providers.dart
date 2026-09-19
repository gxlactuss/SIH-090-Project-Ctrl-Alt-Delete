import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/single_child_widget.dart';

import '../core/config/app_config.dart';
import '../core/dev/dev_accounts.dart';
import '../data/remote/api_client.dart';
import '../data/remote/backend_session.dart';
import '../data/remote/default_api.dart';
import '../data/remote/media_auth.dart';
import '../data/remote/mock_api.dart';
import '../data/remote/voice/voice_api.dart';
import '../data/repositories/listing_repository.dart';
import '../data/repositories/sales_repository.dart';
import '../data/repositories/seller_repository.dart';
import '../core/routing/link_router.dart';
import '../services/analytics_service.dart';
import '../services/connectivity_service.dart';
import '../services/crash_reporter.dart';
import '../services/notification_service.dart';
import '../services/dictation_service.dart';
import '../services/listing_watcher.dart';
import '../services/permission_service.dart';
import '../services/speech_service.dart';
import '../services/update_service.dart';
import '../services/upload_service.dart';
import 'app_state.dart';
import 'catalog_controller.dart';
import 'onboarding_controller.dart';
import 'queue_controller.dart';
import 'sales_controller.dart';

List<SingleChildWidget> appProviders({
  required SellerRepository sellers,
  required SpeechService speech,
  ApiClient? api,
  AnalyticsService? analytics,
  CrashReporter? crashes,
  NotificationService? notifications,
  GlobalKey<NavigatorState>? navigatorKey,

  VoiceApi? voice,

  Future<void> Function()? backgroundUploads,
}) {
  final appState = AppState(sellers: sellers, speech: speech);

  final session = api == null ? buildBackendSession() : null;
  final client =
      api ??
      buildApiClient(
        session: session,
        craftStory: () => appState.profile?.craftStory,
      );
  final listings = ListingRepository(api: client);
  final salesRepository = SalesRepository(api: client);

  final analyticsService = analytics ?? AnalyticsService();
  unawaited(analyticsService.sweep());
  final crashReporter = crashes ?? CrashReporter();
  final notifier =
      notifications ??
      NotificationService(sellers: sellers, analytics: analyticsService);
  final router = LinkRouter(
    navigatorKey: navigatorKey ?? GlobalKey<NavigatorState>(),
    listings: listings,
  );
  notifier.onOpen = router.open;

  return [
    Provider<AnalyticsService>.value(value: analyticsService),
    Provider<CrashReporter>.value(value: crashReporter),
    Provider<NotificationService>.value(value: notifier),
    Provider<LinkRouter>.value(value: router),
    Provider<ApiClient>.value(value: client),
    if (session != null) Provider<BackendSession>.value(value: session),
    if (session != null)
      Provider<MediaAuth>.value(
        value: MediaAuth.forSession(AppConfig.apiBaseUrl, session),
      ),
    Provider<ListingRepository>.value(value: listings),
    Provider<SalesRepository>.value(value: salesRepository),
    ChangeNotifierProvider<SalesController>(
      create: (_) =>
          SalesController(sales: salesRepository, notifications: notifier),
    ),
    Provider<SellerRepository>.value(value: sellers),
    Provider<PermissionService>(create: (_) => const PermissionService()),
    ChangeNotifierProvider<SpeechService>.value(value: speech),
    ChangeNotifierProvider<UpdateService>(
      create: (_) => UpdateService(
        api: client,
        storeUrl: AppConfig.storeUrl.isEmpty ? null : AppConfig.storeUrl,
      ),
    ),
    ChangeNotifierProvider<ConnectivityService>(
      create: (_) => ConnectivityService()..start(),
    ),
    if (voice != null) Provider<VoiceApi>.value(value: voice),
    ChangeNotifierProvider<DictationService>(
      create: (context) => DictationService(
        voice: voice,
        isOnline: () => context.read<ConnectivityService>().isOnline,
      ),
    ),
    ChangeNotifierProvider<QueueController>(
      create: (_) => QueueController()..load(),
    ),
    ChangeNotifierProvider<CatalogController>(
      create: (_) => DevAccounts.enabled && !kReleaseMode && client is MockApi
          ? CatalogController.demo(repository: listings)
          : CatalogController(repository: listings),
    ),
    if (client is! MockApi)
      Provider<ListingWatcher>(
        lazy: false,
        create: (context) => ListingWatcher(
          catalog: context.read<CatalogController>(),
          queue: context.read<QueueController>(),
          onResume: () => context.read<SalesController>().load(),
        )..start(),
        dispose: (_, watcher) => watcher.dispose(),
      ),
    ProxyProvider2<QueueController, ConnectivityService, UploadService>(
      lazy: false,
      update: (_, queue, connectivity, previous) =>
          previous ??
          (UploadService(
            api: client,
            queue: queue,
            connectivity: connectivity,
            analytics: analyticsService,
            notifications: notifier,
            voice: voice,
            language: () => appState.language,
            onWorkLeft: backgroundUploads,
          )..start()),
      dispose: (_, service) => service.dispose(),
    ),
    ChangeNotifierProvider<AppState>.value(value: appState),
    ChangeNotifierProxyProvider<AppState, OnboardingController>(
      create: (context) =>
          OnboardingController(appState: context.read<AppState>()),
      update: (_, appState, controller) => controller!,
    ),
  ];
}
