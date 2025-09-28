import 'dart:developer';

import 'package:church_notes/data/source/local/bible_cache.dart';
import 'package:church_notes/domain/constants/bible_names.dart';
import 'package:church_notes/domain/enums/bible_version.dart';
import 'package:church_notes/domain/models/passage.dart';
import 'package:church_notes/domain/models/verse.dart';
import 'package:church_notes/domain/repositories/bible_repository.dart';
import 'package:sqflite/sqflite.dart';

class BibleRepositoryImpl implements BibleRepository {
  final Database _db;
  final BibleCache _bibleCache;
  const BibleRepositoryImpl(this._db, this._bibleCache);

  @override
  Future<List<String>> getBookNames(BibleVersion version) async {
    return BibleBook.getNames(version).map((e) => e.name).toList();
  }

  @override
  Future<Passage> getPassage(BibleReference reference) async {
    const where = 'book_name = ? AND chapter = ?';
    final verseQuery = reference.verseEnd == null
        ? 'verse = ?'
        : 'verse >= ? AND verse <= ?';
    log('Looking for $reference...');

    final whereArgs = [
      reference.bookName,
      reference.chapter,
      reference.verseStart,
    ];
    if (reference.verseEnd != null) whereArgs.add(reference.verseEnd!);
    final data = await _db.query(
      reference.version.code,
      where: '$where AND $verseQuery',
      whereArgs: whereArgs,
    );

    return Passage(reference: reference, verses: Verse.fromJSON(data));
  }
}
