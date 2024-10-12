import 'package:church_notes/domain/models/note.dart';
import 'package:church_notes/domain/repositories/note_repository.dart';
import 'package:church_notes/presentation/home/cubit/note_list_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NoteListCubit extends Cubit<NoteListState> {
  final NoteRepository _noteRepository;
  NoteListCubit(this._noteRepository) : super(const NoteListState()) {
    fetchNotes();
  }

  void fetchNotes() async {
    try {
      final notes = await _noteRepository.getNotes();

      emit(state.copyWith(
        status: NoteListStatus.success,
        notes: notes,
      ));
    } catch (e) {
      emit(
        state.copyWith(
          status: NoteListStatus.failure,
          error: e,
        ),
      );
    }
  }

  Future<Note> createNewNote() async {
    final emptyNote = Note.empty();
    final note = await _noteRepository.addNote(emptyNote);
    final notes = state.notes.toList();
    notes.add(note);
    notes.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    emit(state.copyWith(
      status: NoteListStatus.success,
      notes: notes,
    ));
    return note;
  }

  Future<void> updateNote(Note note) async {
    final notes = state.notes.toList();
    final noteIndex = notes.indexWhere((element) => element.id == note.id);
    if (noteIndex < 0) return;

    notes[noteIndex] = note;
    emit(state.copyWith(
      status: NoteListStatus.success,
      notes: notes,
    ));
  }

  void deleteNote(Note note) async {
    await _noteRepository.removeNote(note);
    final notes = state.notes.toList();
    notes.remove(note);

    emit(state.copyWith(
      status: NoteListStatus.success,
      notes: notes,
    ));
  }
}
