import 'package:church_notes/domain/models/passage.dart';
import 'package:church_notes/domain/models/verse.dart';
import 'package:church_notes/domain/repositories/bible_repository.dart';
import 'package:sqflite/sqflite.dart';

const _tableName = 'ASV';

class BibleRepositoryImpl implements BibleRepository {
  final Database _db;

  const BibleRepositoryImpl(this._db);

  @override
  Future<Passage> getPassage(BibleReference reference) async {
    const where = 'book_name = ? AND chapter = ?';
    final verseQuery = reference.verseEnd == null ? 'verse = ?' : 'verse >= ? AND verse <= ?';

    final whereArgs = [reference.bookName, reference.chapter, reference.verseStart];
    if (reference.verseEnd != null) whereArgs.add(reference.verseEnd!);
    final data = await _db.query(
      _tableName,
      where: '$where AND $verseQuery',
      whereArgs: whereArgs,
    );

    return Passage(
      reference: reference,
      verses: Verse.fromJSON(data),
    );
  }
}
