import 'dart:convert';

import 'package:sqflite/sqflite.dart';

import '../models/listing.dart';
import 'app_database.dart';

class ListingDao {
  ListingDao({AppDatabase? database})
    : _database = database ?? AppDatabase.instance;

  final AppDatabase _database;

  Future<Database> get _db => _database.open();

  Future<void> upsert(Listing listing) async {
    final db = await _db;
    await db.insert(
      AppDatabase.listings,
      toRow(listing),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> upsertAll(Iterable<Listing> listings) async {
    if (listings.isEmpty) return;
    final db = await _db;
    final batch = db.batch();
    for (final listing in listings) {
      batch.insert(
        AppDatabase.listings,
        toRow(listing),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }

  Future<List<Listing>> all() async {
    final db = await _db;
    final rows = await db.query(
      AppDatabase.listings,
      orderBy: 'cached_at DESC',
    );
    return [for (final row in rows) ?fromRow(row)];
  }

  Future<Listing?> byId(String id) async {
    final db = await _db;
    final rows = await db.query(
      AppDatabase.listings,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    return rows.isEmpty ? null : fromRow(rows.first);
  }

  Future<void> delete(String id) async {
    final db = await _db;
    await db.delete(AppDatabase.listings, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> clear() async {
    final db = await _db;
    await db.delete(AppDatabase.listings);
  }

  Future<int> count() async {
    final db = await _db;
    final rows = await db.rawQuery(
      'SELECT COUNT(*) AS n FROM ${AppDatabase.listings}',
    );
    return Sqflite.firstIntValue(rows) ?? 0;
  }

  static Map<String, Object?> toRow(Listing listing) => {
    'id': listing.id,
    'status': listing.status.name,
    'title': listing.title,
    'cached_at': DateTime.now().millisecondsSinceEpoch,
    'data': jsonEncode(listing.toJson()),
  };

  static Listing? fromRow(Map<String, Object?> row) {
    try {
      final data = jsonDecode(row['data'] as String) as Map<String, Object?>;
      return Listing.fromJson({
        ...data,
        'id': row['id'],
        'status': row['status'],
        'title': row['title'],
      });
    } catch (_) {
      return null;
    }
  }
}
