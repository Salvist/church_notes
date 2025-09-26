import 'dart:convert';

import 'package:church_notes/domain/models/verse.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

const asvTableName = 'ASV';
const tbTableName = 'TB';

const bibleColumns =
    'id INTEGER PRIMARY KEY AUTOINCREMENT'
    'book_name TEXT, '
    'chapter INTEGER, '
    'verse INTEGER, '
    'text TEXT, '
    'createdAt INTEGER';

class DatabaseHelper {
  const DatabaseHelper._();

  static Future<Database> initDB() async {
    final dbPath = await getDatabasesPath();
    const dbName = 'church_notes.db';
    final db = await openDatabase(
      join(dbPath, dbName),
      version: 4,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
    return db;
  }

  static Future<void> _onCreate(Database db, int version) async {
    final asvBible = await getVerses('assets/bibles/english/asv.json');
    await db.execute(getBibleTableSyntax(asvTableName));
    await addBible(db, asvTableName, asvBible);

    final tbBible = await getVerses('assets/bibles/indonesian/tb.json');
    await db.execute(getBibleTableSyntax(tbTableName));
    await addBible(db, tbTableName, tbBible);

    await db.execute(
      'CREATE TABLE Notes (id TEXT PRIMARY KEY, title TEXT, content TEXT, updatedAt TEXT, createdAt TEXT)',
    );
  }

  static Future<void> _onUpgrade(
    Database db,
    int oldVersion,
    int newVersion,
  ) async {
    await db.execute('DROP TABLE $asvTableName');
    await db.execute('DROP TABLE $tbTableName');

    final asvBible = await getVerses('assets/bibles/english/asv.json');
    await db.execute(getBibleTableSyntax(asvTableName));
    await addBible(db, asvTableName, asvBible);

    final tbBible = await getVerses('assets/bibles/indonesian/tb.json');
    await db.execute(getBibleTableSyntax(tbTableName));
    await addBible(db, tbTableName, tbBible);
  }

  static Future<void> addBible(
    Database db,
    String tableName,
    List<Verse> verses,
  ) async {
    final batch = db.batch();
    for (final verse in verses) {
      batch.insert(tableName, verse.toMap());
    }
    await batch.commit(noResult: true);
  }

  static Future<List<Verse>> getVerses(String biblePath) async {
    final jsonString = await rootBundle.loadString(biblePath);
    final bibleJSON = jsonDecode(jsonString) as Map<String, dynamic>;
    final rawVerses = bibleJSON['verses'] as List<dynamic>;
    final verses = Verse.fromJSON(rawVerses);
    return verses;
  }

  static String getBibleTableSyntax(String tableName) {
    return 'CREATE TABLE $tableName ('
        'id INTEGER PRIMARY KEY AUTOINCREMENT, '
        'book_name TEXT, '
        'chapter INTEGER, '
        'verse INTEGER, '
        'text TEXT'
        ')';
  }
}
