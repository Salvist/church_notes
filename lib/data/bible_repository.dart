import 'dart:developer';

import 'package:church_notes/data/source/local/bible_cache.dart';
import 'package:church_notes/data/source/remote/nlt_data_source.dart';
import 'package:church_notes/domain/constants/bible_names.dart';
import 'package:church_notes/domain/enums/bible_version.dart';
import 'package:church_notes/domain/models/passage.dart';
import 'package:church_notes/domain/models/verse.dart';
import 'package:church_notes/domain/repositories/bible_repository.dart';
import 'package:sqflite/sqflite.dart';

class BibleRepositoryImpl implements BibleRepository {
  final Database _db;
  final BibleCache _bibleCache;
  final NLTDataSource _nltDataSource;
  const BibleRepositoryImpl(this._db, this._bibleCache) : _nltDataSource = const NLTDataSource();

  @override
  Future<List<String>> getBookNames(BibleVersion version) async {
    return BibleBook.englishNames.map((e) => e.name).toList();
    final data = await _db.query(version.code, distinct: true, columns: ['book_name']);
    return data.map<String>((e) => e['book_name'] as String).toList(growable: false);
  }

  @override
  Future<Passage> getPassage(BibleReference reference) async {
    final passageCache = await _bibleCache.getPassage(reference);
    if (passageCache != null) return passageCache;

    throw Exception('No passage was found for $reference');
    // const where = 'book_name = ? AND chapter = ?';
    // final verseQuery = reference.verseEnd == null ? 'verse = ?' : 'verse >= ? AND verse <= ?';
    // log('Looking for $reference...');
    //
    // try {
    //   final whereArgs = [reference.bookName, reference.chapter, reference.verseStart];
    //   if (reference.verseEnd != null) whereArgs.add(reference.verseEnd!);
    //   final data = await _db.query(
    //     reference.version.code,
    //     where: '$where AND $verseQuery',
    //     whereArgs: whereArgs,
    //   );
    //
    //   return Passage(
    //     reference: reference,
    //     verses: Verse.fromJSON(data),
    //   );
    // } catch (e) {
    //   final passage = await _nltDataSource.getPassage(reference);
    //   return passage;
    // }
  }
}
