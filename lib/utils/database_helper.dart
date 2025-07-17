import 'dart:convert';

import 'package:church_notes/data/source/local/bible_parser.dart';
import 'package:church_notes/domain/enums/bible_version.dart';
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

class DatabaseHelper {
  const DatabaseHelper._();

  static Future<Database> initDB() async {
    final dbPath = await getDatabasesPath();
    const dbName = 'church_notes.db';
    final db = await openDatabase(
      join(dbPath, dbName),
      version: 3,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
    return db;
  }

  static Future<void> _onCreate(Database db, int version) async {
    // Version 1y create ASV table and Notes table
    final asvBible = await getVerses('assets/bibles/english/asv.json');
    await db.execute(asvCreateTable);
    await addBible(db, asvTableName, asvBible);

    await db.execute(
        'CREATE TABLE Notes (id TEXT PRIMARY KEY, title TEXT, content TEXT, updatedAt TEXT, createdAt TEXT)');
  }

  static Future<void> _onUpgrade(
      Database db, int oldVersion, int newVersion) async {
    // Version 2
    if (oldVersion < 2) {
      if (!await _tableExists(db, tbTableName)) {
        final tbBible = await getVerses('assets/bibles/indonesian/tb.json');
        await db.execute(tbCreateTable);
        await addBible(db, tbTableName, tbBible);
      }
    }

    // Version 3
    if (oldVersion < 3) {
      final kjvTableName = BibleVersion.kjv.code;
      if (!await _tableExists(db, kjvTableName)) {
        final kjvBible =
            await BibleParser.parseKJV('assets/bibles/english/kjv.json');
        await db.execute(createBibleTable(kjvTableName));
        await addBible(db, kjvTableName, kjvBible);
      }
    }
  }

  static Future<bool> _tableExists(Database db, String tableName) async {
    final result = await db.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table' AND name=?",
        [tableName]);
    return result.isNotEmpty;
  }

  static Future<void> addBible(
      Database db, String tableName, List<Verse> verses) async {
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

  static String createBibleTable(String tableName) {
    return 'CREATE TABLE $tableName ('
        'id INTEGER PRIMARY KEY AUTOINCREMENT, '
        'book_name TEXT, '
        'chapter INTEGER, '
        'verse INTEGER, '
        'text TEXT'
        ')';
  }
}
