import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../core/dev/dev_flags.dart';
import '../data/remote/api_client.dart';

class UpdateService extends ChangeNotifier {
  UpdateService({
    this.api,
    this.storeUrl,
    Future<int?> Function()? currentBuild,
    this.timeout = const Duration(seconds: 3),
  }) : _currentBuild = currentBuild ?? _installedBuild;

  final ApiClient? api;

  final String? storeUrl;

  final Future<int?> Function() _currentBuild;

  final Duration timeout;

  bool _mustUpdate = false;

  bool get mustUpdate => _mustUpdate;

  Future<void> check() async {
    if (DevFlags.forceUpdate) return _set(true);

    final api = this.api;
    if (api == null) return;

    try {
      final minimum = await api.minimumSupportedBuild().timeout(timeout);
      if (minimum == null) return;
      final current = await _currentBuild();
      if (current == null) return;
      _set(current < minimum);
    } catch (_) {}
  }

  void _set(bool mustUpdate) {
    if (mustUpdate == _mustUpdate) return;
    _mustUpdate = mustUpdate;
    notifyListeners();
  }

  static Future<int?> _installedBuild() async =>
      int.tryParse((await PackageInfo.fromPlatform()).buildNumber);
}
