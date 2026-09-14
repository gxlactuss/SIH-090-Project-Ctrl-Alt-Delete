import 'dart:async';

import 'package:flutter/foundation.dart';

import '../data/repositories/seller_repository.dart';
import 'analytics_service.dart';
import 'deep_link_service.dart';

/// The three things the app is allowed to interrupt a seller for.
///
/// Exactly the three 8.7 has switches for, and the enum is what ties the two
/// together: a fourth kind of notification cannot be added without a switch
/// for it appearing on the settings screen, which is the point.
enum NotificationKind {
  /// Something sold. The only one that is unambiguously good news.
  sold,

  /// A listing is stuck on 5.1 waiting for one answer.
  needsAttention,

  /// A capture made offline has finished uploading.
  uploadFinished,
}

/// A push as it arrives, before we decide whether the seller wanted it.
@immutable
class PushMessage {
  const PushMessage({required this.kind, this.listingId, this.saleId});

  /// Builds one from a raw payload. Returns null for anything unrecognised,
  /// because a push whose kind we cannot read is a push we cannot check a
  /// consent switch for, and showing it anyway would break 8.7.
  static PushMessage? fromPayload(Map<String, Object?> payload) {
    final kind = NotificationKind.values
        .where((k) => k.name == payload['kind'])
        .firstOrNull;
    if (kind == null) return null;
    return PushMessage(
      kind: kind,
      listingId: payload['listingId'] as String?,
      saleId: payload['saleId'] as String?,
    );
  }

  final NotificationKind kind;
  final String? listingId;
  final String? saleId;

  /// Where tapping it should land. A notification that opens the home screen
  /// and leaves the seller to find what it was about is a notification that
  /// trains them to ignore notifications.
  LinkTarget? get target => switch (kind) {
        NotificationKind.sold when saleId != null => LinkTarget.sale(saleId!),
        // Straight into 5.1: the whole message is "one question is waiting",
        // and the answer is two taps away.
        NotificationKind.needsAttention when listingId != null =>
          LinkTarget.review(listingId!),
        NotificationKind.uploadFinished when listingId != null =>
          LinkTarget.listing(listingId!),
        NotificationKind.uploadFinished => const LinkTarget.queue(),
        _ => null,
      };
}

/// What actually puts a notification in the tray.
///
/// Stubbed until there is a backend and a Firebase project: this app has no
/// push credentials, and a plugin wired to nothing would be harder to reason
/// about than an interface wired to nothing. The decisions worth getting
/// right now -- which pushes are allowed, what each one opens, what happens
/// when the seller has switched it off -- all live in [NotificationService]
/// above this line, and none of them change when the transport arrives.
abstract interface class NotificationPresenter {
  Future<void> show(PushMessage message);
}

/// Records what would have been shown. The demo build's tray.
class DebugNotificationPresenter implements NotificationPresenter {
  final List<PushMessage> shown = [];

  @override
  Future<void> show(PushMessage message) async {
    shown.add(message);
    if (kDebugMode) debugPrint('[push] ${message.kind.name}');
  }
}

/// Decides whether a push is shown, and where tapping it goes.
///
/// The switches on 8.7 are honoured here rather than on the server. A seller
/// who turns "tell me when something sells" off has to stop being told
/// immediately and while offline, and a preference that only exists as a
/// server-side subscription does neither.
class NotificationService {
  NotificationService({
    required this._sellers,
    NotificationPresenter? presenter,
    this._analytics,
  }) : _presenter = presenter ?? DebugNotificationPresenter();

  final SellerRepository _sellers;
  final NotificationPresenter _presenter;
  final AnalyticsService? _analytics;

  /// Set by the app so a tapped notification can navigate. Left null in
  /// tests, which assert on the target rather than on a Navigator.
  void Function(LinkTarget target)? onOpen;

  /// Whether 8.7 currently allows this kind through.
  Future<bool> isAllowed(NotificationKind kind) async {
    try {
      return switch (kind) {
        NotificationKind.sold => await _sellers.notifySold(),
        NotificationKind.needsAttention =>
          await _sellers.notifyNeedsAttention(),
        NotificationKind.uploadFinished =>
          await _sellers.notifyUploadFinished(),
      };
    } catch (_) {
      // Preferences we cannot read default to quiet. Being unable to check
      // whether the seller consented is not the same as consent.
      return false;
    }
  }

  /// Handles an incoming push. Returns whether it was shown, so the caller
  /// and the tests can tell "suppressed" from "delivered" -- a distinction a
  /// void method would hide.
  Future<bool> handle(PushMessage message) async {
    if (!await isAllowed(message.kind)) return false;
    await _presenter.show(message);
    if (message.kind == NotificationKind.sold) {
      _analytics?.log(AnalyticsEvent.saleReceived);
    }
    return true;
  }

  /// Handles a raw payload from the transport, whatever it turns out to be.
  Future<bool> handlePayload(Map<String, Object?> payload) async {
    final message = PushMessage.fromPayload(payload);
    if (message == null) return false;
    return handle(message);
  }

  /// The seller tapped one. Nothing is shown that has no target, so the null
  /// case here is a payload that changed shape under us rather than a
  /// notification we chose not to make openable.
  void open(PushMessage message) {
    final target = message.target;
    if (target == null) return;
    onOpen?.call(target);
  }
}
