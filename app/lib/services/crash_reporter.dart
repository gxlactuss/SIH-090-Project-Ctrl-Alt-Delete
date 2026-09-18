import 'dart:async';

import 'package:flutter/foundation.dart';

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

  final String? context;

  final bool fatal;

  @override
  String toString() =>
      '${fatal ? 'FATAL' : 'error'} ${context == null ? '' : '($context) '}'
      '$error';
}

abstract interface class CrashSink {
  Future<void> report(CrashReport report);
}

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

class CrashReporter {
  CrashReporter({CrashSink? sink, DateTime Function()? now})
    : _sink = sink ?? DebugCrashSink(),
      _now = now ?? DateTime.now;

  final CrashSink _sink;
  final DateTime Function() _now;

  FlutterExceptionHandler? _previousFlutterHandler;
  bool _installed = false;

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
      _previousFlutterHandler?.call(details);
    };

    PlatformDispatcher.instance.onError = (error, stack) {
      record(error, stack, context: 'outside the widget tree', fatal: true);
      return true;
    };
  }

  void dispose() {
    if (!_installed) return;
    FlutterError.onError = _previousFlutterHandler;
    PlatformDispatcher.instance.onError = null;
    _installed = false;
  }

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
        } catch (_) {}
      }),
    );
  }
}
