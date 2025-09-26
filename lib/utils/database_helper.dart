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

const tbCreateTable = 'CREATE TABLE $tbTableName ('
    'id INTEGER PRIMARY KEY AUTOINCREMENT, '
    'book_name TEXT, '
    'book INTEGER, '
    'chapter INTEGER, '
    'verse INTEGER, '
    'text TEXT'
    ')';

const asvTableName = 'ASV';
const tbTableName = 'TB';

const bibleColumns = 'id INTEGER PRIMARY KEY AUTOINCREMENT'
    'book_name TEXT, '
    'chapter INTEGER, '
    'verse INTEGER, '
    'text TEXT, '
    'createdAt INTEGER';

class DatabaseHelper {
  const DatabaseHelper._();
  static const _oldVersion = 1;
  static const _newVersion = 2;

  static Future<Database> initDB() async {
    final dbPath = await getDatabasesPath();
    const dbName = 'church_notes.db';
    final db = await openDatabase(
      join(dbPath, dbName),
      version: 1,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
    return db;
  }

  static Future<void> _onCreate(Database db, int version) async {
    // Version 1
    // American Standard Version (ASV)
    final asvBible = await getVerses('assets/bibles/english/asv.json');
    await db.execute(asvCreateTable);
    await addBible(db, asvTableName, asvBible);

    // Version 2
    // Terjemahan Baru (TB)
    final tbBible = await getVerses('assets/bibles/indonesian/tb.json');
    await db.execute(tbCreateTable);
    await addBible(db, tbTableName, tbBible);

    await db
        .execute('CREATE TABLE Notes (id TEXT PRIMARY KEY, title TEXT, content TEXT, updatedAt TEXT, createdAt TEXT)');
  }

  static Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Version 2
    final tbBible = await getVerses('assets/bibles/indonesian/tb.json');
    await db.execute(tbCreateTable);
    await addBible(db, tbTableName, tbBible);

    // Version 3
  }

  static Future<void> createBible() async {}

  static Future<void> migrateBibleTable(Database db, String bibleTable) async {
    await db.execute('ALTER TABLE $bibleTable RENAME TO ${bibleTable}_old');
    await db.execute('CREATE TABLE $bibleTable ($bibleColumns)');
  }

  static Future<void> addBible(Database db, String tableName, List<Verse> verses) async {
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
}
