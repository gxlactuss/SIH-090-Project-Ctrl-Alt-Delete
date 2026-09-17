import 'dart:async';

import 'package:flutter/foundation.dart';

import '../data/models/sale.dart';
import '../data/repositories/sales_repository.dart';
import '../services/notification_service.dart';

class SalesController extends ChangeNotifier {
  SalesController({required this._sales, this._notifications});

  final SalesRepository _sales;

  final NotificationService? _notifications;

  List<Sale> _all = const [];

  List<Sale> get sales => _all;

  bool _loaded = false;

  bool get isLoaded => _loaded;

  bool _loading = false;
  bool get isLoading => _loading;

  int get unreadCount => _unread ??= _all.where((s) => !s.isRead).length;

  bool get isEmpty => _all.isEmpty;

  Sale? byId(String id) {
    for (final sale in _all) {
      if (sale.id == id) return sale;
    }
    return null;
  }

  List<Sale> get toPack {
    final now = DateTime.now();
    final due =
        _all
            .where((s) => s.packByDate != null && s.packByDate!.isAfter(now))
            .toList()
          ..sort((a, b) => a.packByDate!.compareTo(b.packByDate!));
    return due;
  }

  Future<void> load() =>
      _inFlight ??= _load().whenComplete(() => _inFlight = null);

  Future<void>? _inFlight;

  Future<void> _load() async {
    _loading = true;
    notifyListeners();

    _all = await _sales.fetch();
    _loaded = true;
    _loading = false;
    notifyListeners();
    unawaited(_notifications?.remindToPack(_all));
  }

  Future<void> markRead(String id) async {
    final sale = byId(id);
    if (sale == null || sale.isRead) return;
    await _sales.markRead(id);
    _all = [for (final s in _all) s.id == id ? s.copyWith(isRead: true) : s];
    notifyListeners();
  }

  int get thisWeekInPaise {
    final now = DateTime.now();
    final monday = DateTime(
      now.year,
      now.month,
      now.day,
    ).subtract(Duration(days: now.weekday - 1));
    return _sumSince(monday);
  }

  int get thisMonthInPaise {
    final now = DateTime.now();
    return _sumSince(DateTime(now.year, now.month));
  }

  int get totalInPaise => _total ??= _sum(_all);

  int get itemsSold =>
      _itemsSold ??= _all.fold<int>(0, (count, sale) => count + sale.quantity);

  int _sum(Iterable<Sale> sales) =>
      sales.fold(0, (total, sale) => total + sale.amountInPaise);

  int? _unread;
  int? _total;
  int? _itemsSold;

  final Map<DateTime, int> _since = {};

  int _sumSince(DateTime start) => _since.putIfAbsent(
    start,
    () => _sum(_all.where((s) => !s.placedAt.isBefore(start))),
  );

  @override
  void notifyListeners() {
    _unread = null;
    _total = null;
    _itemsSold = null;
    _since.clear();
    super.notifyListeners();
  }
}
