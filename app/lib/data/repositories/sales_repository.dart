import 'package:shared_preferences/shared_preferences.dart';

import '../models/sale.dart';
import '../remote/api_client.dart';

/// Read-only view of what sold on ONDC.
///
/// The one thing this app owns about a sale is whether the seller has looked
/// at it. That lives on the phone: it is about their attention, not about the
/// order, and it must not need a network to be true.
class SalesRepository {
  SalesRepository({required this._api, this._prefs});

  static const _kRead = 'sales_read_ids';

  final ApiClient _api;
  SharedPreferences? _prefs;

  Future<SharedPreferences> get _store async =>
      _prefs ??= await SharedPreferences.getInstance();

  List<Sale> _cache = const [];

  /// Whatever was last fetched, newest first. Rendered with no network, like
  /// every other screen in this app.
  List<Sale> get cached => _cache;

  /// Fetches and merges in what has already been read. Returns the cache
  /// unchanged when the network is not there, rather than an empty list --
  /// "nothing has sold" is a very different thing to say to a seller than
  /// "we could not check".
  Future<List<Sale>> fetch() async {
    final List<Sale> fresh;
    try {
      fresh = await _api.sales();
    } catch (_) {
      return _cache;
    }

    final read = await _readIds();
    _cache = [
      for (final sale in fresh) sale.copyWith(isRead: read.contains(sale.id)),
    ]..sort((a, b) => b.placedAt.compareTo(a.placedAt));
    return _cache;
  }

  int get unreadCount => _cache.where((s) => !s.isRead).length;

  /// Called when a sale is opened on 7.2.
  Future<void> markRead(String id) async {
    final read = await _readIds();
    if (!read.add(id)) return;
    await (await _store).setStringList(_kRead, read.toList());
    _cache = [
      for (final sale in _cache)
        sale.id == id ? sale.copyWith(isRead: true) : sale,
    ];
  }

  Future<Set<String>> _readIds() async =>
      ((await _store).getStringList(_kRead) ?? const <String>[]).toSet();
}
