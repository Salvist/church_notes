import 'package:church_notes/domain/models/note.dart';

abstract interface class NoteRepository {
  Future<Note> addNote(Note note);
  Future<void> updateNote(Note note);
  Future<void> removeNote(Note note);

  Future<List<Note>> getNotes();
}
