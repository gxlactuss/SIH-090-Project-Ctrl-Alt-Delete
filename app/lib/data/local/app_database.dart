import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  AppDatabase._();

  static final AppDatabase instance = AppDatabase._();

  static const int schemaVersion = 4;

  static const String captures = 'captures';

  static const String listings = 'listings';

  Database? _db;
  Future<Database>? _opening;

  Future<Database> open() {
    final db = _db;
    if (db != null) return Future.value(db);
    return _opening ??= _open();
  }

  Future<Database> _open() async {
    final path = p.join(await getDatabasesPath(), 'kaarigar.db');
    final db = await openDatabase(
      path,
      version: schemaVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
    _db = db;
    return db;
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $captures (
        id TEXT PRIMARY KEY,
        photo_paths TEXT NOT NULL,
        voice_note_path TEXT NOT NULL,
        created_at INTEGER NOT NULL,
        uploaded_at INTEGER,
        attempts INTEGER NOT NULL DEFAULT 0,
        last_error TEXT,
        template_listing_id TEXT,
        description TEXT
      )
    ''');

    await db.execute(
      'CREATE INDEX idx_captures_pending ON $captures (uploaded_at, created_at)',
    );

    await _createListings(db);
  }

  Future<void> _createListings(Database db) async {
    await db.execute('''
      CREATE TABLE $listings (
        id TEXT PRIMARY KEY,
        status TEXT NOT NULL,
        title TEXT,
        cached_at INTEGER NOT NULL,
        data TEXT NOT NULL
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int from, int to) async {
    if (from < 2) {
      await db.execute(
        'ALTER TABLE $captures ADD COLUMN template_listing_id TEXT',
      );
    }
    if (from < 3) {
      await _createListings(db);
    }
    if (from < 4) {
      await db.execute('ALTER TABLE $captures ADD COLUMN description TEXT');
    }
  }

  Future<void> close() async {
    await _db?.close();
    _db = null;
    _opening = null;
  }
}
