import 'dart:async';

import 'package:flutter/foundation.dart';

import '../data/models/sale.dart';
import '../data/repositories/seller_repository.dart';
import 'analytics_service.dart';
import 'deep_link_service.dart';

enum NotificationKind { sold, needsAttention, uploadFinished, packBy }

@immutable
class PushMessage {
  const PushMessage({required this.kind, this.listingId, this.saleId});

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

  LinkTarget? get target => switch (kind) {
    NotificationKind.sold when saleId != null => LinkTarget.sale(saleId!),
    NotificationKind.needsAttention when listingId != null => LinkTarget.review(
      listingId!,
    ),
    NotificationKind.uploadFinished when listingId != null =>
      LinkTarget.listing(listingId!),
    NotificationKind.uploadFinished => const LinkTarget.queue(),
    NotificationKind.packBy when saleId != null => LinkTarget.sale(saleId!),
    _ => null,
  };
}

abstract interface class NotificationPresenter {
  Future<void> show(PushMessage message);
}

class DebugNotificationPresenter implements NotificationPresenter {
  final List<PushMessage> shown = [];

  @override
  Future<void> show(PushMessage message) async {
    shown.add(message);
    if (kDebugMode) debugPrint('[push] ${message.kind.name}');
  }
}

class NotificationService {
  NotificationService({
    required this._sellers,
    NotificationPresenter? presenter,
    this._analytics,
  }) : _presenter = presenter ?? DebugNotificationPresenter();

  final SellerRepository _sellers;
  final NotificationPresenter _presenter;
  final AnalyticsService? _analytics;

  void Function(LinkTarget target)? onOpen;

  Future<bool> isAllowed(NotificationKind kind) async {
    try {
      return switch (kind) {
        NotificationKind.sold => await _sellers.notifySold(),
        NotificationKind.needsAttention =>
          await _sellers.notifyNeedsAttention(),
        NotificationKind.uploadFinished =>
          await _sellers.notifyUploadFinished(),
        NotificationKind.packBy => await _sellers.notifyPackBy(),
      };
    } catch (_) {
      return false;
    }
  }

  Future<bool> handle(PushMessage message) async {
    if (!await isAllowed(message.kind)) return false;
    await _presenter.show(message);
    if (message.kind == NotificationKind.sold) {
      _analytics?.log(AnalyticsEvent.saleReceived);
    }
    return true;
  }

  Future<int> remindToPack(Iterable<Sale> sales, {DateTime? now}) async {
    final at = now ?? DateTime.now();
    final today = DateTime(at.year, at.month, at.day);

    final due = <String>[];
    final saleOf = <String, Sale>{};
    for (final sale in sales) {
      final packBy = sale.packByDate;
      if (packBy == null) continue;
      final days = DateTime(
        packBy.year,
        packBy.month,
        packBy.day,
      ).difference(today).inDays;
      if (days != 0 && days != 1) continue;
      final key = '${sale.id}:$days';
      due.add(key);
      saleOf[key] = sale;
    }
    if (due.isEmpty) return 0;

    final Set<String> reminded;
    try {
      reminded = await _sellers.remindedToPack();
    } catch (_) {
      return 0;
    }

    var shown = 0;
    for (final key in due) {
      if (reminded.contains(key)) continue;
      final message = PushMessage(
        kind: NotificationKind.packBy,
        saleId: saleOf[key]!.id,
      );
      if (await handle(message)) {
        shown++;
        reminded.add(key);
      }
    }

    try {
      await _sellers.saveRemindedToPack(reminded.where(due.contains).toSet());
    } catch (_) {}
    return shown;
  }

  Future<bool> handlePayload(Map<String, Object?> payload) async {
    final message = PushMessage.fromPayload(payload);
    if (message == null) return false;
    return handle(message);
  }

  void open(PushMessage message) {
    final target = message.target;
    if (target == null) return;
    onOpen?.call(target);
  }
}
