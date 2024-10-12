import 'dart:convert';

import 'package:church_notes/domain/models/verse.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

const asvCreateTable = 'CREATE TABLE $asvTableName ('
    'id INTEGER PRIMARY KEY AUTOINCREMENT, '
    'book_name TEXT, '
    'book INTEGER, '
    'chapter INTEGER, '
    'verse INTEGER, '
    'text TEXT'
    ')';

const asvTableName = 'ASV';

class DatabaseHelper {
  const DatabaseHelper._();

  static Future<Database> initDB() async {
    final dbPath = await getDatabasesPath();
    const dbName = 'church_notes.db';
    final db = await openDatabase(
      join(dbPath, dbName),
      version: 1,
      onCreate: _onCreate,
    );
    return db;
  }

  static Future<void> _onCreate(Database db, int version) async {
    final json = await rootBundle.loadString('assets/bibles/english/asv.json');
    final bibleASV = jsonDecode(json) as Map<String, dynamic>;
    final rawVerses = bibleASV['verses'] as List<dynamic>;
    final versesASV = Verse.fromJSON(rawVerses);

    await db.execute(asvCreateTable);
    await addBible(db, versesASV);
    await db
        .execute('CREATE TABLE Notes (id TEXT PRIMARY KEY, title TEXT, content TEXT, updatedAt TEXT, createdAt TEXT)');
  }

  static Future<void> addBible(Database db, List<Verse> verses) async {
    final batch = db.batch();
    for (final verse in verses) {
      batch.insert(asvTableName, verse.toMap());
    }
    await batch.commit(noResult: true);
  }
}
