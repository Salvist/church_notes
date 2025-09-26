import 'dart:developer';

import 'package:church_notes/domain/models/passage.dart';
import 'package:church_notes/domain/models/verse.dart';
import 'package:sqflite/sqflite.dart';

class BibleCache {
  final Database _db;
  const BibleCache(this._db);

  Future<void> savePassage(Passage passage) async {
    final bibleTable = passage.reference.version.code;
    for (final verse in passage.verses) {
      await _db.insert(bibleTable, verse.toRow());
    }
  }

  Future<void> saveVerse(String bibleTable, Verse verse) async {
    await _db.insert(bibleTable, verse.toRow());
  }

  Future<Passage?> getPassage(BibleReference reference) async {
    const where = 'book_name = ? AND chapter = ?';
    final verseQuery = reference.verseEnd == null ? 'verse = ?' : 'verse >= ? AND verse <= ?';
    log('Looking for $reference...');

    try {
      final whereArgs = [reference.bookName, reference.chapter, reference.verseStart];
      if (reference.verseEnd != null) whereArgs.add(reference.verseEnd!);
      final data = await _db.query(
        reference.version.code,
        where: '$where AND $verseQuery',
        whereArgs: whereArgs,
      );

      return Passage(
        reference: reference,
        verses: Verse.fromJSON(data),
      );
    } catch (e) {
      return null;
    }
  }
}
