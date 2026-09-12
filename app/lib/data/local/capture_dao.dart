import 'package:sqflite/sqflite.dart';

import '../models/capture_item.dart';
import 'app_database.dart';

class CaptureDao {
  CaptureDao({AppDatabase? database})
      : _database = database ?? AppDatabase.instance;

  final AppDatabase _database;

  Future<Database> get _db => _database.open();

  Future<void> insert(CaptureItem item) async {
    final db = await _db;
    await db.insert(
      AppDatabase.captures,
      item.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<CaptureItem>> all() async {
    final db = await _db;
    final rows = await db.query(
      AppDatabase.captures,
      orderBy: 'created_at DESC',
    );
    return rows.map(CaptureItem.fromMap).toList();
  }

  Future<List<CaptureItem>> pending() async {
    final db = await _db;
    final rows = await db.query(
      AppDatabase.captures,
      where: 'uploaded_at IS NULL',
      orderBy: 'created_at ASC',
    );
    return rows.map(CaptureItem.fromMap).toList();
  }

  Future<CaptureItem?> byId(String id) async {
    final db = await _db;
    final rows = await db.query(
      AppDatabase.captures,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    return rows.isEmpty ? null : CaptureItem.fromMap(rows.first);
  }

  Future<void> markUploaded(String id, {DateTime? at}) async {
    final db = await _db;
    await db.update(
      AppDatabase.captures,
      {
        'uploaded_at': (at ?? DateTime.now()).millisecondsSinceEpoch,
        'last_error': null,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> recordFailure(String id, String reason) async {
    final db = await _db;
    await db.rawUpdate(
      'UPDATE ${AppDatabase.captures} '
      'SET attempts = attempts + 1, last_error = ? WHERE id = ?',
      [reason, id],
    );
  }

  Future<void> clearFailure(String id) async {
    final db = await _db;
    await db.update(
      AppDatabase.captures,
      {'last_error': null},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> delete(String id) async {
    final db = await _db;
    await db.delete(AppDatabase.captures, where: 'id = ?', whereArgs: [id]);
  }
}
