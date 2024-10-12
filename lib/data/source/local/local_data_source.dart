import 'package:church_notes/domain/models/note.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

const _tableName = 'Notes';

class NoteLocalDataSource {
  final Uuid _idGenerator;
  final Database _db;

  const NoteLocalDataSource(this._db) : _idGenerator = const Uuid();

  Future<Note> addNote(Note note) async {
    final id = _idGenerator.v1();
    final updatedNote = note.copyWith(id: id);
    await _db.insert(_tableName, updatedNote.toSQL());
    return updatedNote;
  }

  Future<void> updateNote(Note note) async {
    await _db.update(
      _tableName,
      note.toSQL(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  Future<List<Note>> getNotes() async {
    final sqlNotes = await _db.query(_tableName);
    final notes = sqlNotes.map((e) => Note.fromSQL(e)).toList();
    notes.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return notes;
  }

  Future<void> removeNote(Note note) async {
    await _db.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }
}
