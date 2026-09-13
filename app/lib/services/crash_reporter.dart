import 'dart:async';

import 'package:flutter/foundation.dart';

/// One caught crash, with enough context to be worth reading later.
@immutable
class CrashReport {
  const CrashReport({
    required this.error,
    required this.stack,
    required this.at,
    this.context,
    this.fatal = false,
  });

  final Object error;
  final StackTrace stack;
  final DateTime at;

  /// What the app was doing. "uploading capture", "publishing listing" --
  /// the sentence that turns a stack trace into a bug report.
  final String? context;

  /// Whether the app could carry on afterwards.
  final bool fatal;

  @override
  String toString() =>
      '${fatal ? 'FATAL' : 'error'} ${context == null ? '' : '($context) '}'
      '$error';
}

/// Where crashes go once they leave the app. Vendor-shaped, so swapping in
/// Crashlytics or Sentry is one class and no call sites.
abstract interface class CrashSink {
  Future<void> report(CrashReport report);
}

/// Keeps the last few crashes in memory and prints them in debug. Enough to
/// develop against, and enough for 9.7 to say honestly whether this build has
/// fallen over.
class DebugCrashSink implements CrashSink {
  final List<CrashReport> reports = [];

  static const int _keep = 50;

  @override
  Future<void> report(CrashReport report) async {
    reports.add(report);
    if (reports.length > _keep) reports.removeAt(0);
    if (kDebugMode) {
      debugPrint('[crash] $report');
      debugPrintStack(stackTrace: report.stack);
    }
  }
}

/// Catches what would otherwise be a white screen on a seller's phone.
///
/// Two things have to be hooked, and missing either one leaves half the
/// crashes unreported: [FlutterError.onError] catches everything thrown
/// inside the widget tree, and [PlatformDispatcher.onError] catches
/// everything thrown outside it -- which on this app is most of what can
/// actually go wrong, because the camera, the recorder, the TTS engine and
/// the uploader all live outside the tree.
///
/// The device this is written for is a 2 GB phone that will be killed by the
/// OS under memory pressure, so a crash is a routine event and not an
/// embarrassment. What matters is that it is recorded and that the seller's
/// captured work survives it -- which it does, because section 3 writes to
/// the database before it says anything.
class CrashReporter {
  CrashReporter({CrashSink? sink, DateTime Function()? now})
      : _sink = sink ?? DebugCrashSink(),
        _now = now ?? DateTime.now;

  final CrashSink _sink;
  final DateTime Function() _now;

  FlutterExceptionHandler? _previousFlutterHandler;
  bool _installed = false;

  /// Installs the handlers. Called once, from `main`, before `runApp`.
  void install() {
    if (_installed) return;
    _installed = true;

    _previousFlutterHandler = FlutterError.onError;
    FlutterError.onError = (details) {
      record(
        details.exception,
        details.stack ?? StackTrace.current,
        context: details.context?.toDescription(),
        fatal: false,
      );
      // Still handed on, so a debug build keeps printing the red box it
      // would have printed. Reporting a crash must not hide it.
      _previousFlutterHandler?.call(details);
    };

    PlatformDispatcher.instance.onError = (error, stack) {
      record(error, stack, context: 'outside the widget tree', fatal: true);
      return true;
    };
  }

  /// Removes the handlers again. For tests, which must not leak a reporter
  /// into the next test's failures.
  void dispose() {
    if (!_installed) return;
    FlutterError.onError = _previousFlutterHandler;
    PlatformDispatcher.instance.onError = null;
    _installed = false;
  }

  /// Records something the app caught itself. The `catch` blocks scattered
  /// through the services swallow errors on purpose -- a failed upload is a
  /// retry and not a dialog -- and this is how they stay visible to us
  /// without becoming visible to the seller.
  void record(
    Object error,
    StackTrace stack, {
    String? context,
    bool fatal = false,
  }) {
    unawaited(
      Future<void>(() async {
        try {
          await _sink.report(
            CrashReport(
              error: error,
              stack: stack,
              at: _now(),
              context: context,
              fatal: fatal,
            ),
          );
        } catch (_) {
          // The crash reporter crashing must not crash the app.
        }
      }),
    );
  }
}
