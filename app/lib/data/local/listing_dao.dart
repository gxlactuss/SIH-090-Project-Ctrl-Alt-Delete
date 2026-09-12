import 'dart:convert';

import 'package:sqflite/sqflite.dart';

import '../models/fact_sheet.dart';
import '../models/listing.dart';
import '../models/listing_status.dart';
import '../models/suggestion.dart';
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
    return [
      for (final row in rows) ?fromRow(row),
    ];
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
        'data': jsonEncode(_toData(listing)),
      };

  static Map<String, Object?> _toData(Listing listing) => {
        'description': listing.description,
        'imageUrls': listing.imageUrls,
        'followUpQuestion': listing.followUpQuestion,
        'suggestedPriceInPaise': listing.suggestedPriceInPaise,
        'priceFloorInPaise': listing.priceFloorInPaise,
        'previewUrl': listing.previewUrl,
        'photoConsent': listing.photoConsent,
        'storyConsent': listing.storyConsent,
        'views': listing.views,
        'templateListingId': listing.templateListingId,
        'factSheet': {
          'material': listing.factSheet.material,
          'size': listing.factSheet.size,
          'colour': listing.factSheet.colour,
          'technique': listing.factSheet.technique,
          'quantity': listing.factSheet.quantity,
          'priceInPaise': listing.factSheet.priceInPaise,
          'hoursToMake': listing.factSheet.hoursToMake,
          'materialCostInPaise': listing.factSheet.materialCostInPaise,
          'isOneOfAKind': listing.factSheet.isOneOfAKind,
        },
        'suggestions': [
          for (final suggestion in listing.suggestions)
            {
              'id': suggestion.id,
              'spokenPrompt': suggestion.spokenPrompt,
              'textIfAccepted': suggestion.textIfAccepted,
              'accepted': suggestion.accepted,
            },
        ],
      };

  static Listing? fromRow(Map<String, Object?> row) {
    try {
      final id = row['id'] as String;
      final status = ListingStatus.values
          .where((s) => s.name == row['status'])
          .firstOrNull;
      if (status == null) return null;

      final data = jsonDecode(row['data'] as String) as Map<String, Object?>;
      final sheet = (data['factSheet'] as Map?)?.cast<String, Object?>() ?? {};

      return Listing(
        id: id,
        status: status,
        title: row['title'] as String?,
        description: data['description'] as String?,
        imageUrls: (data['imageUrls'] as List?)?.cast<String>() ?? const [],
        followUpQuestion: data['followUpQuestion'] as String?,
        suggestedPriceInPaise: data['suggestedPriceInPaise'] as int?,
        priceFloorInPaise: data['priceFloorInPaise'] as int?,
        previewUrl: data['previewUrl'] as String?,
        photoConsent: data['photoConsent'] as bool? ?? false,
        storyConsent: data['storyConsent'] as bool? ?? false,
        views: data['views'] as int? ?? 0,
        templateListingId: data['templateListingId'] as String?,
        factSheet: FactSheet(
          material: sheet['material'] as String?,
          size: sheet['size'] as String?,
          colour: sheet['colour'] as String?,
          technique: sheet['technique'] as String?,
          quantity: sheet['quantity'] as int?,
          priceInPaise: sheet['priceInPaise'] as int?,
          hoursToMake: (sheet['hoursToMake'] as num?)?.toDouble(),
          materialCostInPaise: sheet['materialCostInPaise'] as int?,
          isOneOfAKind: sheet['isOneOfAKind'] as bool? ?? false,
        ),
        suggestions: [
          for (final raw in (data['suggestions'] as List? ?? const []))
            if (raw is Map)
              Suggestion(
                id: raw['id'] as String,
                spokenPrompt: raw['spokenPrompt'] as String,
                textIfAccepted: raw['textIfAccepted'] as String,
                accepted: raw['accepted'] as bool?,
              ),
        ],
      );
    } catch (_) {
      return null;
    }
  }
}
