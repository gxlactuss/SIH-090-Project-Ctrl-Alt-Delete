import 'package:flutter/foundation.dart';

import '../core/dev/dev_flags.dart';

/// Decides whether this build may still run.
///
/// 10.6 is a wall, so the decision behind it has to be conservative: an app
/// that locks a seller out because a version check timed out is worse than
/// one that runs a build too old for a week. Anything short of the server
/// clearly saying "this build is finished" is treated as fine.
class UpdateService extends ChangeNotifier {
  UpdateService({this.storeUrl});

  /// Where 10.6 sends the seller. Null until there is a store listing.
  final String? storeUrl;

  bool _mustUpdate = false;

  /// True only when the server has refused this build outright.
  bool get mustUpdate => _mustUpdate;

  /// Asks whether this build is still supported.
  ///
  /// There is no version endpoint yet, so this answers no by default and can
  /// be forced on with `--dart-define=forceUpdate=true` to show the gate on
  /// stage. Wiring the real check means changing this method and nothing
  /// else: every caller already treats a failure as "carry on".
  Future<void> check() async {
    // TODO(backend): ask the server for the minimum supported build, compare
    // it with package_info, and set _mustUpdate from that. Never from a
    // timeout, a parse error or a missing field.
    final forced = DevFlags.forceUpdate;
    if (forced == _mustUpdate) return;
    _mustUpdate = forced;
    notifyListeners();
  }
}
