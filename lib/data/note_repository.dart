import 'dart:developer';

import 'package:church_notes/data/source/local/local_data_source.dart';
import 'package:church_notes/domain/models/note.dart';
import 'package:church_notes/domain/repositories/note_repository.dart';

class NoteRepositoryImpl implements NoteRepository {
  final NoteLocalDataSource _local;

  const NoteRepositoryImpl(this._local);

  @override
  Future<Note> addNote(Note note) async {
    final newNote = await _local.addNote(note);
    return newNote;
  }

  @override
  Future<List<Note>> getNotes() async {
    return await _local.getNotes();
  }

  @override
  Future<void> updateNote(Note note) async {
    await _local.updateNote(note);
    log('Note "${note.title}" has been saved', name: 'NoteRepository');
  }

  @override
  Future<void> removeNote(Note note) async {
    await _local.removeNote(note);
    log('Note ${note.title} has been removed');
  }
}
